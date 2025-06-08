import 'package:gap/gap.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:Tosell/core/router/app_router.dart';
import 'package:Tosell/core/widgets/CustomAppBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:Tosell/Features/auth/register/screens/user_info_tab.dart';
import 'package:Tosell/Features/auth/register/widgets/build_background.dart';
import 'package:Tosell/Features/auth/register/screens/delivery_info_tab.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      if (_tabController.index != _currentIndex) {
        setState(() {
          _currentIndex = _tabController.index;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            _buildBackgroundSection(),
            _buildBottomSheetSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundSection() {
    return Column(
      children: [
        Expanded(
          child: buildBackground(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(25),
                 CustomAppBar(
                          // title: "إنشاء حساب",
                          titleWidget: Text('تسجيل دخول', style: context.textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 16
                          ),) ,
                          showBackButton: true,
                          onBackButtonPressed: () =>context.push(AppRoutes.login),
                        ),
                _buildLogo(),
                const Gap(10),
                _buildTitle(),
                _buildDescription(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: SvgPicture.asset("assets/svg/Logo.svg"),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "انشاء حساب جديد",
        textAlign: TextAlign.right,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 32,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        "مرحبا بك في منصة توصيل، قم بادخال المعلومات ادناه و سيتم انشاء حساب لمتجرك بعد الموافقة و التفعيل.",
        textAlign: TextAlign.right,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildBottomSheetSection() {
    return DraggableScrollableSheet(
      initialChildSize: 0.69,
      minChildSize: 0.69,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            // physics: const NeverScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Gap(20),
                _buildTabBar(),
                _buildTabBarView(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: TabBar(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        indicator: const BoxDecoration(),
        labelPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        tabs: List.generate(2, (i) {
          final bool isSelected = _currentIndex == i;
          final String label = i == 0 ? "معلومات الحساب" : "معلومات التوصيل";

          return Tab(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 8,
                  width: 160.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : _currentIndex == 1 ? const Color(0xff8CD98C) :   const Color(0xffE1E7EA),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : _currentIndex == 1 ? const Color(0xff8CD98C) :  Theme.of(context).colorScheme.secondary,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTabBarView() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: TabBarView(
        controller: _tabController,
        children: const [
          UserInfoTab(),
          DeliveryInfoTab(),
        ],
      ),
    );
  }
}