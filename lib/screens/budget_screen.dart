// lib/screens/budget_screen.dart
// Spendly – Budget screen (Finora-inspired layout)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../design_system.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({Key? key}) : super(key: key);

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  int _touchedIndex = -1;

  static const _categories = [
    _BudgetItem('Food & Dining', AppColors.catFood, 0.60, '₹759', '₹1,200',
        Icons.restaurant_rounded),
    _BudgetItem('Transport', AppColors.catTransport, 0.45, '₹337', '₹750',
        Icons.directions_car_rounded),
    _BudgetItem('Shopping', AppColors.catShopping, 0.88, '₹440', '₹500',
        Icons.shopping_bag_rounded),
    _BudgetItem('Health', AppColors.catHealth, 0.30, '₹90', '₹300',
        Icons.favorite_rounded),
    _BudgetItem('Entertainment', AppColors.catEntertain, 1.15, '₹345', '₹300',
        Icons.movie_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.pageBg),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ─── AppBar ───────────────────────────────────────────────────
            _buildHeader(),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // ─── Monthly Budget Summary Card ──────────────────────
                    _buildMonthlySummaryCard(),
                    const SizedBox(height: 24),

                    // ─── Spending Breakdown (donut + list) ───────────────
                    SectionTitle(title: 'Spending Breakdown'),
                    const SizedBox(height: 16),
                    _buildDonutSection(),
                    const SizedBox(height: 28),

                    // ─── Category Budget Cards ────────────────────────────
                    SectionTitle(title: 'Category Budgets'),
                    const SizedBox(height: 14),
                    ..._categories.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: BudgetProgressCard(
                            category: item.name,
                            spent: item.spent,
                            limit: item.limit,
                            progress: item.progress,
                            color: item.color,
                            icon: item.icon,
                          ),
                        )),

                    const SizedBox(height: 20),

                    // ─── Money Tip ────────────────────────────────────────
                    _buildMoneyTip(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Text('Budget', style: _j(22, FontWeight.w700, AppColors.textPrimary)),
          const Spacer(),
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.bgMint,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(Icons.settings_outlined,
                color: AppColors.income, size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlySummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s20),
      decoration: BoxDecoration(
        gradient: AppGradients.heroCard,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: [
          BoxShadow(
            color: AppColors.incomeGlow.withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Monthly Budget',
                  style:
                      _j(14, FontWeight.w500, Colors.white.withOpacity(0.80))),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child:
                    Text('Edit', style: _j(12, FontWeight.w600, Colors.white)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('₹2,000.00', style: _j(32, FontWeight.w800, Colors.white)),
          const SizedBox(height: 14),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: 0.38,
              minHeight: 8,
              backgroundColor: Colors.white.withOpacity(0.25),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF90FFB8)),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('₹759.40 spent',
                  style:
                      _j(13, FontWeight.w500, Colors.white.withOpacity(0.85))),
              const Spacer(),
              Text('₹1,240.60 remaining',
                  style: _j(13, FontWeight.w600, Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDonutSection() {
    return SpendlyCard(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Row(
        children: [
          // Donut chart
          SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: _buildPieSections(),
                    centerSpaceRadius: 45,
                    sectionsSpace: 3,
                    pieTouchData: PieTouchData(
                      touchCallback: (_, response) {
                        setState(() {
                          _touchedIndex =
                              response?.touchedSection?.touchedSectionIndex ??
                                  -1;
                        });
                      },
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('₹759',
                        style: _j(14, FontWeight.w800, AppColors.textPrimary)),
                    Text('spent',
                        style:
                            _j(11, FontWeight.w400, AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.s20),
          // Legend
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _categories.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: item.color, shape: BoxShape.circle)),
                      const SizedBox(width: 8),
                      Expanded(
                          child: Text(item.name,
                              style: _j(
                                  12, FontWeight.w500, AppColors.textPrimary),
                              overflow: TextOverflow.ellipsis)),
                      Text(
                          '${(item.progress * 100 / _totalProgress * 100).toInt()}%',
                          style:
                              _j(12, FontWeight.w700, AppColors.textSecondary)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  double get _totalProgress => _categories.fold(0.0, (s, c) => s + c.progress);

  List<PieChartSectionData> _buildPieSections() {
    return List.generate(_categories.length, (i) {
      final item = _categories[i];
      final isTouched = i == _touchedIndex;
      return PieChartSectionData(
        value: item.progress,
        color: item.color,
        radius: isTouched ? 38.0 : 32.0,
        title: '',
        badgeWidget: isTouched
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                    color: item.color, borderRadius: BorderRadius.circular(4)),
                child: Text(item.name.split(' ').first,
                    style: _j(8, FontWeight.w600, Colors.white)),
              )
            : null,
        badgePositionPercentageOffset: 1.2,
      );
    });
  }

  Widget _buildMoneyTip() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: AppColors.actionSoft,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.action.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.action.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(Icons.lightbulb_rounded,
                color: AppColors.action, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Money Tip',
                    style: _j(13, FontWeight.w700, AppColors.action)),
                const SizedBox(height: 2),
                Text(
                  "You're doing great! Keep your spending below 70% of your budget.",
                  style: _j(12, FontWeight.w400, AppColors.textSecondary),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: AppColors.action),
        ],
      ),
    );
  }
}

TextStyle _j(double s, FontWeight w, Color c) =>
    GoogleFonts.plusJakartaSans(fontSize: s, fontWeight: w, color: c);

class _BudgetItem {
  final String name;
  final Color color;
  final double progress;
  final String spent;
  final String limit;
  final IconData icon;
  const _BudgetItem(
      this.name, this.color, this.progress, this.spent, this.limit, this.icon);
}
