import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

import '../models/order_model.dart';
import '../utils/api_client.dart';
import '../utils/constants.dart';
import '../utils/logger_helper.dart';
import '../utils/toast_helper.dart';
import 'auth_controller.dart';

class OrdersController extends GetxController {
  final authController = Get.find<AuthController>();
  final orders = <OrderModel>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;

  Future<void> fetchOrders() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final connectivity = await Connectivity().checkConnectivity();
      if (connectivity == ConnectivityResult.none) {
        ToastHelper.showError('No internet connection');
        hasError.value = true;
        return;
      }
      final assignedTo = _resolveAssignedTo();
      final data = await ApiClient.getList('/orders', {'assignedTo': assignedTo});
      orders.assignAll(data.map((item) => OrderModel.fromJson(item)).toList());
    } catch (error, stack) {
      LoggerHelper.logger.e('Fetch orders error', error: error, stackTrace: stack);
      ToastHelper.showError('Failed to load orders');
      hasError.value = true;
    } finally {
      isLoading.value = false;
    }
  }

  List<OrderModel> get pickupPending => orders
      .where((order) => order.pickupStatus.toLowerCase() != 'picked')
      .toList();

  List<OrderModel> get deliveryPending => orders
      .where((order) => order.pickupStatus.toLowerCase() == 'picked')
      .where((order) => order.deliveryStatus.toLowerCase() != 'delivered')
      .toList();

  List<OrderModel> get delivered => orders
      .where((order) => order.deliveryStatus.toLowerCase() == 'delivered')
      .toList();

  String _resolveAssignedTo() {
    final currentUser = authController.user.value;
    if (currentUser == null) return '';
    final field = AppConstants.assignedMatchField.toLowerCase();
    if (field == 'phone') {
      return currentUser.phone;
    }
    return currentUser.name;
  }
}
