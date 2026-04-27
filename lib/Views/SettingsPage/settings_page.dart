import 'package:evana_event_management_app/Views/Common/branded_page_scaffold.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _entryAlerts = true;
  bool _walletHints = true;
  bool _marketingUpdates = false;

  @override
  Widget build(BuildContext context) {
    return BrandedPageScaffold(
      title: 'Settings',
      subtitle:
          'Fine-tune how the app surfaces ticket, scanner, and event updates.',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          BrandedSectionCard(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  value: _entryAlerts,
                  activeColor: Colors.greenAccent,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Entry validation alerts'),
                  subtitle: const Text(
                    'Show alerts for invalid or replayed scans.',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _entryAlerts = value;
                    });
                  },
                ),
                SwitchListTile.adaptive(
                  value: _walletHints,
                  activeColor: Colors.greenAccent,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Wallet reminders'),
                  subtitle: const Text(
                    'Keep ticket readiness prompts visible before events.',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _walletHints = value;
                    });
                  },
                ),
                SwitchListTile.adaptive(
                  value: _marketingUpdates,
                  activeColor: Colors.greenAccent,
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Marketing updates'),
                  subtitle: const Text(
                    'Receive optional event discovery highlights.',
                  ),
                  onChanged: (value) {
                    setState(() {
                      _marketingUpdates = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
