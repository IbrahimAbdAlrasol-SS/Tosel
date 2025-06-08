import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/router/app_router.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:Tosell/core/widgets/OutlineButton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tosell/core/helpers/SharedPreferencesHelper.dart';

class LogoutScreen extends StatefulWidget {
  const LogoutScreen({super.key});

  @override
  State<LogoutScreen> createState() => _LogoutScreenState();
}

class _LogoutScreenState extends State<LogoutScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(AppSpaces.medium),
            Container(
              width: 140,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFFD4D7DD),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: AppSpaces.horizontalMedium,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          "assets/svg/logout.gif",
                          width: 150.w,
                        ),
                        Text(
                          "هل انت متأكد من تسجيل الخروج؟",
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: const Color(0xffE96363),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24),
                        ),
                        Text(
                          'تذكر يمكنك العودة دائما من خلال تسجيل الدخول ذا لا تقلق',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(
                                  color: const Color(0xff698596),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: AppSpaces.allMedium,
              child: SafeArea(
                child: FillButton(
                  color: const Color(0xffE96363),
                  label: "تسجيل الخروج",
                  onPressed: () {
                    SharedPreferencesHelper.removeUser();
                    context.go(AppRoutes.login);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
