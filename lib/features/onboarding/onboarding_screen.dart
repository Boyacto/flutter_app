import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<void> _completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboarding_complete', true);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/');
      }
    }
  }

  void _skip() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _skip,
                child: const Text('Skip'),
              ),
            ),

            // Pages
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: const [
                  _OnboardingPage(
                    emoji: '💰',
                    title: 'Smart Jars',
                    description:
                        'Create jars for your savings goals. Round up purchases automatically and watch your savings grow!',
                  ),
                  _OnboardingPage(
                    emoji: '🎮',
                    title: 'Play & Earn',
                    description:
                        'Play fun AR games, complete missions, and earn real money and rewards while you save!',
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
                  2,
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
                    if (_currentPage < 1) {
                      _pageController.nextPage(
                        duration: AppTokens.normal,
                        curve: AppTokens.easeInOut,
                      );
                    } else {
                      _completeOnboarding();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppTokens.s20),
                  ),
                  child: Text(_currentPage < 1 ? 'Next' : 'Get Started'),
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
  final String emoji;
  final String title;
  final String description;

  const _OnboardingPage({
    required this.emoji,
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
          // Emoji
          Container(
            padding: const EdgeInsets.all(AppTokens.s32),
            decoration: BoxDecoration(
              color: AppTokens.navy.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Text(
              emoji,
              style: TextStyle(fontSize: 80),
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
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
