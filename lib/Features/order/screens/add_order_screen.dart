import 'package:gap/gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/router/app_router.dart';
import 'package:Tosell/core/utils/GlobalToast.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:Tosell/core/widgets/CustomAppBar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/core/widgets/custom_section.dart';
import 'package:Tosell/Features/profile/models/zone.dart';
import 'package:Tosell/Features/order/models/Location.dart';
import 'package:Tosell/core/widgets/CustomTextFormField.dart';
import 'package:Tosell/Features/order/widgets/Geolocator.dart';
import 'package:Tosell/Features/order/models/add_order_form.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'package:Tosell/Features/profile/providers/zone_provider.dart';
import 'package:Tosell/Features/order/providers/order_commands_provider.dart';

class AddOrderScreen extends ConsumerStatefulWidget {
  const AddOrderScreen({super.key});

  @override
  ConsumerState<AddOrderScreen> createState() => _AddOrderScreenState();
}

class _AddOrderScreenState extends ConsumerState<AddOrderScreen> {
  String? selectedPickupZoneId;

  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneNumberController =
      TextEditingController();
  final TextEditingController _customerSecondPhoneNumberController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _orderNoteController = TextEditingController();
  final TextEditingController _orderSizeController =
      TextEditingController(text: '1');

  String? _selectedGovernorateId;
  String? _SelectedCityId;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<Zone> deliveryZones = [];
  List<Governorate> governorateZones = [];

  Future<void> _loadGovernorate() async {
    final governorates =
        await ref.read(zoneNotifierProvider.notifier).getAllGovernorate();
    setState(() {
      governorateZones = governorates;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadGovernorate();
  }

  Future<void> _loadZones(String governorateId) async {
    final zones = await ref
        .read(zoneNotifierProvider.notifier)
        .getALlZones(governorateId: governorateId);

    var z = deliveryZones;
    setState(() {
      _SelectedCityId = null;
      deliveryZones = zones;
    });
  }

  @override
  Widget build(BuildContext context) {
    var zoneState = ref.watch(zoneNotifierProvider);

    return Scaffold(
      body: zoneState.when(
        data: (data) => _buildUi(context, data),
        error: (error, _) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildUi(BuildContext context, List<Zone> pickupZones) {
    var orderState = ref.watch(orderCommandsNotifierProvider);

    void addOrder() async {
      try {
        var pickupLocation = await getCurrentLocation();
        final result =
            await ref.read(orderCommandsNotifierProvider.notifier).addOrder(
                  AddOrderForm(
                    code: _barcodeController.text,
                    customerName: _customerNameController.text,
                    customerPhoneNumber: _customerPhoneNumberController.text,
                    customerSecondPhoneNumber:
                        _customerSecondPhoneNumberController.text,
                    deliveryZoneId: _SelectedCityId,
                    note: _orderNoteController.text,
                    pickupZoneId: selectedPickupZoneId ?? '',
                    content: _contentController.text,
                    pickUpLocation: Location(
                        lat: pickupLocation.latitude.toString(),
                        long: pickupLocation.longitude.toString()),
                    size: int.parse(_orderSizeController.text),
                    amount: _amountController.text,
                  ),
                );
        print("Result: $result");

        if (result.$1 == null) {
          GlobalToast.show(
            message: result.$2!,
            backgroundColor: Theme.of(context).colorScheme.error,
            textColor: Colors.white,
          );
        } else {
          GlobalToast.show(
            message: "تم انشاء الطلب بنجاح",
            backgroundColor: Colors.green,
            textColor: Colors.white,
          );
          if (orderState is AsyncData) {
            context.go(AppRoutes.orders);
          }
        }
      } catch (e) {
        GlobalToast.show(
          message: "حدث خطأ أثناء إرسال الطلب${e.toString()}.",
          backgroundColor: Theme.of(context).colorScheme.error,
          textColor: Colors.white,
        );
      }
    }

    return SafeArea(
      child: Column(
        children: [
          CustomAppBar(
            title: "إنشاء طلب جديد",
            showBackButton: true,
            onBackButtonPressed: () => context.go(AppRoutes.home),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomSection(
                    noLine: true,
                    title: 'موقع إستلام المنتج',
                    icon: SvgPicture.asset(
                      "assets/svg/Receipt.svg",
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    leading: Row(
                      children: [
                        SvgPicture.asset(
                          "assets/svg/navigation_add.svg",
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const Gap(AppSpaces.small),
                        Text(
                          "إضافة موقع",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Gap(AppSpaces.small),
                      ],
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                          bottom: 13.0,
                          right: 8.0,
                          left: 8.0,
                        ),
                        child: SizedBox(
                          height: 50, // Fixed height for the ListView
                          child: ListView.builder(
                            itemCount: pickupZones.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final zone = pickupZones[index];
                              final isSelected =
                                  zone.id.toString() == selectedPickupZoneId;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedPickupZoneId = zone.id.toString();
                                  });
                                },
                                child: buildZone(context, zone, isSelected),
                              );
                            },
                            itemExtent:
                                330, // Set the item width, making it fixed
                            shrinkWrap: false, // Prevent shrinking the list
                            physics:
                                const ClampingScrollPhysics(), // Better for horizontal scrolling
                          ),
                        ),
                      )
                    ],
                  ),

                  CustomSection(
                    noLine: true,
                    title: "معلومات الوصل",
                    icon: SvgPicture.asset(
                      "assets/svg/navigation_add.svg",
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
                        child: Form(
                          key: _formKey,
                          child: CustomTextFormField(
                            controller: _barcodeController,
                            label: "رقم الوصل",
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .unfocus(); // This hides the keyboard
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a valid barcode';
                              }
                              var validate = ref
                                  .read(orderCommandsNotifierProvider.notifier)
                                  .validateCode(code: value)
                                  .then(
                                (value) {
                                  if (!value) return 'Invalid code';
                                },
                              );

                              return null; // Return null if validation passes
                            },
                            // Add validation logic inside the onEditingComplete callback
                            // onEditingComplete: (value) async {
                            //   if (_formKey.currentState?.validate() ?? false) {
                            // var validate = await ref
                            // .read(
                            // orderCommandsNotifierProvider.notifier)
                            // .validateCode(code: value);

                            //     if (validate) {
                            //       // Handle successful validation here
                            //     } else {
                            //       // Handle failure here
                            //       print('Invalid code');
                            //     }
                            //   } else {
                            //     // Form is invalid, show error
                            //     print("Form is invalid!");
                            //   }
                            // },
                            suffixInner: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () => scanBarcode(context),
                                child: SvgPicture.asset(
                                  "assets/svg/Barcode.svg",
                                  width: 24,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  //? products carts list
                  buildProductCart(context, "لايوجد"),

                  CustomSection(
                    noLine: true,
                    title: "معلومات الزبون",
                    icon: SvgPicture.asset(
                      "assets/svg/box.svg",
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
                        child: CustomTextFormField(
                          hint: "مثال: \"أحمد علي\"",
                          label: "أسم الزبون",
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .unfocus(); // This hides the keyboard
                          },
                          controller: _customerNameController,
                        ),
                      ),

                      //=======
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
                        child: CustomTextFormField(
                          label: "رقم الهاتف",
                          hint: 'مثال: "07x xxx xxxx"',
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .unfocus(); // This hides the keyboard
                          },
                          controller: _customerPhoneNumberController,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
                        child: CustomTextFormField(
                          label: "رقم الهاتف الثاني",
                          hint: 'مثال: "07x xxx xxxx"',
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .unfocus(); // This hides the keyboard
                          },
                          controller: _customerSecondPhoneNumberController,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
                        child: CustomTextFormField<String>(
                          label: "المحافظة",
                          hint: "مثال: 'بغداد'",
                          dropdownItems: governorateZones.map((gov) {
                            return DropdownMenuItem<String>(
                              value: gov.id?.toString() ?? '',
                              child: Text(gov.name ?? 'Unknown'),
                            );
                          }).toList(),
                          // controller: _governorateIdController,
                          selectedValue: _selectedGovernorateId,
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
                      ),

                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
                        child: CustomTextFormField<String>(
                          label: "المنطقة",
                          hint: "مثال: \'المنصور\'",
                          // controller: _CityIdController,
                          dropdownItems: deliveryZones.isNotEmpty
                              ? deliveryZones.map((zone) {
                                  return DropdownMenuItem<String>(
                                    value: zone.id?.toString() ?? '',
                                    child: Text(zone.name ?? 'Unknown'),
                                  );
                                }).toList()
                              : [],

                          selectedValue: _SelectedCityId,
                          onDropdownChanged: (value) {
                            setState(() {
                              _SelectedCityId = value;
                            });
                          },
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
                      ),
                    ],
                  ),

                  CustomSection(
                    noLine: true,
                    title: "معلومات الطلب",
                    icon: SvgPicture.asset(
                      "assets/svg/navigation_add.svg",
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    children: [
                      //=======
                      Padding(
                          padding: const EdgeInsets.only(
                              top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
                          child: CustomTextFormField<String>(
                            label: "حجم الطلب",
                            hint: "متوسط",
                            controller: _orderSizeController,
                            dropdownItems: const [
                              DropdownMenuItem(
                                value: "0",
                                child: Text("صغير"),
                              ),
                              DropdownMenuItem(
                                value: "1",
                                child: Text("متوسط"),
                              ),
                              DropdownMenuItem(
                                value: "2",
                                child: Text("كبير"),
                              ),
                            ],
                            selectedValue: "1",
                            onDropdownChanged: (value) {},
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
                          )),
                      //=======
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
                        child: CustomTextFormField(
                          label: "ملاحظة",
                          hint: 'مثال: "المادة قابلة للكسر"',
                          maxLines: 3,
                          controller: _orderNoteController,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context)
                                .unfocus(); // This hides the keyboard
                          },
                        ),
                      ),
                    ],
                  ),
                  //? send button
                  const Gap(AppSpaces.exLarge),
                  Container(
                    padding: AppSpaces.allMedium,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20))),
                    child: FillButton(
                      label: 'إرسال الطلب',
                      isLoading: orderState.isLoading,
                      onPressed: () => addOrder(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  CustomSection buildProductCart(BuildContext context, String product) {
    return CustomSection(
      noLine: true,
      title: 'معلومات المنتج',
      icon: SvgPicture.asset(
        "assets/svg/box.svg",
        color: Theme.of(context).colorScheme.primary,
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
          child: CustomTextFormField(
            label: "تفاصيل المنتج",
            controller: _contentController,
            hint: " مثال: \'صندوق ادوات كهرباء\'",
            maxLines: 3,
            onFieldSubmitted: (_) {
              FocusScope.of(context).unfocus(); // This hides the keyboard
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 8.0, bottom: 13.0, right: 8.0, left: 8.0),
          child: CustomTextFormField(
            label: "سعر المنتج",
            controller: _amountController,
            hint: " مثال: \'30,000 \'",
            keyboardType: TextInputType.number,
            onFieldSubmitted: (_) {
              FocusScope.of(context).unfocus(); // This hides the keyboard
            },
          ),
        ),
      ],
    );
  }

  Widget buildZone(BuildContext context, Zone zone, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFFF1F2F4),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Gap(AppSpaces.medium),
          SizedBox(
            width: 18,
            height: 18,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              padding: const EdgeInsets.all(3),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(3),
              ),
            ),
          ),
          const Gap(AppSpaces.exSmall),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                SvgPicture.asset(
                  "assets/svg/MapPinSimple.svg",
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    zone.name ?? "لايوجد",
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    zone.governorate?.name ?? "لايوجد",
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> scanBarcode(BuildContext context) async {
    String? res = await SimpleBarcodeScanner.scanBarcode(
      context,
      barcodeAppBar: const BarcodeAppBar(
        appBarTitle: 'Test',
        centerTitle: false,
        enableBackButton: true,
        backButtonIcon: Icon(Icons.arrow_back_ios),
      ),
      isShowFlashIcon: true,
      delayMillis: 2000,
      cameraFace: CameraFace.back,
    );
    setState(() {
      _barcodeController.text = res ?? '';
    });
  }
}
