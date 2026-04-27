import 'package:evana_event_management_app/Controllers/booking_provider.dart';
import 'package:evana_event_management_app/Controllers/event_provider.dart';
import 'package:evana_event_management_app/Helpers/app_theme.dart';
import 'package:evana_event_management_app/Routes/routes.dart';
import 'package:evana_event_management_app/Services/booking_service.dart';
import 'package:evana_event_management_app/Services/event_service.dart';
import 'package:evana_event_management_app/Services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.instance.initialize();
  final eventService = EventService(
    storageService: StorageService.instance,
  );
  await eventService.seedFutureStackTickets();

  runApp(
    EvanaApp(
      bookingService: BookingService(
        storageService: StorageService.instance,
      ),
      eventService: eventService,
    ),
  );
}

class EvanaApp extends StatelessWidget {
  const EvanaApp({
    required this.bookingService,
    required this.eventService,
    super.key,
  });

  final BookingService bookingService;
  final EventService eventService;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventProvider>(
          create: (_) => EventProvider(
            eventService: eventService,
          )..initDashboard(),
        ),
        ChangeNotifierProvider<BookingProvider>(
          create: (_) => BookingProvider(
            bookingService: bookingService,
          ),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        initialRoute: Routes.splash,
        getPages: Routes.routes,
      ),
    );
  }
}
