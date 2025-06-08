import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:Tosell/core/widgets/OutlineButton.dart';

class OrderRatingScreen extends StatefulWidget {
  const OrderRatingScreen({super.key});

  @override
  State<OrderRatingScreen> createState() => _OrderRatingScreenState();
}

class _OrderRatingScreenState extends State<OrderRatingScreen> {
  final TextEditingController _otherReasonController = TextEditingController();
  int _rating = 0;
  bool isRated = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(top: AppSpaces.medium),
          sliver: SliverToBoxAdapter(
            child: Row(
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
          ),
        ),
        SliverPadding(
          padding: AppSpaces.horizontalMedium,
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "تقييم الطلب",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.primary,
                  ),
                ),
                const Gap(AppSpaces.exSmall),
                const Divider(thickness: 0.1),
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/svg/rating.gif",
                        width: 150.w,
                      ),
                      Text(
                        isRated == false
                            ? "كيف كانت تجربتك معنا؟  "
                            : "شكرًا لك!",
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        isRated == false
                            ? "تقييمك سيساهم في تحسين خدماتنا و تجربتك في استخدام أكسير"
                            : "تم إرسال تقييمك بنجاح. نقدر مساهمتك في تحسين خدماتنا.",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      const Gap(AppSpaces.exSmall),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                          (index) => GestureDetector(
                            onTap: () {
                              setState(() {
                                _rating = 5 - index;
                                isRated = true;

                                // Scroll the view with a smooth transition
                                Future.delayed(
                                  const Duration(
                                      milliseconds:
                                          500), // Delay for smooth transition
                                  () {
                                    _scrollController.animateTo(
                                      _scrollController
                                          .position.maxScrollExtent,
                                      duration: const Duration(
                                          milliseconds:
                                              1500), // Smooth scrolling duration
                                      curve: Curves.easeOut,
                                    );
                                  },
                                );
                              });
                            },
                            child: Icon(
                              index >= 5 - _rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: const Color(0xFFDBBC06),
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      isRated == true
                          ? _buildSuggestionField(theme, _otherReasonController)
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Animated Padding section after rating
        if (isRated)
          SliverPadding(
            padding: EdgeInsets.only(top: 20.h),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: AppSpaces.allMedium,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedCustomButton(
                        borderColor: theme.outline,
                        label: "غلق",
                        textColor: theme.secondary,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    const Gap(AppSpaces.medium),
                    Expanded(
                      child: FillButton(
                        color: theme.primary,
                        label: "ارسال التقييم",
                        onPressed: () {
                  
                        },
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

  Widget _buildSuggestionField(
      ColorScheme theme, TextEditingController otherReasonController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Gap(AppSpaces.small),
        Text(
          "هل لديك أي شكوى او اقتراحات لتحسين خدماتنا؟ ",
          style: TextStyle(
            fontSize: 16,
            color: theme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: otherReasonController,
          maxLines: 3,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32),
              borderSide: BorderSide(
                color: theme.outline,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
