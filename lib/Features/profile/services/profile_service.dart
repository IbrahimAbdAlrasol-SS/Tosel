import 'dart:async';

import 'package:Tosell/Features/auth/models/User.dart';
import 'package:Tosell/core/Client/BaseClient.dart';

class ProfileService {
  final BaseClient<User> baseClient;

  ProfileService()
      : baseClient = BaseClient<User>(fromJson: (json) => User.fromJson(json));

  FutureOr<(User?, String?)> updateUser({required User user}) async {
    try {
      if (user.img != null && user.img!.isNotEmpty) {
        var upload = await baseClient.uploadFile(user.img!);
        if (upload.data == null) return (null, 'error uploading image');
        user.img = upload.data![0];
      }
      var result = await baseClient.update(
          endpoint: '/auth/change-profile', data: user.toJson());

      if (result.singleData == null) return (null, result.message);
      return (result.singleData, null);
    } catch (e) {
      return (null, e.toString());
    }
  }

  FutureOr<(User?, String?)> changePassword(
      {required String oldPassword, required String newPassword}) async {
    try {
      var result =
          await baseClient.update(endpoint: '/auth/change-password', data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      });

      if (result.data == null) return (null, result.message);
      return (result.singleData, null);
    } catch (e) {
      return (null, e.toString());
    }
  }
}
