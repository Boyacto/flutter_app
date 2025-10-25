import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';
import '../../../core/models/banner.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({
    super.key,
    required this.banners,
  });

  final List<PromoBanner> banners;

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    // Auto-scroll every 4 seconds
    Future.delayed(const Duration(seconds: 4), _autoScroll);
  }

  void _autoScroll() {
    if (!mounted || widget.banners.isEmpty) return;

    final nextPage = (_currentPage + 1) % widget.banners.length;
    _pageController.animateToPage(
      nextPage,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(seconds: 4), _autoScroll);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: widget.banners.length,
            itemBuilder: (context, index) {
              final banner = widget.banners[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppTokens.s8),
                child: _BannerCard(banner: banner),
              );
            },
          ),
        ),
        const SizedBox(height: AppTokens.s12),
        // Page indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.banners.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentPage == index ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentPage == index
                    ? AppTokens.navy
                    : AppTokens.gray200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.banner});

  final PromoBanner banner;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${banner.title} - Coming soon!')),
          );
        },
        borderRadius: AppTokens.radius24,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getBackgroundColor().withOpacity(0.8),
                _getBackgroundColor(),
              ],
            ),
            borderRadius: AppTokens.radius24,
          ),
          padding: const EdgeInsets.all(AppTokens.s20),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      banner.title,
                      style: AppTokens.title.copyWith(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppTokens.s12),
              // Banner emoji/icon
              Text(
                banner.imageUrl,
                style: TextStyle(fontSize: 60),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    // Alternate colors based on ID or position
    final colors = [
      AppTokens.teal,
      AppTokens.accentRed,
      AppTokens.navy,
    ];
    final hash = banner.id.hashCode.abs();
    return colors[hash % colors.length];
  }
}
