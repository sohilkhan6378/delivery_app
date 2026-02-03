import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/pickup_controller.dart';
import '../../models/order_model.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';

class PickupDetailScreen extends StatelessWidget {
  const PickupDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final order = Get.arguments as OrderModel;
    final controller = Get.find<PickupController>();
    controller.clear();
    return Scaffold(
      appBar: AppBar(title: const Text('Pickup Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #${order.orderId}', style: AppTextStyles.title),
            const SizedBox(height: 8),
            Text(order.partyName, style: AppTextStyles.body),
            const SizedBox(height: 24),
            Obx(() {
              final image = controller.selectedImage.value;
              if (image == null) {
                return const Text('No pickup photo selected');
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(image.path), height: 220, fit: BoxFit.cover),
              );
            }),
            const SizedBox(height: 16),
            AppButton(
              label: 'Upload Pickup Photo',
              onPressed: () => controller.pickImage(fromCamera: true),
            ),
            const SizedBox(height: 12),
            Obx(
              () => AppButton(
                label: 'Submit Pickup',
                isLoading: controller.isSubmitting.value,
                onPressed: () => controller.submitPickup(order),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
