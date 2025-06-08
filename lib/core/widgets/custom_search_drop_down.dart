import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:dropdown_search/dropdown_search.dart';

class CustomSearchDropDown<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final TextStyle? labelStyle;
  final Widget? prefixOuter;
  final Widget? suffixOuter;
  final double? radius;
  final bool? showLabel;
  final List<T>? items;
  final Future<List<T>> Function(String)? asyncItems;
  final T? selectedValue;
  final String Function(T)? itemAsString;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool readOnly;
  final bool showSearchBox;
  final DropdownSearchPopupItemBuilder<T>? popupItemBuilder;

  const CustomSearchDropDown({
    super.key,
    required this.label,
    this.hint,
    this.labelStyle,
    this.prefixOuter,
    this.suffixOuter,
    this.radius,
    this.showLabel = true,
    this.items,
    this.asyncItems,
    this.selectedValue,
    this.itemAsString,
    this.onChanged,
    this.validator,
    this.readOnly = false,
    this.showSearchBox = true,
    this.popupItemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final outlineColor = Theme.of(context).colorScheme.outline;
    final borderRadius = BorderRadius.circular(radius ?? 28);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showLabel!)
          Text(
            label,
            style: labelStyle ??
                Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black),
          ),
        if (showLabel!) const Gap(AppSpaces.small),
        Row(
          children: [
            if (prefixOuter != null) prefixOuter!,
            Expanded(
              child: DropdownSearch<T>(
                items:  items ?? [] ,
                asyncItems: asyncItems, // ✅ this is correct for v5.0.6
                selectedItem: selectedValue,
                onChanged: onChanged,
                itemAsString: itemAsString,
                validator: validator,
                popupProps: PopupProps.menu(
                  showSearchBox: showSearchBox,
                  itemBuilder: popupItemBuilder,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "ابحث...",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      border: OutlineInputBorder(
                        borderRadius: borderRadius,
                      ),
                    ),
                  ),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: hint,
                    hintStyle: const TextStyle(color: Color(0xFF698596)),
                    border: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: outlineColor),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(color: outlineColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: borderRadius,
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 1,
                      ),
                    ),
                    errorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 1),
                    ),
                  ),
                ),
              ),
            ),
            if (suffixOuter != null) suffixOuter!,
          ],
        ),
      ],
    );
  }
}
