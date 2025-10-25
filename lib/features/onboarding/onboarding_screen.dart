import 'package:flutter/material.dart';
import '../../theme/tokens.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              ),
            ),

            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: const [
                  _OnboardingPage(
                    icon: Icons.savings,
                    title: 'Save Spare Change',
                    description:
                        'Round up your purchases to the nearest dollar and save the difference automatically.',
                  ),
                  _OnboardingPage(
                    icon: Icons.account_balance,
                    title: 'Connect Your Account',
                    description:
                        'Link your bank account to track transactions and save automatically.',
                  ),
                  _OnboardingPage(
                    icon: Icons.tune,
                    title: 'Set Your Rules',
                    description:
                        'Customize round-up amounts, categories, and spending limits to fit your needs.',
                  ),
                  _OnboardingPage(
                    icon: Icons.emoji_events,
                    title: 'Reach Your Goals',
                    description:
                        'Set savings goals and watch your balance grow with every purchase.',
                  ),
                ],
              ),
            ),

            // Page indicators
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppTokens.s24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: AppTokens.s4),
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
            ),

            // Action button
            Padding(
              padding: const EdgeInsets.all(AppTokens.s24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < 3) {
                      _pageController.nextPage(
                        duration: AppTokens.normal,
                        curve: AppTokens.easeInOut,
                      );
                    } else {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppTokens.s20),
                  ),
                  child: Text(_currentPage < 3 ? 'Next' : 'Get Started'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTokens.s32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(AppTokens.s32),
            decoration: BoxDecoration(
              color: AppTokens.navy.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 80,
              color: AppTokens.navy,
            ),
          ),

          const SizedBox(height: AppTokens.s40),

          // Title
          Text(
            title,
            style: AppTokens.title.copyWith(
              fontSize: 28,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: AppTokens.s16),

          // Description
          Text(
            description,
            style: AppTokens.body.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
