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
    return generateSecureHash(
      ticketId: ticketId,
      eventId: eventId,
      userId: userId,
      purchaseDate: purchaseDate,
    );
  }

  String get qrPayload {
    return jsonEncode(<String, dynamic>{
      'ticketId': ticketId,
      'eventId': eventId,
      'userId': userId,
      'purchaseDate': purchaseDate.toIso8601String(),
      'hash': secureHash,
      'isScanned': isScanned,
    });
  }

  static String generateSecureHash({
    required String ticketId,
    required String eventId,
    required String userId,
    required DateTime purchaseDate,
  }) {
    final raw =
        '$ticketId|$eventId|$userId|${purchaseDate.toIso8601String()}';
    return sha256.convert(utf8.encode(raw)).toString();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ticketId': ticketId,
      'eventId': eventId,
      'userId': userId,
      'purchaseDate': purchaseDate.toIso8601String(),
      'isScanned': isScanned,
      'eventTitle': eventTitle,
      'eventDate': eventDate.toIso8601String(),
    };
  }

  factory TicketModel.fromMap(Map<dynamic, dynamic> map) {
    return TicketModel(
      ticketId: map['ticketId'] as String,
      eventId: map['eventId'] as String,
      userId: map['userId'] as String,
      purchaseDate: DateTime.parse(map['purchaseDate'] as String),
      isScanned: map['isScanned'] as bool,
      eventTitle: map['eventTitle'] as String,
      eventDate: DateTime.parse(map['eventDate'] as String),
    );
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
