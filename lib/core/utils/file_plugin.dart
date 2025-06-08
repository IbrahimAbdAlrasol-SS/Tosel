// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';

// /// Util class to prepare audio files for custom audio browser
// class FilePlugin {
//   Future<Uri> createAssetFileUri(String prefix, String fileName) async {
//     final byteData = await rootBundle.load('$prefix$fileName');
//     final file = File('${await getTemporaryDirectoryPath()}/$fileName');
//     await file.create(recursive: true);
//     await file.writeAsBytes(byteData.buffer.asUint8List());
//     return file.uri;
//   }

//   Future<String> getTemporaryDirectoryPath() async {
//     if (Platform.isAndroid) {
//       final result = await getExternalStorageDirectories();
//       if (result == null || result.isEmpty) {
//         throw Exception("Cannot resolve temporary directory!");
//       } else {
//         return result.first.path;
//       }
//     } else {
//       final dir = await getTemporaryDirectory();
//       return dir.path;
//     }
//   }

//   Future<Directory?> getAppTemporaryDirectory() async {
//     if (Platform.isAndroid) {
//       final result = await getExternalStorageDirectories();
//       if (result == null || result.isEmpty) {
//         throw Exception("Cannot resolve temporary directory!");
//       } else {
//         return result.first;
//       }
//     } else {
//       final dir = await getTemporaryDirectory();
//       return dir;
//     }
//   }

//   Future<XFile?> compressImage(String path) async {
//     final compressedFilePath =
//         '${await getTemporaryDirectoryPath()}/${DateTime.now().millisecondsSinceEpoch}.jpg';
//     final compressedFile = await FlutterImageCompress.compressAndGetFile(
//       path,
//       compressedFilePath,
//       quality: 75,
//     );
//     return compressedFile;
//   }

//   Future<XFile?> pickeAndCompressImage(BuildContext context) async {
//     final imageFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (imageFile == null) {
//       return null;
//     }
//     return await compressImage(imageFile.path);
//   }
// }
