import 'package:flutter/material.dart';
import '../../theme/tokens.dart';
import '../models/event.dart';
import '../utils/currency.dart';
import '../utils/date.dart';

/// Event list with grouping by date
class EventList extends StatelessWidget {
  final List<Event> events;
  final Future<void> Function()? onLoadMore;

  const EventList({
    super.key,
    required this.events,
    this.onLoadMore,
  });

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppTokens.s32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.history,
                size: 64,
                color: Theme.of(context).colorScheme.outline,
              ),
              const SizedBox(height: AppTokens.s16),
              Text(
                'No activity yet',
                style: AppTokens.body.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Group events by date
    final grouped = <String, List<Event>>{};
    for (final event in events) {
      final dateKey = DateFormatter.formatGroupDate(event.timestamp);
      grouped.putIfAbsent(dateKey, () => []);
      grouped[dateKey]!.add(event);
    }

    return ListView.builder(
      itemCount: grouped.length,
      itemBuilder: (context, index) {
        final dateKey = grouped.keys.elementAt(index);
        final dateEvents = grouped[dateKey]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTokens.s16,
                vertical: AppTokens.s12,
              ),
              child: Text(
                dateKey,
                style: AppTokens.label.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),

            // Events for this date
            ...dateEvents.map((event) => _buildEventItem(context, event)),
          ],
        );
      },
    );
  }

  Widget _buildEventItem(BuildContext context, Event event) {
    switch (event.type) {
      case EventType.roundup:
        return _RoundUpItem(event: event);
      case EventType.topup:
        return _TopUpItem(event: event);
      case EventType.skip:
        return _SkipItem(event: event);
      case EventType.goalAchieved:
        return _GoalAchievedItem(event: event);
    }
  }
}

// Round-up event item
class _RoundUpItem extends StatelessWidget {
  final Event event;

  const _RoundUpItem({required this.event});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppTokens.navy.withValues(alpha: 0.1),
        child: const Icon(Icons.arrow_upward, color: AppTokens.navy, size: 20),
      ),
      title: Text(
        event.merchant ?? 'Round-up',
        style: AppTokens.body.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        '${event.category ?? ''} • ${CurrencyFormatter.formatUSD(event.transactionAmount ?? 0.0)}',
        style: AppTokens.caption.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: Text(
        '+${CurrencyFormatter.formatUSD(event.amountDelta)}',
        style: AppTokens.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTokens.navy,
        ),
      ),
    );
  }
}

// Top-up event item
class _TopUpItem extends StatelessWidget {
  final Event event;

  const _TopUpItem({required this.event});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppTokens.accentRed.withValues(alpha: 0.1),
        child: const Icon(Icons.add_circle, color: AppTokens.accentRed, size: 20),
      ),
      title: Text(
        'Manual Top-up',
        style: AppTokens.body.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        DateFormatter.formatTime(event.timestamp),
        style: AppTokens.caption.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: Text(
        '+${CurrencyFormatter.formatUSD(event.amountDelta)}',
        style: AppTokens.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTokens.accentRed,
        ),
      ),
    );
  }
}

// Skip event item
class _SkipItem extends StatelessWidget {
  final Event event;

  const _SkipItem({required this.event});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppTokens.gray200,
        child: Icon(Icons.block, color: AppTokens.gray500, size: 20),
      ),
      title: Text(
        event.merchant ?? 'Skipped',
        style: AppTokens.body.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      subtitle: Text(
        event.reason ?? 'Unknown reason',
        style: AppTokens.caption.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
      trailing: const Icon(Icons.info_outline, size: 16),
    );
  }
}

// Goal achieved event item
class _GoalAchievedItem extends StatelessWidget {
  final Event event;

  const _GoalAchievedItem({required this.event});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: AppTokens.accentRed.withValues(alpha: 0.1),
        child: const Icon(Icons.emoji_events, color: AppTokens.accentRed, size: 20),
      ),
      title: Text(
        'Goal Achieved!',
        style: AppTokens.body.copyWith(
          fontWeight: FontWeight.w600,
          color: AppTokens.accentRed,
        ),
      ),
      subtitle: Text(
        DateFormatter.formatTime(event.timestamp),
        style: AppTokens.caption.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: const Icon(Icons.celebration, color: AppTokens.accentRed),
    );
  }
}
