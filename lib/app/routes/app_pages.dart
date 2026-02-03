import 'package:get/get.dart';

import '../views/splash/splash_screen.dart';
import '../views/auth/login_screen.dart';
import '../views/home/home_screen.dart';
import '../views/pickup/pickup_detail_screen.dart';
import '../views/delivery/delivery_proof_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.pickupDetail,
      page: () => const PickupDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.deliveryProof,
      page: () => const DeliveryProofScreen(),
    ),
  ];
}
