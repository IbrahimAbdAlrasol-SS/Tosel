// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class RoundedButton extends ConsumerWidget {
//   const RoundedButton({
//     super.key,
//     this.size,
//     this.backgroundColor,
//     this.iconColor,
//     this.svgPath,
//     this.icon,
//     this.iconSize,
//     this.hasBadge = false,
//     this.count,
//     this.child,
//     this.onTap,
//   });
//   final double? size;
//   final double? iconSize;
//   final Color? backgroundColor;
//   final Color? iconColor;
//   final String? svgPath;
//   final IconData? icon;
//   final bool hasBadge;
//   final int? count; // <- Here's the new count property
//   final VoidCallback? onTap;
//   final Widget? child;
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return SizedBox.fromSize(
//       size: Size(size ?? 56, size ?? 56),
//       child: ClipOval(
//         child: Material(
//           color: backgroundColor ?? Theme.of(context).colorScheme.primary,
//           child: InkWell(
//             onTap: onTap,
//             child: Center(
//               child: child ??
//                   (svgPath != null
//                       ? count !=
//                               null // <- Use count to conditionally render Badge.count
//                           ? Badge.count(
//                               count: count!,
//                               alignment: Alignment.topLeft,
                                   
//                               backgroundColor: hasBadge
//                                   ? Theme.of(context).colorScheme.error
//                                   : Colors.transparent,
//                               offset: const Offset(7, -7),
//                               child: SvgPicture.asset(
//                                 svgPath!,
//                                 // ignore: deprecated_member_use
//                                 color: iconColor,
//                                 height: iconSize,
//                                 width: iconSize,
//                               ),
//                             )
//                           : Badge(
//                               alignment: Alignment.topRight,
//                               smallSize: 10,
//                               backgroundColor: hasBadge
//                                   ? Theme.of(context).colorScheme.error
//                                   : Colors.transparent,
//                               child: SvgPicture.asset(
//                                 svgPath!,
//                                 // ignore: deprecated_member_use
//                                 color: iconColor,
//                                 height: iconSize,
//                                 width: iconSize,
//                               ),
//                             )
//                       : Badge(
//                           alignment: Alignment.topRight,
//                           smallSize: 10,
//                           backgroundColor: hasBadge
//                               ? Theme.of(context).colorScheme.error
//                               : Colors.transparent,
//                           child: Icon(
//                             icon!,
//                             color: iconColor ?? Theme.of(context).colorScheme.onPrimary,
//                             size: iconSize ?? 24,
//                           ),
//                         )),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
