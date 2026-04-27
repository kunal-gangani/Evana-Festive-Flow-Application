import 'package:evana_event_management_app/Services/storage_service.dart';
import 'package:evana_event_management_app/Services/validation_service.dart';
import 'package:evana_event_management_app/Views/Scanner/scanner_view.dart';
import 'package:flutter/material.dart';

class QRScannerPage extends StatelessWidget {
  const QRScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScannerView(
      validationService: ValidationService(
        storageService: StorageService.instance,
      ),
    );
  }
}
