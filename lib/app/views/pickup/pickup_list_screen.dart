import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/orders_controller.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/loading_shimmer.dart';
import '../../widgets/order_card.dart';

class PickupListScreen extends StatelessWidget {
  const PickupListScreen({super.key});

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
                Text('Pickup Pending', style: AppTextStyles.headline),
                const SizedBox(height: 16),
                if (controller.isLoading.value)
                  ...List.generate(4, (_) => const LoadingShimmer())
                else if (controller.hasError.value)
                  const Center(child: Text('Failed to load orders. Pull to retry.'))
                else if (controller.pickupPending.isEmpty)
                  const Center(child: Text('No pickup pending orders'))
                else
                  ...controller.pickupPending
                      .map((order) => OrderCard(
                            order: order,
                            status: order.pickupStatus.isEmpty
                                ? 'Pending'
                                : order.pickupStatus,
                            actionLabel: 'Start Pickup',
                            onTap: () => Get.toNamed(
                              AppRoutes.pickupDetail,
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
