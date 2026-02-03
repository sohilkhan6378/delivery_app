import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user_model.dart';
import '../utils/api_client.dart';
import '../utils/constants.dart';
import '../utils/logger_helper.dart';
import '../utils/toast_helper.dart';

class AuthController extends GetxController {
  final box = GetStorage();
  final isLoading = false.obs;
  final user = Rxn<UserModel>();

  bool get isLoggedIn => box.read(AppConstants.storageSessionKey) == true;

  @override
  void onInit() {
    super.onInit();
    final stored = box.read(AppConstants.storageUserKey);
    if (stored is Map<String, dynamic>) {
      user.value = UserModel.fromJson(stored);
    }
  }

  Future<void> login(String identifier) async {
    isLoading.value = true;
    try {
      final response = await ApiClient.post('/login', {
        'identifier': identifier.trim(),
      });
      final success = response['success'] == true;
      if (!success) {
        ToastHelper.showError(response['message']?.toString() ?? 'Login failed');
        return;
      }
      final data = response['user'] as Map<String, dynamic>;
      final currentUser = UserModel.fromJson(data);
      if (currentUser.role != AppConstants.roleDeliveryBoy) {
        ToastHelper.showError('Access denied for role: ${currentUser.role}');
        return;
      }
      user.value = currentUser;
      await box.write(AppConstants.storageUserKey, currentUser.toJson());
      await box.write(AppConstants.storageSessionKey, true);
      ToastHelper.showSuccess('Login successful');
      Get.offAllNamed('/home');
    } catch (error, stack) {
      LoggerHelper.logger.e('Login error', error: error, stackTrace: stack);
      ToastHelper.showError('Login failed. Please retry.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await box.erase();
    user.value = null;
    ToastHelper.showInfo('Logged out');
    Get.offAllNamed('/login');
  }
}
