import 'package:flutter/foundation.dart';

enum EventCategory {
  music,
  tech,
  workshop,
  sports,
}

@immutable
class EventModel {
  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.venue,
    required this.imageUrl,
    required this.priceLabel,
    required this.startDate,
    required this.category,
    required this.isFeatured,
    required this.currentBookings,
    required this.maxBookings,
  });

  final String id;
  final String title;
  final String description;
  final String venue;
  final String imageUrl;
  final String priceLabel;
  final DateTime startDate;
  final EventCategory category;
  final bool isFeatured;
  final int currentBookings;
  final int maxBookings;

  bool get isFull => currentBookings >= maxBookings;

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      venue: map['venue'] as String? ?? '',
      imageUrl: map['imageUrl'] as String? ?? '',
      priceLabel: map['priceLabel'] as String? ?? '',
      startDate: DateTime.tryParse(map['startDate'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
      category: EventCategory.values.byName(
        (map['category'] as String? ?? EventCategory.music.name).toLowerCase(),
      ),
      isFeatured: map['isFeatured'] as bool? ?? false,
      currentBookings: map['currentBookings'] as int? ?? 0,
      maxBookings: map['maxBookings'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'venue': venue,
      'imageUrl': imageUrl,
      'priceLabel': priceLabel,
      'startDate': startDate.toIso8601String(),
      'category': category.name,
      'isFeatured': isFeatured,
      'currentBookings': currentBookings,
      'maxBookings': maxBookings,
    };
  }

  EventModel copyWith({
    String? id,
    String? title,
    String? description,
    String? venue,
    String? imageUrl,
    String? priceLabel,
    DateTime? startDate,
    EventCategory? category,
    bool? isFeatured,
    int? currentBookings,
    int? maxBookings,
  }) {
    return EventModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      venue: venue ?? this.venue,
      imageUrl: imageUrl ?? this.imageUrl,
      priceLabel: priceLabel ?? this.priceLabel,
      startDate: startDate ?? this.startDate,
      category: category ?? this.category,
      isFeatured: isFeatured ?? this.isFeatured,
      currentBookings: currentBookings ?? this.currentBookings,
      maxBookings: maxBookings ?? this.maxBookings,
    );
  }
}
