import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/order_model.dart';
import '../utils/api_client.dart';
import '../utils/date_utils.dart';
import '../utils/logger_helper.dart';
import '../utils/permissions_helper.dart';
import '../utils/toast_helper.dart';
import 'orders_controller.dart';

class PickupController extends GetxController {
  final ordersController = Get.find<OrdersController>();
  final picker = ImagePicker();
  final isSubmitting = false.obs;
  final selectedImage = Rxn<File>();

  Future<void> pickImage({bool fromCamera = true}) async {
    final cameraGranted = await PermissionsHelper.requestCamera();
    if (!cameraGranted) {
      ToastHelper.showError('Camera permission denied');
      return;
    }
    final source = fromCamera ? ImageSource.camera : ImageSource.gallery;
    final image = await picker.pickImage(source: source, imageQuality: 70);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> submitPickup(OrderModel order) async {
    if (selectedImage.value == null) {
      ToastHelper.showError('Please upload pickup photo');
      return;
    }
    isSubmitting.value = true;
    try {
      final bytes = await selectedImage.value!.readAsBytes();
      final base64Image = base64Encode(bytes);
      final response = await ApiClient.post('/pickupSubmit', {
        'orderId': order.orderId,
        'pickupPhoto': base64Image,
        'pickupTime': AppDateUtils.isoNow(),
        'pickupStatus': 'Picked',
      });
      if (response['success'] == true) {
        ToastHelper.showSuccess('Pickup submitted');
        await ordersController.fetchOrders();
        Get.back();
      } else {
        ToastHelper.showError(response['message']?.toString() ?? 'Submit failed');
      }
    } catch (error, stack) {
      LoggerHelper.logger.e('Pickup submit error', error: error, stackTrace: stack);
      ToastHelper.showError('Pickup submit failed');
    } finally {
      isSubmitting.value = false;
    }
  }

  void clear() {
    selectedImage.value = null;
  }
}
