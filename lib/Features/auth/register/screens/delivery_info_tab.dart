import 'package:gap/gap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:Tosell/Features/profile/models/zone.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tosell/core/widgets/CustomTextFormField.dart';

class DeliveryInfoTab extends StatefulWidget {
  const DeliveryInfoTab({super.key});

  @override
  State<DeliveryInfoTab> createState() => _DeliveryInfoTabState();
}

class _DeliveryInfoTabState extends State<DeliveryInfoTab> {
  Set<int> expandedTiles = {};
  List<Governorate> governorateZones = [];
  List<Zone> zones = [Zone()];

  @override
Widget build(BuildContext context) {
  final theme = Theme.of(context);

  return SafeArea(
    child: SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24), // space after button
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...zones.asMap().entries.map((entry) {
            final index = entry.key;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
              child: buildCard(index, theme),
            );
          }),

          const SizedBox(height: 12),

          // "إضافة موقع" Button
          Padding(
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
                      zones.add(Zone()); // Add new zone on tap
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
          ),
        ],
      ),
    ),
  );
}


  Widget buildCard(int index, ThemeData theme) {
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
            title: const Text(
              "عنوان إستلام البضاعة",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: "Tajawal",
                color: Color(0xFF121416),
              ),
              textAlign: TextAlign.right,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildDropdown("المحافظة", "مثال: 'بغداد'"),
                  _buildDropdown("المنطقة", "مثال: 'المنصور'"),
                  _buildTextField("اقرب نقطة دالة", "مثال: 'قرب مطعم الخيمة'"),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      'الموقع',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/map.png',
                            fit: BoxFit.cover,
                          ),
                          Positioned.fill(
                            child: Container(color: Colors.black.withOpacity(0.5)),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 5, left: 3),
                                child: SvgPicture.asset(
                                  'assets/svg/MapPinLine.svg',
                                  color: context.colorScheme.primary,
                                ),
                              ),
                              Text(
                                'تحديد الموقع',
                                style: context.textTheme.bodyMedium?.copyWith(
                                  fontSize: 16,
                                  color: context.colorScheme.primary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  _buildDropdown("معدل الطلبات اليومي المتوقع", "0 - 10"),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
      child: CustomTextFormField<String>(
        label: label,
        hint: hint,
        dropdownItems: governorateZones.map((gov) {
          return DropdownMenuItem<String>(
            value: gov.id?.toString() ?? '',
            child: Text(gov.name ?? 'Unknown'),
          );
        }).toList(),
        onDropdownChanged: (value) => _loadZones(value ?? ''),
        suffixInner: Padding(
          padding: const EdgeInsets.all(12.0),
          child: GestureDetector(
            onTap: () {},
            child: SvgPicture.asset(
              "assets/svg/CaretDown.svg",
              width: 24,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
      child: CustomTextFormField(
        label: label,
        hint: hint,
        onFieldSubmitted: (_) => FocusScope.of(context).unfocus(),
      ),
    );
  }

  Future<void> _loadZones(String governorateId) async {
    // Call API here if needed
  }
}
