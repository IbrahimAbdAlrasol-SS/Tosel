import 'package:gap/gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/Features/profile/models/zone.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tosell/core/widgets/CustomTextFormField.dart';
import 'package:Tosell/Features/order/widgets/google_map_widget.dart';

class AdressSheet extends ConsumerStatefulWidget {
  // final Address? address;
  final bool isEditing;

  const AdressSheet({super.key, this.isEditing = false});

  @override
  ConsumerState<AdressSheet> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<AdressSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _streetNameController = TextEditingController();
  List<Governorate> governorateZones = [];
  List<Zone> zones = [Zone()];

  int selectedHouseType = 0;

  @override
  void initState() {
    // if (widget.isEditing) {
    //   _nameController.text = widget.address!.name;
    //   _streetNameController.text = widget.address!.streetName;
    //   selectedHouseType = widget.address!.buildingType;
    //   Future.microtask(() => ref
    //       // .read(locationProvider.notifier)
    //       // .setLocation(LatLng(widget.address!.lat, widget.address!.lng))
    //       );
    // }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: context.colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                 const SizedBox(height: 15,),
                  Center(
                    child: Container(
                      height: 2,
                      width: 150,
                      decoration:  const BoxDecoration(
                        color: Color(0xffEAEEF0),
                        borderRadius: BorderRadius.all(Radius.circular(64))
                        
                      ),
                    ),
                  ),
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
                  const SizedBox(height: 30,),
                ],
              )
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
        // onDropdownChanged: (value) => _loadZones(value ?? ''),
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
}
