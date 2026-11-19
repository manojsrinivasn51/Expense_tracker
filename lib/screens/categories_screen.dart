// lib/screens/categories_screen.dart
// Spendly – Categories screen (Finora-inspired design)
//
// WHAT'S NEW
//  • Every category card has a small coloured EDIT icon (top-right).
//  • Category totals / counts are now CALCULATED from the transaction history
//    (each transaction has a date + time), not hard-coded.
//  • Period filter: Last 7 days / Last 30 days / All time – the numbers and
//    the order of the cards change with the selected period (highest spend first).
//  • Tap a card → see that category's transactions with date and time.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_system.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data
// ─────────────────────────────────────────────────────────────────────────────
enum CategoryType { expense, income }

/// A category. Count / total are NOT stored here any more – they are
/// calculated from the transaction history.
class CategoryItem {
  final String id;
  final String name;
  final IconData icon;
  final Color color;
  final CategoryType type;

  const CategoryItem({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.type,
  });

  CategoryItem copyWith({String? name, IconData? icon, Color? color}) {
    return CategoryItem(
      id: id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      type: type,
    );
  }
}

/// One transaction in the history (amount is always positive; the category
/// type decides if it is shown as spending or income).
class TxRecord {
  final String id;
  final String categoryId;
  final String title;
  final double amount;
  final DateTime dateTime;

  const TxRecord({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.amount,
    required this.dateTime,
  });
}

/// Calculated numbers for one category in the selected period.
class _CatStats {
  final int count;
  final double total;
  final DateTime? last;
  const _CatStats(this.count, this.total, this.last);
  static const empty = _CatStats(0, 0, null);
}

enum _Period { week, month, all }

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────
class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  final _searchCtrl = TextEditingController();
  String _query = '';
  _Period _period = _Period.month;

  // NOTE: copy the const list so it can be edited / deleted at runtime.
  List<CategoryItem> _categories = List.of(_kDefaultCategories);
  late List<TxRecord> _transactions;

  @override
  void initState() {
    super.initState();
    _transactions = _seedTransactions();
    _tabCtrl = TabController(length: 3, vsync: this, initialIndex: 0);
    _tabCtrl.addListener(() => setState(() {}));
    _searchCtrl.addListener(
        () => setState(() => _query = _searchCtrl.text.toLowerCase()));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── Period helpers ─────────────────────────────────────────────────────────
  DateTime? get _periodStart {
    final now = DateTime.now();
    switch (_period) {
      case _Period.week:
        return now.subtract(const Duration(days: 7));
      case _Period.month:
        return now.subtract(const Duration(days: 30));
      case _Period.all:
        return null;
    }
  }

  String get _periodLabel {
    switch (_period) {
      case _Period.week:
        return 'Last 7 days';
      case _Period.month:
        return 'Last 30 days';
      case _Period.all:
        return 'All time';
    }
  }

  // ── History → numbers ──────────────────────────────────────────────────────
  /// Transactions of one category inside the selected period, newest first.
  List<TxRecord> _txFor(String categoryId) {
    final start = _periodStart;
    final list = _transactions
        .where((t) =>
            t.categoryId == categoryId &&
            (start == null || !t.dateTime.isBefore(start)))
        .toList()
      ..sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return list;
  }

  Map<String, _CatStats> _computeStats() {
    final result = <String, _CatStats>{};
    for (final c in _categories) {
      final list = _txFor(c.id);
      double total = 0;
      for (final t in list) {
        total += t.amount;
      }
      result[c.id] = _CatStats(
          list.length, total, list.isEmpty ? null : list.first.dateTime);
    }
    return result;
  }

  /// Filtered by tab + search, then sorted by spending (highest first).
  List<CategoryItem> _filtered(Map<String, _CatStats> stats) {
    Iterable<CategoryItem> list = _categories;
    if (_tabCtrl.index == 1) {
      list = list.where((c) => c.type == CategoryType.expense);
    } else if (_tabCtrl.index == 2) {
      list = list.where((c) => c.type == CategoryType.income);
    }
    if (_query.isNotEmpty) {
      list = list.where((c) => c.name.toLowerCase().contains(_query));
    }
    final out = list.toList()
      ..sort((a, b) =>
          (stats[b.id]?.total ?? 0).compareTo(stats[a.id]?.total ?? 0));
    return out;
  }

  double _maxTotalFor(CategoryType type, Map<String, _CatStats> stats) {
    double m = 0;
    for (final c in _categories.where((c) => c.type == type)) {
      final t = stats[c.id]?.total ?? 0;
      if (t > m) m = t;
    }
    return m;
  }

  // ── Actions ────────────────────────────────────────────────────────────────
  void _openAddSheet([CategoryItem? editing]) async {
    final result = await showModalBottomSheet<CategoryItem>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CategoryFormSheet(editing: editing),
    );
    if (result != null) {
      setState(() {
        if (editing != null) {
          final idx = _categories.indexWhere((c) => c.id == editing.id);
          if (idx != -1) _categories[idx] = result;
        } else {
          _categories = [..._categories, result];
        }
      });
    }
  }

  void _openHistory(CategoryItem cat) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _HistorySheet(
        category: cat,
        txs: _txFor(cat.id),
        periodLabel: _periodLabel,
        onEdit: () => _openAddSheet(cat),
      ),
    );
  }

  void _deleteCategory(CategoryItem cat) {
    setState(() => _categories.removeWhere((c) => c.id == cat.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md)),
        margin: const EdgeInsets.all(16),
        content: Row(
          children: [
            const Icon(Icons.delete_outline_rounded,
                color: Colors.white70, size: 18),
            const SizedBox(width: 8),
            Expanded(
                child: Text('"${cat.name}" deleted',
                    style: _j(13, FontWeight.w500, Colors.white))),
            GestureDetector(
              onTap: () {
                setState(() => _categories = [..._categories, cat]);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              child: Text('Undo',
                  style: _j(13, FontWeight.w700, const Color(0xFF90FFB8))),
            ),
          ],
        ),
        duration: const Duration(seconds: 8),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final stats = _computeStats();
    final filtered = _filtered(stats);
    final expenseCount =
        _categories.where((c) => c.type == CategoryType.expense).length;
    final incomeCount =
        _categories.where((c) => c.type == CategoryType.income).length;
    final maxExpense = _maxTotalFor(CategoryType.expense, stats);
    final maxIncome = _maxTotalFor(CategoryType.income, stats);

    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.pageBg),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ─── Header ──────────────────────────────────────────────────
            _buildHeader(),

            // ─── Stats row ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: _buildStatsRow(expenseCount, incomeCount),
            ),
            const SizedBox(height: 16),

            // ─── Search bar ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildSearchBar(),
            ),
            const SizedBox(height: 16),

            // ─── Type filter tabs ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildTypeTabs(),
            ),
            const SizedBox(height: 12),

            // ─── Period chips (history range) ─────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _buildPeriodChips(),
            ),
            const SizedBox(height: 14),

            // ─── Category grid ────────────────────────────────────────────
            Expanded(
              child: filtered.isEmpty
                  ? _buildEmptyState()
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                        childAspectRatio: 0.95,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final c = filtered[i];
                        final s = stats[c.id] ?? _CatStats.empty;
                        final maxT = c.type == CategoryType.expense
                            ? maxExpense
                            : maxIncome;
                        final share = maxT <= 0 ? 0.0 : s.total / maxT;
                        return _CategoryCard(
                          category: c,
                          stats: s,
                          share: share,
                          onOpen: () => _openHistory(c),
                          onEdit: () => _openAddSheet(c),
                          onDelete: () => _deleteCategory(c),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Categories',
                  style: _j(24, FontWeight.w800, AppColors.textPrimary)),
              Text('Based on your spending history',
                  style: _j(13, FontWeight.w400, AppColors.textSecondary)),
            ],
          ),
          const Spacer(),
          // Add button
          GestureDetector(
            onTap: () => _openAddSheet(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppGradients.incomeBtn,
                borderRadius: BorderRadius.circular(AppRadius.md),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.income.withOpacity(0.30),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child:
                  const Icon(Icons.add_rounded, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats row ──────────────────────────────────────────────────────────────
  Widget _buildStatsRow(int expense, int income) {
    return Row(
      children: [
        _StatChip(
          label: 'Expense',
          count: expense,
          color: AppColors.expense,
          icon: Icons.trending_down_rounded,
        ),
        const SizedBox(width: 12),
        _StatChip(
          label: 'Income',
          count: income,
          color: AppColors.income,
          icon: Icons.trending_up_rounded,
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.bgMint,
            borderRadius: BorderRadius.circular(AppRadius.pill),
          ),
          child: Text('${_categories.length} total',
              style: _j(12, FontWeight.w600, AppColors.income)),
        ),
      ],
    );
  }

  // ── Search bar ─────────────────────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: const [
          BoxShadow(
              color: AppColors.shadowDark,
              blurRadius: 12,
              offset: Offset(0, 3)),
        ],
      ),
      child: TextField(
        controller: _searchCtrl,
        style: _j(14, FontWeight.w400, AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: 'Search categories…',
          hintStyle: _j(14, FontWeight.w400, AppColors.textTertiary),
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppColors.textTertiary, size: 20),
          suffixIcon: _query.isNotEmpty
              ? GestureDetector(
                  onTap: () {
                    _searchCtrl.clear();
                    setState(() => _query = '');
                  },
                  child: const Icon(Icons.close_rounded,
                      color: AppColors.textTertiary, size: 18),
                )
              : null,
          border: InputBorder.none,
          filled: false,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // ── Type tabs ──────────────────────────────────────────────────────────────
  Widget _buildTypeTabs() {
    final labels = ['All', 'Expenses', 'Income'];
    final colors = [AppColors.income, AppColors.expense, AppColors.income];
    return Container(
      height: 42,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.bgMint,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        children: List.generate(labels.length, (i) {
          final isSel = _tabCtrl.index == i;
          final selColor = colors[i];
          return Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _tabCtrl.index = i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                decoration: BoxDecoration(
                  color: isSel ? selColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  boxShadow: isSel
                      ? [
                          BoxShadow(
                              color: selColor.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 2))
                        ]
                      : [],
                ),
                alignment: Alignment.center,
                child: Text(
                  labels[i],
                  style: _j(13, FontWeight.w600,
                      isSel ? Colors.white : AppColors.textSecondary),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Period chips ───────────────────────────────────────────────────────────
  Widget _buildPeriodChips() {
    const labels = {
      _Period.week: 'Last 7 days',
      _Period.month: 'Last 30 days',
      _Period.all: 'All time',
    };
    return Row(
      children: [
        for (final p in _Period.values) ...[
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _period = p);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: _period == p
                    ? AppColors.income.withOpacity(0.12)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                border: Border.all(
                  color: _period == p
                      ? AppColors.income.withOpacity(0.45)
                      : AppColors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.schedule_rounded,
                      size: 13,
                      color: _period == p
                          ? AppColors.income
                          : AppColors.textTertiary),
                  const SizedBox(width: 5),
                  Text(
                    labels[p]!,
                    style: _j(
                        11.5,
                        _period == p ? FontWeight.w700 : FontWeight.w500,
                        _period == p
                            ? AppColors.income
                            : AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ],
    );
  }

  // ── Empty state ────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.bgMint,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.category_outlined,
                color: AppColors.income, size: 38),
          ),
          const SizedBox(height: 16),
          Text('No categories found',
              style: _j(17, FontWeight.w700, AppColors.textPrimary)),
          const SizedBox(height: 6),
          Text(
            _query.isEmpty
                ? 'Tap + to create your first category'
                : 'Try a different search term',
            style: _j(13, FontWeight.w400, AppColors.textSecondary),
          ),
          if (_query.isEmpty) ...[
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () => _openAddSheet(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: AppGradients.incomeBtn,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text('Create Category',
                    style: _j(14, FontWeight.w700, Colors.white)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Category Card (grid item)
// ─────────────────────────────────────────────────────────────────────────────
class _CategoryCard extends StatefulWidget {
  final CategoryItem category;
  final _CatStats stats;
  final double share; // 0–1, size of the bottom bar
  final VoidCallback onOpen;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryCard({
    Key? key,
    required this.category,
    required this.stats,
    required this.share,
    required this.onOpen,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _showOptions() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _OptionsSheet(
        category: widget.category,
        stats: widget.stats,
        onView: widget.onOpen,
        onEdit: widget.onEdit,
        onDelete: widget.onDelete,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cat = widget.category;
    final s = widget.stats;
    final isExpense = cat.type == CategoryType.expense;
    final amountColor = isExpense ? AppColors.expense : AppColors.income;
    final sign = isExpense ? '- ' : '+ ';

    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onOpen();
      },
      onTapCancel: () => _ctrl.reverse(),
      onLongPress: _showOptions,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: const [
              BoxShadow(
                  color: AppColors.shadowDark,
                  blurRadius: 14,
                  offset: Offset(0, 4)),
              BoxShadow(
                  color: AppColors.shadowGreen,
                  blurRadius: 20,
                  offset: Offset(0, 6)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Top row: icon + type pill + EDIT icon ─────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 10, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon badge
                    Container(
                      width: 46,
                      height: 46,
                      decoration: BoxDecoration(
                        color: cat.color.withOpacity(0.13),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(cat.icon, color: cat.color, size: 24),
                    ),
                    const Spacer(),
                    // Type pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: amountColor.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: Text(
                        isExpense ? 'Exp' : 'Inc',
                        style: _j(10, FontWeight.w700, amountColor),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ── Name + stats (from transaction history) ────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cat.name,
                      style: _j(14, FontWeight.w700, AppColors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      s.count == 1
                          ? '1 transaction'
                          : '${s.count} transactions',
                      style: _j(11, FontWeight.w400, AppColors.textTertiary),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      s.count == 0 ? '₹0' : '$sign${_inr(s.total)}',
                      style: _j(15, FontWeight.w800, amountColor),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      s.last == null
                          ? 'No activity'
                          : 'Last: ${_fmtShort(s.last!)}, ${_fmtTime(s.last!)}',
                      style: _j(10, FontWeight.w500, AppColors.textTertiary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Share bar (relative to the biggest category of this type)
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: cat.color.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: widget.share.clamp(0.05, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: cat.color,
                            borderRadius: BorderRadius.circular(AppRadius.pill),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// History sheet – transactions of one category with DATE and TIME
// ─────────────────────────────────────────────────────────────────────────────
class _HistorySheet extends StatelessWidget {
  final CategoryItem category;
  final List<TxRecord> txs; // already newest-first
  final String periodLabel;
  final VoidCallback onEdit;

  const _HistorySheet({
    Key? key,
    required this.category,
    required this.txs,
    required this.periodLabel,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isExpense = category.type == CategoryType.expense;
    final amountColor = isExpense ? AppColors.expense : AppColors.income;
    final sign = isExpense ? '- ' : '+ ';
    double total = 0;
    for (final t in txs) {
      total += t.amount;
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.4,
      maxChildSize: 0.92,
      expand: false,
      builder: (context, scrollCtrl) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
          ),
          child: ListView(
            controller: scrollCtrl,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Header
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: category.color.withOpacity(0.13),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(category.icon, color: category.color, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(category.name,
                            style:
                                _j(17, FontWeight.w800, AppColors.textPrimary)),
                        Text(
                          '${txs.length} transactions · $periodLabel',
                          style:
                              _j(12, FontWeight.w400, AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  // Small coloured edit icon
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      onEdit();
                    },
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: category.color.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: category.color.withOpacity(0.35)),
                      ),
                      child: Icon(Icons.edit_rounded,
                          size: 16, color: category.color),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Total card
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: amountColor.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: amountColor.withOpacity(0.18)),
                ),
                child: Row(
                  children: [
                    Text(isExpense ? 'Total spent' : 'Total received',
                        style:
                            _j(13, FontWeight.w600, AppColors.textSecondary)),
                    const Spacer(),
                    Text(
                      txs.isEmpty ? '₹0' : '$sign${_inr(total)}',
                      style: _j(18, FontWeight.w800, amountColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              Text('Transaction history',
                  style: _j(13, FontWeight.w700, AppColors.textSecondary)),
              const SizedBox(height: 10),

              if (txs.isEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      'No transactions in this period',
                      style: _j(13, FontWeight.w500, AppColors.textTertiary),
                    ),
                  ),
                )
              else
                for (final t in txs)
                  Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.bgCard,
                      borderRadius: BorderRadius.circular(AppRadius.xl),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: category.color.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: Icon(category.icon,
                              color: category.color, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                t.title,
                                style: _j(13.5, FontWeight.w700,
                                    AppColors.textPrimary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              // DATE + TIME
                              Text(
                                '${_dayLabel(t.dateTime)} · ${_fmtDate(t.dateTime)} · ${_fmtTime(t.dateTime)}',
                                style: _j(11, FontWeight.w400,
                                    AppColors.textTertiary),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$sign${_inr(t.amount)}',
                          style: _j(13.5, FontWeight.w800, amountColor),
                        ),
                      ],
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Options sheet (long-press)
// ─────────────────────────────────────────────────────────────────────────────
class _OptionsSheet extends StatelessWidget {
  final CategoryItem category;
  final _CatStats stats;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _OptionsSheet({
    Key? key,
    required this.category,
    required this.stats,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Category preview
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: category.color.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(category.icon, color: category.color, size: 26),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.name,
                      style: _j(16, FontWeight.w700, AppColors.textPrimary)),
                  Text(
                    '${stats.count} transactions · ${_inr(stats.total)}',
                    style: _j(12, FontWeight.w400, AppColors.textSecondary),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 12),

          // View history
          _actionTile(
            icon: Icons.receipt_long_rounded,
            label: 'View Transactions',
            color: category.color,
            onTap: () {
              Navigator.pop(context);
              onView();
            },
          ),
          const SizedBox(height: 8),

          // Edit
          _actionTile(
            icon: Icons.circle_rounded,
            label: 'Edit Category',
            color: AppColors.income,
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          const SizedBox(height: 8),

          // Delete
          _actionTile(
            icon: Icons.delete_outline_rounded,
            label: 'Delete Category',
            color: AppColors.expense,
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
          const SizedBox(height: 8),

          // Cancel
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.bgMint,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              alignment: Alignment.center,
              child: Text('Cancel',
                  style: _j(14, FontWeight.w600, AppColors.textSecondary)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionTile(
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: color.withOpacity(0.15)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(label, style: _j(14, FontWeight.w600, color)),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Add / Edit Category bottom sheet
// ─────────────────────────────────────────────────────────────────────────────
class _CategoryFormSheet extends StatefulWidget {
  final CategoryItem? editing;
  const _CategoryFormSheet({Key? key, this.editing}) : super(key: key);

  @override
  State<_CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends State<_CategoryFormSheet> {
  late TextEditingController _nameCtrl;
  late CategoryType _type;
  late Color _selectedColor;
  late IconData _selectedIcon;

  static const _palette = [
    Color(0xFFFF7A2F),
    Color(0xFF4F5BD5),
    Color(0xFFFFB020),
    Color(0xFFF0506E),
    Color(0xFF8B5CF6),
    Color(0xFF1a6b45),
    Color(0xFF0EA5E9),
    Color(0xFFEF4444),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFF6366F1),
    Color(0xFFEC4899),
  ];

  static const _icons = [
    Icons.restaurant_rounded,
    Icons.directions_car_rounded,
    Icons.shopping_bag_rounded,
    Icons.favorite_rounded,
    Icons.movie_rounded,
    Icons.account_balance_wallet_rounded,
    Icons.home_rounded,
    Icons.flight_rounded,
    Icons.fitness_center_rounded,
    Icons.school_rounded,
    Icons.coffee_rounded,
    Icons.sports_basketball_rounded,
    Icons.pets_rounded,
    Icons.local_hospital_rounded,
    Icons.music_note_rounded,
    Icons.work_rounded,
    Icons.savings_rounded,
    Icons.card_giftcard_rounded,
    Icons.phone_android_rounded,
    Icons.electrical_services_rounded,
    Icons.attach_money_rounded,
    Icons.trending_up_rounded,
    Icons.category_rounded,
    Icons.more_horiz_rounded,
  ];

  @override
  void initState() {
    super.initState();
    final e = widget.editing;
    _nameCtrl = TextEditingController(text: e?.name ?? '');
    _type = e?.type ?? CategoryType.expense;
    _selectedColor = e?.color ?? _palette[0];
    _selectedIcon = e?.icon ?? _icons[0];
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    final result = CategoryItem(
      id: widget.editing?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      icon: _selectedIcon,
      color: _selectedColor,
      type: _type,
    );
    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.editing != null;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Title
            Row(
              children: [
                Text(
                  isEditing ? 'Edit Category' : 'New Category',
                  style: _j(20, FontWeight.w800, AppColors.textPrimary),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded,
                      color: AppColors.textTertiary),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Preview pill ─────────────────────────────────────────────
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: _selectedColor.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: _selectedColor.withOpacity(0.25)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: _selectedColor.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                      ),
                      child:
                          Icon(_selectedIcon, color: _selectedColor, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _nameCtrl.text.isEmpty ? 'Category Name' : _nameCtrl.text,
                      style: _j(16, FontWeight.w700, _selectedColor),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Name input ───────────────────────────────────────────────
            Text('Name',
                style: _j(13, FontWeight.w600, AppColors.textSecondary)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameCtrl,
              onChanged: (_) => setState(() {}),
              style: _j(15, FontWeight.w600, AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'e.g. Groceries, Freelance…',
                prefixIcon: const Icon(Icons.label_outline_rounded,
                    color: AppColors.income, size: 20),
                filled: true,
                fillColor: AppColors.bgMint,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide:
                      const BorderSide(color: AppColors.income, width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ── Type toggle ───────────────────────────────────────────────
            Text('Type',
                style: _j(13, FontWeight.w600, AppColors.textSecondary)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _type = CategoryType.expense),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _type == CategoryType.expense
                            ? AppColors.expense.withOpacity(0.12)
                            : AppColors.bgMint,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: _type == CategoryType.expense
                              ? AppColors.expense.withOpacity(0.40)
                              : AppColors.border,
                          width: _type == CategoryType.expense ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.trending_down_rounded,
                              size: 18,
                              color: _type == CategoryType.expense
                                  ? AppColors.expense
                                  : AppColors.textTertiary),
                          const SizedBox(width: 6),
                          Text(
                            'Expense',
                            style: _j(
                                13,
                                FontWeight.w700,
                                _type == CategoryType.expense
                                    ? AppColors.expense
                                    : AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _type = CategoryType.income),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _type == CategoryType.income
                            ? AppColors.income.withOpacity(0.12)
                            : AppColors.bgMint,
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: _type == CategoryType.income
                              ? AppColors.income.withOpacity(0.40)
                              : AppColors.border,
                          width: _type == CategoryType.income ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.trending_up_rounded,
                              size: 18,
                              color: _type == CategoryType.income
                                  ? AppColors.income
                                  : AppColors.textTertiary),
                          const SizedBox(width: 6),
                          Text(
                            'Income',
                            style: _j(
                                13,
                                FontWeight.w700,
                                _type == CategoryType.income
                                    ? AppColors.income
                                    : AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Icon picker ───────────────────────────────────────────────
            Text('Icon',
                style: _j(13, FontWeight.w600, AppColors.textSecondary)),
            const SizedBox(height: 10),
            SizedBox(
              height: 52,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _icons.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final icon = _icons[i];
                  final isSel = icon == _selectedIcon;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedIcon = icon),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSel
                            ? _selectedColor.withOpacity(0.15)
                            : AppColors.bgMint,
                        borderRadius: BorderRadius.circular(AppRadius.sm),
                        border: Border.all(
                          color: isSel ? _selectedColor : AppColors.border,
                          width: isSel ? 2 : 1,
                        ),
                      ),
                      child: Icon(icon,
                          color:
                              isSel ? _selectedColor : AppColors.textTertiary,
                          size: 22),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),

            // ── Color picker ───────────────────────────────────────────────
            Text('Color',
                style: _j(13, FontWeight.w600, AppColors.textSecondary)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _palette.map((color) {
                final isSel = color == _selectedColor;
                return GestureDetector(
                  onTap: () => setState(() => _selectedColor = color),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color:
                            isSel ? AppColors.textPrimary : Colors.transparent,
                        width: 2.5,
                      ),
                      boxShadow: isSel
                          ? [
                              BoxShadow(
                                  color: color.withOpacity(0.40),
                                  blurRadius: 8,
                                  spreadRadius: 1)
                            ]
                          : [],
                    ),
                    child: isSel
                        ? const Icon(Icons.check_rounded,
                            color: Colors.white, size: 18)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),

            // ── Save button ────────────────────────────────────────────────
            PrimaryButton(
              label: isEditing ? 'Save Changes' : 'Create Category',
              icon: isEditing ? Icons.check_rounded : Icons.add_rounded,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat chip widget
// ─────────────────────────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;

  const _StatChip({
    Key? key,
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppRadius.pill),
        border: Border.all(color: color.withOpacity(0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text('$count $label', style: _j(12, FontWeight.w600, color)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Default categories (no hard-coded totals – they come from the history)
// ─────────────────────────────────────────────────────────────────────────────
const List<CategoryItem> _kDefaultCategories = [
  CategoryItem(
    id: '1',
    name: 'Food & Dining',
    icon: Icons.restaurant_rounded,
    color: AppColors.catFood,
    type: CategoryType.expense,
  ),
  CategoryItem(
    id: '2',
    name: 'Transport',
    icon: Icons.directions_car_rounded,
    color: AppColors.catTransport,
    type: CategoryType.expense,
  ),
  CategoryItem(
    id: '3',
    name: 'Shopping',
    icon: Icons.shopping_bag_rounded,
    color: AppColors.catShopping,
    type: CategoryType.expense,
  ),
  CategoryItem(
    id: '4',
    name: 'Health & Fitness',
    icon: Icons.favorite_rounded,
    color: AppColors.catHealth,
    type: CategoryType.expense,
  ),
  CategoryItem(
    id: '5',
    name: 'Entertainment',
    icon: Icons.movie_rounded,
    color: AppColors.catEntertain,
    type: CategoryType.expense,
  ),
  CategoryItem(
    id: '6',
    name: 'Salary',
    icon: Icons.account_balance_wallet_rounded,
    color: AppColors.catSalary,
    type: CategoryType.income,
  ),
  CategoryItem(
    id: '7',
    name: 'Freelance',
    icon: Icons.work_rounded,
    color: Color(0xFF0EA5E9),
    type: CategoryType.income,
  ),
  CategoryItem(
    id: '8',
    name: 'Utilities',
    icon: Icons.electrical_services_rounded,
    color: Color(0xFF6366F1),
    type: CategoryType.expense,
  ),
  CategoryItem(
    id: '9',
    name: 'Others',
    icon: Icons.category_rounded,
    color: AppColors.catOthers,
    type: CategoryType.expense,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Sample transaction history (date + time).
// Replace this with your real transactions (database / provider / API).
// categoryId must match a CategoryItem.id above.
// ─────────────────────────────────────────────────────────────────────────────
List<TxRecord> _seedTransactions() {
  final now = DateTime.now();
  int n = 0;
  TxRecord t(String cat, String title, double amt, int daysAgo, int h, int m) =>
      TxRecord(
        id: 'tx${n++}',
        categoryId: cat,
        title: title,
        amount: amt,
        dateTime: DateTime(now.year, now.month, now.day - daysAgo, h, m),
      );

  return [
    // Food & Dining
    t('1', 'Grocery Store', 452.20, 1, 10, 24),
    t('1', 'Coffee Shop', 120, 1, 18, 32),
    t('1', 'Restaurant Dinner', 860, 3, 20, 15),
    t('1', 'Swiggy Order', 340, 5, 13, 5),
    t('1', 'Bakery', 95, 8, 9, 40),
    t('1', 'Lunch Combo', 280, 12, 13, 20),
    // Transport
    t('2', 'Uber Ride', 230, 2, 9, 10),
    t('2', 'Metro Card Recharge', 500, 6, 8, 45),
    t('2', 'Fuel', 1200, 10, 18, 5),
    // Shopping
    t('3', 'Amazon Order', 899, 4, 15, 30),
    t('3', 'Clothing Store', 1500, 9, 17, 10),
    // Health & Fitness
    t('4', 'Pharmacy', 340, 7, 11, 5),
    t('4', 'Gym Membership', 999, 14, 7, 30),
    // Entertainment
    t('5', 'Netflix', 199, 2, 20, 15),
    t('5', 'Movie Tickets', 450, 11, 19, 45),
    // Salary
    t('6', 'Monthly Salary', 45000, 1, 9, 0),
    t('6', 'Performance Bonus', 15000, 13, 11, 0),
    // Freelance
    t('7', 'Logo Design Project', 8500, 5, 16, 20),
    t('7', 'Website Fix', 10000, 15, 12, 0),
    // Utilities
    t('8', 'Electricity Bill', 1400, 6, 10, 0),
    t('8', 'Internet Bill', 999, 12, 10, 30),
    // Others
    t('9', 'Miscellaneous', 300, 3, 14, 0),
    t('9', 'Gift', 540, 18, 16, 0),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────
TextStyle _j(double s, FontWeight w, Color c) =>
    GoogleFonts.plusJakartaSans(fontSize: s, fontWeight: w, color: c);

const _kMonths = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

/// 16 Nov 2026
String _fmtDate(DateTime d) => '${d.day} ${_kMonths[d.month - 1]} ${d.year}';

/// 16 Nov
String _fmtShort(DateTime d) => '${d.day} ${_kMonths[d.month - 1]}';

/// 10:24 AM
String _fmtTime(DateTime d) {
  final h = d.hour % 12 == 0 ? 12 : d.hour % 12;
  final m = d.minute.toString().padLeft(2, '0');
  final ap = d.hour >= 12 ? 'PM' : 'AM';
  return '$h:$m $ap';
}

/// Today / Yesterday / Mon … (for the history list)
String _dayLabel(DateTime d) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final day = DateTime(d.year, d.month, d.day);
  final diff = today.difference(day).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Yesterday';
  const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  return names[d.weekday - 1];
}

/// ₹1,23,456 (Indian digit grouping; decimals only when needed)
String _inr(double value) {
  final v = value.abs();
  final whole = v == v.roundToDouble();
  final s = whole ? v.toStringAsFixed(0) : v.toStringAsFixed(2);
  final parts = s.split('.');
  final intPart = parts[0];
  String grouped;
  if (intPart.length <= 3) {
    grouped = intPart;
  } else {
    final last3 = intPart.substring(intPart.length - 3);
    var rest = intPart.substring(0, intPart.length - 3);
    final chunks = <String>[];
    while (rest.length > 2) {
      chunks.insert(0, rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) chunks.insert(0, rest);
    grouped = '${chunks.join(',')},$last3';
  }
  return '₹$grouped${parts.length > 1 ? '.${parts[1]}' : ''}';
}
