import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BackgroundScreen extends ConsumerWidget {
  final Widget child;
  const BackgroundScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            height: 200,
            right: -250,
            bottom: 50,
            child: Stack(
              children: [
                // Transparent blurred layer
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    width: 500,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.transparent, // Transparent to apply blur
                  ),
                ),
                // Colored Circle
                Container(
                  width: 500,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: -200,
            bottom: 40,
            child: Stack(
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Container(
                    width: 400,
                    height: MediaQuery.of(context).size.height,
                    color: Colors.transparent,
                  ),
                ),
                Container(
                  width: 400,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
