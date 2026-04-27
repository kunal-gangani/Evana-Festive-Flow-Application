import 'package:evana_event_management_app/Controllers/booking_provider.dart';
import 'package:evana_event_management_app/Controllers/event_provider.dart';
import 'package:evana_event_management_app/Views/Common/branded_page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BrandedPageScaffold(
      title: 'Notifications',
      subtitle:
          'Operational updates generated from the current wallet and event state.',
      child: Consumer2<EventProvider, BookingProvider>(
        builder: (context, eventProvider, bookingProvider, _) {
          final items = <({String title, String body, IconData icon})>[
            (
              title: 'Wallet hydrated',
              body:
                  '${bookingProvider.totalTickets} ticket(s) are ready for attendee access.',
              icon: Icons.account_balance_wallet_outlined,
            ),
            (
              title: 'Entry updates',
              body:
                  '${bookingProvider.totalScanned} ticket(s) have already been checked in through the organizer flow.',
              icon: Icons.qr_code_scanner_rounded,
            ),
            (
              title: 'Capacity watch',
              body:
                  '${eventProvider.events.where((event) => event.isFull).length} event(s) are currently sold out.',
              icon: Icons.local_fire_department_outlined,
            ),
          ];

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = items[index];
              return BrandedSectionCard(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(item.icon, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            item.body,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: Colors.white70),
                          ),
                        ],
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
}
