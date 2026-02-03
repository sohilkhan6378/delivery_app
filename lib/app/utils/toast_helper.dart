import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ToastHelper {
  static void showSuccess(String message) {
    Get.snackbar('Success', message, snackPosition: SnackPosition.BOTTOM);
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
  }

  static void showError(String message) {
    Get.snackbar('Error', message, snackPosition: SnackPosition.BOTTOM);
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
  }

  static void showInfo(String message) {
    Get.snackbar('Info', message, snackPosition: SnackPosition.BOTTOM);
    Fluttertoast.showToast(msg: message, toastLength: Toast.LENGTH_SHORT);
  }
}
