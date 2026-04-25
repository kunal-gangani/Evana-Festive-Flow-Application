import 'package:evana_event_management_app/Helpers/app_exception.dart';
import 'package:evana_event_management_app/Models/event_model.dart';
import 'package:evana_event_management_app/Models/ticket_model.dart';
import 'package:evana_event_management_app/Services/storage_service.dart';

class BookingService {
  BookingService({
    required StorageService storageService,
    this.userId = 'evana-user-001',
  }) : _storageService = storageService;

  final String userId;
  final StorageService _storageService;
  final Map<String, int> _bookingState = <String, int>{};

  Future<List<TicketModel>> getPersistedTickets() {
    return _storageService.getTickets();
  }

  Future<TicketModel> markTicketAsScanned(TicketModel ticket) {
    return _storageService.markTicketAsScanned(ticket.secureHash);
  }

  Future<TicketModel> bookTicket(EventModel event) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 1400));

      final currentBookings = _bookingState[event.id] ?? event.currentBookings;
      if (currentBookings >= event.maxBookings) {
        throw AppException('This event is fully booked.');
      }

      final ticket = TicketModel(
        ticketId: 'TKT-${event.id}-${DateTime.now().millisecondsSinceEpoch}',
        eventId: event.id,
        userId: userId,
        purchaseDate: DateTime.now(),
        isScanned: false,
        eventTitle: event.title,
        eventDate: event.startDate,
      );

      await _storageService.saveTicket(ticket);
      _bookingState[event.id] = currentBookings + 1;
      return ticket;
    } on AppException {
      rethrow;
    } catch (_) {
      throw AppException('Unable to complete booking right now.');
    }
  }
}
