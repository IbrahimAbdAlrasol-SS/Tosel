import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:Tosell/core/constants/spaces.dart';

class RoundedDropdownButton<T> extends StatelessWidget {
  final String hintText;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const RoundedDropdownButton({
    super.key,
    required this.hintText,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(200.0), // Adjust the radius as needed
        border: Border.all(
          color: Colors.grey, // Customize border color
          width: 1.0, // Customize border width
        ),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpaces.small,
          vertical: AppSpaces.exSmall), // Add padding
      child: DropdownButton<T>(
        hint: Padding(
            padding: const EdgeInsets.only(top: 4, right: 4),
            child: Text(
              hintText,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .copyWith(color: Theme.of(context).colorScheme.secondary),
            )),
        value: value,
        items: items,
        onChanged: onChanged,
        isDense: true,
        isExpanded: true,
        underline: Container(),
        style: const TextStyle(
          color: Colors.black,
        ),
        icon: SvgPicture.asset(
          "assets/svg/down.svg",
          color: Theme.of(context).primaryColor,
        ), // Customize icon
        iconSize: 20.0,
        dropdownColor: Colors.white, // Customize dropdown background color
      ),
    );
  }
}
