// ✅ النسخة المُعدلة - يستخدم filter parameter للـ APIimport 'package:Tosell/core/Client/BaseClient.dart';
import 'package:Tosell/Features/auth/register/models/registration_zone.dart';
import 'package:Tosell/core/Client/BaseClient.dart';

class RegistrationZoneService {
  final BaseClient<RegistrationZone> _baseClient;
  
  // ✅ Cache ذكي مع إمكانية Force Refresh
  List<RegistrationZone>? _allZonesCache;
  DateTime? _cacheTime;
  static const Duration _cacheDuration = Duration(minutes: 3); // تقليل مدة الـ cache

  RegistrationZoneService() 
      : _baseClient = BaseClient<RegistrationZone>(
          fromJson: (json) => RegistrationZone.fromJson(json)
        );

  /// جلب كل المناطق مع إمكانية Force Refresh
  Future<List<RegistrationZone>> _getAllZonesWithoutFilter({bool forceRefresh = false}) async {
    try {
      // ✅ تحقق من صلاحية الـ cache (إلا إذا كان force refresh)
      final now = DateTime.now();
      final isCacheValid = !forceRefresh && 
          _allZonesCache != null && 
          _cacheTime != null && 
          now.difference(_cacheTime!) < _cacheDuration;
      
      if (isCacheValid) {
        print('⚡ استخدام البيانات من الـ cache (${_allZonesCache!.length} منطقة)');
        return _allZonesCache!;
      }
      
      // ✅ جلب البيانات من API
      Map<String, dynamic> queryParams = {
        'pageSize': 1000,
        'timestamp': now.millisecondsSinceEpoch, // منع الـ browser cache
      };
      
      print('🌍 ${forceRefresh ? "Force refresh" : "جلب"} كل المناطق من الـ API...');
      print('📤 Parameters: $queryParams');

      final result = await _baseClient.getAll(
        endpoint: '/zone',
        queryParams: queryParams,
      );
      
      // ✅ حفظ في الـ cache
      _allZonesCache = result.getList;
      _cacheTime = now;
      
      print('📥 تم تحديث البيانات: ${_allZonesCache!.length} منطقة');
      
      return _allZonesCache!;
    } catch (e) {
      print('❌ خطأ في جلب البيانات: $e');
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

  /// جلب المحافظات مع بحث محسن وrefresh فوري
  Future<List<RegistrationGovernorate>> getGovernorates({
    String? query, 
    bool forceRefresh = false
  }) async {
    try {
      print('🏛️ بحث المحافظات: "${query ?? "الكل"}" ${forceRefresh ? "(force refresh)" : ""}');
      
      // ✅ جلب البيانات (مع force refresh إذا كان مطلوب)
      final zones = await _getAllZonesWithoutFilter(forceRefresh: forceRefresh);
      
      // ✅ استخراج المحافظات الفريدة
      final Map<int, RegistrationGovernorate> uniqueGovernorates = {};
      
      for (final zone in zones) {
        if (zone.governorate != null && zone.governorate!.id != null) {
          final gov = zone.governorate!;
          uniqueGovernorates[gov.id!] = gov;
        }
      }
      
      var allGovernorates = uniqueGovernorates.values.toList();
      
      // ✅ فلترة محلية محسنة (تدعم البحث الجزئي)
      if (query != null && query.trim().isNotEmpty) {
        final searchQuery = query.trim().toLowerCase();
        allGovernorates = allGovernorates.where((gov) {
          final govName = (gov.name ?? '').toLowerCase();
          return govName.contains(searchQuery) || 
                 govName.startsWith(searchQuery) ||
                 _isArabicMatch(govName, searchQuery);
        }).toList();
        
        print('🔍 فلترة محلية: "$query" → ${allGovernorates.length} نتيجة');
      }
      
      // ✅ ترتيب النتائج (الأقرب للبحث أولاً)
      if (query != null && query.trim().isNotEmpty) {
        final searchQuery = query.trim().toLowerCase();
        allGovernorates.sort((a, b) {
          final aName = (a.name ?? '').toLowerCase();
          final bName = (b.name ?? '').toLowerCase();
          
          // الذي يبدأ بالبحث أولاً
          final aStarts = aName.startsWith(searchQuery);
          final bStarts = bName.startsWith(searchQuery);
          
          if (aStarts && !bStarts) return -1;
          if (!aStarts && bStarts) return 1;
          
          return aName.compareTo(bName);
        });
      }
      
      print('🏛️ النتيجة: ${allGovernorates.length} محافظة');
      for (var gov in allGovernorates.take(5)) {
        print('   ✓ ${gov.name}');
      }
      
      return allGovernorates;
    } catch (e) {
      print('❌ خطأ في جلب المحافظات: $e');
      return [];
    }
  }

  /// جلب المناطق لمحافظة محددة مع بحث محسن
  Future<List<RegistrationZone>> getZonesByGovernorate({
    required int governorateId,
    String? query,
    bool forceRefresh = false,
  }) async {
    try {
      print('🌍 بحث المناطق للمحافظة $governorateId: "${query ?? "الكل"}" ${forceRefresh ? "(force refresh)" : ""}');
      
      // ✅ جلب البيانات (مع force refresh إذا كان مطلوب)
      final allZones = await _getAllZonesWithoutFilter(forceRefresh: forceRefresh);
      
      // ✅ فلترة المناطق للمحافظة المحددة
      var zonesInGovernorate = allZones.where((zone) => 
        zone.governorate?.id == governorateId
      ).toList();
      
      // ✅ فلترة محلية محسنة للمناطق
      if (query != null && query.trim().isNotEmpty) {
        final searchQuery = query.trim().toLowerCase();
        zonesInGovernorate = zonesInGovernorate.where((zone) {
          final zoneName = (zone.name ?? '').toLowerCase();
          return zoneName.contains(searchQuery) || 
                 zoneName.startsWith(searchQuery) ||
                 _isArabicMatch(zoneName, searchQuery);
        }).toList();
        
        print('🔍 فلترة محلية للمناطق: "$query" → ${zonesInGovernorate.length} نتيجة');
      }
      
      // ✅ ترتيب النتائج (الأقرب للبحث أولاً)
      if (query != null && query.trim().isNotEmpty) {
        final searchQuery = query.trim().toLowerCase();
        zonesInGovernorate.sort((a, b) {
          final aName = (a.name ?? '').toLowerCase();
          final bName = (b.name ?? '').toLowerCase();
          
          // الذي يبدأ بالبحث أولاً
          final aStarts = aName.startsWith(searchQuery);
          final bStarts = bName.startsWith(searchQuery);
          
          if (aStarts && !bStarts) return -1;
          if (!aStarts && bStarts) return 1;
          
          return aName.compareTo(bName);
        });
      }
      
      print('🌍 النتيجة: ${zonesInGovernorate.length} منطقة');
      for (var zone in zonesInGovernorate.take(5)) {
        print('   ✓ ${zone.name}');
      }
      
      return zonesInGovernorate;
    } catch (e) {
      print('❌ خطأ في جلب المناطق: $e');
      return [];
    }
  }

  /// تحسين البحث العربي (يدعم البحث الجزئي)
  bool _isArabicMatch(String text, String query) {
    // إزالة التشكيل والمسافات الزائدة
    final cleanText = text.replaceAll(RegExp(r'[ًٌٍَُِّْ\s]+'), '');
    final cleanQuery = query.replaceAll(RegExp(r'[ًٌٍَُِّْ\s]+'), '');
    
    // البحث في الكلمات المنفصلة
    final textWords = cleanText.split(' ').where((w) => w.isNotEmpty);
    final queryWords = cleanQuery.split(' ').where((w) => w.isNotEmpty);
    
    return queryWords.every((queryWord) => 
        textWords.any((textWord) => textWord.contains(queryWord))
    );
  }

  /// مسح الـ cache وإجبار تحديث البيانات
  void clearCache() {
    _allZonesCache = null;
    _cacheTime = null;
    print('🗑️ تم مسح الـ cache - سيتم جلب البيانات الجديدة');
  }

  /// تحديث البيانات فوراً (force refresh)
  Future<void> refreshData() async {
    print('🔄 بدء تحديث البيانات...');
    clearCache();
    await _getAllZonesWithoutFilter(forceRefresh: true);
    print('✅ تم تحديث البيانات بنجاح');
  }

  /// التحقق من حالة الـ cache
  bool get isCacheValid {
    if (_allZonesCache == null || _cacheTime == null) return false;
    final now = DateTime.now();
    return now.difference(_cacheTime!) < _cacheDuration;
  }

  /// الحصول على عدد المناطق في الـ cache
  int get cachedZonesCount => _allZonesCache?.length ?? 0;

  /// الحصول على وقت آخر تحديث للـ cache
  DateTime? get lastUpdateTime => _cacheTime;
}