import 'package:flutter/material.dart';
import '../../../core/models/jar_v2.dart';
import '../../../core/utils/currency.dart';
import '../../../core/utils/date.dart';
import '../../../theme/tokens.dart';

class ActivityList extends StatelessWidget {
  const ActivityList({super.key, required this.activities});

  final List<JarActivity> activities;

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(AppTokens.s24),
          child: Text('No activity yet'),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final activity = activities[index];
        return ListTile(
          leading: Text(activity.emoji, style: const TextStyle(fontSize: 24)),
          title: Text(activity.description),
          subtitle: Text(formatRelativeTime(activity.timestamp)),
          trailing: Text(
            formatCurrency(activity.amount),
            style: AppTokens.label.copyWith(color: AppTokens.teal),
          ),
        );
      },
    );
  }
}
