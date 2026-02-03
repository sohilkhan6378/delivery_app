import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/orders_controller.dart';
import '../widgets/bottom_nav.dart';
import '../pickup/pickup_list_screen.dart';
import '../delivery/delivery_list_screen.dart';
import '../history/history_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ordersController = Get.find<OrdersController>();
  int currentIndex = 0;

  final screens = const [
    PickupListScreen(),
    DeliveryListScreen(),
    HistoryScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    ordersController.fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: SafeArea(child: screens[currentIndex]),
          bottomNavigationBar: BottomNav(
            currentIndex: currentIndex,
            onTap: (index) => setState(() => currentIndex = index),
          ),
        );
      },
    );
  }
}
