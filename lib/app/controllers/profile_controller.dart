import 'package:get/get.dart';

import '../models/user_model.dart';
import 'auth_controller.dart';

class ProfileController extends GetxController {
  final authController = Get.find<AuthController>();

  UserModel? get user => authController.user.value;
}
