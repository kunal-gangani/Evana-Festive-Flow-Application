import 'dart:io';

import 'package:evana_event_management_app/Controllers/booking_provider.dart';
import 'package:evana_event_management_app/Controllers/event_provider.dart';
import 'package:evana_event_management_app/Helpers/app_theme.dart';
import 'package:evana_event_management_app/Routes/routes.dart';
import 'package:evana_event_management_app/Services/booking_service.dart';
import 'package:evana_event_management_app/Services/event_service.dart';
import 'package:evana_event_management_app/Services/storage_service.dart';
import 'package:evana_event_management_app/Views/Dashboard/event_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final tempDirectory = await Directory.systemTemp.createTemp(
      'evana_app_flow_test_',
    );
    await StorageService.instance.initialize(
      storagePath: tempDirectory.path,
    );
  });

  Widget buildTestApp() {
    final bookingService = BookingService(
      storageService: StorageService.instance,
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<EventProvider>(
          create: (_) => EventProvider(
            eventService: EventService(),
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

  testWidgets('launch flow renders splash then navigates to dashboard',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildTestApp());
    await tester.pump();

    expect(find.text('Evana Festive Flow'), findsOneWidget);
    expect(find.byType(LottieBuilder), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    expect(find.byType(EventDashboard), findsOneWidget);
    expect(find.text('Event Discovery'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    expect(find.text('Curated festive experiences'), findsOneWidget);
    expect(find.text('FutureStack Summit'), findsOneWidget);
  });
}
