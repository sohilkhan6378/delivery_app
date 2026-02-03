import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/delivery_controller.dart';
import '../../models/order_model.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';

class DeliveryProofScreen extends StatelessWidget {
  const DeliveryProofScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments as OrderModel;
    final controller = Get.find<DeliveryController>();
    controller.clear();
    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Proof')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #${order.orderId}', style: AppTextStyles.title),
            const SizedBox(height: 8),
            Text(order.partyName, style: AppTextStyles.body),
            const SizedBox(height: 16),
            Text('Delivery Photo', style: AppTextStyles.subtitle),
            const SizedBox(height: 8),
            Obx(() {
              final image = controller.deliveryPhoto.value;
              if (image == null) {
                return const Text('No delivery photo selected');
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(image.path), height: 200, fit: BoxFit.cover),
              );
            }),
            const SizedBox(height: 12),
            AppButton(
              label: 'Upload Delivery Photo',
              onPressed: () => controller.pickDeliveryPhoto(),
            ),
            const SizedBox(height: 16),
            Text('Receiver Photo', style: AppTextStyles.subtitle),
            const SizedBox(height: 8),
            Obx(() {
              final image = controller.receiverPhoto.value;
              if (image == null) {
                return const Text('No receiver photo selected');
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(image.path), height: 200, fit: BoxFit.cover),
              );
            }),
            const SizedBox(height: 12),
            AppButton(
              label: 'Upload Receiver Photo',
              onPressed: () => controller.pickReceiverPhoto(),
            ),
            const SizedBox(height: 16),
            Text('Location', style: AppTextStyles.subtitle),
            const SizedBox(height: 8),
            Obx(() {
              final location = controller.location.value;
              if (location == null) {
                return const Text('No location captured');
              }
              return Text(
                'Lat: ${location.latitude}, Lng: ${location.longitude}',
                style: AppTextStyles.body,
              );
            }),
            const SizedBox(height: 12),
            AppButton(
              label: 'Capture Location',
              onPressed: controller.captureLocation,
            ),
            const SizedBox(height: 24),
            Obx(
              () => AppButton(
                label: 'Complete Delivery',
                isLoading: controller.isSubmitting.value,
                onPressed: () => controller.submitDelivery(order),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
