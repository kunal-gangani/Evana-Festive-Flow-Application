import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';

@immutable
class TicketModel {
  const TicketModel({
    required this.ticketId,
    required this.eventId,
    required this.userId,
    required this.purchaseDate,
    required this.isScanned,
    required this.eventTitle,
    required this.eventDate,
  });

  final String ticketId;
  final String eventId;
  final String userId;
  final DateTime purchaseDate;
  final bool isScanned;
  final String eventTitle;
  final DateTime eventDate;

  String get secureHash {
    final raw = '$ticketId$userId$eventId';
    return sha256.convert(utf8.encode(raw)).toString();
  }

  TicketModel copyWith({
    String? ticketId,
    String? eventId,
    String? userId,
    DateTime? purchaseDate,
    bool? isScanned,
    String? eventTitle,
    DateTime? eventDate,
  }) {
    return TicketModel(
      ticketId: ticketId ?? this.ticketId,
      eventId: eventId ?? this.eventId,
      userId: userId ?? this.userId,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      isScanned: isScanned ?? this.isScanned,
      eventTitle: eventTitle ?? this.eventTitle,
      eventDate: eventDate ?? this.eventDate,
    );
  }
}
