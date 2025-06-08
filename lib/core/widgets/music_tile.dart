import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/constants/spaces.dart';

class MusicTile extends StatelessWidget {
  const MusicTile({
    super.key,
    this.name,
  });

  final String? name;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset("assets/svg/music_note.svg", height: 24, width: 24),
        const Gap(AppSpaces.medium),
        Expanded(
          child: Text(
            name ?? "Test music",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onInverseSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  overflow: TextOverflow.ellipsis,
                ),
            maxLines: 1,
          ),
        )
      ],
    );
  }
}
