import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/widgets/TrianglePainter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

Widget buildCart(BuildContext context,
    {String? title,
    String? subtitle,
    String? iconPath,
    Color? iconColor,
    bool isOrder = false,
    String? state,
    bool expanded = true}) {
  return expanded
      ? Expanded(
          child: Container(
            height: 65,
            padding: const EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(1000),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 6.0, left: 6, bottom: 2),
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.outline),
                    ),
                    child: SvgPicture.asset(
                      iconPath ?? "",
                      color: iconColor,
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                    Text(
                      subtitle ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      : Container(
          height: 65,
          padding: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(1000),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(right: 6.0, left: 6, bottom: 2),
                    child: Container(
                      width: 40,
                      height: 40,
                      padding: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Theme.of(context).colorScheme.surface,
                        border: Border.all(
                            color: Theme.of(context).colorScheme.outline),
                      ),
                      child: SvgPicture.asset(
                        iconPath ?? "",
                        color: iconColor,
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? "",
                        style: isOrder
                            ? TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: Theme.of(context).colorScheme.onSurface,
                              )
                            : TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                      ),
                      Row(
                        children: [
                          if (isOrder)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 4, bottom: 5),
                              child: SvgPicture.asset(
                                "assets/svg/MapPinArea.svg",
                                height: 16,
                                width: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          Text(
                            subtitle ?? "",
                            style: isOrder
                                ? TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color:
                                        Theme.of(context).colorScheme.secondary)
                                : const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 24,
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  if (state != null)
                    Container(
                      width: 100,
                      height: 26,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8FCF5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          state,
                        ),
                      ),
                    ),
                  const Gap(AppSpaces.medium),
                  if (isOrder)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      // child: SvgPicture.asset(
                      //   "assets/svg/CaretDown.svg",
                      //   color: Theme.of(context).colorScheme.primary,
                      // ),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: CustomPaint(
                          size: const Size(16, 16),
                          painter: TrianglePainter(),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        );
}