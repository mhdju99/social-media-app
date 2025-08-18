import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.next,
    this.appName = 'Neurest',
    this.logoAsset = 'assets/icon.png', // ضع مسار أيقونتك
    this.duration = const Duration(milliseconds: 2000),
  });

  /// الصفحة/الودجت التالية بعد انتهاء السبلاش
  final Widget next;

  /// اسم التطبيق الظاهر
  final String appName;

  /// مسار الأيقونة (يفضل 512x512)
  final String logoAsset;

  /// مدة الأنيميشن قبل الانتقال
  final Duration duration;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _scale;
  late final Animation<double> _fade;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    // شريط النظام (شفاف وأيقونات فاتحة)
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    _c = AnimationController(vsync: this, duration: widget.duration);

    // Pop-in لطيف للشعار
    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.7, end: 1.08).chain(CurveTween(curve: Curves.easeOutBack)), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.08, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)), weight: 40),
    ]).animate(_c);

    // Fade لعناصر النص
    _fade = CurvedAnimation(parent: _c, curve: const Interval(0.35, 1.0, curve: Curves.easeOut));

    // وميض خفيف (Glow) للخلفية
    _glow = CurvedAnimation(parent: _c, curve: Curves.easeInOut);

    _c.forward();

    // الانتقال التلقائي
    Future.delayed(widget.duration + const Duration(milliseconds: 300), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 450),
          pageBuilder: (_, __, ___) => widget.next,
          transitionsBuilder: (_, anim, __, child) {
            final fade = CurvedAnimation(parent: anim, curve: Curves.easeOut);
            final slide = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
                .chain(CurveTween(curve: Curves.easeOutCubic))
                .animate(anim);
            return FadeTransition(opacity: fade, child: SlideTransition(position: slide, child: child));
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.2),
            radius: 1.2,
            colors: isDark
                ? [
                    const Color(0xFF0F0F13),
                    Color.lerp(const Color(0xFF0F0F13), const Color(0xFF1E1E26), _glow.value)!,
                  ]
                : [
                    const Color(0xFFF3F6FF),
                    Color.lerp(const Color(0xFFF3F6FF), const Color(0xFFE7ECFF), _glow.value)!,
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ScaleTransition(
                  scale: _scale,
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 40 * _glow.value + 8,
                          spreadRadius: 1,
                          offset: const Offset(0, 8),
                          color: (isDark ? Colors.white : Colors.black).withOpacity(0.08),
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: isDark
                            ? [const Color(0xFF2A2A35), const Color(0xFF1C1C24)]
                            : [Colors.white, const Color(0xFFF2F5FF)],
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1000),
                      child: Image.asset(
                        widget.logoAsset,
                        width: 96,
                        height: 96,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                FadeTransition(
                  opacity: _fade,
                  child: Text(
                    widget.appName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                      color: isDark ? Colors.white : const Color(0xFF0B1220),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeTransition(
                  opacity: _fade,
                  child: Text(
                    'Loading…',
                    style: TextStyle(
                      fontSize: 13,
                      color: (isDark ? Colors.white70 : Colors.black54),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
