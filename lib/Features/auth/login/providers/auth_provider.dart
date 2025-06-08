import 'dart:async';
import 'package:Tosell/Features/auth/Services/Auth_service.dart';
import 'package:Tosell/Features/auth/models/User.dart';
import 'package:Tosell/core/helpers/SharedPreferencesHelper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class authNotifier extends _$authNotifier {
  final AuthService _service = AuthService();

  Future<(User? data, String? error)> login({
     String? phonNumber,
    required String passWord,
  }) async {
    try {
      state = const AsyncValue.loading(); // Set loading state
      final (user, error) = await _service.login(
        phoneNumber: phonNumber,
        password: passWord,
      );
      if (user == null) {
        state = const AsyncValue.data(null); //? to stop loading state
        return (null, error);
      }
      await SharedPreferencesHelper.saveUser(user);
      state = AsyncValue.data(user);
      return (user, error);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
      return (null, e.toString());
    }
  }

  Future<void> register(User form, String passWord) async {
    state = const AsyncValue.loading();
    try {
      final user = await _service.register(form, passWord);
      state = AsyncValue.data(user.$1); // Store logged-in user
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace); // Handle error
    }
  }

  @override
  FutureOr<void> build() async {
    return;
  }
}
