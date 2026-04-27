import 'package:evana_event_management_app/Views/Common/branded_page_scaffold.dart';
import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({super.key});

  @override
  Widget build(BuildContext context) {
    const faqs = [
      (
        question: 'How are ticket IDs protected?',
        answer:
            'Each QR payload carries a SHA-256 signature derived from the ticketId, eventId, userId, and purchase timestamp. Tampering breaks the signature match.'
      ),
      (
        question: 'What happens if someone reuses a QR?',
        answer:
            'The organizer scanner checks the signed payload and the stored ticket state. Once a ticket is marked scanned, replays are rejected as already checked in.'
      ),
      (
        question: 'Where does the wallet data come from?',
        answer:
            'Wallet entries are restored from the local storage service, then surfaced through the booking provider for dashboard and organizer flows.'
      ),
    ];

    return BrandedPageScaffold(
      title: 'FAQ',
      subtitle:
          'Practical answers for attendees and organizers using the secure ticketing flow.',
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        itemCount: faqs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return BrandedSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.question,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  faq.answer,
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
