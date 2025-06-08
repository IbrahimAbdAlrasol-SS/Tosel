import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:Tosell/core/widgets/OutlineButton.dart';

class CancleOrderSheet extends StatefulWidget {
  const CancleOrderSheet({super.key});

  @override
  State<CancleOrderSheet> createState() => _LoginSheetWidgetState();
}

class _LoginSheetWidgetState extends State<CancleOrderSheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
              "الغاء الطلب",
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ),
          const Gap(AppSpaces.exSmall),
          const Divider(thickness: 0.1),
          const Gap(AppSpaces.large),
          Padding(
            padding: AppSpaces.horizontalMedium,
            child: Column(
              children: [
                Image.asset(
                  "assets/svg/cancle.gif",
                  width: 200.w,
                ),
                const Gap(AppSpaces.medium),
                Text("هل انت متأكد من الغاء طلبك؟",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.red, fontWeight: FontWeight.bold)),
                Text("ان كان لديك أي مشكلة او استفسار يرجى مراسلة الدعم",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleSmall!.copyWith(
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
                    child: OutlinedCustomButton(
                  textColor: Theme.of(context).colorScheme.secondary,
                  borderColor: const Color(0xFFF1F2F4),
                  color: Colors.white,
                  label: "غلق",
                  onPressed: () {
                    context.pop();
                  },
                )),
                const Gap(AppSpaces.medium),
                Expanded(
                    child: FillButton(
                  color: Colors.red,
                  label: "الغاء الطلب",
                  onPressed: () {
                    context.pop();
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
