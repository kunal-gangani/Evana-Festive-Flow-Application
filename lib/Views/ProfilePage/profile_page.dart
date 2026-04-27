import 'package:evana_event_management_app/Controllers/booking_provider.dart';
import 'package:evana_event_management_app/Views/Common/branded_page_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return BrandedPageScaffold(
      title: 'Profile',
      subtitle:
          'A quick read on the attendee account and the current ticket footprint.',
      child: Consumer<BookingProvider>(
        builder: (context, provider, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              BrandedSectionCard(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 34,
                      backgroundColor: Colors.white.withValues(alpha: 0.08),
                      child: Text(
                        (user?.email ?? 'E').substring(0, 1).toUpperCase(),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      user?.email ?? 'Guest attendee',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Signed wallet access is active for this profile.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: BrandedStatCard(
                      label: 'Tickets in wallet',
                      value: '${provider.totalTickets}',
                      icon: Icons.confirmation_number_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BrandedStatCard(
                      label: 'Already scanned',
                      value: '${provider.totalScanned}',
                      icon: Icons.verified_outlined,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
