import 'dart:convert';

import 'package:evana_event_management_app/Models/ticket_model.dart';
import 'package:evana_event_management_app/Services/storage_service.dart';

enum ValidationStatus {
  granted,
  alreadyScanned,
  invalid,
}

class ValidationResult {
  const ValidationResult({
    required this.status,
    required this.message,
    this.ticket,
  });

  final ValidationStatus status;
  final String message;
  final TicketModel? ticket;

  bool get isValid => status == ValidationStatus.granted;
}

class ValidationService {
  ValidationService({
    required StorageService storageService,
  }) : _storageService = storageService;

  final StorageService _storageService;

  Future<ValidationResult> validateRawQr(String rawQr) async {
    try {
      final dynamic decoded = jsonDecode(rawQr);
      if (decoded is! Map) {
        return const ValidationResult(
          status: ValidationStatus.invalid,
          message: 'Invalid QR payload.',
        );
      }

      final payload = Map<String, dynamic>.from(decoded);
      final eventId = payload['eventId'] as String?;
      final userId = payload['userId'] as String?;
      final purchaseDateRaw = payload['purchaseDate'] as String?;
      final providedHash = payload['hash'] as String?;
      final isScanned = payload['isScanned'] as bool?;

      if (eventId == null ||
          userId == null ||
          purchaseDateRaw == null ||
          providedHash == null ||
          isScanned == null) {
        return const ValidationResult(
          status: ValidationStatus.invalid,
          message: 'QR code is missing required ticket data.',
        );
      }

      final purchaseDate = DateTime.tryParse(purchaseDateRaw);
      if (purchaseDate == null) {
        return const ValidationResult(
          status: ValidationStatus.invalid,
          message: 'QR code contains an invalid purchase timestamp.',
        );
      }

      final recalculatedHash = TicketModel.generateSecureHash(
        eventId: eventId,
        userId: userId,
        purchaseDate: purchaseDate,
      );

      if (recalculatedHash != providedHash) {
        return const ValidationResult(
          status: ValidationStatus.invalid,
          message: 'Security alert: QR signature mismatch detected.',
        );
      }

      final storedTicket = await _storageService.getTicketByHash(providedHash);
      if (storedTicket == null) {
        return const ValidationResult(
          status: ValidationStatus.invalid,
          message: 'Security alert: ticket was not found locally.',
        );
      }

      final matchesStoredTicket = storedTicket.eventId == eventId &&
          storedTicket.userId == userId &&
          storedTicket.purchaseDate.toIso8601String() ==
              purchaseDate.toIso8601String();
      if (!matchesStoredTicket) {
        return const ValidationResult(
          status: ValidationStatus.invalid,
          message: 'Security alert: ticket data appears tampered.',
        );
      }

      if (isScanned || storedTicket.isScanned) {
        return ValidationResult(
          status: ValidationStatus.alreadyScanned,
          message: 'Security alert: this ticket was already scanned.',
          ticket: storedTicket,
        );
      }

      return ValidationResult(
        status: ValidationStatus.granted,
        message: 'Access granted. Ticket verified successfully.',
        ticket: storedTicket,
      );
    } catch (_) {
      return const ValidationResult(
        status: ValidationStatus.invalid,
        message: 'Security alert: unable to validate this QR code.',
      );
    }
  }
}
