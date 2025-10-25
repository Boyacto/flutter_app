import 'package:flutter/material.dart';
import '../models/mission.dart';
import '../../theme/tokens.dart';

class MissionCardWidget extends StatelessWidget {
  const MissionCardWidget({
    super.key,
    required this.mission,
    required this.onTap,
  });

  final Mission mission;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getStatusColor().withOpacity(0.1),
          child: Text(mission.icon, style: const TextStyle(fontSize: 20)),
        ),
        title: Text(mission.title),
        subtitle: Text(mission.subtitle),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '+${mission.rewardPoints}',
              style: AppTokens.label.copyWith(color: AppTokens.accentRed),
            ),
            Text(
              'pts',
              style: AppTokens.caption.copyWith(color: AppTokens.gray500),
            ),
          ],
        ),
        onTap: mission.status == MissionStatus.locked ? null : onTap,
      ),
    );
  }

  Color _getStatusColor() {
    switch (mission.status) {
      case MissionStatus.available:
        return AppTokens.teal;
      case MissionStatus.inProgress:
        return AppTokens.warningAmber;
      case MissionStatus.completed:
        return AppTokens.successGreen;
      case MissionStatus.locked:
        return AppTokens.gray200;
    }
  }
}
