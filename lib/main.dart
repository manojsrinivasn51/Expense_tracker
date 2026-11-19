// lib/main.dart
// Spendly – App entry point & MainScaffold

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_system.dart';
import 'screens/home_screen.dart';
import 'screens/quick_add_screen.dart';
import 'screens/budget_screen.dart';
import 'screens/currency_screen.dart';
import 'screens/categories_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  runApp(const SpendlyApp());
}

class SpendlyApp extends StatelessWidget {
  const SpendlyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spendly',
      debugShowCheckedModeBanner: false,
      theme: appLightTheme,
      home: const MainScaffold(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main Scaffold with bottom navigation
// ─────────────────────────────────────────────────────────────────────────────
class MainScaffold extends StatefulWidget {
  const MainScaffold({Key? key}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  final _pages = const [
    HomeScreen(),
    CategoriesScreen(),   // tab 1 → Categories
    BudgetScreen(),       // tab 3 → Budget
    CurrencyScreen(),     // tab 3 slot (Currency, accessible via nav remap)
    _ProfilePlaceholder(),
  ];

  void _showQuickAdd() {
    HapticFeedback.mediumImpact();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadius.xxl)),
      ),
      builder: (_) => const QuickAddBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }


  Widget _buildBottomNav() {
    const icons = [
      Icons.home_rounded,
      Icons.category_rounded,   // Categories
      null,                     // FAB placeholder
      Icons.pie_chart_rounded,  // Budget
      Icons.person_rounded,     // Profile
    ];
    const labels = ['Home', 'Categories', '', 'Budget', 'Profile'];

    // Tabs: 0=Home, 1=Categories, 2=FAB(skip), 3=Budget, 4=Profile
    // Pages: 0=Home, 1=CategoriesScreen, 2=BudgetScreen, 3=Currency, 4=Profile
    final pageIndexMap = {0: 0, 1: 1, 3: 2, 4: 4};


    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(icons.length, (i) {
              if (i == 2) {
                return GestureDetector(
                  onTap: _showQuickAdd,
                  behavior: HitTestBehavior.opaque,
                  child: SizedBox(
                    width: 56,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(AppRadius.sm),
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            size: 22,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        SizedBox(
                          width: 60,
                          child: Text(
                            'Add',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
              final pageIdx = pageIndexMap[i] ?? 0;
              final isActive = _selectedIndex == pageIdx;
              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _selectedIndex = pageIdx);
                },
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 56,
                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.income.withOpacity(0.10)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icons[i]!,
                        size: 22,
                        color: isActive
                            ? AppColors.income
                            : AppColors.textTertiary,
                      ),
                      const SizedBox(height: 2),
                      SizedBox(
                        width: 60,
                        child: Text(
                          labels[i],
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight:
                                isActive ? FontWeight.w700 : FontWeight.w400,
                            color: isActive
                                ? AppColors.income
                                : AppColors.textTertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Analytics Placeholder (Spending Analytics screen style)
// ─────────────────────────────────────────────────────────────────────────────
class _AnalyticsPlaceholder extends StatefulWidget {
  const _AnalyticsPlaceholder({Key? key}) : super(key: key);
  @override
  State<_AnalyticsPlaceholder> createState() => _AnalyticsPlaceholderState();
}

class _AnalyticsPlaceholderState extends State<_AnalyticsPlaceholder> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.pageBg),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Text('Spending Categories',
                      style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary)),
                  const Spacer(),
                  const Icon(Icons.date_range_rounded,
                      color: AppColors.textSecondary, size: 24),
                ],
              ),
              const SizedBox(height: 20),

              // Period tabs
              TabPills(
                  labels: const ['Week', 'Month', 'Year'],
                  initial: 1,
                  onChanged: (_) {}),
              const SizedBox(height: 20),

              // Total spending
              SpendlyCard(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Spending',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 13, color: AppColors.textSecondary)),
                    const SizedBox(height: 4),
                    Text('₹1,240.60',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.trending_down_rounded,
                            size: 16, color: AppColors.expense),
                        const SizedBox(width: 4),
                        Text('8.2% vs last month',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                color: AppColors.expense,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Simple bar chart placeholders
                    _buildBarChart(),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Top categories
              SectionTitle(
                  title: 'Top Spending Categories',
                  action: 'See All',
                  onAction: () {}),
              const SizedBox(height: 14),

              SpendlyCard(
                padding: const EdgeInsets.all(AppSpacing.s20),
                child: Column(
                  children: const [
                    SpendingBar(
                        label: 'Food & Dining',
                        color: AppColors.catFood,
                        percent: 0.32,
                        amount: '₹396'),
                    SpendingBar(
                        label: 'Transport',
                        color: AppColors.catTransport,
                        percent: 0.18,
                        amount: '₹223'),
                    SpendingBar(
                        label: 'Shopping',
                        color: AppColors.catShopping,
                        percent: 0.16,
                        amount: '₹198'),
                    SpendingBar(
                        label: 'Health',
                        color: AppColors.catHealth,
                        percent: 0.09,
                        amount: '₹111'),
                    SpendingBar(
                        label: 'Entertainment',
                        color: AppColors.catEntertain,
                        percent: 0.08,
                        amount: '₹99'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart() {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    final values = [0.6, 0.45, 0.75, 0.55, 0.85, 1.0];
    return SizedBox(
      height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(months.length, (i) {
          final isLast = i == months.length - 1;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                width: 28,
                height: 80 * values[i],
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: isLast
                        ? [AppColors.income, AppColors.incomeLight]
                        : [AppColors.bgMint, const Color(0xFFC8E6D4)],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
              ),
              const SizedBox(height: 6),
              Text(months[i],
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color:
                          isLast ? AppColors.income : AppColors.textSecondary,
                      fontWeight: isLast ? FontWeight.w700 : FontWeight.w400)),
            ],
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Profile Placeholder (Finora style)
// ─────────────────────────────────────────────────────────────────────────────
class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.pageBg),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                        color: AppColors.bgMint,
                        borderRadius: BorderRadius.circular(AppRadius.sm)),
                    child: const Icon(Icons.settings_outlined,
                        color: AppColors.income, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Avatar + name
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppGradients.heroCard,
                  boxShadow: [
                    BoxShadow(
                        color: AppColors.income.withOpacity(0.30),
                        blurRadius: 16,
                        offset: const Offset(0, 6))
                  ],
                ),
                child: const Icon(Icons.person_rounded,
                    color: Colors.white, size: 40),
              ),
              const SizedBox(height: 12),
              Text('Manoj Kumar',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary)),
              const SizedBox(height: 2),
              Text('manoj@example.com',
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 13, color: AppColors.textSecondary)),
              const SizedBox(height: 20),

              // Financial health card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.s20),
                decoration: BoxDecoration(
                  gradient: AppGradients.heroCard,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your Financial Health',
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.80))),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text('Excellent',
                                  style: GoogleFonts.plusJakartaSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white)),
                              const SizedBox(width: 4),
                              const Icon(Icons.trending_up_rounded,
                                  color: Color(0xFF90FFB8), size: 18),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text("Keep going! You're on the right track.",
                              style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: Colors.white.withOpacity(0.70))),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator(
                            value: 0.92,
                            strokeWidth: 5,
                            backgroundColor: Colors.white.withOpacity(0.25),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFF90FFB8)),
                          ),
                        ),
                        Text('92%',
                            style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Menu items
              SpendlyCard(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Column(
                  children: [
                    _profileMenuItem(
                        Icons.person_outline_rounded, 'Personal Information'),
                    _divider(),
                    _profileMenuItem(
                        Icons.security_rounded, 'Security & Privacy'),
                    _divider(),
                    _profileMenuItem(
                        Icons.notifications_outlined, 'Notifications'),
                    _divider(),
                    _profileMenuItem(
                        Icons.help_outline_rounded, 'Help & Support'),
                    _divider(),
                    _profileMenuItem(Icons.settings_outlined, 'Settings'),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Logout
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.expenseSoft,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border:
                      Border.all(color: AppColors.expense.withOpacity(0.20)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.logout_rounded,
                        color: AppColors.expense, size: 18),
                    const SizedBox(width: 8),
                    Text('Log Out',
                        style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.expense)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileMenuItem(IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
                color: AppColors.bgMint,
                borderRadius: BorderRadius.circular(AppRadius.xs)),
            child: Icon(icon, color: AppColors.income, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
              child: Text(label,
                  style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary))),
          const Icon(Icons.arrow_forward_ios_rounded,
              size: 14, color: AppColors.textTertiary),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(
      height: 1,
      thickness: 1,
      color: AppColors.divider,
      indent: 16,
      endIndent: 16);
}
