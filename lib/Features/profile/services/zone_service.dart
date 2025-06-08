import 'package:Tosell/Features/profile/models/zone.dart';
import 'package:Tosell/core/Client/BaseClient.dart';

class ZoneService {
  final BaseClient<ZoneObject> baseClient;

  ZoneService()
      : baseClient = BaseClient<ZoneObject>(
            fromJson: (json) => ZoneObject.fromJson(json));

  // Future<List<Zone>> getAllZones(
  //     {Map<String, dynamic>? queryParams, int page = 1}) async {
  //   try {
  //     var result = await baseClient.getAll(
  //         endpoint: '/zone', page: page, queryParams: queryParams);
  //     if (result.data == null) return [];
  //     return result.data!.map((e) => ).toList();
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<List<Zone>> getMyZones() async {
    try {
      var result = await baseClient.get(endpoint: '/merchantzones/merchant');
      if (result.data == null) return [];
      return result.data!.map((e) => e.zone!).toList();
    } catch (e) {
      rethrow;
    }
  }
}
