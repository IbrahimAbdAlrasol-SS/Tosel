import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:Tosell/core/widgets/OutlineButton.dart';

class OrderCompleted extends ConsumerWidget {
  const OrderCompleted({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
              child: Container(
            padding: AppSpaces.allMedium,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/svg/orderCompleted.gif"),
                const Gap(AppSpaces.large),
                Text(
                  "تم تأكيد طلبك بنجاح.",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                Text(
                  "نعمل على تجهيزه و توصيله باسرع وقت",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "شكرًا لطلبك من أكسير",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(),
                ),
              ],
            ),
          )),
          Container(
            padding: AppSpaces.allMedium,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: FillButton(label: "تتبع الطلب", onPressed: () {}),
                ),
                const Gap(AppSpaces.medium),
                Expanded(
                  child: OutlinedCustomButton(
                      label: "تصفح المنتجات",
                      onPressed: () {
                        context.go("/home");
                      }),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}
