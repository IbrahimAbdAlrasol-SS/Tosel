import 'package:Tosell/Features/profile/models/zone.dart';
import 'package:Tosell/Features/profile/services/governorate_service.dart';
import 'package:Tosell/Features/profile/services/zone_price_service.dart';
import 'package:Tosell/Features/profile/services/zone_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'zone_provider.g.dart';

@riverpod
class zoneNotifier extends _$zoneNotifier {
  ZoneService zoneService = ZoneService();
  ZonePriceService zonePriceService = ZonePriceService();
  GovernorateService governorateService = GovernorateService();

  Future<List<Governorate>> getAllGovernorate() async {
    return await governorateService.getAllZones();
  }

  Future<List<Zone>> getALlZones({required String governorateId}) async {
    return await zonePriceService.getAllZones(governorateId: governorateId);
  }

  @override
  FutureOr<List<Zone>> build() async {
    return await zoneService.getMyZones();
  }
}
