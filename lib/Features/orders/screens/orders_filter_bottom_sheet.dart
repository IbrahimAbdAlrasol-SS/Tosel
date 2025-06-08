import 'package:Tosell/Features/orders/models/OrderFilter.dart';
import 'package:Tosell/Features/orders/models/order_enum.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/router/app_router.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:Tosell/core/widgets/CustomTextFormField.dart';
import 'package:Tosell/core/widgets/DatePickerTextField%20.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class OrdersFilterBottomSheet extends ConsumerStatefulWidget {
  const OrdersFilterBottomSheet({super.key});

  @override
  ConsumerState<OrdersFilterBottomSheet> createState() =>
      _OrdersFilterBottomSheetState();
}

class _OrdersFilterBottomSheetState
    extends ConsumerState<OrdersFilterBottomSheet> {
  final TextEditingController orderStateController = TextEditingController();
  final TextEditingController productTypeController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController provinceController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  String? selectedState = orderStatus[0].name;

  bool _anyFilter = false;

  @override
  void initState() {
    super.initState();
    orderStateController.addListener(_checkFilters);
    productTypeController.addListener(_checkFilters);
    dateController.addListener(_checkFilters);
    provinceController.addListener(_checkFilters);
    areaController.addListener(_checkFilters);
  }

  void _checkFilters() {
    setState(() {
      _anyFilter = orderStateController.text.isNotEmpty ||
          productTypeController.text.isNotEmpty ||
          dateController.text.isNotEmpty ||
          provinceController.text.isNotEmpty ||
          areaController.text.isNotEmpty;
    });
  }

  void clearFilters() {
    setState(() {
      orderStateController.clear();
      productTypeController.clear();
      dateController.clear();
      provinceController.clear();
      areaController.clear();
      _anyFilter = false;
    });
  }

  @override
  void dispose() {
    orderStateController.removeListener(_checkFilters);
    productTypeController.removeListener(_checkFilters);
    dateController.removeListener(_checkFilters);
    provinceController.removeListener(_checkFilters);
    areaController.removeListener(_checkFilters);

    orderStateController.dispose();
    productTypeController.dispose();
    dateController.dispose();
    provinceController.dispose();
    areaController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Gap(AppSpaces.medium),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpaces.small),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: clearFilters,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/svg/FunnelX.svg',
                        color: _anyFilter
                            ? Theme.of(context).colorScheme.error
                            : Theme.of(context).colorScheme.secondary,
                      ),
                      const Gap(AppSpaces.exSmall),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Text(
                          'حذف التصفية',
                          style: TextStyle(
                            color: _anyFilter
                                ? Theme.of(context).colorScheme.error
                                : Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpaces.small),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField<String>(
                    controller: orderStateController,
                    label: 'حالة الطلب',
                    labelStyle: context.textTheme.bodyLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    dropdownItems: [
                      ...orderStatus.map(
                        (state) => DropdownMenuItem<String>(
                          value: state.value.toString(),
                          child: Text(state.name ?? ''),
                        ),
                      ),
                    ],
                    suffixInner: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SvgPicture.asset(
                        "assets/svg/CaretDown.svg",
                        width: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    selectedValue: orderStateController.text.isNotEmpty
                        ? orderStateController.text
                        : null,
                    onDropdownChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedState = orderStatus[int.parse(value)].name;
                          orderStateController.text = value;
                        });
                      }
                    },
                    // ...
                  ),
                  const Gap(AppSpaces.large),
                  Text(
                    'الطلب',
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Gap(AppSpaces.exSmall),
                  DatePickerTextField(
                    controller: dateController,
                    readOnly: true,
                    hint: 'التاريخ',
                    hintStyle: const TextStyle(color: Color(0xFF698596)),
                    onChanged: (value) {},
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'يرجى اختيار تاريخ صالح';
                      }
                      return null;
                    },
                  ),
                  const Gap(AppSpaces.large),
                  Text(
                    'الموقع',
                    style: context.textTheme.bodyLarge!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  CustomTextFormField<String>(
                    controller: provinceController,
                    hint: 'المحافظة',
                    dropdownItems: const [
                      DropdownMenuItem(value: "1", child: Text("بغداد")),
                      DropdownMenuItem(value: "2", child: Text("الحلة")),
                    ],
                    onDropdownChanged: (value) {
                      if (value != null) {
                        setState(() {
                          provinceController.text = value;
                        });
                      }
                    },
                    label: '',
                    showLabel: false,
                    suffixInner: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SvgPicture.asset(
                        "assets/svg/CaretDown.svg",
                        width: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  const Gap(AppSpaces.exSmall),
                  CustomTextFormField<String>(
                    controller: areaController,
                    hint: 'المنطقة',
                    dropdownItems: const [
                      DropdownMenuItem(value: "1", child: Text("المنصور")),
                      DropdownMenuItem(value: "2", child: Text("الكرادة")),
                    ],
                    onDropdownChanged: (value) {
                      if (value != null) {
                        setState(() {
                          areaController.text = value;
                        });
                      }
                    },
                    label: '',
                    showLabel: false,
                    suffixInner: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SvgPicture.asset(
                        "assets/svg/CaretDown.svg",
                        width: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FillButton(
              label: "بحث",
              onPressed: () {
                context.pop();
                context.go(AppRoutes.orders,
                    extra: OrderFilter(
                      status: int.tryParse(orderStateController.text) ?? 0,
                    )
                    // orderStatus
                    // .where(
                    //     (state) => state.value == orderStateController.text).first
                    // .name
                    );
              },
            ),
          ),
        ],
      ),
    );
  }
}
