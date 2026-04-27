import 'package:evana_event_management_app/Controllers/booking_provider.dart';
import 'package:evana_event_management_app/Controllers/event_provider.dart';
import 'package:evana_event_management_app/Models/event_model.dart';
import 'package:evana_event_management_app/Views/Common/branded_page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventAnalyticsPage extends StatelessWidget {
  const EventAnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BrandedPageScaffold(
      title: 'Event Analytics',
      subtitle:
          'Capacity, check-in progress, and signed-ticket conversion across the live catalog.',
      child: Consumer2<EventProvider, BookingProvider>(
        builder: (context, eventProvider, bookingProvider, _) {
          final events = eventProvider.events;
          if (events.isEmpty) {
            return const BrandedEmptyState(
              title: 'No event data available',
              description:
                  'Refresh the dashboard once events are available to unlock organizer analytics.',
              icon: Icons.bar_chart_rounded,
            );
          }

          final totalCapacity =
              events.fold<int>(0, (sum, event) => sum + event.maxBookings);
          final totalBooked = events.fold<int>(
            0,
            (sum, event) => sum + event.currentBookings,
          );
          final capacityFill =
              totalCapacity == 0 ? 0.0 : totalBooked / totalCapacity;
          final scannedTickets = bookingProvider.totalScanned;
          final scannedRate = bookingProvider.totalTickets == 0
              ? 0.0
              : scannedTickets / bookingProvider.totalTickets;
          final leadEvent = _topEvent(events);

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              Row(
                children: [
                  Expanded(
                    child: BrandedStatCard(
                      label: 'Catalog capacity',
                      value: '$totalBooked/$totalCapacity',
                      icon: Icons.stacked_bar_chart_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BrandedStatCard(
                      label: 'Wallet scan rate',
                      value: '${(scannedRate * 100).toStringAsFixed(0)}%',
                      icon: Icons.qr_code_2_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              BrandedSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall occupancy',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: capacityFill.clamp(0.0, 1.0),
                        minHeight: 12,
                        backgroundColor: Colors.white.withValues(alpha: 0.12),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.greenAccent,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${(capacityFill * 100).toStringAsFixed(1)}% of listed capacity is already committed.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (leadEvent != null)
                BrandedSectionCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Best performing event',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        leadEvent.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${leadEvent.currentBookings}/${leadEvent.maxBookings} bookings | ${_occupancyLabel(leadEvent)} full',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              ...events.map(
                (event) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: BrandedSectionCard(
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
                            Text(
                              '${_occupancyLabel(event)}%',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: event.isFull
                                        ? Colors.redAccent.shade100
                                        : Colors.greenAccent,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${event.venue} | ${formatEventDate(event.startDate)}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white70,
                                  ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: event.maxBookings == 0
                                ? 0
                                : event.currentBookings / event.maxBookings,
                            minHeight: 10,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              event.isFull
                                  ? Colors.redAccent.shade100
                                  : Colors.greenAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  EventModel? _topEvent(List<EventModel> events) {
    if (events.isEmpty) {
      return null;
    }

    return events.reduce((left, right) {
      final leftRatio =
          left.maxBookings == 0 ? 0.0 : left.currentBookings / left.maxBookings;
      final rightRatio = right.maxBookings == 0
          ? 0.0
          : right.currentBookings / right.maxBookings;
      return leftRatio >= rightRatio ? left : right;
    });
  }

  String _occupancyLabel(EventModel event) {
    final occupancy = event.maxBookings == 0
        ? 0.0
        : (event.currentBookings / event.maxBookings) * 100;
    return occupancy.toStringAsFixed(0);
  }
}
