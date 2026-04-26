import 'dart:io';

import 'package:evana_event_management_app/Models/event_model.dart';
import 'package:evana_event_management_app/Services/booking_service.dart';
import 'package:evana_event_management_app/Services/storage_service.dart';
import 'package:evana_event_management_app/Services/validation_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late BookingService bookingService;
  late ValidationService validationService;

  setUpAll(() async {
    final tempDirectory = await Directory.systemTemp.createTemp(
      'evana_end_to_end_validation_test_',
    );
    await StorageService.instance.initialize(
      storagePath: tempDirectory.path,
    );
    bookingService = BookingService(
      storageService: StorageService.instance,
    );
    validationService = ValidationService(
      storageService: StorageService.instance,
    );
  });

  setUp(() async {
    await StorageService.instance.clearTickets();
  });

  test('booking persists a ticket that organizer validation can scan once',
      () async {
    final event = EventModel(
      id: 'evt-001',
      title: 'Midnight Raaga Sessions',
      description: 'An immersive music night with live fusion artists.',
      venue: 'Royal Opera Lawn, Bengaluru',
      imageUrl: 'https://images.unsplash.com/example',
      priceLabel: 'From Rs. 1,499',
      startDate: DateTime(2026, 5, 2, 19, 30),
      category: EventCategory.music,
      isFeatured: true,
      currentBookings: 168,
      maxBookings: 220,
    );

    final bookedTicket = await bookingService.bookTicket(event);
    final persistedTickets = await StorageService.instance.getTickets();

    expect(persistedTickets, hasLength(1));
    expect(persistedTickets.single.ticketId, bookedTicket.ticketId);
    expect(persistedTickets.single.isScanned, isFalse);

    final firstValidation = await validationService.validateRawQr(
      bookedTicket.qrPayload,
    );
    expect(firstValidation.status, ValidationStatus.granted);
    expect(firstValidation.ticket?.ticketId, bookedTicket.ticketId);

    final scannedTicket = await bookingService.markTicketAsScanned(bookedTicket);
    expect(scannedTicket.isScanned, isTrue);

    final secondValidation = await validationService.validateRawQr(
      bookedTicket.qrPayload,
    );
    expect(secondValidation.status, ValidationStatus.alreadyScanned);
  });
}
