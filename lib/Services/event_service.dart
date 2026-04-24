import 'package:evana_event_management_app/Helpers/app_exception.dart';
import 'package:evana_event_management_app/Models/event_model.dart';

class EventService {
  Future<List<EventModel>> getEvents() async {
    try {
      return await Future<List<EventModel>>.delayed(
        const Duration(seconds: 2),
        () => [
          EventModel(
            id: 'evt-001',
            title: 'Midnight Raaga Sessions',
            description: 'An immersive music night with live fusion artists.',
            venue: 'Royal Opera Lawn, Bengaluru',
            imageUrl: 'https://images.unsplash.com/photo-1501386761578-eac5c94b800a?auto=format&fit=crop&w=1200&q=80',
            priceLabel: 'From Rs. 1,499',
            startDate: DateTime(2026, 5, 2, 19, 30),
            category: EventCategory.music,
            isFeatured: true,
            currentBookings: 168,
            maxBookings: 220,
          ),
          EventModel(
            id: 'evt-002',
            title: 'FutureStack Summit',
            description: 'A premium tech conference on AI products and cloud systems.',
            venue: 'Convention Centre, Hyderabad',
            imageUrl: 'https://images.unsplash.com/photo-1511578314322-379afb476865?auto=format&fit=crop&w=1200&q=80',
            priceLabel: 'From Rs. 2,999',
            startDate: DateTime(2026, 5, 6, 10, 0),
            category: EventCategory.tech,
            isFeatured: false,
            currentBookings: 312,
            maxBookings: 320,
          ),
          EventModel(
            id: 'evt-003',
            title: 'Designing With Light Workshop',
            description: 'A curated workshop on stage aesthetics and live experience design.',
            venue: 'Studio Ember, Mumbai',
            imageUrl: 'https://images.unsplash.com/photo-1515169067868-5387ec356754?auto=format&fit=crop&w=1200&q=80',
            priceLabel: 'From Rs. 899',
            startDate: DateTime(2026, 5, 9, 14, 0),
            category: EventCategory.workshop,
            isFeatured: true,
            currentBookings: 44,
            maxBookings: 60,
          ),
          EventModel(
            id: 'evt-004',
            title: 'City Night Run',
            description: 'A sports carnival with a 10K illuminated run and recovery lounge.',
            venue: 'Marine Drive, Kochi',
            imageUrl: 'https://images.unsplash.com/photo-1517649763962-0c623066013b?auto=format&fit=crop&w=1200&q=80',
            priceLabel: 'From Rs. 699',
            startDate: DateTime(2026, 5, 12, 5, 45),
            category: EventCategory.sports,
            isFeatured: false,
            currentBookings: 510,
            maxBookings: 510,
          ),
        ],
      );
    } catch (_) {
      throw AppException('Unable to load events right now.');
    }
  }
}
