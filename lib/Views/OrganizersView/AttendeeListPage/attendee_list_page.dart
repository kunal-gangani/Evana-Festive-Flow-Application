import 'package:evana_event_management_app/Controllers/booking_provider.dart';
import 'package:evana_event_management_app/Helpers/app_theme.dart';
import 'package:evana_event_management_app/Views/Common/branded_page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AttendeeListPage extends StatelessWidget {
  const AttendeeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BrandedPageScaffold(
      title: 'Attendee List',
      subtitle:
          'Tickets are sourced from local storage and shown with their signed identity and scan state.',
      child: Consumer<BookingProvider>(
        builder: (context, provider, _) {
          final tickets = provider.userTickets;
          if (tickets.isEmpty) {
            return const BrandedEmptyState(
              title: 'No attendees in storage',
              description:
                  'Booked tickets will appear here once the wallet has been hydrated.',
              icon: Icons.groups_outlined,
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            itemCount: tickets.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return BrandedSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ticket.eventTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        _StatusChip(isScanned: ticket.isScanned),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      ticket.ticketId,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.accentAmber,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 10),
                    _InfoRow(
                      label: 'Ticket hash',
                      value: ticket.secureHash,
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      label: 'Purchased',
                      value: formatEventDate(ticket.purchaseDate),
                    ),
                    const SizedBox(height: 8),
                    _InfoRow(
                      label: 'Event date',
                      value: formatEventDate(ticket.eventDate),
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
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.isScanned,
  });

  final bool isScanned;

  @override
  Widget build(BuildContext context) {
    final color = isScanned ? Colors.greenAccent : AppTheme.accentAmber;
    final label = isScanned ? 'Checked in' : 'Active';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 86,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white54,
                ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ),
      ],
    );
  }
}
