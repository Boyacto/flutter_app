import 'package:flutter/material.dart';
import '../../../theme/tokens.dart';

/// Card widget for saving feature toggles
/// Used for Coin Saving, Auto-Save, and Brand Collaboration
class SavingFeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onInfoTap;

  const SavingFeatureCard({
    super.key,
    required this.title,
    required this.description,
    required this.isEnabled,
    required this.onToggle,
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTokens.s16,
        vertical: AppTokens.s8,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.s20),
        child: Row(
          children: [
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: AppTokens.subtitle.copyWith(
                      color: AppTokens.navy,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppTokens.s4),

                  // Description
                  Text(
                    description,
                    style: AppTokens.body.copyWith(
                      color: AppTokens.gray600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppTokens.s12),

            // Toggle switch
            Switch(
              value: isEnabled,
              onChanged: onToggle,
            ),
          ],
        ),
      ),
    );
  }
}

/// Special variant for brand collaboration with info button
class BrandCollaborationCard extends StatelessWidget {
  final String brandName;
  final String description;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  final VoidCallback onInfoTap;

  const BrandCollaborationCard({
    super.key,
    required this.brandName,
    required this.description,
    required this.isEnabled,
    required this.onToggle,
    required this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTokens.s16,
        vertical: AppTokens.s8,
      ),
      child: InkWell(
        onTap: isEnabled ? onInfoTap : null,
        borderRadius: AppTokens.radius24,
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.s20),
          child: Row(
            children: [
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title with brand name
                    Row(
                      children: [
                        Text(
                          'Participate in Brand Collaboration',
                          style: AppTokens.subtitle.copyWith(
                            color: AppTokens.navy,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        if (isEnabled) ...[
                          const SizedBox(width: AppTokens.s8),
                          Icon(
                            Icons.info_outline,
                            size: 18,
                            color: AppTokens.teal,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppTokens.s4),

                    // Description
                    Text(
                      description,
                      style: AppTokens.body.copyWith(
                        color: AppTokens.gray600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppTokens.s12),

              // Toggle switch
              Switch(
                value: isEnabled,
                onChanged: onToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
