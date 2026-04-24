import 'package:evana_event_management_app/Controllers/booking_provider.dart';
import 'package:evana_event_management_app/Controllers/event_provider.dart';
import 'package:evana_event_management_app/Helpers/app_theme.dart';
import 'package:evana_event_management_app/Models/event_model.dart';
import 'package:evana_event_management_app/Views/SplashScreen/festive_logo.dart';
import 'package:evana_event_management_app/Views/Tickets/ticket_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.event,
  });

  final EventModel event;

  @override
  Widget build(BuildContext context) {
    final bookingProvider = context.watch<BookingProvider>();
    final eventProvider = context.read<EventProvider>();
    final isBooking = bookingProvider.isBooking;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppTheme.accentAmber.withValues(alpha: 0.22),
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              event.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  color: const Color(0xFF171D39),
                );
              },
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.18),
                    Colors.black.withValues(alpha: 0.7),
                    const Color(0xFF0A0E21),
                  ],
                ),
              ),
            ),
            Positioned(
              right: -8,
              top: 16,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.12,
                  child: FestiveLogo(size: 90),
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              top: 18,
              child: Row(
                children: [
                  _HeaderBadge(label: _categoryLabel(event.category)),
                  const Spacer(),
                  if (event.isFeatured) const _HeaderBadge(label: 'Featured'),
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: AppTheme.accentAmber,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.venue,
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white,
                                  ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(
                        event.priceLabel,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppTheme.accentAmber,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const Spacer(),
                      Text(
                        '${event.currentBookings}/${event.maxBookings}',
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: event.isFull
                                  ? Colors.redAccent.shade100
                                  : Colors.white70,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primary.withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _dateLabel(event.startDate),
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .labelMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: event.isFull || isBooking
                              ? null
                              : () async {
                                  bookingProvider.clearError();
                                  final messenger =
                                      ScaffoldMessenger.of(context);
                                  final navigator = Navigator.of(context);

                                  final ticket =
                                      await bookingProvider.handleBooking(
                                    event,
                                    eventProvider,
                                  );

                                  if (!context.mounted || ticket == null) {
                                    if (context.mounted &&
                                        bookingProvider.error != null) {
                                      messenger.showSnackBar(
                                        SnackBar(
                                          content:
                                              Text(bookingProvider.error!),
                                        ),
                                      );
                                    }
                                    return;
                                  }

                                  navigator.push(
                                    MaterialPageRoute<void>(
                                      builder: (_) =>
                                          TicketDetailView(ticket: ticket),
                                    ),
                                  );
                                },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppTheme.accentAmber,
                            foregroundColor: const Color(0xFF0A0E21),
                            disabledBackgroundColor:
                                Colors.white.withValues(alpha: 0.12),
                            disabledForegroundColor: Colors.white54,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: isBooking
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF0A0E21),
                                    ),
                                  ),
                                )
                              : Text(event.isFull ? 'Sold Out' : 'Book Now'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _categoryLabel(EventCategory category) {
    switch (category) {
      case EventCategory.music:
        return 'Music';
      case EventCategory.tech:
        return 'Tech';
      case EventCategory.workshop:
        return 'Workshop';
      case EventCategory.sports:
        return 'Sports';
    }
  }

  String _dateLabel(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[date.month - 1];
    final hour = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
    final minute = date.minute.toString().padLeft(2, '0');
    final meridiem = date.hour >= 12 ? 'PM' : 'AM';
    return '$month ${date.day} • $hour:$minute $meridiem';
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.36),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppTheme.accentAmber.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
      ),
    );
  }
}
