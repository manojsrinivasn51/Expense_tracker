// lib/widgets/lottie_icon.dart
// Spendly – Reusable Lottie animation widget with graceful fallback.
//
// ═══════════════════════════════════════════════════════════════════════════
// HOW TO ADD YOUR OWN ANIMATIONS FROM LOTTIEFILES:
// ─────────────────────────────────────────────────
// 1. Go to  https://lottiefiles.com  → search any animation.
// 2. Click  Download  →  choose "Lottie JSON"  (always free).
// 3. Save to:  assets/lottie/<name>.json
// 4. Use it:   LottieIcon(asset: 'assets/lottie/<name>.json')
//
// From your screenshot the "Bills" download works. Do the same for:
//   Send       → search "send money lottie"
//   Receive    → search "receive money lottie"
//   Bills      → you already have this one ✓
//   More       → search "grid menu lottie"
//   Success    → search "success checkmark lottie"
//   Empty box  → search "empty state lottie"
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

// ─────────────────────────────────────────────────────────────────────────────
// 1. LottieIcon – single animated icon with auto-fallback
// ─────────────────────────────────────────────────────────────────────────────
class LottieIcon extends StatefulWidget {
  /// Path to your Lottie JSON, e.g. 'assets/lottie/send.json'
  final String asset;
  final IconData fallbackIcon;
  final Color fallbackColor;
  final double size;
  final bool loop;
  final bool autoplay;

  /// Pass an external controller to trigger the animation on demand (tap, etc.)
  final AnimationController? controller;

  const LottieIcon({
    Key? key,
    required this.asset,
    this.fallbackIcon = Icons.circle_outlined,
    this.fallbackColor = const Color(0xFF1a6b45),
    this.size = 48,
    this.loop = true,
    this.autoplay = true,
    this.controller,
  }) : super(key: key);

  @override
  State<LottieIcon> createState() => _LottieIconState();
}

class _LottieIconState extends State<LottieIcon>
    with SingleTickerProviderStateMixin {
  AnimationController? _internal;
  bool _hasError = false;

  AnimationController get _ctrl => widget.controller ?? _internal!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _internal = AnimationController(vsync: this);
    }
  }

  @override
  void dispose() {
    _internal?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) return _fallback();

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Lottie.asset(
        widget.asset,
        controller: _ctrl,
        width: widget.size,
        height: widget.size,
        fit: BoxFit.contain,
        repeat: widget.loop,
        animate: widget.autoplay,
        onLoaded: (comp) {
          _ctrl.duration = comp.duration;
          if (widget.autoplay) {
            widget.loop ? _ctrl.repeat() : _ctrl.forward();
          }
        },
        errorBuilder: (_, err, stack) {
          // Schedule setState outside of build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) setState(() => _hasError = true);
          });
          return _fallback();
        },
      ),
    );
  }

  Widget _fallback() => SizedBox(
        width: widget.size,
        height: widget.size,
        child: Icon(
          widget.fallbackIcon,
          color: widget.fallbackColor,
          size: widget.size * 0.60,
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. LottieQuickAction – tap-to-play quick-action button (Finora style)
// ─────────────────────────────────────────────────────────────────────────────
class LottieQuickAction extends StatefulWidget {
  final String lottiePath;
  final String label;
  final Color bgColor;
  final Color labelColor;
  final IconData fallback;
  final VoidCallback? onTap;

  const LottieQuickAction({
    Key? key,
    required this.lottiePath,
    required this.label,
    required this.bgColor,
    required this.labelColor,
    this.fallback = Icons.circle_outlined,
    this.onTap,
  }) : super(key: key);

  @override
  State<LottieQuickAction> createState() => _LottieQuickActionState();
}

class _LottieQuickActionState extends State<LottieQuickAction>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleCtrl;
  late AnimationController _lottieCtrl;
  late Animation<double> _scaleAnim;
  bool _pressed = false;

  @override
  void initState() {
    super.initState();
    _scaleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _scaleCtrl, curve: Curves.easeOut),
    );
    _lottieCtrl = AnimationController(vsync: this)
      ..addStatusListener((s) {
        // go back to frame 0 so the icon returns to its idle look
        if (s == AnimationStatus.completed) _lottieCtrl.value = 0;
      });
  }

  @override
  void dispose() {
    _scaleCtrl.dispose();
    _lottieCtrl.dispose();
    super.dispose();
  }

  void _handleTap() {
    HapticFeedback.lightImpact();
    _scaleCtrl.forward().then((_) => _scaleCtrl.reverse());
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _pressed = true);
        _scaleCtrl.forward();
      },
      onTapUp: (_) {
        setState(() => _pressed = false);
        _scaleCtrl.reverse();
        HapticFeedback.lightImpact();
        if (_lottieCtrl.duration != null) _lottieCtrl.forward(from: 0); // new
        widget.onTap?.call();
      },
      onTapCancel: () {
        setState(() => _pressed = false);
        _scaleCtrl.reverse();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Animated circle ─────────────────────────────────────────────
          AnimatedBuilder(
            animation: _scaleAnim,
            builder: (_, child) =>
                Transform.scale(scale: _scaleAnim.value, child: child),
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // Soft tinted background — same colour as the icon
                color: widget.bgColor.withOpacity(0.12),
                boxShadow: [
                  BoxShadow(
                    color: widget.bgColor.withOpacity(_pressed ? 0.30 : 0.14),
                    blurRadius: _pressed ? 18 : 10,
                    spreadRadius: _pressed ? 2 : 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // ── Visible icon (always shown) ──────────────────────
                  Icon(
                    widget.fallback,
                    color: widget.bgColor,
                    size: 28,
                  ),
                  // ── Lottie overlay (plays on tap if file exists) ─────
                  // The Lottie is transparent/invisible at frame 0,
                  // so the icon always shows through until a tap fires.
                  Positioned.fill(
                    child: _LottieTapOverlay(
                      asset: widget.lottiePath,
                      color: widget.bgColor,
                      fallback: widget.fallback,
                      controller: _lottieCtrl,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget.label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B7C74),
            ),
          ),
        ],
      ),
    );
  }
}

/// Internal: plays a ripple-scale Lottie overlay on top of the icon.
/// If the asset is missing / corrupt, it renders nothing (transparent).
class _LottieTapOverlay extends StatefulWidget {
  final String asset;
  final Color color;
  final IconData fallback;
  final AnimationController controller;
  const _LottieTapOverlay({
    Key? key,
    required this.asset,
    required this.color,
    required this.fallback,
    required this.controller,
  }) : super(key: key);

  @override
  State<_LottieTapOverlay> createState() => _LottieTapOverlayState();
}

class _LottieTapOverlayState extends State<_LottieTapOverlay> {
  bool _failed = false;

  Widget _icon() => Center(
        child: Icon(widget.fallback, color: widget.color, size: 28),
      );

  @override
  Widget build(BuildContext context) {
    if (_failed) return _icon();
    return Lottie.asset(
      widget.asset,
      controller: widget.controller,
      fit: BoxFit.contain,
      onLoaded: (comp) => widget.controller.duration = comp.duration,
      errorBuilder: (_, __, ___) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _failed = true);
        });
        return _icon();
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. LottieEmptyState – full-screen / section empty state
// ─────────────────────────────────────────────────────────────────────────────
class LottieEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? buttonLabel;
  final VoidCallback? onButton;
  final String lottiePath;
  final double lottieSize;

  const LottieEmptyState({
    Key? key,
    required this.title,
    required this.subtitle,
    this.buttonLabel,
    this.onButton,
    this.lottiePath = 'assets/lottie/empty.json',
    this.lottieSize = 140,
  }) : super(key: key);

  static const _green = Color(0xFF1a6b45);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieIcon(
              asset: lottiePath,
              fallbackIcon: Icons.inbox_rounded,
              fallbackColor: _green,
              size: lottieSize,
              loop: true,
              autoplay: true,
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F1F18),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6B7C74),
              ),
            ),
            if (buttonLabel != null && onButton != null) ...[
              const SizedBox(height: 24),
              _ActionButton(label: buttonLabel!, onTap: onButton!),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ActionButton({Key? key, required this.label, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0B5D3B), Color(0xFF22A05C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(9999),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1a6b45).withOpacity(0.30),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. LottieSuccessOverlay – shown after save / transaction add
// ─────────────────────────────────────────────────────────────────────────────

/// Call this to show a brief success animation overlay.
/// It auto-dismisses after the animation completes.
void showLottieSuccess(BuildContext context, {String message = 'Saved!'}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.35),
    barrierDismissible: false,
    builder: (_) => _SuccessDialog(message: message),
  );
}

class _SuccessDialog extends StatefulWidget {
  final String message;
  const _SuccessDialog({Key? key, required this.message}) : super(key: key);
  @override
  State<_SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<_SuccessDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LottieIcon(
              asset: 'assets/lottie/success.json',
              fallbackIcon: Icons.check_circle_rounded,
              fallbackColor: const Color(0xFF1a6b45),
              size: 120,
              loop: false,
              autoplay: true,
              controller: _ctrl,
            ),
            const SizedBox(height: 16),
            Text(
              widget.message,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F1F18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
