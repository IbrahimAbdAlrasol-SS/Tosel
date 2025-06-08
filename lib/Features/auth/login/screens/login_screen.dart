import 'package:gap/gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:Tosell/core/router/app_router.dart';
import 'package:Tosell/core/utils/GlobalToast.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:Tosell/core/widgets/CustomAppBar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/core/widgets/CustomTextFormField.dart';
import 'package:Tosell/core/helpers/SharedPreferencesHelper.dart';
import 'package:Tosell/Features/auth/login/providers/auth_provider.dart';
import 'package:Tosell/Features/auth/register/widgets/build_background.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _phoneOrUsernameController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isTextFieldFocused = false;

  @override
  void initState() {
    super.initState();

    _phoneFocusNode.addListener(_handleFocusChange);
    _passwordFocusNode.addListener(_handleFocusChange);
  }

  void _handleFocusChange() {
    final isFocused = _phoneFocusNode.hasFocus || _passwordFocusNode.hasFocus;
    if (isFocused != _isTextFieldFocused) {
      setState(() {
        _isTextFieldFocused = isFocused;
      });
    }
  }

  @override
  void dispose() {
    _phoneFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(authNotifierProvider);

    return loginState.when(
      data: (_) => _buildUi(context, loginState),
      loading: () => _buildUi(context, loginState),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
    );
  }

  @override
  Widget _buildUi(BuildContext context, AsyncValue<void> loginState) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // Background
            Column(
              children: [
                Expanded(
                  child: buildBackground(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Gap(25),
                        CustomAppBar(
                          // title: "إنشاء حساب",
                          titleWidget: Text('إنشاء حساب', style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 16
                          ),) ,
                          showBackButton: true,
                          onBackButtonPressed: () =>context.push(AppRoutes.registerScreen),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: SvgPicture.asset("assets/svg/Logo.svg"),
                        ),
                        const Gap(16),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "مرحبًا بعودتك",
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
                            "قم بادخال رقم هاتفك و رمزك السري و اكمل رحلتك في إستعمال منصة توصيل.",
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
            // Login Form Sheet
            DraggableScrollableSheet(
              initialChildSize: 0.66,
              minChildSize: 0.66,
              maxChildSize: 0.66,
              builder: (context, scrollController) {
                return Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(AppSpaces.exLarge),
                        topLeft: Radius.circular(AppSpaces.exLarge),
                      ),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      // padding: EdgeInsets.only(
                      //   bottom: MediaQuery.of(context).viewInsets.bottom,
                      // ),
                      child: Padding(
                        padding: AppSpaces.horizontalMedium,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Gap(AppSpaces.medium),
                            if (!_isTextFieldFocused)
                              Center(
                                  child:
                                      Image.asset("assets/images/Shape.png")),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomTextFormField(
                                    controller: _phoneOrUsernameController,
                                    label: "رقم الهاتف",
                                    focusNode: _phoneFocusNode,
                                    validator: (value) => value!.isEmpty
                                        ? "الرجاء إدخال اسم المستخدم أو الهاتف"
                                        : null,
                                    prefixInner: Icon(
                                      CupertinoIcons.person,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  const Gap(AppSpaces.medium),
                                  CustomTextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    focusNode: _passwordFocusNode,
                                    label: "كلمة المرور",
                                    validator: (value) => value!.isEmpty
                                        ? "الرجاء إدخال كلمة المرور"
                                        : null,
                                    prefixInner: Icon(
                                      CupertinoIcons.lock,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Gap(AppSpaces.medium),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  "ليس لديك حساب؟",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                const Gap(AppSpaces.exSmall),
                                GestureDetector(
                                  onTap: () {
                                    context.go(AppRoutes.registerScreen);
                                  },
                                  child: Text(
                                    "إنشاء حساب",
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const Gap(AppSpaces.medium),
                            FillButton(
                              label: "تسجيل الدخول",
                              isLoading: loginState.isLoading,
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final phoneNumber =
                                      _phoneOrUsernameController.text;
                                  final password = _passwordController.text;

                                  final result = await ref
                                      .read(authNotifierProvider.notifier)
                                      .login(
                                          passWord: password,
                                          phonNumber: phoneNumber);

                                  if (result.$1 == null) {
                                    GlobalToast.show(
                                      message: result.$2!,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.error,
                                      textColor: Colors.white,
                                    );
                                  } else {
                                    GlobalToast.show(
                                      message: "تم تسجيل الدخول بنجاح",
                                      backgroundColor:
                                          context.colorScheme.primary,
                                      textColor: Colors.white,
                                    );
                                    if (loginState is AsyncData) {
                                      SharedPreferencesHelper.saveUser(
                                          result.$1!);
                                      context.go(AppRoutes.home);
                                    }
                                  }
                                }
                              },
                            ),
                            // const Gap(20),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
