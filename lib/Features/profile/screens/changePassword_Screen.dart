import 'package:Tosell/Features/profile/providers/profile_provider.dart';
import 'package:Tosell/core/router/app_router.dart';
import 'package:Tosell/core/utils/GlobalToast.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:Tosell/core/widgets/CustomAppBar.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isCurrentPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          const SizedBox(height: 35),
          const CustomAppBar(title: "تغيير كلمة السر", showBackButton: true),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    buildInputField(
                      label: "كلمة السر الحالية",
                      controller: currentPasswordController,
                      visible: isCurrentPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          isCurrentPasswordVisible = !isCurrentPasswordVisible;
                        });
                      },
                      validator: (value) => value == null || value.isEmpty
                          ? 'يرجى إدخال كلمة السر الحالية'
                          : null,
                    ),
                    buildInputField(
                      label: "كلمة السر الجديدة",
                      controller: newPasswordController,
                      visible: isNewPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          isNewPasswordVisible = !isNewPasswordVisible;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'يرجى إدخال كلمة السر الجديدة';
                        if (value.length < 6)
                          return 'كلمة السر يجب أن تكون على الأقل 6 أحرف';
                        return null;
                      },
                    ),
                    buildInputField(
                      label: "تأكيد كلمة السر الجديدة",
                      controller: confirmPasswordController,
                      visible: isConfirmPasswordVisible,
                      toggleVisibility: () {
                        setState(() {
                          isConfirmPasswordVisible = !isConfirmPasswordVisible;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'يرجى تأكيد كلمة السر الجديدة';
                        if (value != newPasswordController.text)
                          return 'كلمات السر غير متطابقة';
                        return null;
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.white,
            ),
            width: double.infinity,
            padding:
                const EdgeInsets.only(bottom: 30, left: 16, right: 16, top: 16),
            child: FillButton(
              label: 'حفظ',
              isLoading: isLoading,
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  _setLoadingState(true);
                  var result = await ref
                      .read(profileNotifierProvider.notifier)
                      .changePassword(
                        oldPassword: currentPasswordController.text,
                        newPassword: newPasswordController.text,
                      );

                  if (result.$2 != null) {
                    GlobalToast.show(
                      message: result.$2!,
                      backgroundColor: Theme.of(context).colorScheme.error,
                      textColor: Colors.white,
                    );
                    _setLoadingState(false);
                  } else {
                    GlobalToast.show(
                      message: "تم تحديث المعلومات بنجاح",
                      backgroundColor: context.colorScheme.primary,
                      textColor: Colors.white,
                    );
                    _setLoadingState(false);

                    if (context.mounted) {
                      context.pushReplacement(AppRoutes.home);
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _setLoadingState(bool state) {
    setState(() {
      isLoading = state;
    });
  }

  Widget buildInputField({
    required String label,
    required TextEditingController controller,
    required bool visible,
    required VoidCallback toggleVisibility,
    required String? Function(String?) validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF121416),
              fontWeight: FontWeight.bold,
              fontFamily: "Tajawal",
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: const Color(0xFFF1F2F4), width: 1),
            ),
            child: TextFormField(
              controller: controller,
              validator: validator,
              obscureText: !visible,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    visible ? Icons.visibility : Icons.visibility_off,
                    color: context.colorScheme.primary,
                  ),
                  onPressed: toggleVisibility,
                ),
                hintText: '',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF70798F),
                  fontFamily: "Tajawal",
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
                fontFamily: "Tajawal",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
