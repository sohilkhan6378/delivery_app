import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/auth_controller.dart';
import '../../theme/app_text_styles.dart';
import '../../utils/validators.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();
  final authController = Get.find<AuthController>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth > 600 ? 420.0 : double.infinity;
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Welcome Back', style: AppTextStyles.headline),
                        const SizedBox(height: 8),
                        Text('Login with phone or email',
                            style: AppTextStyles.body),
                        const SizedBox(height: 24),
                        AppTextField(
                          controller: controller,
                          label: 'Phone or Email',
                          validator: (value) => Validators.requiredField(value),
                        ),
                        const SizedBox(height: 16),
                        Obx(
                          () => AppButton(
                            label: 'Login',
                            isLoading: authController.isLoading.value,
                            onPressed: () {
                              if (formKey.currentState?.validate() ?? false) {
                                authController.login(controller.text);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
