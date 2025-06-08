import 'package:Tosell/Features/home/models/home.dart';
import 'package:Tosell/core/Client/BaseClient.dart';

class HomeService {
  final BaseClient<Home> baseClient;

  HomeService()
      : baseClient = BaseClient<Home>(fromJson: (json) => Home.fromJson(json));

  Future<Home?> getInfo() async {
    try {
      // var result = await baseClient.get(endpoint: 'dashboard/mobile');
      var result = await baseClient.get_noResponse(
          endpoint: '/dashboard/mobile/merchant');
      // if (result.singleData == null) return Home();
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
