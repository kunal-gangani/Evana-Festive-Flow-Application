import 'package:evana_event_management_app/Controllers/booking_provider.dart';
import 'package:evana_event_management_app/Controllers/event_provider.dart';
import 'package:evana_event_management_app/Views/Common/branded_page_scaffold.dart';
import 'package:evana_event_management_app/Views/OrganizersView/AttendeeListPage/attendee_list_page.dart';
import 'package:evana_event_management_app/Views/OrganizersView/BroadcastMessagePage/broadcast_message_page.dart';
import 'package:evana_event_management_app/Views/OrganizersView/CreateEditEventPage/create_edit_event_page.dart';
import 'package:evana_event_management_app/Views/OrganizersView/EventAnalyticsPage/event_analytics_page.dart';
import 'package:evana_event_management_app/Views/OrganizersView/EventManagementPage/event_management_page.dart';
import 'package:evana_event_management_app/Views/OrganizersView/OrgQRScannerPage/org_qr_scanner_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrganizerDashboardPage extends StatelessWidget {
  const OrganizerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BrandedPageScaffold(
      title: 'Organizer Command',
      subtitle:
          'Monitor signed ticket traffic, review event health, and launch entry operations from one place.',
      child: Consumer2<EventProvider, BookingProvider>(
        builder: (context, eventProvider, bookingProvider, _) {
          final totalEvents = eventProvider.events.length;
          final soldOutEvents =
              eventProvider.events.where((event) => event.isFull).length;
          final totalTickets = bookingProvider.totalTickets;
          final checkedIn = bookingProvider.totalScanned;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              Row(
                children: [
                  Expanded(
                    child: BrandedStatCard(
                      label: 'Live events',
                      value: '$totalEvents',
                      icon: Icons.celebration_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BrandedStatCard(
                      label: 'Checked in',
                      value: '$checkedIn/$totalTickets',
                      icon: Icons.verified_user_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: BrandedStatCard(
                      label: 'Sold out',
                      value: '$soldOutEvents',
                      icon: Icons.local_fire_department_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BrandedStatCard(
                      label: 'Signature-ready',
                      value: 'SHA-256',
                      icon: Icons.shield_outlined,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              BrandedSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entry security posture',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Every QR is verified against the stored ticket signature before admission. Replays and tampered ticketId payloads are blocked before check-in is written back to storage.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              BrandedActionTile(
                title: 'Scan at Gate',
                subtitle:
                    'Open the hardened scanner with success and failure haptics.',
                icon: Icons.qr_code_scanner_rounded,
                onTap: () => _push(context, const OrgQRScannerPage()),
              ),
              const SizedBox(height: 12),
              BrandedActionTile(
                title: 'Event Analytics',
                subtitle:
                    'Review occupancy, scanned tickets, and event-level conversion.',
                icon: Icons.insights_outlined,
                onTap: () => _push(context, const EventAnalyticsPage()),
              ),
              const SizedBox(height: 12),
              BrandedActionTile(
                title: 'Attendee List',
                subtitle:
                    'Inspect ticket holders with live scanned and active states.',
                icon: Icons.groups_2_outlined,
                onTap: () => _push(context, const AttendeeListPage()),
              ),
              const SizedBox(height: 12),
              BrandedActionTile(
                title: 'Event Management',
                subtitle:
                    'Review event capacity and jump into the event brief composer.',
                icon: Icons.event_note_outlined,
                onTap: () => _push(context, const EventManagementPage()),
              ),
              const SizedBox(height: 12),
              BrandedActionTile(
                title: 'Broadcast Message',
                subtitle:
                    'Prepare attendee updates with audience-aware copy previews.',
                icon: Icons.campaign_outlined,
                onTap: () => _push(context, const BroadcastMessagePage()),
              ),
              const SizedBox(height: 12),
              BrandedActionTile(
                title: 'Create Event Brief',
                subtitle:
                    'Draft event metadata and preview the attendee-facing surface.',
                icon: Icons.edit_calendar_outlined,
                onTap: () => _push(context, const CreateEditEventPage()),
              ),
            ],
          );
        },
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => page),
    );
  }
}
