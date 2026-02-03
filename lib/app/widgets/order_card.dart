import 'package:flutter/material.dart';

import '../models/order_model.dart';
import '../theme/app_text_styles.dart';
import 'status_chip.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final String status;
  final String actionLabel;
  final VoidCallback onTap;

  const OrderCard({
    super.key,
    required this.order,
    required this.status,
    required this.actionLabel,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order #${order.orderId}', style: AppTextStyles.title),
            const SizedBox(height: 8),
            Text(order.partyName, style: AppTextStyles.body),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatusChip(label: status),
                TextButton(onPressed: onTap, child: Text(actionLabel)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
