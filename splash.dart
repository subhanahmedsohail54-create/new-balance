import 'package:flutter/material.dart';
import 'package:subhan/Login/Register/register.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _loadingController;
  late AnimationController _shoeController;
  late AnimationController _scanController;

  late Animation<double> _logoFade;
  late Animation<double> _logoScale;
  late Animation<double> _taglineFade;
  late Animation<Offset> _taglineSlide;
  late Animation<double> _loadingProgress;
  late Animation<Offset> _shoeSlide;
  late Animation<double> _shoeFade;
  late Animation<double> _scanAnim;

  double _displayPercent = 0;

  @override
  void initState() {
    super.initState();

    // Logo Controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _logoScale = Tween<double>(begin: 0.4, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _taglineFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    _taglineSlide =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );

    // Shoe Controller
    _shoeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _shoeSlide =
        Tween<Offset>(begin: const Offset(0.5, 0), end: Offset.zero).animate(
      CurvedAnimation(parent: _shoeController, curve: Curves.easeOutCubic),
    );

    _shoeFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shoeController, curve: Curves.easeOut),
    );

    // Loading Controller
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );

    _loadingProgress = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _loadingController, curve: Curves.easeInOut),
    );

    _loadingProgress.addListener(() {
      setState(() {
        _displayPercent = (_loadingProgress.value * 100);
      });
    });

    // Scan line Controller
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    _scanAnim = Tween<double>(begin: 0, end: 1).animate(_scanController);

    // Start animations in sequence
    _startAnimations();
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();

    await Future.delayed(const Duration(milliseconds: 800));
    _shoeController.forward();

    await Future.delayed(const Duration(milliseconds: 600));
    _loadingController.forward();
    _scanController.repeat();

    // Navigate to home after loading
    await Future.delayed(const Duration(milliseconds: 3000));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const RegisterPage(),
          transitionsBuilder: (_, anim, __, child) => FadeTransition(
            opacity: anim,
            child: child,
          ),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _loadingController.dispose();
    _shoeController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1520),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF111D2E),
                  Color(0xFF0D1520),
                  Color(0xFF0A1118),
                ],
              ),
            ),
          ),

          // Glow top-left
          Positioned(
            top: -80,
            left: -80,
            child: AnimatedBuilder(
              animation: _logoController,
              builder: (_, __) => Opacity(
                opacity: _logoFade.value * 0.7,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0x601E4D8C), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Glow bottom-right
          Positioned(
            bottom: -60,
            right: -60,
            child: AnimatedBuilder(
              animation: _logoController,
              builder: (_, __) => Opacity(
                opacity: _taglineFade.value * 0.5,
                child: Container(
                  width: 240,
                  height: 240,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [Color(0x400F3A6E), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Corner decorations
          const Positioned(
            top: 50,
            left: 30,
            child: _CornerDeco(isTopLeft: true),
          ),
          const Positioned(
            bottom: 50,
            right: 30,
            child: _CornerDeco(isTopLeft: false),
          ),

          // Scan line
          AnimatedBuilder(
            animation: _scanAnim,
            builder: (_, __) {
              final screenH = MediaQuery.of(context).size.height;
              return Positioned(
                top: _scanAnim.value * screenH,
                left: 0,
                right: 0,
                child: Container(
                  height: 1,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color(0x265B9BD5),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Main content
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Est. tag
                  FadeTransition(
                    opacity: _taglineFade,
                    child: const Text(
                      'EST. 1906',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 4,
                        color: Color(0xFF4A7FB5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // NB Logo Icon
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (_, __) => FadeTransition(
                      opacity: _logoFade,
                      child: Transform.scale(
                        scale: _logoScale.value,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: const Color(0x4D1E4D8C),
                            border: Border.all(
                              color: const Color(0xFF2A6AAD),
                              width: 0.8,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'NB',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5B9BD5),
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Brand name
                  FadeTransition(
                    opacity: _logoFade,
                    child: const Text(
                      'NEW BALANCE',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 8,
                        color: Color(0xFFF0F4F8),
                        height: 1,
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // Tagline
                  SlideTransition(
                    position: _taglineSlide,
                    child: FadeTransition(
                      opacity: _taglineFade,
                      child: const Text(
                        'FEARLESSLY INDEPENDENT',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 3,
                          color: Color(0xFF4A7FB5),
                        ),
                      ),
                    ),
                  ),

                  // Divider
                  FadeTransition(
                    opacity: _taglineFade,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 24),
                      width: 40,
                      height: 1,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Color(0xFF4A7FB5),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Shoe SVG illustration
                  SlideTransition(
                    position: _shoeSlide,
                    child: FadeTransition(
                      opacity: _shoeFade,
                      child: SizedBox(
                        height: 150,
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Glow under shoe
                            Positioned(
                              bottom: 8,
                              child: Container(
                                width: 180,
                                height: 18,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF1E4D8C)
                                          .withOpacity(0.5),
                                      blurRadius: 24,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Shoe SVG via CustomPaint
                            CustomPaint(
                              size: const Size(220, 120),
                              painter: _ShoePainter(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Loading bar
                  AnimatedBuilder(
                    animation: _loadingProgress,
                    builder: (_, __) => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'LOADING',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                                color: Color(0xFF2D4F72),
                              ),
                            ),
                            Text(
                              '${_displayPercent.round()}%',
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 2,
                                color: Color(0xFF4A7FB5),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1A2E45),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            widthFactor: _loadingProgress.value,
                            alignment: Alignment.centerLeft,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF1E4D8C),
                                    Color(0xFF5B9BD5),
                                    Color(0xFF1E4D8C),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Dots indicator
                  FadeTransition(
                    opacity: _taglineFade,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _PulseDot(delay: const Duration(milliseconds: 0)),
                        const SizedBox(width: 6),
                        _PulseDot(
                            isActive: true,
                            delay: const Duration(milliseconds: 200)),
                        const SizedBox(width: 6),
                        _PulseDot(delay: const Duration(milliseconds: 400)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Corner decoration widget
class _CornerDeco extends StatelessWidget {
  final bool isTopLeft;
  const _CornerDeco({required this.isTopLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        border: Border(
          top: isTopLeft
              ? const BorderSide(color: Color(0x1A5B9BD5), width: 1)
              : BorderSide.none,
          left: isTopLeft
              ? const BorderSide(color: Color(0x1A5B9BD5), width: 1)
              : BorderSide.none,
          bottom: !isTopLeft
              ? const BorderSide(color: Color(0x1A5B9BD5), width: 1)
              : BorderSide.none,
          right: !isTopLeft
              ? const BorderSide(color: Color(0x1A5B9BD5), width: 1)
              : BorderSide.none,
        ),
      ),
    );
  }
}

// Pulsing dot widget
class _PulseDot extends StatefulWidget {
  final bool isActive;
  final Duration delay;

  const _PulseDot({this.isActive = false, required this.delay});

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _anim = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Opacity(
        opacity: _anim.value,
        child: Container(
          width: widget.isActive ? 14 : 5,
          height: 5,
          decoration: BoxDecoration(
            color: widget.isActive
                ? const Color(0xFF4A7FB5)
                : const Color(0xFF1E3A55),
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

// Shoe CustomPainter
class _ShoePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Sole
    final solePaint = Paint()
      ..shader = LinearGradient(
        colors: [const Color(0xFF1E3A55), const Color(0xFF0A1820)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, h * 0.78, w, h * 0.22));
    final solePath = Path()
      ..moveTo(w * 0.12, h * 0.82)
      ..quadraticBezierTo(w * 0.5, h * 0.96, w * 0.92, h * 0.86)
      ..lineTo(w * 0.94, h * 0.94)
      ..quadraticBezierTo(w * 0.5, h * 1.08, w * 0.08, h * 0.92)
      ..close();
    canvas.drawPath(solePath, solePaint);

    // Midsole stripe
    final midPaint = Paint()..color = const Color(0xFF1E4D8C).withOpacity(0.8);
    final midPath = Path()
      ..moveTo(w * 0.10, h * 0.80)
      ..quadraticBezierTo(w * 0.5, h * 0.91, w * 0.91, h * 0.81)
      ..lineTo(w * 0.92, h * 0.86)
      ..quadraticBezierTo(w * 0.5, h * 0.96, w * 0.11, h * 0.86)
      ..close();
    canvas.drawPath(midPath, midPaint);

    // Main shoe body
    final bodyPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF2A6AAD),
          const Color(0xFF1A4A7C),
          const Color(0xFF0D2A4A),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    final bodyPath = Path()
      ..moveTo(w * 0.13, h * 0.80)
      ..lineTo(w * 0.18, h * 0.44)
      ..quadraticBezierTo(w * 0.22, h * 0.22, w * 0.36, h * 0.16)
      ..lineTo(w * 0.74, h * 0.12)
      ..quadraticBezierTo(w * 0.90, h * 0.12, w * 0.93, h * 0.24)
      ..lineTo(w * 0.92, h * 0.80)
      ..quadraticBezierTo(w * 0.5, h * 0.90, w * 0.13, h * 0.80)
      ..close();
    canvas.drawPath(bodyPath, bodyPaint);

    // Toe box
    final toePaint = Paint()..color = const Color(0xFF1A4A7C);
    final toePath = Path()
      ..moveTo(w * 0.13, h * 0.80)
      ..quadraticBezierTo(w * 0.04, h * 0.74, w * 0.02, h * 0.62)
      ..quadraticBezierTo(w * 0.00, h * 0.48, w * 0.10, h * 0.44)
      ..lineTo(w * 0.18, h * 0.44)
      ..lineTo(w * 0.15, h * 0.78)
      ..close();
    canvas.drawPath(toePath, toePaint);

    // Heel counter
    final heelPaint = Paint()..color = const Color(0xFF0D2A4A).withOpacity(0.9);
    final heelPath = Path()
      ..moveTo(w * 0.90, h * 0.24)
      ..quadraticBezierTo(w * 0.96, h * 0.38, w * 0.94, h * 0.80)
      ..lineTo(w * 0.92, h * 0.80)
      ..quadraticBezierTo(w * 0.94, h * 0.50, w * 0.90, h * 0.24)
      ..close();
    canvas.drawPath(heelPath, heelPaint);

    // NB letters
    final nbStroke = Paint()
      ..color = const Color(0xFF5B9BD5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final nPath = Path()
      ..moveTo(w * 0.38, h * 0.54)
      ..lineTo(w * 0.38, h * 0.20)
      ..lineTo(w * 0.45, h * 0.46)
      ..lineTo(w * 0.45, h * 0.20);
    canvas.drawPath(nPath, nbStroke);
    final bPath = Path()
      ..moveTo(w * 0.50, h * 0.20)
      ..lineTo(w * 0.50, h * 0.54)
      ..moveTo(w * 0.50, h * 0.20)
      ..quadraticBezierTo(w * 0.62, h * 0.20, w * 0.62, h * 0.34)
      ..quadraticBezierTo(w * 0.62, h * 0.37, w * 0.50, h * 0.37)
      ..quadraticBezierTo(w * 0.64, h * 0.37, w * 0.64, h * 0.54)
      ..quadraticBezierTo(w * 0.64, h * 0.54, w * 0.50, h * 0.54);
    canvas.drawPath(bPath, nbStroke);

    // Side stripes
    final s1 = Paint()
      ..color = const Color(0xFF5B9BD5).withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(
        Path()
          ..moveTo(w * 0.22, h * 0.64)
          ..quadraticBezierTo(w * 0.55, h * 0.52, w * 0.90, h * 0.56),
        s1);
    canvas.drawPath(
        Path()
          ..moveTo(w * 0.20, h * 0.70)
          ..quadraticBezierTo(w * 0.55, h * 0.60, w * 0.91, h * 0.64),
        s1..color = const Color(0xFF3A7BBF).withOpacity(0.25)
          ..strokeWidth = 1.0);

    // Tongue
    final tonguePaint = Paint()..color = const Color(0xFF1E4D8C).withOpacity(0.92);
    final tonguePath = Path()
      ..moveTo(w * 0.53, h * 0.16)
      ..quadraticBezierTo(w * 0.55, h * 0.02, w * 0.58, -h * 0.02)
      ..quadraticBezierTo(w * 0.62, -h * 0.06, w * 0.64, -h * 0.02)
      ..quadraticBezierTo(w * 0.67, h * 0.04, w * 0.68, h * 0.16)
      ..close();
    canvas.drawPath(tonguePath, tonguePaint);

    // Laces
    final lacePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < 4; i++) {
      final y = h * (0.24 + i * 0.08);
      final xEnd = w * (0.70 - i * 0.02);
      lacePaint.color = const Color(0xFF8BB8E0).withOpacity(0.50 - i * 0.08);
      canvas.drawLine(Offset(w * 0.36, y), Offset(xEnd, y - h * 0.01), lacePaint);
    }

    // Glint
    canvas.drawPath(
      Path()
        ..moveTo(w * 0.22, h * 0.32)
        ..quadraticBezierTo(w * 0.38, h * 0.24, w * 0.52, h * 0.27),
      Paint()
        ..color = Colors.white.withOpacity(0.10)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(_ShoePainter oldDelegate) => false;
}