import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class StatusChip extends StatelessWidget {
  final String label;

  const StatusChip({super.key, required this.label});

  Color _chipColor() {
    final value = label.toLowerCase();
    if (value.contains('pending')) {
      return AppColors.warning;
    }
    if (value.contains('picked')) {
      return AppColors.info;
    }
    if (value.contains('delivered')) {
      return AppColors.success;
    }
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _chipColor().withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(color: _chipColor(), fontWeight: FontWeight.w600),
      ),
    );
  }
}
