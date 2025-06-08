import 'package:Tosell/Features/order/screens/order_details_screen.dart';
import 'package:Tosell/Features/profile/models/transaction.dart';
import 'package:Tosell/Features/profile/models/transaction_enum.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/widgets/CustomAppBar.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:Tosell/core/widgets/custom_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TransactionDetailsScreen extends ConsumerWidget {
  final Transaction transaction;
  const TransactionDetailsScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var date = DateTime.parse(transaction.creationDate!);
    var state = transactionStates[transaction.type!];
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const CustomAppBar(
                title: 'تفاصيل سجل المعاملات',
                showBackButton: true,
              ),
              CustomSection(
                title: "معلومات المعاملة",
                icon: SvgPicture.asset(
                  "assets/svg/Receipt.svg",
                  color: Theme.of(context).colorScheme.primary,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                childrenRadius: const BorderRadius.all(Radius.circular(16)),
                children: [
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildOrderSection("رقم المعاملة",
                            "assets/svg/HashStraight.svg", Theme.of(context),
                            padding: const EdgeInsets.only(bottom: 3, top: 3),
                            subWidget: const Text('لايوجد')),
                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const Gap(AppSpaces.small),
                        buildOrderSection(
                          "حالة الطلب",
                          "assets/svg/SpinnerGap.svg",
                          Theme.of(context),
                          padding: const EdgeInsets.only(bottom: 3, top: 3),
                          subWidget: Container(
                            width: 100,
                            height: 26,
                            decoration: BoxDecoration(
                              color: state.color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(state.screenTitle!),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildOrderSection(
                          "التاريخ",
                          "assets/svg/CalendarBlank.svg",
                          Theme.of(context),
                          padding: const EdgeInsets.only(bottom: 3, top: 3),
                          subWidget:
                              Text("${date.day}.${date.month}.${date.year}"),
                        ),
                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const Gap(AppSpaces.small),
                        buildOrderSection(
                          "السعر",
                          "assets/svg/coines.svg",
                          Theme.of(context),
                          padding: const EdgeInsets.only(bottom: 3, top: 3),
                          subWidget:
                              Text(transaction.amount?.toString() ?? 'لايوجد'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CustomSection(
                title: "معلومات الزبون",
                icon: SvgPicture.asset(
                  "assets/svg/User.svg",
                  color: Theme.of(context).colorScheme.primary,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                childrenRadius: const BorderRadius.all(Radius.circular(16)),
                children: [
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildOrderSection("أسم الزبون",
                            "assets/svg/UserCircle.svg", Theme.of(context),
                            padding: const EdgeInsets.only(bottom: 3, top: 3),
                            subWidget:
                                Text(transaction.senderName ?? 'لايوجد')),
                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const Gap(AppSpaces.small),
                        buildOrderSection("رقم الهاتف", "assets/svg/Phone.svg",
                            Theme.of(context),
                            padding: const EdgeInsets.only(bottom: 3, top: 3),
                            subWidget: const Text('لايوجد')),
                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                      ],
                    ),
                  ),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildOrderSection(
                          "المحافظة",
                          "assets/svg/MapPinLine.svg",
                          Theme.of(context),
                          padding: const EdgeInsets.only(bottom: 3, top: 3),
                          subWidget: const Text("لايوجد"),
                        ),
                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const Gap(AppSpaces.small),
                        buildOrderSection(
                          "المنطقة",
                          "assets/svg/MapPinArea.svg",
                          Theme.of(context),
                          padding: const EdgeInsets.only(bottom: 3, top: 3),
                          subWidget: const Text("لايوجد"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              CustomSection(
                title: "معلومات المنتج",
                icon: SvgPicture.asset(
                  "assets/svg/box.svg",
                  color: Theme.of(context).colorScheme.primary,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                childrenRadius: const BorderRadius.all(Radius.circular(16)),
                children: [
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildOrderSection(
                            "النوع", "assets/svg/Cards.svg", Theme.of(context),
                            padding: const EdgeInsets.only(bottom: 3, top: 3),
                            subWidget: const Text("لايوجد")),
                        VerticalDivider(
                          width: 1,
                          thickness: 1,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const Gap(AppSpaces.small),
                        buildOrderSection("الحجم", "assets/svg/BoundingBox.svg",
                            Theme.of(context),
                            padding: const EdgeInsets.only(bottom: 3, top: 3),
                            subWidget: const Text("لايوجد")),
                      ],
                    ),
                  ),
                ],
              ),
              _buildTransactionState(context, state),
              const Gap(AppSpaces.small),
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
                child: Expanded(
                  child: FillButton(
                    color: Theme.of(context).colorScheme.primary,
                    label: "تواصل مع الدعم الفني",
                    reverse: true,
                    icon: Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: SvgPicture.asset(
                        'assets/svg/support.svg',
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () => GoRouter.of(context).pop(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  CustomSection _buildTransactionState(
      BuildContext context, TransactionEnum state) {
    return CustomSection(
      title: "حالة المعاملة",
      icon: SvgPicture.asset(
        'assets/svg/ArrowsDownUp.svg',
        color: Theme.of(context).colorScheme.primary,
      ),
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 8),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: Padding(
                      padding: const EdgeInsets.all(8.0), child: state.icon),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.title!,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: state.titleColor,
                          fontFamily: "Tajawal",
                        ),
                      ),
                      Text(
                        state.subTitle!,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).colorScheme.onSurface,
                          fontFamily: "Tajawal",
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
