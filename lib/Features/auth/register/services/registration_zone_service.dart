import 'package:Tosell/core/Client/BaseClient.dart';
import 'package:Tosell/Features/auth/register/models/registration_zone.dart';

class RegistrationZoneService {
  final BaseClient<RegistrationZone> _baseClient;

  RegistrationZoneService() 
      : _baseClient = BaseClient<RegistrationZone>(
          fromJson: (json) => RegistrationZone.fromJson(json)
        );

  /// البحث في المناطق للتسجيل
  Future<List<RegistrationZone>> searchZones({String? query}) async {
    try {
      Map<String, dynamic>? queryParams;
      
      // إضافة parameter البحث إذا كان موجود
      if (query != null && query.isNotEmpty) {
        queryParams = {
          'search': query,
          'pageSize': 100, 
        };
        
        // جرب هذه البدائل إذا لم يعمل search:
        //queryParams = {'filter': query, 'pageSize': 100};
         queryParams = {'name': query, 'pageSize': 100};
         //queryParams = {'q': query, 'pageSize': 100};
      } else {
        queryParams = {'pageSize': 100}; // حتى بدون بحث، جلب 100 نتيجة
      }

      print('🔍 البحث عن: "$query"');
      print('📤 Parameters: $queryParams');

      final result = await _baseClient.getAll(
        endpoint: '/zone',
        queryParams: queryParams,
      );
      
      print('📥 النتائج: ${result.getList.length} منطقة');
      for (var zone in result.getList.take(5)) {
        print('   - ${zone.name} (${zone.governorate?.name})');
      }
      
      return result.getList;
    } catch (e) {
      print('❌ خطأ في البحث: $e');
      return [];
    }
  }

  /// جلب المحافظات المتاحة (فريدة)
  Future<List<RegistrationGovernorate>> getGovernorates({String? query}) async {
    try {
      final zones = await searchZones(query: query);
      
      print('🏛️ معالجة ${zones.length} منطقة لاستخراج المحافظات');
      
      // استخراج المحافظات الفريدة
      final Map<int, RegistrationGovernorate> uniqueGovernorates = {};
      
      for (final zone in zones) {
        if (zone.governorate != null && zone.governorate!.id != null) {
          final gov = zone.governorate!;
          
          // فلترة إضافية على مستوى المحافظة
          if (query == null || query.isEmpty || 
              (gov.name?.contains(query) ?? false)) {
            uniqueGovernorates[gov.id!] = gov;
          }
        }
      }
      
      final result = uniqueGovernorates.values.toList();
      print('🏛️ تم العثور على ${result.length} محافظة');
      for (var gov in result) {
        print('   - ${gov.name}');
      }
      
      return result;
    } catch (e) {
      print('❌ خطأ في جلب المحافظات: $e');
      return [];
    }
  }

  /// جلب المناطق لمحافظة محددة
  Future<List<RegistrationZone>> getZonesByGovernorate({
    required int governorateId,
    String? query,
  }) async {
    try {
      final allZones = await searchZones(query: query);
      
      return allZones.where((zone) => 
        zone.governorate?.id == governorateId &&
        (query == null || query.isEmpty || (zone.name?.contains(query) ?? false))
      ).toList();
    } catch (e) {
      return [];
    }
  }
}