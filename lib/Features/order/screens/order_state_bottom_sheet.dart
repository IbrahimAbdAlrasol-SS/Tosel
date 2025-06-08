import 'package:Tosell/Features/orders/models/order_enum.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:another_stepper/dto/stepper_data.dart';
import 'package:another_stepper/widgets/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class OrderStateBottomSheet extends StatefulWidget {
  final int state;
  const OrderStateBottomSheet({
    super.key,
    required this.state,
  });

  @override
  State<OrderStateBottomSheet> createState() => _OrderStateBottomSheetState();
}

class _OrderStateBottomSheetState extends State<OrderStateBottomSheet> {
  @override
  Widget build(BuildContext context) {
    List<StepperData> stepperData = List.generate(orderStatus.length, (index) {
      final item = orderStatus[index];
      final isActive = index <= widget.state;

      final iconColor = isActive
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.secondary;
      final titleColor = isActive
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.secondary;

      final iconWidget = SvgPicture.asset(
        item.icon!,
        width: 20.sp,
        color: iconColor,
      );

      return StepperData(
        title: StepperText(
          item.name!,
          textStyle: TextStyle(
            fontWeight: FontWeight.bold,
            height: 1,
            color: titleColor,
          ),
        ),
        subtitle: StepperText(
          item.description!,
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontSize: 12.sp,
          ),
        ),
        iconWidget: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(30)),
            border: isActive
                ? Border.all(color: Theme.of(context).colorScheme.primary)
                : Border.all(color: Theme.of(context).colorScheme.secondary),
          ),
          child: iconWidget,
        ),
      );
    });

    return Column(
      children: [
        const Gap(AppSpaces.medium),
        Container(
          height: 3,
          width: 70,
          decoration: BoxDecoration(
            color: context.colorScheme.secondary,
            borderRadius: BorderRadius.circular(70),
          ),
        ),
        const Gap(AppSpaces.medium),
        Flexible(
          // <-- Flexible directly inside Column
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AnotherStepper(
                stepperList: stepperData,
                verticalGap: 10,
                activeIndex: widget.state,
                activeBarColor: Theme.of(context).colorScheme.primary,
                inActiveBarColor: Theme.of(context).colorScheme.secondary,
                stepperDirection: Axis.vertical,
                iconWidth: 40,
                iconHeight: 40,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
