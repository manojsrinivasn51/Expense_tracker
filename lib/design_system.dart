// lib/design_system.dart
// Spendly – Finora-inspired light FinTech design system.
// Color palette: Income green #1a6b45, Expense red #7c2d2d, Action indigo #4F46E5

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ---------------------------------------------------------------------------
// 1️⃣  Design Tokens
// ---------------------------------------------------------------------------
class AppColors {
  // ── Brand / Income (green) ──────────────────────────────────────────────
  static const Color income = Color(0xFF1a6b45);
  static const Color incomeLight = Color(0xFF22A05C);
  static const Color incomeDark = Color(0xFF0F4D31);
  static const Color incomeGlow = Color(0xFF0B5D3B);

  // ── Expense (red) ────────────────────────────────────────────────────────
  static const Color expense = Color(0xFF7c2d2d);
  static const Color expenseLight = Color(0xFFD94040);
  static const Color expenseSoft = Color(0xFFFFECEC);

  // ── Action / CTA (indigo) ────────────────────────────────────────────────
  static const Color action = Color(0xFF4F46E5);
  static const Color actionLight = Color(0xFF6366F1);
  static const Color actionSoft = Color(0xFFEEF2FF);

  // ── Backgrounds ──────────────────────────────────────────────────────────
  static const Color bgLight = Color(0xFFF4FAF7);
  static const Color bgWhite = Color(0xFFFFFFFF);
  static const Color bgCard = Color(0xFFFFFFFF);
  static const Color bgMint = Color(0xFFE6F5EE);
  static const Color bgSky = Color(0xFFEFF7F2);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0F1F18);
  static const Color textSecondary = Color(0xFF6B7C74);
  static const Color textTertiary = Color(0xFFADB8B2);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // ── Category palette ─────────────────────────────────────────────────────
  static const Color catFood = Color(0xFFFF7A2F);
  static const Color catTransport = Color(0xFF4F5BD5);
  static const Color catShopping = Color(0xFFFFB020);
  static const Color catHealth = Color(0xFFF0506E);
  static const Color catEntertain = Color(0xFF8B5CF6);
  static const Color catSalary = Color(0xFF1a6b45);
  static const Color catOthers = Color(0xFFB0BAB4);

  // ── Status ───────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color border = Color(0xFFE8EFE9);
  static const Color divider = Color(0xFFF0F4F1);

  // ── Shadow ───────────────────────────────────────────────────────────────
  static const Color shadowGreen = Color(0x281a6b45);
  static const Color shadowDark = Color(0x140F1F18);
}

class AppGradients {
  static const LinearGradient heroCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B5D3B), Color(0xFF1a6b45), Color(0xFF22A05C)],
    stops: [0.0, 0.55, 1.0],
  );

  static const LinearGradient pageBg = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFEFF7F2), Color(0xFFF4FAF7), Color(0xFFFFFFFF)],
    stops: [0.0, 0.4, 1.0],
  );

  static const LinearGradient actionBtn = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF4F46E5), Color(0xFF6366F1)],
  );

  static const LinearGradient incomeBtn = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B5D3B), Color(0xFF22A05C)],
  );

  static const LinearGradient expenseBtn = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7c2d2d), Color(0xFFD94040)],
  );
}

class AppRadius {
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 20.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double pill = 9999.0;
}

class AppSpacing {
  static const double s2 = 2.0;
  static const double s4 = 4.0;
  static const double s6 = 6.0;
  static const double s8 = 8.0;
  static const double s10 = 10.0;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s16 = 16.0;
  static const double s20 = 20.0;
  static const double s24 = 24.0;
  static const double s28 = 28.0;
  static const double s32 = 32.0;
}

// ---------------------------------------------------------------------------
// 2️⃣  Typography – Plus Jakarta Sans
// ---------------------------------------------------------------------------
TextStyle _j(double size, FontWeight w, Color c) =>
    GoogleFonts.plusJakartaSans(fontSize: size, fontWeight: w, color: c);

class AppText {
  static TextStyle display = _j(32, FontWeight.w800, AppColors.textPrimary);
  static TextStyle h1 = _j(26, FontWeight.w700, AppColors.textPrimary);
  static TextStyle h2 = _j(22, FontWeight.w700, AppColors.textPrimary);
  static TextStyle h3 = _j(18, FontWeight.w700, AppColors.textPrimary);
  static TextStyle h4 = _j(16, FontWeight.w600, AppColors.textPrimary);
  static TextStyle bodyLg = _j(15, FontWeight.w400, AppColors.textPrimary);
  static TextStyle body = _j(14, FontWeight.w400, AppColors.textPrimary);
  static TextStyle bodySm = _j(13, FontWeight.w400, AppColors.textSecondary);
  static TextStyle caption = _j(12, FontWeight.w400, AppColors.textSecondary);
  static TextStyle label = _j(11, FontWeight.w600, AppColors.textTertiary);

  // White overrides
  static TextStyle h1w = _j(26, FontWeight.w700, Colors.white);
  static TextStyle h2w = _j(22, FontWeight.w700, Colors.white);
  static TextStyle bodyLgW = _j(15, FontWeight.w500, Colors.white);
  static TextStyle captionW =
      _j(12, FontWeight.w500, Colors.white.withOpacity(0.75));
}

// ---------------------------------------------------------------------------
// 3️⃣  ThemeData
// ---------------------------------------------------------------------------
final ThemeData appLightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.bgLight,
  primaryColor: AppColors.income,
  colorScheme: const ColorScheme.light(
    primary: AppColors.income,
    secondary: AppColors.action,
    surface: AppColors.bgCard,
    error: AppColors.error,
  ),
  textTheme: GoogleFonts.plusJakartaSansTextTheme(),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: _j(20, FontWeight.w700, AppColors.textPrimary),
    iconTheme: const IconThemeData(color: AppColors.textPrimary),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.bgMint,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      borderSide: const BorderSide(color: AppColors.income, width: 1.5),
    ),
    hintStyle: _j(14, FontWeight.w400, AppColors.textTertiary),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.income,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.pill)),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      textStyle: _j(15, FontWeight.w600, Colors.white),
      elevation: 0,
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.bgMint,
    selectedColor: AppColors.income,
    labelStyle: _j(12, FontWeight.w500, AppColors.textSecondary),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.pill)),
    side: BorderSide.none,
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

// ---------------------------------------------------------------------------
// 4️⃣  Core Layout Widgets
// ---------------------------------------------------------------------------

/// GradientPage – full screen gradient bg + safe area
class GradientPage extends StatelessWidget {
  final Widget child;
  final bool safeBottom;
  const GradientPage({Key? key, required this.child, this.safeBottom = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.pageBg),
      child: SafeArea(bottom: safeBottom, child: child),
    );
  }
}

/// SpendlyCard – standard white card with soft shadow
class SpendlyCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final Color? color;
  final VoidCallback? onTap;
  const SpendlyCard(
      {Key? key,
      required this.child,
      this.padding,
      this.radius,
      this.color,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final card = Container(
      padding: padding ?? const EdgeInsets.all(AppSpacing.s16),
      decoration: BoxDecoration(
        color: color ?? AppColors.bgCard,
        borderRadius: BorderRadius.circular(radius ?? AppRadius.xl),
        boxShadow: const [
          BoxShadow(
              color: AppColors.shadowDark,
              blurRadius: 16,
              offset: Offset(0, 4)),
          BoxShadow(
              color: AppColors.shadowGreen,
              blurRadius: 24,
              offset: Offset(0, 8)),
        ],
      ),
      child: child,
    );
    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: _PressScale(child: card));
    }
    return card;
  }
}

// ---------------------------------------------------------------------------
// 5️⃣  Hero Balance Card
// ---------------------------------------------------------------------------
class BalanceCard extends StatelessWidget {
  final String balance;
  final String delta;
  final bool isPositiveDelta;
  final bool balanceVisible;
  final VoidCallback onToggleVisibility;
  final String? cardNumber;

  const BalanceCard({
    Key? key,
    required this.balance,
    required this.delta,
    this.isPositiveDelta = true,
    required this.balanceVisible,
    required this.onToggleVisibility,
    this.cardNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.s24),
      decoration: BoxDecoration(
        gradient: AppGradients.heroCard,
        borderRadius: BorderRadius.circular(AppRadius.xxl),
        boxShadow: [
          BoxShadow(
            color: AppColors.incomeGlow.withOpacity(0.40),
            blurRadius: 28,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label row
          Row(
            children: [
              Text('Total Balance', style: AppText.captionW),
              const Spacer(),
              if (cardNumber != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(cardNumber!,
                      style: _j(11, FontWeight.w600, Colors.white)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.s8),

          // Amount + eye
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: Text(
                  balanceVisible ? balance : '₹ ••••••',
                  key: ValueKey(balanceVisible),
                  style: _j(36, FontWeight.w800, Colors.white),
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
              GestureDetector(
                onTap: onToggleVisibility,
                child: Icon(
                  balanceVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.white.withOpacity(0.70),
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.s16),

          // Delta pill + VISA
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositiveDelta
                          ? Icons.trending_up_rounded
                          : Icons.trending_down_rounded,
                      size: 14,
                      color: isPositiveDelta
                          ? const Color(0xFF90FFB8)
                          : const Color(0xFFFF9090),
                    ),
                    const SizedBox(width: 4),
                    Text(delta,
                        style: _j(11, FontWeight.w600,
                            Colors.white.withOpacity(0.9))),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.xs),
                ),
                child: Text('VISA',
                    style: _j(10, FontWeight.w800, const Color(0xFF1A1F71))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 6️⃣  Quick Action Button (circular mint)
// ---------------------------------------------------------------------------
class QuickActionBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color? color;
  const QuickActionBtn(
      {Key? key,
      required this.icon,
      required this.label,
      this.onTap,
      this.color})
      : super(key: key);

  @override
  State<QuickActionBtn> createState() => _QuickActionBtnState();
}

class _QuickActionBtnState extends State<QuickActionBtn> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.color ?? AppColors.income;
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _pressed ? c : AppColors.bgMint,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: c.withOpacity(_pressed ? 0.30 : 0.08),
                  blurRadius: _pressed ? 14 : 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child:
                Icon(widget.icon, color: _pressed ? Colors.white : c, size: 22),
          ),
          const SizedBox(height: 6),
          Text(widget.label,
              style: _j(11, FontWeight.w600, AppColors.textSecondary)),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 7️⃣  Transaction Tile (Finora style)
// ---------------------------------------------------------------------------
class TxTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final String amount;
  final String time;
  final bool isIncome;
  final VoidCallback? onTap;

  const TxTile({
    Key? key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.time,
    this.isIncome = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: _PressScale(
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.s16, vertical: AppSpacing.s14),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: const [
              BoxShadow(
                  color: AppColors.shadowDark,
                  blurRadius: 10,
                  offset: Offset(0, 3)),
            ],
          ),
          child: Row(
            children: [
              leading,
              const SizedBox(width: AppSpacing.s14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: _j(14, FontWeight.w600, AppColors.textPrimary)),
                    const SizedBox(height: AppSpacing.s2),
                    Text(subtitle,
                        style:
                            _j(12, FontWeight.w400, AppColors.textSecondary)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    amount,
                    style: _j(14, FontWeight.w700,
                        isIncome ? AppColors.income : AppColors.expense),
                  ),
                  const SizedBox(height: AppSpacing.s2),
                  Text(time,
                      style: _j(11, FontWeight.w400, AppColors.textTertiary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 8️⃣  Category Icon Badge
// ---------------------------------------------------------------------------
class CategoryBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  const CategoryBadge(
      {Key? key, required this.icon, required this.color, this.size = 44})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(size * 0.30),
      ),
      child: Icon(icon, color: color, size: size * 0.48),
    );
  }
}

// ---------------------------------------------------------------------------
// 9️⃣  Section Header
// ---------------------------------------------------------------------------
class SectionTitle extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;
  const SectionTitle(
      {Key? key, required this.title, this.action, this.onAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: _j(17, FontWeight.w700, AppColors.textPrimary)),
        if (action != null)
          GestureDetector(
            onTap: onAction,
            child: Row(
              children: [
                Text(action!,
                    style: _j(13, FontWeight.w500, AppColors.textSecondary)),
                const SizedBox(width: 2),
                const Icon(Icons.arrow_forward_ios_rounded,
                    size: 11, color: AppColors.textSecondary),
              ],
            ),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// 10️⃣  Tab Segment Pills (Week / Month / Year)
// ---------------------------------------------------------------------------
class TabPills extends StatefulWidget {
  final List<String> labels;
  final int initial;
  final ValueChanged<int> onChanged;
  final Color? activeColor;
  const TabPills(
      {Key? key,
      required this.labels,
      this.initial = 0,
      required this.onChanged,
      this.activeColor})
      : super(key: key);

  @override
  State<TabPills> createState() => _TabPillsState();
}

class _TabPillsState extends State<TabPills> {
  late int _sel;
  @override
  void initState() {
    super.initState();
    _sel = widget.initial;
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.activeColor ?? AppColors.income;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.bgMint,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.labels.length, (i) {
          final isSel = i == _sel;
          return GestureDetector(
            onTap: () {
              setState(() => _sel = i);
              widget.onChanged(i);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: isSel ? active : Colors.transparent,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                boxShadow: isSel
                    ? [
                        BoxShadow(
                            color: active.withOpacity(0.25),
                            blurRadius: 8,
                            offset: const Offset(0, 2))
                      ]
                    : [],
              ),
              child: Text(
                widget.labels[i],
                style: _j(13, FontWeight.w600,
                    isSel ? Colors.white : AppColors.textSecondary),
              ),
            ),
          );
        }),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 11️⃣  Spending Bar (budget category row)
// ---------------------------------------------------------------------------
class SpendingBar extends StatelessWidget {
  final String label;
  final Color color;
  final double percent; // 0–1
  final String amount;
  const SpendingBar(
      {Key? key,
      required this.label,
      required this.color,
      required this.percent,
      required this.amount})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s8),
      child: Row(
        children: [
          Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: AppSpacing.s10),
          SizedBox(
              width: 100,
              child: Text(label,
                  style: _j(13, FontWeight.w500, AppColors.textPrimary))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.pill),
              child: LinearProgressIndicator(
                value: percent.clamp(0.0, 1.0),
                minHeight: 7,
                backgroundColor: AppColors.bgMint,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s10),
          Text('${(percent * 100).toInt()}%',
              style: _j(12, FontWeight.w600, AppColors.textSecondary)),
          const SizedBox(width: AppSpacing.s8),
          SizedBox(
            width: 60,
            child: Text(amount,
                textAlign: TextAlign.right,
                style: _j(13, FontWeight.w600, AppColors.textPrimary)),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 12️⃣  Primary Button
// ---------------------------------------------------------------------------
class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final Gradient? gradient;
  final IconData? icon;
  const PrimaryButton(
      {Key? key,
      required this.label,
      required this.onPressed,
      this.gradient,
      this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _PressScale(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            gradient: gradient ?? AppGradients.incomeBtn,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            boxShadow: [
              BoxShadow(
                color: AppColors.income.withOpacity(0.30),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
              ],
              Text(label, style: _j(15, FontWeight.w700, Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 13️⃣  Glass Bottom Nav (frosted 5-tab)
// ---------------------------------------------------------------------------
class SpendlyBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const SpendlyBottomNav(
      {Key? key, required this.currentIndex, required this.onTap})
      : super(key: key);

  static const _icons = [
    Icons.home_rounded,
    Icons.bar_chart_rounded,
    Icons.pie_chart_rounded,
    Icons.flag_rounded,
    Icons.person_rounded
  ];
  static const _labels = ['Home', 'Categories', 'Budget', 'Goals', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:
          const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          color: Colors.white.withOpacity(0.85),
          padding: EdgeInsets.only(
            top: AppSpacing.s8,
            bottom: MediaQuery.of(context).padding.bottom > 0
                ? MediaQuery.of(context).padding.bottom
                : AppSpacing.s8,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_icons.length, (i) {
              final active = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 56,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.income.withOpacity(0.12)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Icon(
                          _icons[i],
                          size: 22,
                          color: active
                              ? AppColors.income
                              : AppColors.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: _j(
                            10,
                            active ? FontWeight.w700 : FontWeight.w400,
                            active ? AppColors.income : AppColors.textTertiary),
                        child: Text(_labels[i]),
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

// ---------------------------------------------------------------------------
// 14️⃣  KPI Stat Card (spent / income / savings)
// ---------------------------------------------------------------------------
class KpiCard extends StatelessWidget {
  final String label;
  final String amount;
  final IconData icon;
  final Color color;
  final bool isUp;
  final String? delta;
  const KpiCard(
      {Key? key,
      required this.label,
      required this.amount,
      required this.icon,
      required this.color,
      this.isUp = true,
      this.delta})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: const [
          BoxShadow(
              color: AppColors.shadowDark,
              blurRadius: 12,
              offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon + delta pill row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              if (delta != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: (isUp ? AppColors.income : AppColors.expense)
                        .withOpacity(0.10),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isUp
                            ? Icons.arrow_upward_rounded
                            : Icons.arrow_downward_rounded,
                        size: 9,
                        color: isUp ? AppColors.income : AppColors.expense,
                      ),
                      const SizedBox(width: 1),
                      Text(delta!,
                          style: _j(9, FontWeight.w600,
                              isUp ? AppColors.income : AppColors.expense)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Amount – FittedBox prevents overflow in tight columns
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              amount,
              style: _j(17, FontWeight.w800, AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: _j(11, FontWeight.w500, AppColors.textSecondary),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 15️⃣  Budget Progress Card
// ---------------------------------------------------------------------------
class BudgetProgressCard extends StatelessWidget {
  final String category;
  final String spent;
  final String limit;
  final double progress; // 0–1
  final Color color;
  final IconData icon;
  const BudgetProgressCard(
      {Key? key,
      required this.category,
      required this.spent,
      required this.limit,
      required this.progress,
      required this.color,
      required this.icon})
      : super(key: key);

  bool get isOver => progress > 1.0;

  @override
  Widget build(BuildContext context) {
    final barColor = isOver
        ? AppColors.expense
        : (progress > 0.80 ? AppColors.warning : color);
    return SpendlyCard(
      padding: const EdgeInsets.all(AppSpacing.s16),
      child: Column(
        children: [
          Row(
            children: [
              CategoryBadge(icon: icon, color: color, size: 40),
              const SizedBox(width: AppSpacing.s12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category,
                        style: _j(14, FontWeight.w600, AppColors.textPrimary)),
                    const SizedBox(height: 2),
                    Text('$spent of $limit',
                        style:
                            _j(12, FontWeight.w400, AppColors.textSecondary)),
                  ],
                ),
              ),
              if (isOver)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.expenseSoft,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Text('Over',
                      style: _j(10, FontWeight.w700, AppColors.expense)),
                )
              else
                Text('${(progress * 100).toInt()}%',
                    style: _j(14, FontWeight.w700, AppColors.textPrimary)),
            ],
          ),
          const SizedBox(height: AppSpacing.s12),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              minHeight: 8,
              backgroundColor: AppColors.bgMint,
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 16️⃣  GlassMorphism container
// ---------------------------------------------------------------------------
class GlassBox extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry borderRadius;
  const GlassBox(
      {Key? key, required this.child, this.borderRadius = BorderRadius.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.18),
            borderRadius: borderRadius,
            border: Border.all(color: Colors.white.withOpacity(0.25), width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// 17️⃣  Press scale animation
// ---------------------------------------------------------------------------
class _PressScale extends StatefulWidget {
  final Widget child;
  const _PressScale({Key? key, required this.child}) : super(key: key);

  @override
  State<_PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<_PressScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 120),
        lowerBound: 0.0,
        upperBound: 0.03);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _down(_) => _ctrl.forward();
  void _up(_) => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _down,
      onTapUp: _up,
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) =>
            Transform.scale(scale: 1 - _ctrl.value, child: widget.child),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Backward-compat aliases for old code that still references DesignColors
// ---------------------------------------------------------------------------
class DesignColors {
  static const Color brand = AppColors.income;
  static const Color brandLight = AppColors.incomeLight;
  static const Color heroGradientStart = AppColors.incomeGlow;
  static const Color heroGradientEnd = AppColors.income;
  static const Color bgGradientStart = Color(0xFFDDF0FA);
  static const Color bgGradientEnd = Color(0xFFE6F6EE);
  static const Color surface = AppColors.bgCard;
  static const Color mintTint = AppColors.bgMint;
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color positive = AppColors.income;
  static const Color negative = AppColors.expense;
  static const Color food = AppColors.catFood;
  static const Color transport = AppColors.catTransport;
  static const Color shopping = AppColors.catShopping;
  static const Color health = AppColors.catHealth;
  static const Color entertainment = AppColors.catEntertain;
  static const Color others = AppColors.catOthers;
  static const Color emerald = AppColors.income;
  static const Color violet = AppColors.action;
  static const Color cyan = Color(0xFF00BCD4);
  static const Color amber = AppColors.warning;
  static const Color rose = AppColors.expense;
}

class DesignGradients {
  static const LinearGradient hero = AppGradients.heroCard;
  static const LinearGradient background = AppGradients.pageBg;
}

class DesignSpacing {
  static const double s4 = AppSpacing.s4;
  static const double s6 = AppSpacing.s6;
  static const double s8 = AppSpacing.s8;
  static const double s12 = AppSpacing.s12;
  static const double s14 = AppSpacing.s14;
  static const double s16 = AppSpacing.s16;
  static const double s20 = AppSpacing.s20;
  static const double s24 = AppSpacing.s24;
}

class DesignShape {
  static const double cardRadius = AppRadius.xl;
  static const double iconTileRadius = AppRadius.md;
  static const double pillRadius = AppRadius.pill;
}

// Old PressScale (public) still works
class PressScale extends StatefulWidget {
  final Widget child;
  const PressScale({Key? key, required this.child}) : super(key: key);
  @override
  State<PressScale> createState() => _OldPressScaleState();
}

class _OldPressScaleState extends State<PressScale>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 120),
        lowerBound: 0.0,
        upperBound: 0.04);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _down(_) => _ctrl.forward();
  void _up(_) => _ctrl.reverse();
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTapDown: _down,
        onTapUp: _up,
        onTapCancel: () => _ctrl.reverse(),
        child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, ch) =>
                Transform.scale(scale: 1 - _ctrl.value, child: widget.child)),
      );
}

class GlassMorphism extends StatelessWidget {
  final Widget child;
  final BorderRadiusGeometry borderRadius;
  const GlassMorphism(
      {Key? key, required this.child, this.borderRadius = BorderRadius.zero})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      GlassBox(child: child, borderRadius: borderRadius);
}

// Old AppCard alias
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  const AppCard({Key? key, required this.child, this.padding})
      : super(key: key);
  @override
  Widget build(BuildContext context) =>
      SpendlyCard(padding: padding, child: child);
}
