import 'package:flutter/material.dart';

class OutlinedCustomButton extends StatelessWidget {
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
  final Color? borderColor;


  const OutlinedCustomButton({
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
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? 45.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? Theme.of(context).primaryColor,
          side: BorderSide(color: borderColor ?? Theme.of(context).primaryColor),
          backgroundColor: color ?? Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ?  CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                strokeWidth: 2.5,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: fontSize ?? 16.0,
                      fontWeight: fontWeight ?? FontWeight.w500,
                      color: textColor ?? Theme.of(context).primaryColor,
                                  height: 3.1
                    ),
                  ),
                  if (icon != null) const SizedBox(width: 8.0),
                  if (icon != null) icon!,
                ],
              ),
      ),
    );
  }
}
