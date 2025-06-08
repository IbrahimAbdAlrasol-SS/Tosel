import 'package:Tosell/Features/auth/models/User.dart';
import 'package:Tosell/core/Client/BaseClient.dart';

class AuthService {
  final BaseClient<User> baseClient;

  AuthService()
      : baseClient = BaseClient<User>(fromJson: (json) => User.fromJson(json));

  Future<(User? data, String? error)> login(
      {String? phoneNumber, required String password}) async {
    try {
      var result = await baseClient.create(endpoint: '/auth/login', data: {
        'phoneNumber': phoneNumber,
        'password': password,
      });

      if (result.singleData == null) return (null, result.message);
      return (result.getSingle, null);
    } catch (e) {
      return (null, e.toString());
    }
  }

  Future<(User? data, String? error)> register(
      User user, String passWord) async {
    try {
      var result = await baseClient.create(
        endpoint: '/auth/merchant-register',
        data: {...user.toJson(), 'password': passWord},
      );
      // if (result.singleData == null) return User();
      if (result.getSingle == null) return (null, result.message);
      return (result.singleData, null);
    } catch (e) {
      return (null, e.toString());
    }
  }
}
