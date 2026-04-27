import 'package:evana_event_management_app/Views/Common/branded_page_scaffold.dart';
import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    const sections = [
      (
        title: 'Digital ticket integrity',
        body:
            'Ticket QR payloads are signed and must remain unmodified. Altered ticketId or user fields invalidate entry.'
      ),
      (
        title: 'Single-use check-in',
        body:
            'Organizer validation marks tickets as scanned after successful admission. Replay attempts are rejected to protect venue operations.'
      ),
      (
        title: 'Local storage',
        body:
            'Wallet and validation state are persisted locally to support fast access and organizer-side verification during the current app lifecycle.'
      ),
    ];

    return BrandedPageScaffold(
      title: 'Terms & Conditions',
      subtitle:
          'Key policies that support secure admission and predictable event operations.',
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        itemCount: sections.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final section = sections[index];
          return BrandedSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  section.body,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        height: 1.5,
                      ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
