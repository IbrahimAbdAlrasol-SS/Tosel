
import 'package:flutter/material.dart';

class BackgroundPattern extends StatelessWidget {
  const BackgroundPattern({super.key, this.children});

  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Image.asset(
          "assets/images/shapes.png",
          color: Theme.of(context).colorScheme.primary,
        ),
        if (children != null) ...children!,
      ],
    );
  }
}
