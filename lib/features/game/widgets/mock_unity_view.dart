import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';

class MockUnityView extends StatefulWidget {
  const MockUnityView({
    super.key,
    required this.isPlaying,
    required this.onShoot,
  });

  final bool isPlaying;
  final VoidCallback onShoot;

  @override
  State<MockUnityView> createState() => _MockUnityViewState();
}

class _MockUnityViewState extends State<MockUnityView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _ballLaunched = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _launchBall() {
    if (!widget.isPlaying || _ballLaunched) return;

    setState(() {
      _ballLaunched = true;
    });

    _controller.forward(from: 0.0).then((_) {
      // After animation completes, notify parent
      Future.delayed(const Duration(milliseconds: 300), () {
        widget.onShoot();
        setState(() {
          _ballLaunched = false;
        });
        _controller.reset();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTokens.tealLight.withOpacity(0.2),
            AppTokens.navy.withOpacity(0.05),
          ],
        ),
        borderRadius: AppTokens.radius24,
        border: Border.all(
          color: AppTokens.gray200,
          width: 2,
        ),
      ),
      child: Stack(
        children: [
          // Background grid pattern (mock AR environment)
          Positioned.fill(
            child: CustomPaint(
              painter: _GridPainter(),
            ),
          ),

          // Basketball hoop (target)
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTokens.accentRed.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(40),
                  border: Border.all(color: AppTokens.accentRed, width: 3),
                ),
                child: Center(
                  child: Text(
                    '🏀',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
            ),
          ),

          // Animated basketball
          if (_ballLaunched)
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                final progress = _animation.value;
                final bottom = 20 + (300 * progress);
                final scale = 1.0 - (progress * 0.5);

                return Positioned(
                  bottom: bottom,
                  left: MediaQuery.of(context).size.width / 2 - 20,
                  child: Transform.scale(
                    scale: scale,
                    child: Transform.rotate(
                      angle: progress * 6.28, // Full rotation
                      child: child,
                    ),
                  ),
                );
              },
              child: Text('🏀', style: TextStyle(fontSize: 40)),
            ),

          // Shoot button
          if (widget.isPlaying && !_ballLaunched)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: _launchBall,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppTokens.teal,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTokens.teal.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.touch_app,
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'SHOOT',
                          style: AppTokens.label.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // "Waiting" state
          if (!widget.isPlaying)
            Positioned.fill(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(AppTokens.s24),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: AppTokens.radius16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.videogame_asset,
                        size: 48,
                        color: AppTokens.gray500,
                      ),
                      const SizedBox(height: AppTokens.s12),
                      Text(
                        'Tap "Start Game" to begin',
                        style: AppTokens.body.copyWith(
                          color: AppTokens.gray700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTokens.gray200.withOpacity(0.3)
      ..strokeWidth = 1;

    const spacing = 30.0;

    // Draw vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }

    // Draw horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
