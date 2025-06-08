import 'package:Tosell/Features/profile/models/zone.dart';
import 'package:Tosell/core/Client/BaseClient.dart';

class ZonePriceService {
  final BaseClient<Zone> baseClient;

  ZonePriceService()
      : baseClient = BaseClient<Zone>(fromJson: (json) => Zone.fromJson(json));

  Future<List<Zone>> getAllZones({ required String governorateId, int page = 1}) async {
    try {
      var result = await baseClient.getAll(
          endpoint: '/zone',
          page: page,
          queryParams: {'governorateId': governorateId});
      if (result.data == null) return [];
      return result.data ?? [];
    } catch (e) {
      rethrow;
    }
  }
}
