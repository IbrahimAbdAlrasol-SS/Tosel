import 'package:flutter/material.dart';
import 'package:Tosell/core/constants/spaces.dart';

class CustomSkeleton extends StatelessWidget {
  const CustomSkeleton(
      {super.key, this.height, this.width, this.layer = 1, this.borderRadius});

  final double? height, width;
  final int layer;
  final BorderRadiusGeometry? borderRadius;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: const EdgeInsets.all(AppSpaces.medium / 2),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04 * layer),
        borderRadius: borderRadius ?? AppSpaces.smallRadius,
      ),
    );
  }
}

class CircleSkeleton extends StatelessWidget {
  const CircleSkeleton({super.key, this.size = 24, this.layer = 1});

  final double? size;
  final int layer;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      // padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.04 * layer),
        shape: BoxShape.circle,
      ),
    );
  }
}
