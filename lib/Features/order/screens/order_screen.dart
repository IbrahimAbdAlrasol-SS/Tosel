import 'package:gap/gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:Tosell/core/widgets/CustomAppBar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/core/widgets/OutlineButton.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tosell/core/widgets/CustomTextFormField.dart';
import 'package:Tosell/Features/order/widgets/adress_sheet.dart';
import 'package:Tosell/Features/order/widgets/delivery_options.dart';
import 'package:Tosell/Features/order/widgets/order_cart_header.dart';
import 'package:Tosell/Features/order/widgets/order_product_widget.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  bool isFastDelivery = false; // Default selection

  void handleDeliveryOptionChange(bool value) {
    setState(() {
      isFastDelivery = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var addressControler = ref.watch(addressControllerProvider);

    // print(addressControler.addresses);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: SafeArea(
            child: Column(
          children: [
            const CustomAppBar(
              title: "اتمام الطلب",
              showBackButton: true,
              actions: [],
            ),
            Padding(
              padding: AppSpaces.horizontalMedium,
              child: Column(
                children: [
                  // if (addressControler.addresses.isNotEmpty)
                  OrderCartHeader(
                    title: "عنوان التسليم",
                    icon: Icon(
                      CupertinoIcons.map_pin,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    actions: const [
                      // AddressesList(addresses: addressControler.addresses),
                    ],
                    headerActions: const [AddAdressButton()],
                  ),
                  // if (addressControler.addresses.isEmpty)
                  OrderCartHeader(
                    icon: const Icon(CupertinoIcons.map),
                    title: "عنوان التوصيل",
                    actions: [
                      Text(
                        "لم تقم بإضافة عنوان توصيل حتى الآن. الرجاء إضافة عنوان جديد لإتمام عملية الطلب.",
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const Gap(AppSpaces.medium),
                      const AddAdressButton()
                    ],
                  ),
                  const Gap(AppSpaces.medium),
                  OrderCartHeader(
                    icon: Icon(
                      CupertinoIcons.car,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: "طريقة التوصيل",
                    actions: [
                      DeliveryOption(
                        selectedValue: isFastDelivery,
                        onChanged: handleDeliveryOptionChange,
                      ),
                    ],
                  ),
                  const Gap(AppSpaces.medium),
                  OrderCartHeader(
                    icon: Icon(
                      CupertinoIcons.creditcard,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: "الدفع من خلال",
                    actions: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Theme.of(context).colorScheme.outline,
                              width: 0.5),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Row(
                          children: [
                            Radio<bool>(
                              value: true,
                              groupValue: true,
                              onChanged: (value) => {},
                            ),
                            SvgPicture.asset("assets/svg/wallet.svg",
                                width: 20.sp),
                            const Gap(AppSpaces.small),
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "دفع عند الاستلام (نقدا)",
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Gap(AppSpaces.medium),
                  OrderCartHeader(
                    icon: SvgPicture.asset("assets/svg/discount.svg",
                        width: 25.sp),
                    title: "خصم",
                    actions: [
                      Row(
                        children: [
                          const Expanded(
                              child: CustomTextFormField(
                            label: "كود الخصم",
                            hint: "ادخل كود الخصم هنا",
                            showLabel: false,
                          )),
                          const Gap(AppSpaces.small),
                          OutlinedCustomButton(
                            label: "تفعيل",
                            onPressed: () {},
                            height: 50.sp,
                          )
                        ],
                      )
                    ],
                  ),
                  const Gap(AppSpaces.medium),
                  OrderCartHeader(
                    icon: Icon(
                      CupertinoIcons.shopping_cart,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: "قائمة المشتريات",
                    actions: [
                      ListView.separated(
                        separatorBuilder: (BuildContext context, int index) {
                          return const Gap(AppSpaces.medium);
                        },
                        itemBuilder: (BuildContext context, int pos) {
                          return const OrderProductWidget();
                        },
                        itemCount: 3,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      ),
                    ],
                  ),
                  const Gap(AppSpaces.medium),
                  OrderCartHeader(
                    icon: SvgPicture.asset(
                      "assets/svg/invoice.svg",
                      width: 20.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: "تفاصيل الفاتورة",
                    actions: const [CartInvoiceWidget()],
                  ),
                ],
              ),
            ),
            const Gap(AppSpaces.medium),
            Container(
              padding: AppSpaces.allMedium,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: FillButton(
                  label: "تأكيد الطلب",
                  onPressed: () {
                    context.go('/orderCompleted');
                  }),
            ),
          ],
        )),
      ),
    );
  }
}

class AddAdressButton extends StatelessWidget {
  const AddAdressButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedCustomButton(
        label: "اضافة عنوان جديد",
        onPressed: () {
          showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (BuildContext context) {
                return GestureDetector(
                  child: Container(child: const AdressSheet()),
                );
              });
        },
        icon: const Icon(CupertinoIcons.plus),
        width: 180.w);
  }
}

class CartInvoiceWidget extends StatelessWidget {
  const CartInvoiceWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("مجموع المنتجات",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    )),
            Text("4", style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const Gap(AppSpaces.exSmall),
        const Divider(thickness: 0.1),
        const Gap(AppSpaces.exSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("مبلغ التوصيل",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    )),
            Text("5,000 د.ع", style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const Gap(AppSpaces.exSmall),
        const Divider(thickness: 0.1),
        const Gap(AppSpaces.exSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("مبلغ الخصم",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.secondary,
                    )),
            Text("0 د.ع", style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
        const Gap(AppSpaces.exSmall),
        const Divider(thickness: 0.1),
        const Gap(AppSpaces.exSmall),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("المجموع الكلي",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            Text("5,000 د.ع",
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
          ],
        ),
      ],
    );
  }
}
