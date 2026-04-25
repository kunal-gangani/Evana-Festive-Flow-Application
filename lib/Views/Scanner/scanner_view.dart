import 'dart:ui';

import 'package:evana_event_management_app/Controllers/booking_provider.dart';
import 'package:evana_event_management_app/Helpers/app_theme.dart';
import 'package:evana_event_management_app/Services/validation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class ScannerView extends StatefulWidget {
  const ScannerView({
    required this.validationService,
    super.key,
  });

  final ValidationService validationService;

  @override
  State<ScannerView> createState() => _ScannerViewState();
}

class _ScannerViewState extends State<ScannerView> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _isProcessing = false;
  bool _showSuccessOverlay = false;
  String _successMessage = 'Access granted. Ticket verified successfully.';

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _handleDetection(BarcodeCapture capture) async {
    if (_isProcessing) {
      return;
    }

    final Barcode? firstBarcode =
        capture.barcodes.isEmpty ? null : capture.barcodes.first;
    final rawValue = firstBarcode?.rawValue;
    if (rawValue == null || rawValue.isEmpty) {
      return;
    }

    _isProcessing = true;
    final bookingProvider = context.read<BookingProvider>();
    await _scannerController.stop();

    final result = await widget.validationService.validateRawQr(rawValue);
    if (!mounted) {
      return;
    }

    if (result.isValid && result.ticket != null) {
      final updatedTicket =
          await bookingProvider.markTicketAsScanned(result.ticket!);

      if (!mounted) {
        return;
      }

      if (updatedTicket == null) {
        await HapticFeedback.vibrate();
        await _showResultDialog(
          title: 'Security Alert',
          message:
              bookingProvider.error ?? 'Unable to update the scanned ticket.',
          accentColor: Colors.redAccent,
          icon: Icons.warning_rounded,
        );
      } else {
        await HapticFeedback.heavyImpact();
        await _showSuccessOverlayBanner(result.message);
      }
    } else if (result.status == ValidationStatus.alreadyScanned) {
      await HapticFeedback.vibrate();
      await _showResultDialog(
        title: 'Already Checked In',
        message: result.message,
        accentColor: Colors.redAccent,
        icon: Icons.block_rounded,
      );
    } else {
      await HapticFeedback.vibrate();
      await _showResultDialog(
        title: 'Security Alert',
        message: result.message,
        accentColor: Colors.redAccent,
        icon: Icons.shield_moon_rounded,
      );
    }

    if (mounted) {
      _isProcessing = false;
      await _scannerController.start();
    }
  }

  Future<void> _showSuccessOverlayBanner(String message) async {
    setState(() {
      _successMessage = message;
      _showSuccessOverlay = true;
    });

    await Future<void>.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _showSuccessOverlay = false;
      });
    }
  }

  Future<void> _showResultDialog({
    required String title,
    required String message,
    required Color accentColor,
    required IconData icon,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF111633),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(
              color: accentColor.withValues(alpha: 0.35),
            ),
          ),
          title: Row(
            children: [
              Icon(icon, color: accentColor),
              const SizedBox(width: 12),
              Text(title),
            ],
          ),
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: const Color(0xFF0A0E21),
              ),
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF05070F),
      appBar: AppBar(
        title: const Text('Organizer Mode'),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _scannerController,
            fit: BoxFit.cover,
            onDetect: _handleDetection,
          ),
          const Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: _StatsCard(),
          ),
          const _ScannerOverlay(),
          IgnorePointer(
            ignoring: !_showSuccessOverlay,
            child: AnimatedOpacity(
              opacity: _showSuccessOverlay ? 1 : 0,
              duration: const Duration(milliseconds: 220),
              child: Center(
                child: AnimatedScale(
                  scale: _showSuccessOverlay ? 1 : 0.92,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutBack,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 28),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xCC0F5D41),
                          Color(0xCC18A66A),
                        ],
                      ),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.greenAccent.withValues(alpha: 0.24),
                          blurRadius: 28,
                          spreadRadius: 4,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 66,
                          height: 66,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                            ),
                          ),
                          child: const Icon(
                            Icons.check_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Access Granted',
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _successMessage,
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 36,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF111633).withValues(alpha: 0.86),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: AppTheme.accentAmber.withValues(alpha: 0.24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Festive Entry Scanner',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Align the guest ticket QR inside the frame for secure verification.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white70,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.14),
                const Color(0xFF10162E).withValues(alpha: 0.7),
              ],
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.16),
            ),
          ),
          child: Selector<BookingProvider, int>(
            selector: (_, provider) => provider.totalScanned,
            builder: (context, totalScanned, _) {
              final bookingProvider = context.read<BookingProvider>();
              final totalTickets = bookingProvider.totalTickets;
              final checkInProgress = bookingProvider.checkInProgress;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Checked In: $totalScanned / $totalTickets',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: checkInProgress,
                      minHeight: 11,
                      backgroundColor: Colors.white.withValues(alpha: 0.12),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.greenAccent,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ScannerOverlay extends StatelessWidget {
  const _ScannerOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final frameSize = constraints.maxWidth * 0.68;
          final horizontalInset = (constraints.maxWidth - frameSize) / 2;
          final verticalInset = (constraints.maxHeight - frameSize) / 2;
          return Stack(
            children: [
              Positioned.fill(
                bottom: constraints.maxHeight - verticalInset,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.48),
                ),
              ),
              Positioned.fill(
                top: verticalInset + frameSize,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.48),
                ),
              ),
              Positioned.fill(
                top: verticalInset,
                bottom: verticalInset,
                right: constraints.maxWidth - horizontalInset,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.48),
                ),
              ),
              Positioned.fill(
                top: verticalInset,
                bottom: verticalInset,
                left: horizontalInset + frameSize,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.48),
                ),
              ),
              Center(
                child: Container(
                  width: frameSize,
                  height: frameSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: AppTheme.accentAmber,
                      width: 3,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentAmber.withValues(alpha: 0.18),
                        blurRadius: 26,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Stack(
                    children: const [
                      _CornerMarker(alignment: Alignment.topLeft),
                      _CornerMarker(alignment: Alignment.topRight),
                      _CornerMarker(alignment: Alignment.bottomLeft),
                      _CornerMarker(alignment: Alignment.bottomRight),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CornerMarker extends StatelessWidget {
  const _CornerMarker({
    required this.alignment,
  });

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Container(
        width: 34,
        height: 34,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(
            top: alignment.y < 0
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            bottom: alignment.y > 0
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            left: alignment.x < 0
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
            right: alignment.x > 0
                ? const BorderSide(color: Colors.white, width: 4)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
