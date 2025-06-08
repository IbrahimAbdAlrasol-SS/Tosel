import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/Features/order/widgets/google_map_widget.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/widgets/CustomTextFormField.dart';
import 'package:Tosell/core/widgets/FillButton.dart';

class AddAdressSheet extends ConsumerStatefulWidget {
  // final Address? address;
  final bool isEditing;

  const AddAdressSheet({super.key, this.isEditing = false});

  @override
  ConsumerState<AddAdressSheet> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<AddAdressSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _streetNameController = TextEditingController();

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
    final List<String> houseTypes = ["منزل", "شقة", "مكتب", "محل"];
    // final addAddressState = ref.watch(addressControllerProvider);

    // if (addAddressState.success) {
    // GlobalToast.show(
    //     message: widget.isEditing
    //         ? "تم تعديل العنوان بنجاح"
    //         : "تم اضافة العنوان بنجاح",
    //     backgroundColor: Colors.green,
    //     textColor: Colors.white);
    // Future.microtask(
    //     () => ref.read(addressControllerProvider.notifier).resetState());
    // context.pop();
    // }

    // if (addAddressState.failure != null) {
    //   GlobalToast.show(
    //       message: addAddressState.failure!.message,
    //       backgroundColor: Colors.red,
    //       textColor: Colors.white);
    // }

    return Container(
      height: screenHeight * 0.83 + keyboardHeight,
      padding: EdgeInsets.only(bottom: keyboardHeight),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: screenHeight * 0.83,
          ),
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(AppSpaces.medium),
                Expanded(
                  child: Padding(
                    padding: AppSpaces.horizontalMedium,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 150.w,
                              height: 2,
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4D7DD),
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ],
                        ),
                        const Gap(AppSpaces.medium),
                        Text(
                          "اضافة عنوان",
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        const Gap(AppSpaces.exSmall),
                        const Divider(thickness: 0.1),
                        const Gap(AppSpaces.large),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 58.h,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: houseTypes.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedHouseType = index;
                                        });
                                      },
                                      child: Container(
                                        width: 70.w,
                                        padding: AppSpaces.allSmall,
                                        margin: const EdgeInsets.only(
                                            left: AppSpaces.small),
                                        decoration: BoxDecoration(
                                          color: selectedHouseType == index
                                              ? Theme.of(context)
                                                  .colorScheme
                                                  .primary
                                              : Colors.white,
                                          border: Border.all(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              CupertinoIcons.home,
                                              color: selectedHouseType == index
                                                  ? Colors.white
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .primary,
                                            ),
                                            const Gap(AppSpaces.small),
                                            Text(
                                              houseTypes[index],
                                              style: TextStyle(
                                                color:
                                                    selectedHouseType == index
                                                        ? Colors.white
                                                        : Theme.of(context)
                                                            .colorScheme
                                                            .primary,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const Gap(AppSpaces.medium),
                              CustomTextFormField(
                                controller: _nameController,
                                label: "اسم العنوان",
                                hint: "مثلا المنزل",
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "الرجاء إدخال اسم";
                                  }
                                  return null;
                                },
                              ),
                              const Gap(AppSpaces.medium),
                              Text(
                                "نوع المبنى",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                ),
                              ),
                              const Gap(AppSpaces.medium),
                              CustomTextFormField(
                                controller: _streetNameController,
                                label: "اسم الشارع",
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "الرجاء إدخال اسم";
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),

                        // make listview builder horizntal should have column icon and houte type name

                        const Gap(AppSpaces.medium),

                        const Text("الموقع على الخريطة"),
                        const Gap(AppSpaces.small),

                        const GoogleMapWidget(),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: AppSpaces.allMedium,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: FillButton(
                    label: widget.isEditing ? "تعديل العنوان" : "اضافة العنوان",
                    // isLoading: widget.isEditing
                    //     ? addAddressState.isUpdating
                    //     : addAddressState.isAdding,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // var addaddressControllerProvider =
                        //     ref.read(addressControllerProvider.notifier);
                        // var location = ref.watch(locationProvider);

                        // if (widget.isEditing) {
                        //   addaddressControllerProvider.updateAddress(
                        //     id: widget.address!.id,
                        //     name: _nameController.text,
                        //     streetName: _streetNameController.text,
                        //     lat: location!.latitude,
                        //     lng: location.longitude,
                        //     buildingType: selectedHouseType,
                        //   );
                        // } else {
                        //   addaddressControllerProvider.addAddress(
                        //     name: _nameController.text,
                        //     streetName: _streetNameController.text,
                        //     lat: location!.latitude,
                        //     lng: location.longitude,
                        //     buildingType: selectedHouseType,
                        //   );
                        // }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
