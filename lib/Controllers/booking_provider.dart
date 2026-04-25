import 'package:evana_event_management_app/Helpers/app_exception.dart';
import 'package:evana_event_management_app/Models/event_model.dart';
import 'package:evana_event_management_app/Models/ticket_model.dart';
import 'package:evana_event_management_app/Services/booking_service.dart';
import 'package:flutter/foundation.dart';

import 'event_provider.dart';

class BookingProvider extends ChangeNotifier {
  BookingProvider({
    required BookingService bookingService,
  }) : _bookingService = bookingService {
    hydrate();
  }

  final BookingService _bookingService;

  List<TicketModel> _userTickets = const [];
  bool _isBooking = false;
  bool _isHydrating = false;
  String? _error;
  bool _isDisposed = false;
  Future<void>? _hydrationFuture;

  List<TicketModel> get userTickets => _userTickets;
  bool get isBooking => _isBooking;
  bool get isHydrating => _isHydrating;
  String? get error => _error;
  int get totalScanned => _userTickets.where((ticket) => ticket.isScanned).length;
  int get totalTickets => _userTickets.length;
  double get checkInProgress =>
      totalTickets == 0 ? 0.0 : totalScanned / totalTickets;

  Future<void> hydrate() {
    return _hydrationFuture ??= _hydrateInternal();
  }

  Future<void> _hydrateInternal() async {
    try {
      _isHydrating = true;
      _error = null;
      _safeNotifyListeners();

      final persistedTickets = await _bookingService.getPersistedTickets();
      if (_isDisposed) {
        return;
      }

      _userTickets = persistedTickets;
    } on AppException catch (error) {
      _error = error.message;
    } catch (_) {
      _error = 'Unable to restore your tickets right now.';
    } finally {
      _isHydrating = false;
      _safeNotifyListeners();
    }
  }

  Future<TicketModel?> handleBooking(
    EventModel event,
    EventProvider eventProvider,
  ) async {
    try {
      await hydrate();
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

  Future<TicketModel?> markTicketAsScanned(TicketModel ticket) async {
    try {
      _error = null;

      final updatedTicket = await _bookingService.markTicketAsScanned(ticket);
      if (_isDisposed) {
        return null;
      }

      _userTickets = _userTickets
          .map(
            (existingTicket) => existingTicket.secureHash == ticket.secureHash
                ? updatedTicket
                : existingTicket,
          )
          .toList();
      _safeNotifyListeners();
      return updatedTicket;
    } on AppException catch (error) {
      _error = error.message;
      _safeNotifyListeners();
      return null;
    } catch (_) {
      _error = 'Unable to update the scanned ticket.';
      _safeNotifyListeners();
      return null;
    }
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
