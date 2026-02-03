import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/orders_controller.dart';
import '../controllers/pickup_controller.dart';
import '../controllers/delivery_controller.dart';
import '../controllers/profile_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(OrdersController(), permanent: true);
    Get.put(PickupController(), permanent: true);
    Get.put(DeliveryController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
  }
}
