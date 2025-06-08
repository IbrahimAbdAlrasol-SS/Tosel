import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/constants/spaces.dart';

class AddressesList extends StatefulWidget {
  // final List<Address> addresses;

  const AddressesList({super.key});

  @override
  State<AddressesList> createState() => _AddressesListState();
}

class _AddressesListState extends State<AddressesList> {
  // List<Address> addresses = [];

  // Address? selectedAddress;

  @override
  void initState() {
 
    // addresses = widget.addresses;
    // selectedAddress = addresses.first;
    super.initState();
  }

  // change selected address

  // void changeSelectedAddress(Address address) {
  //   setState(() {
  //     selectedAddress = address;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // horizontal list view
      height: 55.h,
      child: ListView.separated(
        itemCount: 1,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return const Gap(AppSpaces.medium);
        },
        itemBuilder: (context, index) {
          return Container(
            width: 200.w,
            padding: AppSpaces.allSmall,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // radio button for selecting address

                // Radio<Address>(
                //   value: widget.addresses[index],
                //   groupValue: selectedAddress,
                //   onChanged: (value) {
                //     changeSelectedAddress(value!);
                //   },
                // ),

                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    CupertinoIcons.map_pin,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Gap(AppSpaces.small),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "العنوان الاول",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      "العنوان الاول",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
