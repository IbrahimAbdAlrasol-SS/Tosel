import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DatePickerTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final TextStyle? hintStyle;
  final BorderRadius? borderRadius;
  final Color outlineColor;
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validator;
  final bool readOnly;

  const DatePickerTextField({
    required this.controller,
    required this.hint,
    this.hintStyle,
    this.borderRadius,
    this.outlineColor = Colors.grey,
    this.onChanged,
    this.validator,
    this.readOnly = false,
    super.key,
  });

  @override
  _DatePickerTextFieldState createState() => _DatePickerTextFieldState();
}

class _DatePickerTextFieldState extends State<DatePickerTextField> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      widget.controller.text = selectedDate
          .toLocal()
          .toString()
          .split(' ')[0]; // Format the date to 'yyyy-MM-dd'
      if (widget.onChanged != null) {
        widget.onChanged!(widget.controller.text);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context), // Trigger date picker when tapped
      child: AbsorbPointer(
        // Prevent interaction with TextFormField itself, only GestureDetector handles it
        child: TextFormField(
          readOnly: widget.readOnly,
          controller: widget.controller,
          keyboardType: TextInputType.datetime,
          onChanged: widget.onChanged,
          validator: widget.validator,
          decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            hintStyle:
                widget.hintStyle ?? const TextStyle(color: Color(0xFF698596)),
            hintText: widget.hint,
            border: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(28),
              borderSide: BorderSide(color: widget.outlineColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(28),
              borderSide: BorderSide(color: widget.outlineColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(28),
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
                width: 1,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            suffixIcon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SvgPicture.asset(
                'assets/svg/CalendarBlank.svg',
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
