import 'package:Tosell/Features/auth/register/models/registration_zone.dart';
import 'package:Tosell/core/Client/BaseClient.dart';

class RegistrationZoneService {
  final BaseClient<RegistrationZone> _baseClient;
  
  // ✅ Cache للبيانات الكاملة لتحسين الأداء
  List<RegistrationZone>? _allZonesCache;
  DateTime? _cacheTime;
  static const Duration _cacheDuration = Duration(minutes: 5);

  RegistrationZoneService() 
      : _baseClient = BaseClient<RegistrationZone>(
          fromJson: (json) => RegistrationZone.fromJson(json)
        );

  /// جلب كل المناطق بدون فلتر (للمحافظات) مع Cache
  Future<List<RegistrationZone>> _getAllZonesWithoutFilter() async {
    try {
      // ✅ تحقق من صلاحية الـ cache
      final now = DateTime.now();
      final isCacheValid = _allZonesCache != null && 
          _cacheTime != null && 
          now.difference(_cacheTime!) < _cacheDuration;
      
      if (isCacheValid) {
        print('⚡ استخدام البيانات من الـ cache (${_allZonesCache!.length} منطقة)');
        return _allZonesCache!;
      }
      
      Map<String, dynamic> queryParams = {
        'pageSize': 1000, // جلب أكبر عدد ممكن بدون فلتر
      };
      
      print('🌍 جلب كل المناطق بدون فلتر من الـ API...');
      print('📤 Parameters: $queryParams');

      final result = await _baseClient.getAll(
        endpoint: '/zone',
        queryParams: queryParams,
      );
      
      // ✅ حفظ في الـ cache
      _allZonesCache = result.getList;
      _cacheTime = now;
      
      print('📥 النتائج: ${_allZonesCache!.length} منطقة (تم حفظها في الـ cache)');
      
      return _allZonesCache!;
    } catch (e) {
      print('❌ خطأ في جلب كل البيانات: $e');
      // إذا حدث خطأ وعندنا cache قديم، استخدمه
      return _allZonesCache ?? [];
    }
  }

  /// البحث في المناطق للتسجيل (مع فلتر API للمناطق)
  Future<List<RegistrationZone>> searchZones({String? query}) async {
    try {
      Map<String, dynamic>? queryParams;
      
      // إضافة parameter البحث إذا كان موجود
      if (query != null && query.isNotEmpty) {
        queryParams = {
          'filter': query,  // ✅ استخدام filter parameter للمناطق
          'pageSize': 100, 
        };
      } else {
        queryParams = {'pageSize': 100}; // حتى بدون بحث، جلب 100 نتيجة
      }

      print('🔍 البحث في المناطق عن: "$query"');
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

  /// جلب المحافظات المتاحة (فريدة) - مع فلترة محلية
  Future<List<RegistrationGovernorate>> getGovernorates({String? query}) async {
    try {
      // ✅ جلب كل البيانات (بدون فلتر على API) لأن API يبحث في المناطق وليس المحافظات
      final zones = await _getAllZonesWithoutFilter();
      
      print('🏛️ معالجة ${zones.length} منطقة لاستخراج المحافظات');
      
      // استخراج المحافظات الفريدة
      final Map<int, RegistrationGovernorate> uniqueGovernorates = {};
      
      for (final zone in zones) {
        if (zone.governorate != null && zone.governorate!.id != null) {
          final gov = zone.governorate!;
          uniqueGovernorates[gov.id!] = gov;
        }
      }
      
      var allGovernorates = uniqueGovernorates.values.toList();
      
      // ✅ فلترة محلياً بناءً على اسم المحافظة (وليس API)
      if (query != null && query.isNotEmpty) {
        allGovernorates = allGovernorates.where((gov) =>
          gov.name?.contains(query) ?? false
        ).toList();
        
        print('🔍 فلترة محلية للمحافظات بـ "$query"');
      }
      
      print('🏛️ تم العثور على ${allGovernorates.length} محافظة مطابقة للبحث "$query"');
      for (var gov in allGovernorates.take(5)) {
        print('   - ${gov.name}');
      }
      
      return allGovernorates;
    } catch (e) {
      print('❌ خطأ في جلب المحافظات: $e');
      return [];
    }
  }

  /// جلب المناطق لمحافظة محددة (مع فلترة محلية)
  Future<List<RegistrationZone>> getZonesByGovernorate({
    required int governorateId,
    String? query,
  }) async {
    try {
      // ✅ جلب كل البيانات أولاً (بدون فلتر API)
      final allZones = await _getAllZonesWithoutFilter();
      
      // فلترة المناطق للمحافظة المحددة
      var zonesInGovernorate = allZones.where((zone) => 
        zone.governorate?.id == governorateId
      ).toList();
      
      // ✅ فلترة إضافية بناءً على query (محلياً للمناطق)
      if (query != null && query.isNotEmpty) {
        zonesInGovernorate = zonesInGovernorate.where((zone) =>
          zone.name?.contains(query) ?? false
        ).toList();
        
        print('🔍 فلترة محلية للمناطق بـ "$query"');
      }
      
      print('🌍 تم العثور على ${zonesInGovernorate.length} منطقة للمحافظة $governorateId مع البحث "$query"');
      for (var zone in zonesInGovernorate.take(5)) {
        print('   - ${zone.name}');
      }
      
      return zonesInGovernorate;
    } catch (e) {
      print('❌ خطأ في جلب المناطق: $e');
      return [];
    }
  }

  /// مسح الـ cache لإجبار تحديث البيانات
  void clearCache() {
    _allZonesCache = null;
    _cacheTime = null;
    print('🗑️ تم مسح الـ cache - سيتم جلب البيانات من API في المرة القادمة');
  }
}