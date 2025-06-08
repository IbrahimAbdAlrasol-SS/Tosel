import 'package:Tosell/Features/auth/register/screens/user_info_tab.dart';
import 'package:Tosell/Features/auth/register/widgets/build_background.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import 'package:Tosell/Features/auth/login/providers/auth_provider.dart';
import 'package:Tosell/core/widgets/CustomAppBar.dart';
import 'package:Tosell/core/widgets/FillButton.dart';

class ForgotpasswordAuth extends ConsumerStatefulWidget {
  final String PageTitle;

  const ForgotpasswordAuth({super.key, required this.PageTitle});

  @override
  ConsumerState<ForgotpasswordAuth> createState() => _ForgotpasswordAuthState();
}

class _ForgotpasswordAuthState extends ConsumerState<ForgotpasswordAuth> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final bool isKeyboardVisible = keyboardHeight > 0;
    final loginState = ref.watch(authNotifierProvider);

    return loginState.when(
      data: (data) =>
          _buildUi(screenHeight, keyboardHeight, context, loginState),
      loading: () =>
          _buildUi(screenHeight, keyboardHeight, context, loginState),
      error: (error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, top: 20),
      child: FillButton(
        label: "إرسال رمز التأكيد",
        width: double.infinity,
        height: 50,
        onPressed: () {
          // أضف منطق الإرسال هنا
        },
      ),
    );
  }

  Widget _buildOTPHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: Text(
          "أدخل الرمز",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildOTPtext() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "إعادة ارسال الرمز",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0XFF698596),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              "00:30",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0XFF0C0808),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUi(double screenHeight, double keyboardHeight,
      BuildContext context, AsyncValue<void> loginState) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: buildBackground(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Gap(25),
                      const CustomAppBar(
                        title: "نسيان كلمة السر",
                        showBackButton: true,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: SvgPicture.asset("assets/svg/Logo.svg"),
                      ),
                      const Gap(16),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "أنشاء كلمة سر جديدة",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const Gap(8),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "لا تقلق، فقط قم باتباع بعض الخطوات و سيتم تعيين كلمة سر جديدة و العودة الى حسابك بأمان.",
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          _buildBottomSheet(),
        ],
      ),
    );
  }

  Widget _buildBottomSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.66,
      minChildSize: 0.66,
      maxChildSize: 0.66,
      builder: (context, scrollController) {
        return Container(
          decoration: _bottomSheetDecoration(),
          child: SingleChildScrollView(
            controller: scrollController,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height * 0.66,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildOTPHeader(),
                    const Gap(10),
                    const OTPInput(),
                    _buildOTPtext(),
                    const Gap(370),
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  BoxDecoration _bottomSheetDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
    );
  }
}

class OTPInput extends StatefulWidget {
  const OTPInput({super.key});

  @override
  State<OTPInput> createState() => _OTPInputState();
}

class _OTPInputState extends State<OTPInput> {
  final List<TextEditingController> _controllers =
      List.generate(5, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(5, (index) => FocusNode());

  @override
  void dispose() {
    _cleanupResources();
    super.dispose();
  }

  void _cleanupResources() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
  }

  void _handleTextInput(String value, int index) {
    if (value.length == 1 && index < 4) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) => _buildOTPBox(index)),
      ),
    );
  }

  Widget _buildOTPBox(int index) {
    return SizedBox(
      width: 65,
      height: 65,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        decoration: _inputDecoration(),
        onChanged: (value) => _handleTextInput(value, index),
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      counterText: '',
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32.5),
        borderSide: BorderSide(
          color: Colors.grey.shade400,
          width: 1,
        ),
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
