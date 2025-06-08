import 'package:flutter/widgets.dart';
import 'package:Tosell/core/constants/spaces.dart';

class SliverPaddingToBoxAdapter extends StatelessWidget {
  const SliverPaddingToBoxAdapter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpaces.medium),
      sliver: SliverToBoxAdapter(
        child: child,
      ),
    );
  }
}
