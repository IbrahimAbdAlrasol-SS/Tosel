import 'package:Tosell/Features/profile/models/zone.dart';
import 'package:Tosell/core/Client/BaseClient.dart';

class GovernorateService {
  final BaseClient<Governorate> baseClient;

  GovernorateService()
      : baseClient = BaseClient<Governorate>(fromJson: (json) => Governorate.fromJson(json));

  Future<List<Governorate>> getAllZones(
      {Map<String, dynamic>? queryParams, int page = 1}) async {
    try {
      var result = await baseClient.getAll(
          endpoint: '/governorate', page: page, queryParams: queryParams);
      if (result.data == null) return [];
      return result.data ?? [];
    } catch (e) {
      rethrow;
    }
  }
}
