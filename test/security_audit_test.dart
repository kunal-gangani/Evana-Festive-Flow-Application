import 'dart:convert';
import 'dart:io';

import 'package:evana_event_management_app/Models/ticket_model.dart';
import 'package:evana_event_management_app/Services/storage_service.dart';
import 'package:evana_event_management_app/Services/validation_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ValidationService validationService;

  setUpAll(() async {
    final tempDirectory = await Directory.systemTemp.createTemp(
      'evana_security_audit_test_',
    );
    await StorageService.instance.initialize(
      storagePath: tempDirectory.path,
    );
    validationService = ValidationService(
      storageService: StorageService.instance,
    );
  });

  setUp(() async {
    await StorageService.instance.clearTickets();
  });

  test('rejects tampered payloads when userId changes without a new hash',
      () async {
    final ticket = TicketModel(
      ticketId: 'TKT-SEC-001',
      eventId: 'evt-002',
      userId: 'user-007',
      purchaseDate: DateTime.utc(2026, 5, 6, 4, 30),
      isScanned: false,
      eventTitle: 'FutureStack Summit',
      eventDate: DateTime.utc(2026, 5, 6, 10),
    );

    await StorageService.instance.saveTicket(ticket);

    final tamperedPayload = Map<String, dynamic>.from(
      jsonDecode(ticket.qrPayload) as Map,
    )..['userId'] = 'attacker-999';

    final result = await validationService.validateRawQr(
      jsonEncode(tamperedPayload),
    );

    expect(result.status, ValidationStatus.invalid);
  });

  test('returns alreadyScanned after organizer flow scans the same QR twice',
      () async {
    final ticket = TicketModel(
      ticketId: 'TKT-SEC-002',
      eventId: 'evt-001',
      userId: 'user-001',
      purchaseDate: DateTime.utc(2026, 5, 2, 14, 0),
      isScanned: false,
      eventTitle: 'Midnight Raaga Sessions',
      eventDate: DateTime.utc(2026, 5, 2, 19, 30),
    );

    await StorageService.instance.saveTicket(ticket);

    final firstResult = await validationService.validateRawQr(ticket.qrPayload);
    expect(firstResult.status, ValidationStatus.granted);

    await StorageService.instance.markTicketAsScanned(ticket.secureHash);

    final secondResult =
        await validationService.validateRawQr(ticket.qrPayload);

    expect(secondResult.status, ValidationStatus.alreadyScanned);
  });
}
