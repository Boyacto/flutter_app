import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../../theme/tokens.dart';

class ShareRetryModal extends StatelessWidget {
  const ShareRetryModal({
    super.key,
    required this.onShareComplete,
  });

  final VoidCallback onShareComplete;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppTokens.radius24,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTokens.s32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTokens.teal.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.share,
                  size: 40,
                  color: AppTokens.teal,
                ),
              ),
            ),

            const SizedBox(height: AppTokens.s24),

            // Title
            Text(
              'Get a Retry!',
              style: AppTokens.title.copyWith(
                fontSize: 24,
                color: AppTokens.navy,
              ),
            ),

            const SizedBox(height: AppTokens.s12),

            // Description
            Text(
              'Share OneUp with your friends and get +1 bonus attempt!',
              style: AppTokens.body.copyWith(color: AppTokens.gray600),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppTokens.s32),

            // Share button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  // Share using share_plus
                  try {
                    await Share.share(
                      'I\'m playing OneUp! 🎮 Join me and earn rewards while saving money! 💰\n\n'
                      'Download OneUp now and get started!',
                      subject: 'Join me on OneUp!',
                    );

                    // After sharing, grant the retry
                    if (context.mounted) {
                      Navigator.pop(context);
                      onShareComplete();
                    }
                  } catch (e) {
                    // Handle error silently or show a message
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Could not share: $e')),
                      );
                    }
                  }
                },
                icon: Icon(Icons.share),
                label: Text('Share & Get Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTokens.teal,
                ),
              ),
            ),

            const SizedBox(height: AppTokens.s12),

            // Skip button
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Maybe Later'),
            ),
          ],
        ),
      ),
    );
  }
}
