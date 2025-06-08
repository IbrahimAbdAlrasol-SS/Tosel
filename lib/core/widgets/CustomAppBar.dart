import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:Tosell/core/constants/spaces.dart';

class CustomAppBar extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool showBackButton;
  final Function()? onBackButtonPressed;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? buttonWidget;
  final Widget? titleWidget;

  const CustomAppBar({
    super.key,
    this.title,
    this.subtitle,
    this.showBackButton = false,
    this.onBackButtonPressed,
    this.actions,
    this.leading,
    this.buttonWidget,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpaces.allMedium,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (showBackButton)
            GestureDetector(
              onTap: onBackButtonPressed ?? () => Navigator.of(context).pop(),
              child: Container(
                  alignment: Alignment.center,
                  padding: AppSpaces.allSmall,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFEAEEF0), width: 2),
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Icon(
                    CupertinoIcons.back,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18.sp,
                  )),
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                  left: showBackButton ? 10 : 0,
                  top: 5,
                  right: showBackButton ? 10 : 0),
              child: Row(
                children: [
                  if (buttonWidget != null)
                    Padding(
                      padding: const EdgeInsets.only(left: AppSpaces.medium),
                      child: buttonWidget!,
                    ),
                  if (title != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title ?? "",
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        if (subtitle != null)
                          Text(
                            subtitle ?? "",
                            style: Theme.of(context).textTheme.titleMedium!,
                          ),
                      ],
                    ),
                  if (titleWidget != null) titleWidget!,
                  if (leading != null) leading!,
                ],
              ),
            ),
          ),
          if (actions != null)
            Row(
              children: actions!,
            ),
        ],
      ),
    );
  }
}
