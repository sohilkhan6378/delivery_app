import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../models/order_model.dart';
import '../utils/api_client.dart';
import '../utils/date_utils.dart';
import '../utils/logger_helper.dart';
import '../utils/permissions_helper.dart';
import '../utils/toast_helper.dart';
import 'orders_controller.dart';

class DeliveryController extends GetxController {
  final ordersController = Get.find<OrdersController>();
  final picker = ImagePicker();
  final isSubmitting = false.obs;
  final deliveryPhoto = Rxn<File>();
  final receiverPhoto = Rxn<File>();
  final location = Rxn<Position>();

  Future<void> pickDeliveryPhoto({bool fromCamera = true}) async {
    final cameraGranted = await PermissionsHelper.requestCamera();
    if (!cameraGranted) {
      ToastHelper.showError('Camera permission denied');
      return;
    }
    final source = fromCamera ? ImageSource.camera : ImageSource.gallery;
    final image = await picker.pickImage(source: source, imageQuality: 70);
    if (image != null) {
      deliveryPhoto.value = File(image.path);
    }
  }

  Future<void> pickReceiverPhoto({bool fromCamera = true}) async {
    final cameraGranted = await PermissionsHelper.requestCamera();
    if (!cameraGranted) {
      ToastHelper.showError('Camera permission denied');
      return;
    }
    final source = fromCamera ? ImageSource.camera : ImageSource.gallery;
    final image = await picker.pickImage(source: source, imageQuality: 70);
    if (image != null) {
      receiverPhoto.value = File(image.path);
    }
  }

  Future<void> captureLocation() async {
    final locationGranted = await PermissionsHelper.requestLocation();
    if (!locationGranted) {
      ToastHelper.showError('Location permission denied');
      return;
    }
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    location.value = position;
  }

  Future<void> submitDelivery(OrderModel order) async {
    if (deliveryPhoto.value == null || receiverPhoto.value == null) {
      ToastHelper.showError('Please upload delivery and receiver photo');
      return;
    }
    if (location.value == null) {
      ToastHelper.showError('Please capture location');
      return;
    }
    isSubmitting.value = true;
    try {
      final deliveryBytes = await deliveryPhoto.value!.readAsBytes();
      final receiverBytes = await receiverPhoto.value!.readAsBytes();
      final response = await ApiClient.post('/deliverySubmit', {
        'orderId': order.orderId,
        'deliveryPhoto': base64Encode(deliveryBytes),
        'receiverPhoto': base64Encode(receiverBytes),
        'deliveryLocation':
            '${location.value!.latitude},${location.value!.longitude}',
        'deliveryTime': AppDateUtils.isoNow(),
        'deliveryStatus': 'Delivered',
      });
      if (response['success'] == true) {
        ToastHelper.showSuccess('Delivery completed');
        await ordersController.fetchOrders();
        Get.back();
      } else {
        ToastHelper.showError(response['message']?.toString() ?? 'Submit failed');
      }
    } catch (error, stack) {
      LoggerHelper.logger.e('Delivery submit error', error: error, stackTrace: stack);
      ToastHelper.showError('Delivery submit failed');
    } finally {
      isSubmitting.value = false;
    }
  }

  void clear() {
    deliveryPhoto.value = null;
    receiverPhoto.value = null;
    location.value = null;
  }
}
