import 'package:evana_event_management_app/Models/event_model.dart';
import 'package:evana_event_management_app/Views/Common/branded_page_scaffold.dart';
import 'package:flutter/material.dart';

class CreateEditEventPage extends StatefulWidget {
  const CreateEditEventPage({super.key});

  @override
  State<CreateEditEventPage> createState() => _CreateEditEventPageState();
}

class _CreateEditEventPageState extends State<CreateEditEventPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'Act VI After Hours');
  final _venueController =
      TextEditingController(text: 'Skyline Hall, Bengaluru');
  final _priceController = TextEditingController(text: 'From Rs. 1,799');
  final _descriptionController = TextEditingController(
    text:
        'A late-night showcase with immersive visuals, fast entry lanes, and a premium attendee journey.',
  );
  EventCategory _category = EventCategory.music;

  @override
  void dispose() {
    _titleController.dispose();
    _venueController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BrandedPageScaffold(
      title: 'Create Event Brief',
      subtitle:
          'Capture the event story, venue, and ticket positioning before backend publishing is wired in.',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
        children: [
          BrandedSectionCard(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildField(
                    controller: _titleController,
                    label: 'Event title',
                  ),
                  const SizedBox(height: 12),
                  _buildField(
                    controller: _venueController,
                    label: 'Venue',
                  ),
                  const SizedBox(height: 12),
                  _buildField(
                    controller: _priceController,
                    label: 'Price label',
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<EventCategory>(
                    initialValue: _category,
                    dropdownColor: const Color(0xFF171D39),
                    decoration: _decoration('Category'),
                    items: EventCategory.values.map((category) {
                      return DropdownMenuItem<EventCategory>(
                        value: category,
                        child: Text(_categoryLabel(category)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) {
                        return;
                      }
                      setState(() {
                        _category = value;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (_) => setState(() {}),
                    decoration: _decoration('Description'),
                    validator: (value) {
                      if (value == null || value.trim().length < 20) {
                        return 'Add at least 20 characters of detail.';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          BrandedSectionCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Live preview',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  _titleController.text,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${_venueController.text} | ${_priceController.text}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white70,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  _descriptionController.text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Category: ${_categoryLabel(_category)}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Event brief validated locally and ready for publishing integration.',
                  ),
                ),
              );
            },
            child: const Text('Validate Brief'),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
  }) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      onChanged: (_) => setState(() {}),
      decoration: _decoration(label),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'This field is required.';
        }
        return null;
      },
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      filled: true,
      fillColor: Colors.white.withValues(alpha: 0.04),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
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
}
