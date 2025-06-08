import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/constants/spaces.dart';

class DeliveryOption extends StatelessWidget {
  final bool selectedValue;
  final ValueChanged<bool> onChanged;

  const DeliveryOption({super.key, required this.selectedValue, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Normal Delivery
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.outline, width: 0.5),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: [
              Radio<bool>(
                value: false,
                groupValue: selectedValue,
                onChanged: (value) => onChanged(value!),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "اعتيادي (5,000 د.ع)",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(),
                  ),
                ),
              ),
              Text(
                "خلال 1-2 يوم",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              const Gap(AppSpaces.medium)
            ],
          ),
        ),
        const SizedBox(height: 10),

        // Fast Delivery
        Container(
          decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.outline, width: 0.5),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Row(
            children: [
              Radio<bool>(
                value: true,
                groupValue: selectedValue,
                onChanged: (value) => onChanged(value!),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "سريع (10,000 د.ع)",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(),
                  ),
                ),
              ),
              Text(
                "خلال 12 ساعة",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
              const Gap(AppSpaces.medium)
            ],
          ),
        ),
      ],
    );
  }
}
