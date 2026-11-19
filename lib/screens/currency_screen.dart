// lib/screens/currency_screen.dart
// Spendly – Currency Converter screen (Finora-inspired layout)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../design_system.dart';

class CurrencyScreen extends StatefulWidget {
  const CurrencyScreen({Key? key}) : super(key: key);

  @override
  State<CurrencyScreen> createState() => _CurrencyScreenState();
}

class _CurrencyScreenState extends State<CurrencyScreen> {
  static const Map<String, _CurrencyInfo> _currencies = {
    'USD': _CurrencyInfo('USD', 'US Dollar', '🇺🇸', 83.92),
    'EUR': _CurrencyInfo('EUR', 'Euro', '🇪🇺', 90.74),
    'GBP': _CurrencyInfo('GBP', 'British Pound', '🇬🇧', 106.43),
    'AED': _CurrencyInfo('AED', 'UAE Dirham', '🇦🇪', 22.85),
    'JPY': _CurrencyInfo('JPY', 'Japanese Yen', '🇯🇵', 0.57),
    'SGD': _CurrencyInfo('SGD', 'Singapore Dollar', '🇸🇬', 63.12),
    'CAD': _CurrencyInfo('CAD', 'Canadian Dollar', '🇨🇦', 62.34),
    'AUD': _CurrencyInfo('AUD', 'Australian Dollar', '🇦🇺', 55.21),
    'CHF': _CurrencyInfo('CHF', 'Swiss Franc', '🇨🇭', 94.56),
    'CNY': _CurrencyInfo('CNY', 'Chinese Yuan', '🇨🇳', 11.59),
  };

  String _fromCurrency = 'USD';
  String _toCurrency = 'INR';
  final _ctrl = TextEditingController();

  double get _fromRate => _currencies[_fromCurrency]?.rateToInr ?? 1.0;
  double get _toRate =>
      _toCurrency == 'INR' ? 1.0 : (_currencies[_toCurrency]?.rateToInr ?? 1.0);

  double get _result {
    final input = double.tryParse(_ctrl.text) ?? 0;
    return input * _fromRate / _toRate;
  }

  void _swap() {
    setState(() {
      final tmp = _fromCurrency;
      _fromCurrency = _toCurrency == 'INR' ? 'INR' : _toCurrency;
      _toCurrency = tmp;
      _ctrl.clear();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppGradients.pageBg),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ─── AppBar ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              child: Row(
                children: [
                  Text('Currency',
                      style: _j(22, FontWeight.w700, AppColors.textPrimary)),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: AppColors.actionSoft,
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.offline_pin_rounded,
                            size: 14, color: AppColors.action),
                        const SizedBox(width: 4),
                        Text('Cached',
                            style: _j(11, FontWeight.w600, AppColors.action)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ─── Converter Card ───────────────────────────────────
                    _buildConverterCard(),
                    const SizedBox(height: 28),

                    // ─── Popular Rates ────────────────────────────────────
                    SectionTitle(title: 'Popular Rates', action: 'vs INR'),
                    const SizedBox(height: 14),
                    _buildRatesGrid(),
                    const SizedBox(height: 16),

                    // ─── Disclaimer ───────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.s12),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                            color: AppColors.warning.withOpacity(0.20)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              size: 16, color: AppColors.warning),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Rates cached for 24 hrs. May differ from live rates.',
                              style: _j(
                                  12, FontWeight.w400, AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConverterCard() {
    return SpendlyCard(
      padding: const EdgeInsets.all(AppSpacing.s20),
      child: Column(
        children: [
          // Title
          Text('Convert Currency',
              style: _j(16, FontWeight.w700, AppColors.textPrimary)),
          const SizedBox(height: 20),

          // FROM
          _buildCurrencyInput(
            label: 'From',
            currency: _fromCurrency,
            controller: _ctrl,
            isInput: true,
            onCurrencyChanged: (v) => setState(() {
              _fromCurrency = v;
            }),
          ),
          const SizedBox(height: 12),

          // Swap button
          Center(
            child: GestureDetector(
              onTap: _swap,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppGradients.incomeBtn,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.income.withOpacity(0.30),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.swap_vert_rounded,
                    color: Colors.white, size: 22),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // TO
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.bgMint,
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Text('INR 🇮🇳',
                    style: _j(15, FontWeight.w600, AppColors.income)),
                const Spacer(),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    '≈ ₹${_result.toStringAsFixed(2)}',
                    key: ValueKey(_result.toStringAsFixed(2)),
                    style: _j(22, FontWeight.w800, AppColors.income),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyInput({
    required String label,
    required String currency,
    required TextEditingController controller,
    required bool isInput,
    required ValueChanged<String> onCurrencyChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgMint,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Currency selector
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currency,
              isDense: true,
              icon: const Icon(Icons.expand_more_rounded,
                  size: 18, color: AppColors.textSecondary),
              items: _currencies.keys.map((k) {
                final c = _currencies[k]!;
                return DropdownMenuItem(
                  value: k,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(c.flag, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(k,
                          style:
                              _j(14, FontWeight.w600, AppColors.textPrimary)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) onCurrencyChanged(v);
              },
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.right,
              style: _j(20, FontWeight.w700, AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: '0.00',
                hintStyle: _j(20, FontWeight.w400, AppColors.textTertiary),
                border: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatesGrid() {
    final entries = _currencies.entries.toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemCount: entries.length,
      itemBuilder: (_, i) {
        final info = entries[i].value;
        return Container(
          padding: const EdgeInsets.all(AppSpacing.s12),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: const [
              BoxShadow(
                  color: AppColors.shadowDark,
                  blurRadius: 8,
                  offset: Offset(0, 2)),
            ],
          ),
          child: Row(
            children: [
              Text(info.flag, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(info.code,
                        style: _j(13, FontWeight.w700, AppColors.textPrimary)),
                    Text('₹${info.rateToInr.toStringAsFixed(2)}',
                        style: _j(12, FontWeight.w500, AppColors.income)),
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

TextStyle _j(double s, FontWeight w, Color c) =>
    GoogleFonts.plusJakartaSans(fontSize: s, fontWeight: w, color: c);

class _CurrencyInfo {
  final String code;
  final String name;
  final String flag;
  final double rateToInr;
  const _CurrencyInfo(this.code, this.name, this.flag, this.rateToInr);
}
