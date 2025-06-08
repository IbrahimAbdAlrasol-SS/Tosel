import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:Tosell/Features/home/models/home.dart';
import 'package:Tosell/Features/home/services/home_service.dart';

part 'home_provider.g.dart';

@riverpod
class HomeNotifier extends _$HomeNotifier {
  final HomeService _service = HomeService();

  Future<Home?> get() async {
    return (await _service.getInfo());
  }

  @override
  FutureOr<Home> build() async {
    return await get() ?? Home();
  }
}
