import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tosell/core/widgets/CustomTextFormField.dart';
import 'package:Tosell/Features/auth/register/models/registration_zone.dart';
import 'package:Tosell/Features/auth/register/services/registration_zone_service.dart';

class DeliveryInfoTab extends StatefulWidget {
  const DeliveryInfoTab({super.key});

  @override
  State<DeliveryInfoTab> createState() => _DeliveryInfoTabState();
}

class _DeliveryInfoTabState extends State<DeliveryInfoTab> {
  Set<int> expandedTiles = {};
  List<DeliveryLocation> deliveryLocations = [DeliveryLocation()];
  
  // خدمة البحث في المناطق
  final RegistrationZoneService _zoneService = RegistrationZoneService();
  
  // ✅ تتبع آخر بحث لكل dropdown لتحسين الـ force refresh
  Map<int, String?> _lastGovernorateQuery = {};
  Map<int, String?> _lastZoneQuery = {};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ...deliveryLocations.asMap().entries.map((entry) {
              final index = entry.key;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
                child: _buildLocationCard(index, theme),
              );
            }),

            const SizedBox(height: 12),
            _buildAddLocationButton(),
            const Gap(8),
            // ✅ زر التحديث الشامل
            _buildRefreshButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(int index, ThemeData theme) {
    bool isExpanded = expandedTiles.contains(index);

    return ClipRRect(
      borderRadius: BorderRadius.circular(isExpanded ? 16 : 64),
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(isExpanded ? 16 : 64),
          side: const BorderSide(width: 1, color: Color(0xFFF1F2F4)),
        ),
        child: Theme(
          data: ThemeData().copyWith(
            dividerColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
            title: Row(
              children: [
                Expanded(
                  child: const Text(
                    "عنوان إستلام البضاعة",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Tajawal",
                      color: Color(0xFF121416),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                if (deliveryLocations.length > 1)
                  IconButton(
                    onPressed: () => _removeLocation(index),
                    icon: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
              ],
            ),
            trailing: SvgPicture.asset(
              "assets/svg/downrowsvg.svg",
              color: theme.colorScheme.primary,
            ),
            onExpansionChanged: (expanded) {
              Future.delayed(const Duration(milliseconds: 100), () {
                setState(() {
                  if (expanded) {
                    expandedTiles.add(index);
                  } else {
                    expandedTiles.remove(index);
                  }
                });
              });
            },
            children: [
              Container(height: 1, color: const Color(0xFFF1F2F4)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildGovernorateDropdown(index),
                    const Gap(AppSpaces.medium),
                    _buildZoneDropdown(index),
                    const Gap(AppSpaces.medium),
                    _buildNearestPointField(index),
                    const Gap(AppSpaces.medium),
                    _buildLocationPicker(),
                    const Gap(AppSpaces.medium),
                    _buildDailyOrderRateDropdown(index),
                    const Gap(AppSpaces.small),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGovernorateDropdown(int index) {
    return RegistrationSearchDropDown<RegistrationGovernorate>(
      label: "المحافظة",
      hint: "ابحث عن المحافظة... مثال: 'بغداد'",
      selectedValue: deliveryLocations[index].selectedGovernorate,
      itemAsString: (gov) => gov.name ?? '',
      asyncItems: (query) async {
        // ✅ Force refresh في أول بحث أو عند تغيير الـ query بشكل كبير
        final shouldForceRefresh = query.length == 1 || 
            (_lastGovernorateQuery[index] != null && 
             (_lastGovernorateQuery[index]!.isEmpty || 
              !query.startsWith(_lastGovernorateQuery[index]!)));
        
        _lastGovernorateQuery[index] = query;
        
        return await _zoneService.getGovernorates(
          query: query, 
          forceRefresh: shouldForceRefresh,
        );
      },
      onChanged: (governorate) {
        setState(() {
          deliveryLocations[index].selectedGovernorate = governorate;
          deliveryLocations[index].selectedZone = null; // إعادة تعيين المنطقة
          _lastZoneQuery[index] = null; // مسح آخر بحث للمناطق
        });
        
        // ✅ مسح cache المناطق عند تغيير المحافظة
        if (governorate != null) {
          _zoneService.clearCache();
        }
      },
      itemBuilder: (context, governorate) => Row(
        children: [
          Icon(
            Icons.location_city,
            color: context.colorScheme.primary,
            size: 18,
          ),
          const Gap(8),
          Text(
            governorate.name ?? '',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ],
      ),
      emptyText: "لا توجد محافظات مطابقة",
      errorText: "خطأ في تحميل المحافظات",
      enableRefresh: true, // ✅ تمكين الـ refresh
    );
  }

  Widget _buildZoneDropdown(int index) {
    final selectedGov = deliveryLocations[index].selectedGovernorate;
    
    return RegistrationSearchDropDown<RegistrationZone>(
      label: "المنطقة",
      hint: selectedGov == null 
          ? "اختر المحافظة أولاً" 
          : "ابحث عن المنطقة... مثال: 'المنصور'",
      selectedValue: deliveryLocations[index].selectedZone,
      itemAsString: (zone) => zone.name ?? '',
      asyncItems: (query) async {
        if (selectedGov?.id == null) return [];
        
        // ✅ Force refresh في أول بحث أو عند تغيير الـ query بشكل كبير
        final shouldForceRefresh = query.length == 1 || 
            (_lastZoneQuery[index] != null && 
             (_lastZoneQuery[index]!.isEmpty || 
              !query.startsWith(_lastZoneQuery[index]!)));
        
        _lastZoneQuery[index] = query;
        
        return await _zoneService.getZonesByGovernorate(
          governorateId: selectedGov!.id!,
          query: query,
          forceRefresh: shouldForceRefresh,
        );
      },
      onChanged: (zone) {
        setState(() {
          deliveryLocations[index].selectedZone = zone;
        });
      },
      itemBuilder: (context, zone) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.place,
                color: context.colorScheme.primary,
                size: 18,
              ),
              const Gap(8),
              Expanded(
                child: Text(
                  zone.name ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          if (zone.governorate?.name != null) ...[
            const Gap(4),
            Padding(
              padding: const EdgeInsets.only(right: 26),
              child: Text(
                '📍 ${zone.governorate!.name!}',
                style: TextStyle(
                  color: context.colorScheme.secondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ],
      ),
      emptyText: selectedGov == null 
          ? "اختر المحافظة أولاً"
          : "لا توجد مناطق مطابقة",
      errorText: "خطأ في تحميل المناطق",
      enableRefresh: true, // ✅ تمكين الـ refresh
    );
  }

  Widget _buildNearestPointField(int index) {
    return CustomTextFormField(
      label: "اقرب نقطة دالة",
      hint: "مثال: 'قرب مطعم الخيمة'",
      onChanged: (value) {
        deliveryLocations[index].nearestPoint = value;
      },
      onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
    );
  }

  Widget _buildLocationPicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الموقع',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 16,
          ),
        ),
        const Gap(AppSpaces.small),
        InkWell(
          onTap: _openLocationPicker,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: context.colorScheme.outline.withOpacity(0.3),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/map.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/svg/MapPinLine.svg',
                              color: context.colorScheme.primary,
                              height: 24,
                            ),
                            const Gap(8),
                            Text(
                              'تحديد الموقع',
                              style: context.textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                color: context.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDailyOrderRateDropdown(int index) {
    return CustomTextFormField<int>(
      label: "معدل الطلبات اليومي المتوقع",
      hint: "اختر المعدل المتوقع",
      dropdownItems: List.generate(11, (i) => 
        DropdownMenuItem<int>(
          value: i,
          child: Text('$i ${i == 1 ? 'طلب' : 'طلبات'}'),
        ),
      ),
      onDropdownChanged: (value) {
        setState(() {
          deliveryLocations[index].dailyOrderRate = value ?? 0;
        });
      },
      suffixInner: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SvgPicture.asset(
          "assets/svg/CaretDown.svg",
          width: 24,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildAddLocationButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 140.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: context.colorScheme.primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(60),
            border: Border.all(color: context.colorScheme.primary),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(60),
            onTap: () {
              setState(() {
                deliveryLocations.add(DeliveryLocation());
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    "assets/svg/navigation_add.svg",
                    color: context.colorScheme.primary,
                    height: 20,
                  ),
                  const Gap(AppSpaces.small),
                  Text(
                    "إضافة موقع",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _removeLocation(int index) {
    setState(() {
      deliveryLocations.removeAt(index);
      expandedTiles.remove(index);
      
      // ✅ تنظيف بيانات البحث المحفوظة
      _lastGovernorateQuery.remove(index);
      _lastZoneQuery.remove(index);
      
      // إعادة ترتيب المؤشرات
      final newExpandedTiles = <int>{};
      final newGovernorateQuery = <int, String?>{};
      final newZoneQuery = <int, String?>{};
      
      for (final expandedIndex in expandedTiles) {
        if (expandedIndex > index) {
          newExpandedTiles.add(expandedIndex - 1);
        } else {
          newExpandedTiles.add(expandedIndex);
        }
      }
      
      // إعادة ترتيب بيانات البحث
      _lastGovernorateQuery.forEach((key, value) {
        if (key > index) {
          newGovernorateQuery[key - 1] = value;
        } else if (key < index) {
          newGovernorateQuery[key] = value;
        }
      });
      
      _lastZoneQuery.forEach((key, value) {
        if (key > index) {
          newZoneQuery[key - 1] = value;
        } else if (key < index) {
          newZoneQuery[key] = value;
        }
      });
      
      expandedTiles = newExpandedTiles;
      _lastGovernorateQuery = newGovernorateQuery;
      _lastZoneQuery = newZoneQuery;
    });
    
    print('🗑️ تم حذف الموقع $index وتنظيف بياناته');
  }

  /// تحديث شامل لجميع البيانات
  Future<void> _refreshAllData() async {
    print('🔄 بدء تحديث شامل للبيانات...');
    
    try {
      // مسح كل الـ cache
      _zoneService.clearCache();
      _lastGovernorateQuery.clear();
      _lastZoneQuery.clear();
      
      // إعادة تحميل البيانات
      await _zoneService.refreshData();
      
      // إظهار رسالة نجاح
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                const Gap(8),
                Text('تم تحديث البيانات بنجاح'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
      
      print('✅ تم التحديث الشامل بنجاح');
    } catch (e) {
  Widget _buildRefreshButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 120.w,
          height: 32.h,
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(60),
            border: Border.all(color: Colors.blue),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(60),
            onTap: _refreshAllData,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh,
                    color: Colors.blue,
                    size: 16,
                  ),
                  const Gap(4),
                  Text(
                    "تحديث البيانات",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _openLocationPicker() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('سيتم فتح منتقي الموقع'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  /// الحصول على بيانات التوصيل المحفوظة
  List<Map<String, dynamic>> getDeliveryData() {
    return deliveryLocations.map((location) => location.toJson()).toList();
  }

  /// التحقق من صحة البيانات
  bool validateData() {
    for (int i = 0; i < deliveryLocations.length; i++) {
      final location = deliveryLocations[i];
      if (location.selectedGovernorate == null || location.selectedZone == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('يرجى إكمال بيانات الموقع ${i + 1}'),
            backgroundColor: Colors.red,
          ),
        );
        return false;
      }
    }
    return true;
  }
}

/// كلاس لحفظ بيانات موقع التوصيل
class DeliveryLocation {
  RegistrationGovernorate? selectedGovernorate;
  RegistrationZone? selectedZone;
  String? nearestPoint;
  int dailyOrderRate;
  
  DeliveryLocation({
    this.selectedGovernorate,
    this.selectedZone,
    this.nearestPoint,
    this.dailyOrderRate = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'governorate': selectedGovernorate?.toJson(),
      'zone': selectedZone?.toJson(),
      'nearestPoint': nearestPoint,
      'dailyOrderRate': dailyOrderRate,
    };
  }
}