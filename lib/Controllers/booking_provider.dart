import 'package:evana_event_management_app/Helpers/app_exception.dart';
import 'package:evana_event_management_app/Models/event_model.dart';
import 'package:evana_event_management_app/Models/ticket_model.dart';
import 'package:evana_event_management_app/Services/booking_service.dart';
import 'package:flutter/foundation.dart';

import 'event_provider.dart';

class BookingProvider extends ChangeNotifier {
  BookingProvider({
    required BookingService bookingService,
  }) : _bookingService = bookingService;

  final BookingService _bookingService;

  List<TicketModel> _userTickets = const [];
  bool _isBooking = false;
  String? _error;
  bool _isDisposed = false;

  List<TicketModel> get userTickets => _userTickets;
  bool get isBooking => _isBooking;
  String? get error => _error;

  Future<TicketModel?> handleBooking(
    EventModel event,
    EventProvider eventProvider,
  ) async {
    try {
      _error = null;

      if (event.isFull) {
        _error = 'This event is fully booked.';
        _safeNotifyListeners();
        return null;
      }

      _isBooking = true;
      _safeNotifyListeners();

      final ticket = await _bookingService.bookTicket(event);
      if (_isDisposed) {
        return null;
      }

      _userTickets = [ticket, ..._userTickets];
      eventProvider.applyBooking(event.id);
      _isBooking = false;
      _safeNotifyListeners();
      return ticket;
    } on AppException catch (error) {
      _error = error.message;
      _isBooking = false;
      _safeNotifyListeners();
      return null;
    } catch (_) {
      _error = 'Unable to complete booking right now.';
      _isBooking = false;
      _safeNotifyListeners();
      return null;
    }
  }

  void clearError() {
    _error = null;
    _safeNotifyListeners();
  }

  void _safeNotifyListeners() {
    if (!_isDisposed) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
