import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

/// Simple shimmer loading placeholder
class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  final double width;
  final double height;
  final BorderRadius? borderRadius;

  @override
  State<LoadingShimmer> createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? AppTokens.darkSurface : AppTokens.gray100;
    final highlightColor = isDark ? AppTokens.gray700 : AppTokens.gray200;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            child: Stack(
              children: [
                Positioned(
                  left: _animation.value * widget.width,
                  right: -widget.width,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          baseColor,
                          highlightColor,
                          baseColor,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                    height: widget.height,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Shimmer card placeholder
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.s16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                LoadingShimmer(
                  width: 48,
                  height: 48,
                  borderRadius: BorderRadius.circular(24),
                ),
                const SizedBox(width: AppTokens.s12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LoadingShimmer(
                        width: double.infinity,
                        height: 16,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 8),
                      LoadingShimmer(
                        width: 120,
                        height: 14,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTokens.s16),
            LoadingShimmer(
              width: double.infinity,
              height: 12,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            LoadingShimmer(
              width: double.infinity,
              height: 12,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            LoadingShimmer(
              width: 200,
              height: 12,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shimmer list placeholder
class ShimmerList extends StatelessWidget {
  const ShimmerList({super.key, this.itemCount = 3});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => const Padding(
        padding: EdgeInsets.only(bottom: AppTokens.s8),
        child: ShimmerCard(),
      ),
    );
  }
}
