import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../theme/tokens.dart';
import '../../core/widgets/event_list.dart';
import '../../core/models/event.dart';
import '../../state/providers.dart';

class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen> {
  String _filter = 'all'; // 'all', 'roundup', 'skip'

  @override
  Widget build(BuildContext context) {
    final allEvents = ref.watch(eventsProvider);

    // Filter events
    final filteredEvents = _filterEvents(allEvents);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Activity'),
      ),
      body: Column(
        children: [
          // Filter chips
          Padding(
            padding: const EdgeInsets.all(AppTokens.s16),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  isSelected: _filter == 'all',
                  onTap: () => setState(() => _filter = 'all'),
                ),
                const SizedBox(width: AppTokens.s8),
                _FilterChip(
                  label: 'Round-ups',
                  isSelected: _filter == 'roundup',
                  onTap: () => setState(() => _filter = 'roundup'),
                ),
                const SizedBox(width: AppTokens.s8),
                _FilterChip(
                  label: 'Skips',
                  isSelected: _filter == 'skip',
                  onTap: () => setState(() => _filter = 'skip'),
                ),
              ],
            ),
          ),

          // Event list
          Expanded(
            child: EventList(events: filteredEvents),
          ),
        ],
      ),
    );
  }

  List<Event> _filterEvents(List<Event> events) {
    switch (_filter) {
      case 'roundup':
        return events.where((e) => e.type == EventType.roundup).toList();
      case 'skip':
        return events.where((e) => e.type == EventType.skip).toList();
      default:
        return events;
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onTap(),
      selectedColor: AppTokens.navy,
      checkmarkColor: Colors.white,
      labelStyle: AppTokens.label.copyWith(
        color: isSelected ? Colors.white : Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
