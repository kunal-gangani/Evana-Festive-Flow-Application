import 'package:evana_event_management_app/Controllers/booking_provider.dart';
import 'package:evana_event_management_app/Controllers/event_provider.dart';
import 'package:evana_event_management_app/Helpers/app_theme.dart';
import 'package:evana_event_management_app/Services/booking_service.dart';
import 'package:evana_event_management_app/Services/event_service.dart';
import 'package:evana_event_management_app/Views/SplashScreen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    const EvanaApp(),
  );
}

class EvanaApp extends StatelessWidget {
  const EvanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventProvider>(
          create: (_) => EventProvider(
            eventService: EventService(),
          )..initDashboard(),
        ),
        ChangeNotifierProvider<BookingProvider>(
          create: (_) => BookingProvider(
            bookingService: BookingService(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
