// import 'package:Toseel/core/constants/global.dart';
// import 'package:Toseel/core/constants/spaces.dart';
// import 'package:Toseel/core/widgets/flex_padded.dart';
// import 'package:Toseel/core/widgets/network_image.dart';
// import 'package:Toseel/features/home/data/models/video_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';

// class PostCard extends StatelessWidget {
//   VideoModel videoModel;
//   PostCard({
//     super.key,
//     required this.videoModel,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 220,
//       width: 125,
//       child: Stack(
//         alignment: Alignment.center,
//         children: [
//           NetworkImageWithLoader(
//             Global.api + videoModel.thumbnail,
//             fit: BoxFit.cover,
//             radius: AppSpaces.none,
//           ),
//           Container(
//             decoration: BoxDecoration(
//               color: Color(0xff031011).withOpacity(0.50),
//             ),
//           ),
//           SvgPicture.asset(
//             "assets/svg/eye.svg",
//             color: Colors.white,
//           ),
//           Positioned(
//             bottom: AppSpaces.small,
//             right: AppSpaces.medium,
//             left: AppSpaces.medium,
//             child: RowPadded(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SvgPicture.asset(
//                     "assets/svg/Heart.svg",
//                     color: Colors.white,
//                     height: 16,
//                     width: 16,
//                   ),
//                   Text(videoModel.likes.toString(),
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                       )),
//                 ]),
//           ),
//         ],
//       ),
//     );
//   }
// }
