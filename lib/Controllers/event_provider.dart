import 'package:evana_event_management_app/Helpers/app_exception.dart';
import 'package:evana_event_management_app/Models/event_model.dart';
import 'package:evana_event_management_app/Services/event_service.dart';
import 'package:flutter/foundation.dart';

class EventProvider extends ChangeNotifier {
  EventProvider({
    required EventService eventService,
  }) : _eventService = eventService;

  final EventService _eventService;

  List<EventModel> _allEvents = const [];
  List<EventModel> _events = const [];
  bool _isLoading = false;
  String? _error;
  EventCategory? _selectedCategory;
  bool _isDisposed = false;

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;
  EventCategory? get selectedCategory => _selectedCategory;

  Future<void> initDashboard() async {
    try {
      _isLoading = true;
      _error = null;
      _safeNotifyListeners();

      final fetchedEvents = await _eventService.getEvents();
      if (_isDisposed) {
        return;
      }

      _allEvents = fetchedEvents;
      _events = fetchedEvents;
      _selectedCategory = null;
      _isLoading = false;
      _safeNotifyListeners();
    } on AppException catch (error) {
      _handleError(error.message);
    } catch (_) {
      _handleError('Something went wrong while fetching events.');
    }
  }

  void filterByCategory(EventCategory category) {
    try {
      _error = null;
      _selectedCategory = category;
      _events = _allEvents.where((event) => event.category == category).toList();
      _safeNotifyListeners();
    } catch (_) {
      _error = 'Unable to apply the selected category.';
      _safeNotifyListeners();
    }
  }

  void showAllEvents() {
    try {
      _error = null;
      _selectedCategory = null;
      _events = _allEvents;
      _safeNotifyListeners();
    } catch (_) {
      _error = 'Unable to restore the full event list.';
      _safeNotifyListeners();
    }
  }

  void applyBooking(String eventId) {
    try {
      _error = null;
      _allEvents = _allEvents
          .map(
            (event) => event.id == eventId
                ? event.copyWith(currentBookings: event.currentBookings + 1)
                : event,
          )
          .toList();

      if (_selectedCategory == null) {
        _events = _allEvents;
      } else {
        _events = _allEvents
            .where((event) => event.category == _selectedCategory)
            .toList();
      }

      _safeNotifyListeners();
    } catch (_) {
      _error = 'Unable to refresh booking availability.';
      _safeNotifyListeners();
    }
  }

  void _handleError(String message) {
    _error = message;
    _isLoading = false;
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
