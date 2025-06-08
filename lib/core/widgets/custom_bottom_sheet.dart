import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/constants/spaces.dart';

class CustomBottomSheet extends StatefulWidget {
  final Widget child;
  final String title;
  final String? subTitle;

  const CustomBottomSheet(
      {super.key, required this.child, required this.title, this.subTitle});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.only(top: AppSpaces.medium),
      decoration: const BoxDecoration(
        color: Color(0xFFFBFEFE),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min, // Prevent extra space
        children: [
          Center(
            child: Container(
              width: 150.w,
              height: 2,
              decoration: BoxDecoration(
                color: const Color(0xFFD4D7DD),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          const Gap(AppSpaces.medium),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: "Tajawal",
                    fontSize: 18,
                    color: theme.primary,
                  ),
                ),
                const Gap(AppSpaces.small),
                widget.subTitle == null
                    ? Container()
                    : Text(
                        widget.subTitle!,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontFamily: "Tajawal",
                          fontSize: 16,
                          color: theme.secondary,
                        ),
                      ),
              ],
            ),
          ),
          const Gap(AppSpaces.small),
          Container(
            decoration: BoxDecoration(
              color: theme.surface,
              border: Border.all(color: theme.outline),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}
