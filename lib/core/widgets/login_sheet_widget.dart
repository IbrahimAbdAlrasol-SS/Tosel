import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/constants/spaces.dart';

import 'FillButton.dart';
import 'OutlineButton.dart';

class LoginSheetWidget extends StatefulWidget {
  const LoginSheetWidget({super.key});

  @override
  State<LoginSheetWidget> createState() => _LoginSheetWidgetState();
}

class _LoginSheetWidgetState extends State<LoginSheetWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(AppSpaces.exLarge),
            topLeft: Radius.circular(AppSpaces.exLarge)),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Gap(AppSpaces.medium),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 150.w,
                height: 2,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4D7DD),
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ],
          ),
          const Gap(AppSpaces.medium),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: AppSpaces.horizontalMedium,
            child: Text(
              "اكمل عملية الشراء",
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          const Gap(AppSpaces.exSmall),
          const Divider(thickness: 0.1),
          Padding(
            padding: AppSpaces.horizontalMedium,
            child: Column(
              children: [
                Image.asset(
                  "assets/svg/pur.gif",
                  width: 230.w,
                ),
                const Gap(AppSpaces.medium),
                Text(
                    "لإكمال عملية الشراء، يرجى تسجيل الدخول إلى حسابك أو إنشاء حساب جديد.",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold)),
                const Gap(AppSpaces.small),
                Text(
                    "لن يستغرق الأمر سوى بضع ثوانٍ لإنشاء حساب أو تسجيل الدخول!",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Theme.of(context).colorScheme.secondary)),
              ],
            ),
          ),
          const Spacer(),
          Container(
            padding: AppSpaces.allMedium,
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            child: Row(
              children: [
                Expanded(
                    child: FillButton(
                  label: "انشاء حساب",
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return GestureDetector(
                            child: Container(
                                // child: RegisterScreen()
                                ),
                          );
                        });
                  },
                )),
                const Gap(AppSpaces.medium),
                Expanded(
                    child: OutlinedCustomButton(
                  label: "تسجيل الدخول",
                  onPressed: () {
                    Navigator.pop(context);
                    showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) {
                          return GestureDetector(
                            child: Container(
                                // child: LoginPage()
                                ),
                          );
                        });
                  },
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
