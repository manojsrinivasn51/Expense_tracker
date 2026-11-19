// lib/screens/home_screen.dart
// ApexPay-inspired Financial Dashboard – replaces the old Spendly home screen.
// Uses a namespaced _Apex color palette to avoid collisions with design_system.dart.
//
// CHANGE: "Spending Breakdown" is now a vertical animated BAR GRAPH
// (tap any bar to see its amount + share of the total).

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

// ───────────────────────── ApexPay Color Palette ─────────────────────────
class _Apex {
  // Slate neutrals
  static const slate900 = Color(0xFF0F172A);
  static const slate800 = Color(0xFF1E293B);
  static const slate700 = Color(0xFF334155);
  static const slate500 = Color(0xFF64748B);
  static const slate400 = Color(0xFF94A3B8);
  static const slate300 = Color(0xFFCBD5E1);
  static const slate200 = Color(0xFFE2E8F0);
  static const slate100 = Color(0xFFF1F5F9);
  static const bg = Color(0xFFF8FAFC);

  // Emerald / Teal
  static const emerald600 = Color(0xFF059669);
  static const emerald500 = Color(0xFF10B981);
  static const emerald400 = Color(0xFF34D399);
  static const emerald300 = Color(0xFF6EE7B7);
  static const emerald200 = Color(0xFFA7F3D0);
  static const emerald100 = Color(0xFFD1FAE5);
  static const emerald50 = Color(0xFFECFDF5);
  static const teal400 = Color(0xFF2DD4BF);
  static const teal500 = Color(0xFF14B8A6);

  // Accent
  static const rose500 = Color(0xFFF43F5E);
}

// ───────────────────────── Transaction Data ─────────────────────────
class _TxItem {
  final String title;
  final String category;
  final String time;
  final String amount;
  final String label;
  final bool isCredit;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final Color iconBorder;

  const _TxItem({
    required this.title,
    required this.category,
    required this.time,
    required this.amount,
    required this.label,
    required this.isCredit,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.iconBorder,
  });
}

const _transactions = <_TxItem>[
  _TxItem(
    title: 'Grocery Store',
    category: 'Food & Dining',
    time: '10:24 AM',
    amount: '- ₹45.20',
    label: 'Debit',
    isCredit: false,
    icon: Icons.shopping_bag_outlined,
    iconColor: Color(0xFFF97316),
    iconBg: Color(0xFFFFF7ED),
    iconBorder: Color(0xFFFFEDD5),
  ),
  _TxItem(
    title: 'Salary',
    category: 'Income',
    time: '09:00 AM',
    amount: '+ ₹1,200.00',
    label: 'Credited',
    isCredit: true,
    icon: Icons.credit_card_outlined,
    iconColor: Color(0xFF059669),
    iconBg: Color(0xFFECFDF5),
    iconBorder: Color(0xFFD1FAE5),
  ),
  _TxItem(
    title: 'Netflix',
    category: 'Entertainment',
    time: '08:15 PM',
    amount: '- ₹15.99',
    label: 'Subscription',
    isCredit: false,
    icon: Icons.play_circle_outline,
    iconColor: Color(0xFF6366F1),
    iconBg: Color(0xFFEEF2FF),
    iconBorder: Color(0xFFE0E7FF),
  ),
  _TxItem(
    title: 'Coffee Shop',
    category: 'Food & Dining',
    time: '06:32 PM',
    amount: '- ₹4.50',
    label: 'Debit',
    isCredit: false,
    icon: Icons.coffee_outlined,
    iconColor: Color(0xFFF59E0B),
    iconBg: Color(0xFFFFFBEB),
    iconBorder: Color(0xFFFEF3C7),
  ),
];

// ═══════════════════════════════════════════════════════════════════════════
// HomeScreen (public — used by MainScaffold)
// ═══════════════════════════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _MeshBackground(),
        SafeArea(
          bottom: false,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
            children: const [
              _GreetingHeader(),
              SizedBox(height: 20),
              _BalanceCard(),
              SizedBox(height: 20),
              _SpendingBreakdown(),
              SizedBox(height: 20),
              _SpendingPill(),
              SizedBox(height: 20),
              _RecentTransactions(),
            ],
          ),
        ),
      ],
    );
  }
}

// ───────────────────────── Mesh Background ─────────────────────────
class _MeshBackground extends StatelessWidget {
  const _MeshBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Container(color: _Apex.bg),
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-0.8, -0.8),
                radius: 0.9,
                colors: [Color(0xFFE6F9F3), Color(0x00E6F9F3)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0.8, -0.5),
                radius: 0.8,
                colors: [Color(0xFFEEF2FF), Color(0x00EEF2FF)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Greeting Header ─────────────────────────
class _GreetingHeader extends StatelessWidget {
  const _GreetingHeader();

  String _getGreeting() {
    final h = DateTime.now().hour;
    if (h >= 5 && h < 12) return 'GOOD MORNING,';
    if (h >= 12 && h < 17) return 'GOOD AFTERNOON,';
    if (h >= 17 && h < 21) return 'GOOD EVENING,';
    return 'GOOD NIGHT,';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getGreeting(),
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: _Apex.slate500,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Text(
                  'Manoj',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: _Apex.slate900,
                  ),
                ),
                const SizedBox(width: 6),
                const Text('👋', style: TextStyle(fontSize: 24)),
              ],
            ),
          ],
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 48,
              height: 48,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: [_Apex.emerald500, _Apex.teal400],
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.person,
                    size: 28, color: _Apex.emerald600),
              ),
            ),
            Positioned(
              top: -2,
              right: -2,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: _Apex.emerald600,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ───────────────────────── Balance Card ─────────────────────────
class _BalanceCard extends StatefulWidget {
  const _BalanceCard();

  @override
  State<_BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<_BalanceCard> {
  bool _visible = true;
  static const _real = '₹2,580.75';
  static const _hidden = '••••••••';

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF043329), Color(0xFF064E3B), Color(0xFF01261D)],
        ),
        border: Border.all(color: _Apex.emerald500.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF059669).withOpacity(0.45),
            blurRadius: 30,
            spreadRadius: -8,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Decorative orbs
            Positioned(
              top: -48,
              right: -48,
              child: _orb(176, _Apex.emerald400.withOpacity(0.10)),
            ),
            Positioned(
              bottom: -64,
              left: -40,
              child: _orb(160, _Apex.emerald300.withOpacity(0.10)),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row — label + card chip
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TOTAL BALANCE',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.8,
                          color: _Apex.emerald200.withOpacity(0.8),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                              color: _Apex.emerald400.withOpacity(0.2)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: _Apex.emerald400,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '•••• 4567',
                              style: GoogleFonts.robotoMono(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 1,
                                color: _Apex.emerald100,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Amount + eye toggle
                  Row(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 350),
                        child: Text(
                          _visible ? _real : _hidden,
                          key: ValueKey(_visible),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.8,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () => setState(() => _visible = !_visible),
                        child: Padding(
                          padding: const EdgeInsets.all(6),
                          child: Icon(
                            _visible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                            color: _Apex.emerald300.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Divider
                  Container(
                    height: 1,
                    color: _Apex.emerald400.withOpacity(0.15),
                  ),
                  const SizedBox(height: 10),

                  // Delta pill + VISA
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: _Apex.emerald500.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(
                              color: _Apex.emerald400.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.trending_up,
                                size: 14, color: _Apex.emerald300),
                            const SizedBox(width: 6),
                            Text.rich(
                              TextSpan(
                                text: '+ ₹320.50 (12.4%) ',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _Apex.emerald200,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'this month',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: _Apex.emerald300.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.95),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'VISA',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            fontStyle: FontStyle.italic,
                            letterSpacing: -0.5,
                            color: const Color(0xFF1E3A8A),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _orb(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

// ═══════════════════════════════════════════════════════════════════════════
// Spending Breakdown — BAR GRAPH
// ═══════════════════════════════════════════════════════════════════════════
class _SpendCat {
  final String label; // full name
  final String shortLabel; // axis label
  final double value; // amount in ₹
  final Color color;
  final IconData icon;
  const _SpendCat(
      this.label, this.shortLabel, this.value, this.color, this.icon);
}

const _spendCategories = <_SpendCat>[
  _SpendCat('Food & Dining', 'Food', 396, Color(0xFFF97316),
      Icons.restaurant_rounded),
  _SpendCat('Transport', 'Transit', 223, Color(0xFF6366F1),
      Icons.directions_car_rounded),
  _SpendCat('Shopping', 'Shop', 198, Color(0xFFF59E0B),
      Icons.shopping_bag_rounded),
  _SpendCat(
      'Health', 'Health', 111, Color(0xFFEC4899), Icons.favorite_rounded),
  _SpendCat('Entertainment', 'Fun', 99, Color(0xFF8B5CF6),
      Icons.movie_rounded),
];

String _rupee(double v) => '₹${v.toStringAsFixed(0)}';

class _SpendingBreakdown extends StatefulWidget {
  const _SpendingBreakdown();

  @override
  State<_SpendingBreakdown> createState() => _SpendingBreakdownState();
}

class _SpendingBreakdownState extends State<_SpendingBreakdown> {
  int _selected = 0;

  // Chart geometry
  static const double _plotHeight = 160; // height of the 0 → axisMax area
  static const double _topPad = 26; // room for amount label above tallest bar
  static const double _bottomPad = 8; // room so the ₹0 label isn't clipped
  static const double _yAxisWidth = 44; // space for Y-axis numbers
  static const double _valueLabelHeight = 20; // amount text above each bar
  static const int _gridLines = 4; // ticks: 0, 250, 500, 750, 1000

  /// Y-axis runs 0 → 1000 (it grows in steps of 1000 if spending exceeds that)
  double get _axisMax => (_maxValue / 1000).ceil().clamp(1, 1000) * 1000.0;

  double get _total =>
      _spendCategories.fold<double>(0, (sum, c) => sum + c.value);

  double get _maxValue => _spendCategories
      .map((c) => c.value)
      .reduce((a, b) => a > b ? a : b);

  @override
  Widget build(BuildContext context) {
    final sel = _spendCategories[_selected];
    final pct = sel.value / _total * 100;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _Apex.slate200.withOpacity(0.7)),
        boxShadow: [
          BoxShadow(
            color: _Apex.slate900.withOpacity(0.06),
            blurRadius: 24,
            spreadRadius: -4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Spending Breakdown',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: _Apex.slate900,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _Apex.emerald50,
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Border.all(color: _Apex.emerald200.withOpacity(0.6)),
                ),
                child: Text(
                  'This Month',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: _Apex.emerald600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Total  ${_rupee(_total)}',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _Apex.slate400,
            ),
          ),
          const SizedBox(height: 14),

          // ── Selected bar summary ─────────────────────────────────
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.15),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: Container(
              key: ValueKey(_selected),
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: sel.color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: sel.color.withOpacity(0.18)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: sel.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(sel.icon, size: 16, color: sel.color),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      sel.label,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _Apex.slate800,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _rupee(sel.value),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: _Apex.slate900,
                        ),
                      ),
                      Text(
                        '${pct.toStringAsFixed(1)}% of total',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: _Apex.slate500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),

          // ── Bar chart ────────────────────────────────────────────
          SizedBox(
            height: _topPad + _plotHeight + _bottomPad,
            child: Stack(
              children: [
                // Y-axis numbers (0 → axisMax) + horizontal grid lines
                for (int i = 0; i <= _gridLines; i++)
                  Positioned(
                    left: 0,
                    right: 0,
                    // i = 0 is the bottom line (0), i = _gridLines is the top
                    top: _topPad + _plotHeight * (1 - i / _gridLines) - 7,
                    height: 14,
                    child: Row(
                      children: [
                        SizedBox(
                          width: _yAxisWidth - 6,
                          child: Text(
                            _rupee(_axisMax * i / _gridLines),
                            textAlign: TextAlign.right,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: _Apex.slate400,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Container(
                            height: 1,
                            color: i == 0 ? _Apex.slate200 : _Apex.slate100,
                          ),
                        ),
                      ],
                    ),
                  ),
                // Bars
                Positioned(
                  left: _yAxisWidth,
                  right: 0,
                  top: 0,
                  bottom: _bottomPad,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (int i = 0; i < _spendCategories.length; i++)
                        Expanded(child: _buildBar(i)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // ── X-axis labels ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(left: _yAxisWidth),
            child: Row(
              children: [
                for (int i = 0; i < _spendCategories.length; i++)
                  Expanded(child: _buildAxisLabel(i)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(int i) {
    final cat = _spendCategories[i];
    final selected = i == _selected;
    // Bar height is relative to the Y-axis scale (0 → axisMax)
    final targetHeight = (cat.value / _axisMax) * _plotHeight;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selected = i);
      },
      child: TweenAnimationBuilder<double>(
        // staggered grow-in animation on first build
        tween: Tween<double>(begin: 0, end: targetHeight),
        duration: Duration(milliseconds: 650 + i * 120),
        curve: Curves.easeOutCubic,
        builder: (context, h, _) {
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 220),
            opacity: selected ? 1.0 : 0.45,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: _valueLabelHeight,
                  child: Center(
                    child: Text(
                      _rupee(cat.value),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: selected ? cat.color : _Apex.slate500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 30,
                  height: h,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                      bottom: Radius.circular(3),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [cat.color, cat.color.withOpacity(0.55)],
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: cat.color.withOpacity(0.35),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildAxisLabel(int i) {
    final cat = _spendCategories[i];
    final selected = i == _selected;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selected = i);
      },
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: selected
                  ? cat.color.withOpacity(0.16)
                  : _Apex.slate100,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              cat.icon,
              size: 14,
              color: selected ? cat.color : _Apex.slate400,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            cat.shortLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: selected ? _Apex.slate800 : _Apex.slate400,
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Spending Pill ─────────────────────────
class _SpendingPill extends StatelessWidget {
  const _SpendingPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [_Apex.slate900, _Apex.slate800],
        ),
        boxShadow: [
          BoxShadow(
            color: _Apex.slate900.withOpacity(0.06),
            blurRadius: 24,
            spreadRadius: -4,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _Apex.emerald500.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: _Apex.emerald400.withOpacity(0.3)),
                ),
                child: const Icon(Icons.pie_chart_outline,
                    size: 16, color: _Apex.emerald400),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spent this month',
                    style: GoogleFonts.plusJakartaSans(
                        fontSize: 11, color: _Apex.slate400),
                  ),
                  Text.rich(
                    TextSpan(
                      text: '₹742.30 ',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _Apex.slate100,
                      ),
                      children: const [
                        TextSpan(
                          text: 'of ₹3,000 budget',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: _Apex.slate400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: _Apex.emerald400.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '24.7%',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _Apex.emerald400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ───────────────────────── Recent Transactions ─────────────────────────
class _RecentTransactions extends StatelessWidget {
  const _RecentTransactions();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.3,
                  color: _Apex.slate900,
                ),
              ),
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      'See All',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _Apex.emerald600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.chevron_right,
                        size: 16, color: _Apex.emerald600),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        for (final t in _transactions) ...[
          _TransactionTile(item: t),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final _TxItem item;
  const _TransactionTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _Apex.slate100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: item.iconBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: item.iconBorder),
            ),
            child: Icon(item.icon, size: 20, color: item.iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                    color: _Apex.slate800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item.category} • ${item.time}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: _Apex.slate400,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item.amount,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.2,
                  color: item.isCredit ? _Apex.emerald600 : _Apex.rose500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight:
                      item.isCredit ? FontWeight.w500 : FontWeight.w400,
                  color: item.isCredit ? _Apex.emerald500 : _Apex.slate400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}