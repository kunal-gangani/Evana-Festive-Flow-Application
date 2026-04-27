import 'package:evana_event_management_app/Controllers/splash_view_model.dart';
import 'package:evana_event_management_app/Helpers/app_theme.dart';
import 'package:evana_event_management_app/Views/SplashScreen/festive_logo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _hasStarted = false;

  void _startNavigation(SplashViewModel viewModel) {
    if (_hasStarted) {
      return;
    }

    _hasStarted = true;
    viewModel.start(
      delay: const Duration(seconds: 3),
      onNavigate: () {
        if (mounted) {
          Get.offAllNamed('/home');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<SplashViewModel>(
      create: (_) => SplashViewModel(),
      child: Consumer<SplashViewModel>(
        builder: (context, viewModel, _) {
          _startNavigation(viewModel);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            final error = viewModel.error;
            if (error != null && mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Splash error: $error')),
              );
            }
          });

          return Scaffold(
            body: DecoratedBox(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF111633),
                    AppTheme.scaffoldBackground,
                    Color(0xFF05070F),
                  ],
                ),
              ),
              child: SafeArea(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 260,
                          height: 260,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Lottie.asset(
                                'assets/animations/act_vi_launch.json',
                                repeat: true,
                                fit: BoxFit.contain,
                              ),
                              Container(
                                width: 82,
                                height: 82,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.06),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.12),
                                  ),
                                ),
                                child: const Center(
                                  child: FestiveLogo(size: 54),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Evana Festive Flow',
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4,
                                  ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Act VI is live: secure tickets, polished scans, and a launch that feels like a live show.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.white70,
                                height: 1.5,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
