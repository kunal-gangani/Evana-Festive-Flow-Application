import 'package:evana_event_management_app/Helpers/app_exception.dart';
import 'package:evana_event_management_app/Models/event_model.dart';
import 'package:evana_event_management_app/Models/ticket_model.dart';

class BookingService {
  BookingService({
    this.userId = 'evana-user-001',
  });

  final String userId;
  final Map<String, int> _bookingState = <String, int>{};

  Future<TicketModel> bookTicket(EventModel event) async {
    try {
      await Future<void>.delayed(const Duration(milliseconds: 1400));

      final currentBookings = _bookingState[event.id] ?? event.currentBookings;
      if (currentBookings >= event.maxBookings) {
        throw AppException('This event is fully booked.');
      }

      _bookingState[event.id] = currentBookings + 1;

      return TicketModel(
        ticketId: 'TKT-${event.id}-${DateTime.now().millisecondsSinceEpoch}',
        eventId: event.id,
        userId: userId,
        purchaseDate: DateTime.now(),
        isScanned: false,
        eventTitle: event.title,
        eventDate: event.startDate,
      );
    } on AppException {
      rethrow;
    } catch (_) {
      throw AppException('Unable to complete booking right now.');
    }
  }
}
