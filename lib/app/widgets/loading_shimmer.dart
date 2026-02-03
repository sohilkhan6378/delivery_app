import 'package:flutter/material.dart';

class LoadingShimmer extends StatelessWidget {
  final double height;

  const LoadingShimmer({super.key, this.height = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
