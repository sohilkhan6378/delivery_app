import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/orders_controller.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/order_card.dart';

class DeliveryListScreen extends StatelessWidget {
  const DeliveryListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrdersController>();
    return Obx(
      () => LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth > 900
              ? (constraints.maxWidth - 900) / 2
              : 16.0;
          return RefreshIndicator(
            onRefresh: controller.fetchOrders,
            child: ListView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              children: [
                Text('Delivery Pending', style: AppTextStyles.headline),
                const SizedBox(height: 16),
                if (controller.isLoading.value)
                  ...List.generate(4, (_) => const LoadingShimmer())
                else if (controller.hasError.value)
                  const Center(child: Text('Failed to load orders. Pull to retry.'))
                else if (controller.deliveryPending.isEmpty)
                  const Center(child: Text('No delivery pending orders'))
                else
                  ...controller.deliveryPending
                      .map((order) => OrderCard(
                            order: order,
                            status: order.deliveryStatus.isEmpty
                                ? 'Pending'
                                : order.deliveryStatus,
                            actionLabel: 'Complete Delivery',
                            onTap: () => Get.toNamed(
                              AppRoutes.deliveryProof,
                              arguments: order,
                            ),
                          ))
                      .toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
