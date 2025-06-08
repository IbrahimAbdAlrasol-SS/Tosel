import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/constants/spaces.dart';

class CustomTextFormField<T> extends StatelessWidget {
  final String label;
  final String? hint;
  final TextStyle? labelStyle;
  final TextInputType? keyboardType;
  final Widget? prefixInner;
  final Widget? prefixOuter;
  final Widget? suffixInner;
  final Widget? suffixOuter;
  final double? radius;
  final TextEditingController? controller;
  final bool obscureText;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool? showLabel;
  final int? maxLines;
  final List<DropdownMenuItem<T>>? dropdownItems;
  final T? selectedValue;
  final Function(T?)? onDropdownChanged;
  final bool readOnly;
  final String? initialValueText;
  final Function(String)? onEditingComplete;
  final FocusNode? focusNode;
  final Function(String)? onFieldSubmitted;

  const CustomTextFormField({
    super.key,
    required this.label,
     this.labelStyle,
    this.hint,
    this.keyboardType,
    this.prefixInner,
    this.prefixOuter,
    this.suffixInner,
    this.suffixOuter,
    this.radius,
    this.controller,
    this.obscureText = false,
    this.onChanged,
    this.validator,
    this.showLabel = true,
    this.maxLines = 1,
    this.dropdownItems,
    this.selectedValue,
    this.onDropdownChanged,
    this.readOnly = false,
    this.initialValueText,
    this.onEditingComplete,
    this.focusNode,
     this.onFieldSubmitted 
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
            style: labelStyle ?? Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Colors.black),
          ),
        if (showLabel!) const Gap(AppSpaces.small),
        Row(
          children: [
            if (prefixOuter != null) prefixOuter!,
            Expanded(
              child: dropdownItems != null
                  ? DropdownButtonFormField<T>(
                      value: selectedValue,
                      items: dropdownItems,
                      onChanged: onDropdownChanged,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: hint ?? '',
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
                        errorBorder: OutlineInputBorder(
                          borderRadius: borderRadius,
                          borderSide: const BorderSide(
                            color: Colors.red,
                            width: 1,
                          ),
                        ),
                        prefixIcon: prefixInner,
                        suffixIcon: suffixInner,
                      ),
                      icon: const SizedBox.shrink(), // Remove dropdown icon
                    )
                  : TextFormField(
                      focusNode: focusNode,
                      initialValue: initialValueText,
                      maxLines: maxLines,
                      onEditingComplete: () => onEditingComplete,
                      readOnly: readOnly,
                      controller: controller,
                      keyboardType: keyboardType,
                      obscureText: obscureText,
                      onFieldSubmitted: onFieldSubmitted,
                      onChanged: (value) {
                        if (onChanged != null) {
                          onChanged!(value);
                        }
                      },
                      validator: validator,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintStyle: const TextStyle(color: Color(0xFF698596)),
                        hintText: hint ?? '',
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
                        errorBorder: OutlineInputBorder(
                          borderRadius: borderRadius,
                          borderSide:
                              const BorderSide(color: Colors.red, width: 1),
                        ),
                        prefixIcon: prefixInner,
                        suffixIcon: suffixInner,
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
