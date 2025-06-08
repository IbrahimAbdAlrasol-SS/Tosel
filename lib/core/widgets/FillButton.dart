import 'package:flutter/material.dart';

class FillButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color? color;
  final double? fontSize;
  final double? height;
  final double? width;
  final double borderRadius;
  final Color? textColor;
  final FontWeight? fontWeight;
  final Widget? icon;
  final bool? reverse;

  const FillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.color,
    this.fontSize,
    this.height,
    this.width,
    this.borderRadius = 64.0,
    this.textColor,
    this.fontWeight,
    this.icon,
    this.reverse,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 45.0,
      child: FilledButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Theme.of(context).primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                ],
              )
            : Row(
                textDirection:
                    reverse == true ? TextDirection.ltr : TextDirection.rtl,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                        fontSize: fontSize ?? 16.0,
                        fontWeight: fontWeight ?? FontWeight.w500,
                        color: textColor ?? Colors.white,
                        height: 3.1),
                  ),
                  if (icon != null) const SizedBox(width: 8.0),
                  if (icon != null) icon!,
                ],
              ),
      ),
    );
  }
}
