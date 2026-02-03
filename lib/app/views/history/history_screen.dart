import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/orders_controller.dart';
import '../../models/order_model.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/order_card.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final controller = Get.find<OrdersController>();
  final searchController = TextEditingController();
  int filterIndex = 0;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  List<OrderModel> _applyFilters(List<OrderModel> orders) {
    final query = searchController.text.toLowerCase();
    var filtered = orders;
    if (query.isNotEmpty) {
      filtered = filtered
          .where((order) =>
              order.orderId.toLowerCase().contains(query) ||
              order.partyName.toLowerCase().contains(query))
          .toList();
    }
    if (filterIndex == 1) {
      final today = DateTime.now();
      filtered = filtered.where((order) {
        if (order.deliveryTime.isEmpty) return false;
        final date = DateTime.tryParse(order.deliveryTime);
        if (date == null) return false;
        return date.year == today.year &&
            date.month == today.month &&
            date.day == today.day;
      }).toList();
    }
    if (filterIndex == 2) {
      final now = DateTime.now();
      filtered = filtered.where((order) {
        if (order.deliveryTime.isEmpty) return false;
        final date = DateTime.tryParse(order.deliveryTime);
        if (date == null) return false;
        return now.difference(date).inDays <= 7;
      }).toList();
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final delivered = controller.delivered;
        final filtered = _applyFilters(delivered);
        return LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth > 900
                ? (constraints.maxWidth - 900) / 2
                : 16.0;
            return ListView(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 16,
              ),
              children: [
                Text('History', style: AppTextStyles.headline),
                const SizedBox(height: 16),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by Order ID or Party Name',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  children: List.generate(3, (index) {
                    final labels = ['All', 'Today', '7 Days'];
                    return ChoiceChip(
                      label: Text(labels[index]),
                      selected: filterIndex == index,
                      onSelected: (_) => setState(() => filterIndex = index),
                    );
                  }),
                ),
                const SizedBox(height: 16),
                if (filtered.isEmpty)
                  const Center(child: Text('No delivered orders'))
                else
                  ...filtered
                      .map((order) => OrderCard(
                            order: order,
                            status: order.deliveryStatus,
                            actionLabel: 'View',
                            onTap: () {},
                          ))
                      .toList(),
              ],
            );
          },
        );
      },
    );
  }
}
