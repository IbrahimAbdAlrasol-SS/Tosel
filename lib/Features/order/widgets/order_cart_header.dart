import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/constants/spaces.dart';

class OrderCartHeader extends ConsumerWidget {
  final String title;
  final Widget? icon;
  final List<Widget>? actions;
  final List<Widget>? headerActions;
  const OrderCartHeader(
      {super.key,
      required this.title,
      this.icon,
      this.actions,
      this.headerActions});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Theme.of(context).colorScheme.outline),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              color: Color(0xFFEAEEF0),
            ),
            padding: AppSpaces.allSmall,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon ?? Container(),
                const Gap(AppSpaces.small),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(title,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          )),
                ),
                const Spacer(),
                Row(
                  children: headerActions ?? [],
                ),
              ],
            ),
          ),
          Padding(
            padding: AppSpaces.allMedium,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: actions ?? [],
            ),
          )
        ],
      ),
    );
  }
}
