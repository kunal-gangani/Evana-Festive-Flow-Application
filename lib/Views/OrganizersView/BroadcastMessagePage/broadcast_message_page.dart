import 'package:evana_event_management_app/Controllers/booking_provider.dart';
import 'package:evana_event_management_app/Views/Common/branded_page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BroadcastMessagePage extends StatefulWidget {
  const BroadcastMessagePage({super.key});

  @override
  State<BroadcastMessagePage> createState() => _BroadcastMessagePageState();
}

class _BroadcastMessagePageState extends State<BroadcastMessagePage> {
  final TextEditingController _messageController = TextEditingController(
    text:
        'Doors open in 30 minutes. Please keep your signed QR ready at the gate for faster check-in.',
  );

  static const List<String> _templates = [
    'Doors open in 30 minutes. Please keep your signed QR ready at the gate for faster check-in.',
    'Venue update: entry for premium pass holders will move to Gate B from 7:00 PM onward.',
    'Reminder: tampered or previously scanned ticket payloads will be rejected during entry validation.',
  ];

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrandedPageScaffold(
      title: 'Broadcast Message',
      subtitle:
          'Compose operations-ready copy for attendees while keeping the signed-ticket workflow clear.',
      child: Consumer<BookingProvider>(
        builder: (context, provider, _) {
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              Row(
                children: [
                  Expanded(
                    child: BrandedStatCard(
                      label: 'Audience size',
                      value: '${provider.totalTickets}',
                      icon: Icons.campaign_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BrandedStatCard(
                      label: 'Already checked in',
                      value: '${provider.totalScanned}',
                      icon: Icons.verified_outlined,
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
                      'Message',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _messageController,
                      maxLines: 5,
                      style: const TextStyle(color: Colors.white),
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        hintText: 'Write an attendee update',
                        hintStyle: const TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.04),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _templates.map((template) {
                        return ActionChip(
                          label: const Text('Use template'),
                          onPressed: () {
                            setState(() {
                              _messageController.text = template;
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              BrandedSectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Preview',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _messageController.text,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Broadcast draft reviewed locally and ready for delivery integration.',
                      ),
                    ),
                  );
                },
                child: const Text('Review Broadcast'),
              ),
            ],
          );
        },
      ),
    );
  }
}
