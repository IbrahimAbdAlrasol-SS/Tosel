import 'package:Tosell/Features/profile/models/transaction.dart';
import 'package:Tosell/Features/profile/models/transaction_enum.dart';
import 'package:Tosell/Features/profile/providers/transaction_provider.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/router/app_router.dart';
import 'package:Tosell/core/widgets/CustomAppBar.dart';
import 'package:Tosell/core/widgets/CustomTextFormField.dart';
import 'package:Tosell/core/widgets/TrianglePainter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class TransactionsScreen extends ConsumerWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var transactionState = ref.watch(transactionNotifierProvider);
    return Scaffold(
      body: transactionState.when(
        data: (data) => buildUi(context, data),
        error: (error, _) => Center(child: Text(error.toString())),
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  SafeArea buildUi(BuildContext context, List<Transaction> transactions) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child: Column(
          children: [
            const CustomAppBar(
              title: 'سجل المعاملات المالية',
              showBackButton: true,
            ),
            const Gap(AppSpaces.medium),
            Row(
              children: [
                // search
                Expanded(
                  child: CustomTextFormField(
                    label: '',
                    showLabel: false,
                    hint: 'تاريخ المعاملة',
                    suffixInner: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset(
                        'assets/svg/CalendarBlank.svg',
                        color: Theme.of(context).colorScheme.primary,
                        width: 3,
                        height: 3,
                      ),
                    ),
                  ),
                ),
                const Gap(AppSpaces.medium),
                GestureDetector(
                  onTap: () {},
                  child: Stack(
                    clipBehavior: Clip.none,
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
                          padding: const EdgeInsets.all(10.0),
                          child: SvgPicture.asset(
                            'assets/svg/Funnel.svg',
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Gap(AppSpaces.large),

            // Wrap ListView with Expanded
            Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) => Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  child: buildItem(
                    context,
                    title: transactions[index].amount?.toString() ?? '0',
                    date:
                        '${DateTime.parse(transactions[index].creationDate!).day.toString()}.${DateTime.parse(transactions[index].creationDate!).month.toString()}.${DateTime.parse(transactions[index].creationDate!).year.toString()}',
                    iconPath: "assets/svg/SpinnerGap.svg",
                    iconColor: const Color(0xFFFFE500),
                    state: transactionStates[transactions[index].type ?? 0],
                    onTap: () => GoRouter.of(context).push(
                        AppRoutes.TransactionDetails,
                        extra: transactions[index]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(
    BuildContext context, {
    String? title,
    String? date,
    String? iconPath,
    Color? iconColor,
    GestureTapCallback? onTap,
    required TransactionEnum state,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65,
        padding: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(1000),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(right: 6.0, left: 6, bottom: 2),
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(4.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Theme.of(context).colorScheme.surface,
                      border: Border.all(
                          color: Theme.of(context).colorScheme.outline),
                    ),
                    child: state.icon,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title ?? "",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: state.screenTitleColor,
                          )),
                      Text(
                        date ?? '',
                        // "${date.day}.${date.month}.${date.year}",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Container(
                  width: 100,
                  height: 26,
                  decoration: BoxDecoration(
                    color: state.color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      state.screenTitle ?? "لايوجد",
                    ),
                  ),
                ),
                const Gap(AppSpaces.medium),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  // child: SvgPicture.asset(
                  //   "assets/svg/CaretDown.svg",
                  //   color: Theme.of(context).colorScheme.primary,
                  // ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: CustomPaint(
                      size: const Size(16, 16),
                      painter: TrianglePainter(),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
