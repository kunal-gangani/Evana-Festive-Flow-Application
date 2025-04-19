import 'package:evana_event_management_app/Views/Authentication/LoginPage/login_page.dart';
import 'package:evana_event_management_app/Views/Authentication/RegisterPage/register_page.dart';
import 'package:evana_event_management_app/Views/EventDetailsPage/event_details_page.dart';
import 'package:evana_event_management_app/Views/HomePage/home_page.dart';
import 'package:evana_event_management_app/Views/SplashScreen/splash_screen.dart';
import 'package:get/get.dart';

class Routes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String detailPage = '/detailPage';

  static List<GetPage> routes = [
    GetPage(
      name: splash,
      page: () => const SplashScreen(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: login,
      page: () => const LoginPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: register,
      page: () => const RegisterPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: home,
      page: () => const HomePage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: detailPage,
      page: () => const EventDetailsPage(),
      transition: Transition.fadeIn,
    ),
  ];
}
