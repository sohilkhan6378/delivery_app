import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/app_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();
    final authController = Get.find<AuthController>();
    final user = profileController.user;
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth > 900
            ? (constraints.maxWidth - 900) / 2
            : 16.0;
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Profile', style: AppTextStyles.headline),
              const SizedBox(height: 24),
              if (user == null)
                const Text('No user data found')
              else
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name, style: AppTextStyles.title),
                        const SizedBox(height: 8),
                        Text('Email: ${user.email}'),
                        Text('Phone: ${user.phone}'),
                        Text('Role: ${user.role}'),
                      ],
                    ),
                  ),
                ),
              const Spacer(),
              AppButton(label: 'Logout', onPressed: authController.logout),
            ],
          ),
        );
      },
    );
  }
}
