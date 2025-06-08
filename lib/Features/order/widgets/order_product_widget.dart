import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/constants/spaces.dart';

class OrderProductWidget extends ConsumerWidget {
  final bool showController;
  const OrderProductWidget({super.key, this.showController = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(114),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(116),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/interest1.jpeg"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 50,
                  height: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(116),
                  ),
                  child: Icon(CupertinoIcons.play_circle,
                      color: Colors.white, size: 19.sp),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("سماعات لاسلكية بلوتوث",
                    style: TextStyle(
                        fontSize: 12.sp, fontWeight: FontWeight.bold)),
                Text("50,000 د.ع",
                    style: TextStyle(fontSize: 12.sp, height: 1)),
              ],
            ),
          ),
          if (showController) const Gap(AppSpaces.small),
          if (showController)
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.sp),
                    border: Border.all(color: Colors.red, width: 1),
                  ),
                  child: Icon(
                    CupertinoIcons.minus,
                    size: 14.sp,
                  ),
                ),
                const Gap(AppSpaces.medium),
                Text("1", style: TextStyle(fontSize: 14.sp)),
                const Gap(AppSpaces.medium),
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.sp),
                    border: Border.all(),
                  ),
                  child: Icon(
                    CupertinoIcons.plus,
                    size: 14.sp,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
