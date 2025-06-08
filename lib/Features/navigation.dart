import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:Tosell/core/router/app_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_barcode_scanner/barcode_appbar.dart';
import 'package:Tosell/core/widgets/background_wrapper.dart';
import 'package:Tosell/core/helpers/SharedPreferencesHelper.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class NavigationPage extends ConsumerStatefulWidget {
  final Widget child;
  const NavigationPage({super.key, required this.child});

  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
  int _selectedIndex = 0;

  final List<String> locations = [
    AppRoutes.home,
    AppRoutes.orders,
    AppRoutes.addOrder,
    AppRoutes.statistics,
    AppRoutes.myProfile,
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentLocation = GoRouterState.of(context).uri.toString();

    final matchedIndex = locations.indexWhere(
      (route) => currentLocation.startsWith(route),
    );

    if (matchedIndex != -1 && matchedIndex != _selectedIndex) {
      setState(() {
        _selectedIndex = matchedIndex;
      });
    }
  }

  void onItemTapped(int index) {
    if (_selectedIndex == index) return;

    setState(() {
      _selectedIndex = index;
    });

    context.go(locations[index]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedPreferencesHelper.getUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;

        return Scaffold(
          body: BackgroundWrapper(child: widget.child),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: true,
            selectedFontSize: 12.sp,
            unselectedFontSize: 12.sp,
            unselectedItemColor: Theme.of(context).colorScheme.secondary,
            onTap: onItemTapped,
            items: [
              _buildNavItem("assets/svg/navigation_home.svg", "الرئيسية", 0),
              _buildNavItem("assets/svg/navigation_box.svg", "الطلبات", 1),
              _buildNavItem("assets/svg/navigation_add.svg", "جديد", 2),
              _buildNavItem("assets/svg/navigation_statstic.svg", "الإحصائيات", 3),
              _buildNavItem("assets/svg/navigation_profile.svg", "الإعدادات", 4),
            ],
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildNavItem(String icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;

    return BottomNavigationBarItem(
      icon: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 35.w,
            height: 35.w,
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : index == 2 || index == 5
                      ? Theme.of(context).colorScheme.primary.withAlpha(20)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(125),
            ),
          ),
          SvgPicture.asset(
            icon,
            width: 20,
            colorFilter: isSelected
                ? const ColorFilter.mode(Colors.white, BlendMode.srcIn)
                : index == 2 || index == 5
                    ? const ColorFilter.mode(Color(0xFF0C6E4C), BlendMode.srcIn)
                    : ColorFilter.mode(
                        Theme.of(context).colorScheme.secondary,
                        BlendMode.srcIn,
                      ),
          ),
        ],
      ),
      label: label,
    );
  }

  Future<String?> scanBarcode(BuildContext context) async {
    String? res = await SimpleBarcodeScanner.scanBarcode(
      context,
      barcodeAppBar: const BarcodeAppBar(
        appBarTitle: 'Scan',
        centerTitle: false,
        enableBackButton: true,
        backButtonIcon: Icon(Icons.arrow_back_ios),
      ),
      isShowFlashIcon: true,
      delayMillis: 2000,
      cameraFace: CameraFace.back,
    );
    return res;
  }
}


