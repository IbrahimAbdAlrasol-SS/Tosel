// import 'dart:developer';
// import 'dart:io';

// import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter/ffmpeg_kit_config.dart';
// import 'package:ffmpeg_kit_flutter/ffmpeg_session.dart';
// import 'package:ffmpeg_kit_flutter/return_code.dart';
// import 'package:ffmpeg_kit_flutter/statistics.dart';
// import 'package:flutter/material.dart';

// class ExportService {
//   /// Disposes any ongoing FFmpeg sessions.
//   static Future<void> dispose() async {
//     final executions = await FFmpegKit.listSessions();
//     if (executions.isNotEmpty) await FFmpegKit.cancel();
//   }

//   /// Runs an FFmpeg command asynchronously and handles callbacks for completion, progress, and errors.
//   static Future<FFmpegSession> runFFmpegCommand(
//     String command, {
//     required String outputPath,
//     required void Function(File file) onCompleted,
//     void Function(Object, StackTrace)? onError,
//     void Function(Statistics)? onProgress,
//   }) async {
//     log('FFmpeg start process with command = $command');
//     final ffSession = await FFmpegKit.executeAsync(
//       command,
//       (session) async {
//         final state =
//             FFmpegKitConfig.sessionStateToString(await session.getState());
//         final code = await session.getReturnCode();
//         final output = await session.getOutput(); // Capture the FFmpeg output

//         debugPrint("FFmpeg Output: $output"); // Print the FFmpeg output

//         if (ReturnCode.isSuccess(code)) {
//           onCompleted(File(outputPath));
//         } else {
//           if (onError != null) {
//             onError(
//               Exception(
//                   'FFmpeg process exited with state $state and return code $code.\n${output ?? ''}'),
//               StackTrace.current,
//             );
//           }
//           return;
//         }
//       },
//       null,
//       onProgress,
//     );
//     return ffSession;
//   }

//   /// Merges an audio file with a video file, replacing the video's original audio.
//   Future<FFmpegSession> mergeAudioAndVideo(
//       String videoFilePath, String audioFilePath, String outputFilePath) async {
//     // FFmpeg command to remove original audio from video, add new audio, and trim audio to fit video length
//     String ffmpegCommand =
//         '-y -i "$videoFilePath" -i "$audioFilePath" -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest -async 1 "$outputFilePath"';

//     // Execute the FFmpeg command
//     final state = await runFFmpegCommand(
//       ffmpegCommand,
//       outputPath: outputFilePath,
//       onCompleted: (file) {
//         debugPrint('FFmpeg process completed successfully: ${file.path}');
//       },
//       onProgress: (statistics) {
//         debugPrint('FFmpeg process progress: ${statistics.getTime()} ms');
//       },
//       onError: (error, stackTrace) {
//         debugPrint('FFmpeg process error: $error');
//       },
//     );

//     return state;
//   }

//   /// Removes audio from a video file.
//   Future<FFmpegSession> removeAudioFromVideo(
//       String videoFilePath, String outputFilePath) async {
//     // FFmpeg command to remove audio from video
//     String ffmpegCommand = '-y -i "$videoFilePath" -c copy -an "$outputFilePath"';

//     // Execute the FFmpeg command
//     final state = await runFFmpegCommand(
//       ffmpegCommand,
//       outputPath: outputFilePath,
//       onCompleted: (file) {
//         debugPrint('FFmpeg process completed successfully: ${file.path}');
//       },
//       onProgress: (statistics) {
//         debugPrint('FFmpeg process progress: ${statistics.getTime()} ms');
//       },
//       onError: (error, stackTrace) {
//         debugPrint('FFmpeg process error: $error');
//       },
//     );

//     return state;
//   }
// }
