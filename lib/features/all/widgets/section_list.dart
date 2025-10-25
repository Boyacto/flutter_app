import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';

class SectionList extends StatelessWidget {
  const SectionList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Section(
          title: 'Recent',
          icon: Icons.history,
          items: const [
            _SectionItem(
              title: 'Vacation Jar',
              subtitle: 'Last opened 2 hours ago',
              icon: Icons.savings,
            ),
            _SectionItem(
              title: 'AR Trick Shot Game',
              subtitle: 'Played yesterday',
              icon: Icons.sports_basketball,
            ),
            _SectionItem(
              title: 'Starbucks Coupon',
              subtitle: 'Redeemed 3 days ago',
              icon: Icons.local_offer,
            ),
          ],
        ),
        const SizedBox(height: AppTokens.s24),
        _Section(
          title: 'Recommended',
          icon: Icons.recommend,
          items: const [
            _SectionItem(
              title: 'Create Emergency Fund',
              subtitle: 'Start saving for unexpected expenses',
              icon: Icons.security,
            ),
            _SectionItem(
              title: 'Try Daily Missions',
              subtitle: 'Earn extra points every day',
              icon: Icons.emoji_events,
            ),
            _SectionItem(
              title: 'Explore Products',
              subtitle: 'Browse exclusive deals',
              icon: Icons.shopping_bag,
            ),
          ],
        ),
        const SizedBox(height: AppTokens.s24),
        _Section(
          title: 'Shortcuts',
          icon: Icons.flash_on,
          items: const [
            _SectionItem(
              title: 'Deposit Money',
              subtitle: 'Add funds to your jar',
              icon: Icons.add_circle,
            ),
            _SectionItem(
              title: 'Withdraw Points',
              subtitle: 'Convert points to cash',
              icon: Icons.account_balance_wallet,
            ),
            _SectionItem(
              title: 'Share OneUp',
              subtitle: 'Invite friends and earn bonuses',
              icon: Icons.share,
            ),
          ],
        ),
        const SizedBox(height: AppTokens.s24),
        _Section(
          title: 'Help & Support',
          icon: Icons.help_outline,
          items: const [
            _SectionItem(
              title: 'How It Works',
              subtitle: 'Learn about saving and earning',
              icon: Icons.school,
            ),
            _SectionItem(
              title: 'FAQs',
              subtitle: 'Frequently asked questions',
              icon: Icons.question_answer,
            ),
            _SectionItem(
              title: 'Contact Support',
              subtitle: 'Get help from our team',
              icon: Icons.support_agent,
            ),
          ],
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.title,
    required this.icon,
    required this.items,
  });

  final String title;
  final IconData icon;
  final List<_SectionItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppTokens.s12),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppTokens.navy),
              const SizedBox(width: AppTokens.s8),
              Text(
                title,
                style: AppTokens.title.copyWith(
                  color: AppTokens.navy,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: AppTokens.s8),
              child: item,
            )),
      ],
    );
  }
}

class _SectionItem extends StatelessWidget {
  const _SectionItem({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppTokens.teal.withOpacity(0.1),
          child: Icon(icon, color: AppTokens.teal, size: 20),
        ),
        title: Text(
          title,
          style: AppTokens.label.copyWith(color: AppTokens.navy),
        ),
        subtitle: Text(
          subtitle,
          style: AppTokens.caption.copyWith(color: AppTokens.gray600),
        ),
        trailing: const Icon(
          Icons.chevron_right,
          color: AppTokens.gray400,
        ),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$title - Coming soon!')),
          );
        },
      ),
    );
  }
}
