// lib/screens/quick_add_screen.dart
// Spendly – Quick Add Transaction bottom-sheet (Finora-inspired)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_system.dart';

class QuickAddScreen extends StatelessWidget {
  const QuickAddScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.pageBg),
      child: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: AppGradients.incomeBtn,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.income.withOpacity(0.35),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.add_rounded,
                    color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),
              Text('Tap + to record a transaction',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 15, color: AppColors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Bottom-Sheet (called from MainScaffold)
// ─────────────────────────────────────────────────────────────────────────────
class QuickAddBottomSheet extends StatefulWidget {
  const QuickAddBottomSheet({Key? key}) : super(key: key);

  @override
  State<QuickAddBottomSheet> createState() => _QuickAddBottomSheetState();
}

class _QuickAddBottomSheetState extends State<QuickAddBottomSheet>
    with SingleTickerProviderStateMixin {
  String _amount = '';
  bool _isExpense = true;
  String _selectedMethod = 'UPI';
  String _selectedCategory = 'Food';

  late TabController _typeTab;

  final _methods = const ['UPI', 'Cash', 'Card', 'Net Banking'];
  final _categories = const [
    _Cat('Food', Icons.restaurant_rounded, AppColors.catFood),
    _Cat('Transport', Icons.directions_car_rounded, AppColors.catTransport),
    _Cat('Shopping', Icons.shopping_bag_rounded, AppColors.catShopping),
    _Cat('Health', Icons.favorite_rounded, AppColors.catHealth),
    _Cat('Entertainment', Icons.movie_rounded, AppColors.catEntertain),
    _Cat('Other', Icons.grid_view_rounded, AppColors.catOthers),
  ];

  @override
  void initState() {
    super.initState();
    _typeTab = TabController(length: 2, vsync: this);
    _typeTab
        .addListener(() => setState(() => _isExpense = _typeTab.index == 0));
  }

  @override
  void dispose() {
    _typeTab.dispose();
    super.dispose();
  }

  Color get _activeColor => _isExpense ? AppColors.expense : AppColors.income;
  Gradient get _activeGradient =>
      _isExpense ? AppGradients.expenseBtn : AppGradients.incomeBtn;

  void _onKey(String key) {
    setState(() {
      if (key == '⌫') {
        if (_amount.isNotEmpty)
          _amount = _amount.substring(0, _amount.length - 1);
      } else if (key == '.' && _amount.contains('.')) {
        return;
      } else {
        _amount += key;
      }
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
          ),
          const SizedBox(height: 16),

          // ── Type toggle ────────────────────────────────────────────────
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.bgMint,
              borderRadius: BorderRadius.circular(AppRadius.pill),
            ),
            child: Row(
              children: [
                // Expense – left half
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _isExpense = true);
                      _typeTab.animateTo(0);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: _isExpense
                            ? AppColors.expenseLight
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.remove_circle_outline_rounded,
                            size: 16,
                            color: _isExpense
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Expense',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: _isExpense
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: _isExpense
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Income – right half
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() => _isExpense = false);
                      _typeTab.animateTo(1);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        color: !_isExpense
                            ? AppColors.income
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(AppRadius.pill),
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle_outline_rounded,
                            size: 16,
                            color: !_isExpense
                                ? Colors.white
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Income',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: !_isExpense
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                              color: !_isExpense
                                  ? Colors.white
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Amount display ─────────────────────────────────────────────
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _amount.isEmpty ? '₹0' : '₹$_amount',
                key: ValueKey(_amount),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  color:
                      _amount.isEmpty ? AppColors.textTertiary : _activeColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // ── Category chips ─────────────────────────────────────────────
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final isSel = cat.name == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat.name),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSel
                          ? cat.color.withOpacity(0.15)
                          : AppColors.bgMint,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                      border: Border.all(
                        color: isSel ? cat.color : AppColors.border,
                        width: isSel ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(cat.icon,
                            size: 14,
                            color: isSel ? cat.color : AppColors.textSecondary),
                        const SizedBox(width: 5),
                        Text(cat.name,
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSel
                                    ? cat.color
                                    : AppColors.textSecondary)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // ── Payment method ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 8,
              children: _methods.map((m) {
                final isSel = m == _selectedMethod;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMethod = m),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color: isSel ? AppColors.income : AppColors.bgMint,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      m,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isSel ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          // ── Numpad ─────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildNumpad(),
          ),
          const SizedBox(height: 16),

          // ── Save button ────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: PrimaryButton(
              label: _isExpense ? 'Add Expense' : 'Add Income',
              gradient: _activeGradient,
              icon: _isExpense
                  ? Icons.remove_circle_outline_rounded
                  : Icons.add_circle_outline_rounded,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildNumpad() {
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['.', '0', '⌫'],
    ];
    return Column(
      children: rows.map((row) {
        return Row(
          children: row.map((d) {
            final isBackspace = d == '⌫';
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                child: GestureDetector(
                  onTap: () => _onKey(d),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 100),
                    height: 56,
                    decoration: BoxDecoration(
                      color: isBackspace ? AppColors.bgMint : AppColors.bgLight,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      boxShadow: const [
                        BoxShadow(
                            color: AppColors.shadowDark,
                            blurRadius: 4,
                            offset: Offset(0, 1)),
                      ],
                    ),
                    child: Center(
                      child: isBackspace
                          ? const Icon(Icons.backspace_outlined,
                              size: 20, color: AppColors.textSecondary)
                          : Text(d,
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary)),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}

class _Cat {
  final String name;
  final IconData icon;
  final Color color;
  const _Cat(this.name, this.icon, this.color);
}
