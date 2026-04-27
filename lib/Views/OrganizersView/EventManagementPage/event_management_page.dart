import 'package:evana_event_management_app/Controllers/event_provider.dart';
import 'package:evana_event_management_app/Helpers/app_theme.dart';
import 'package:evana_event_management_app/Models/event_model.dart';
import 'package:evana_event_management_app/Views/Common/branded_page_scaffold.dart';
import 'package:evana_event_management_app/Views/OrganizersView/CreateEditEventPage/create_edit_event_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventManagementPage extends StatelessWidget {
  const EventManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BrandedPageScaffold(
      title: 'Event Management',
      subtitle:
          'Track availability, spot full houses, and jump into the brief composer for the next launch.',
      actions: [
        IconButton(
          tooltip: 'Refresh events',
          onPressed: () => context.read<EventProvider>().initDashboard(),
          icon: const Icon(Icons.refresh_rounded),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const CreateEditEventPage(),
            ),
          );
        },
        backgroundColor: AppTheme.accentAmber,
        foregroundColor: const Color(0xFF0A0E21),
        label: const Text('New Brief'),
        icon: const Icon(Icons.add_rounded),
      ),
      child: Consumer<EventProvider>(
        builder: (context, provider, _) {
          final events = provider.events;
          if (events.isEmpty) {
            return const BrandedEmptyState(
              title: 'No managed events yet',
              description:
                  'Add or refresh events to monitor capacity and category performance.',
              icon: Icons.event_busy_outlined,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 96),
            itemCount: events.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final event = events[index];
              final occupancy = event.maxBookings == 0
                  ? 0.0
                  : event.currentBookings / event.maxBookings;

              return BrandedSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            event.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: _statusColor(event).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _statusLabel(event),
                            style:
                                Theme.of(context).textTheme.labelMedium?.copyWith(
                                      color: _statusColor(event),
                                      fontWeight: FontWeight.w700,
                                    ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${event.venue} | ${formatEventDate(event.startDate)}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: occupancy.clamp(0.0, 1.0),
                        minHeight: 10,
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _statusColor(event),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${event.currentBookings}/${event.maxBookings} bookings | ${event.priceLabel}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _statusLabel(EventModel event) {
    if (event.isFull) {
      return 'Sold out';
    }
    if (event.currentBookings >= event.maxBookings * 0.8) {
      return 'Nearly full';
    }
    return 'Open';
  }

  Color _statusColor(EventModel event) {
    if (event.isFull) {
      return Colors.redAccent.shade100;
    }
    if (event.currentBookings >= event.maxBookings * 0.8) {
      return AppTheme.accentAmber;
    }
    return Colors.greenAccent;
  }
}
