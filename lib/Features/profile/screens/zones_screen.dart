import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:Tosell/core/utils/extensions.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/router/app_router.dart';
import 'package:Tosell/core/widgets/FillButton.dart';
import 'package:Tosell/core/widgets/CustomAppBar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Tosell/Features/profile/models/zone.dart';
import 'package:Tosell/Features/order/widgets/adress_sheet.dart';
import 'package:Tosell/core/helpers/SharedPreferencesHelper.dart';
import 'package:Tosell/Features/profile/providers/zone_provider.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';

class ZonesScreen extends ConsumerStatefulWidget {
  final String PageTitle;
  const ZonesScreen({super.key, required this.PageTitle});

  @override
  ConsumerState<ZonesScreen> createState() => _ZonesScreenState();
}

class _ZonesScreenState extends ConsumerState<ZonesScreen> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {}

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var zonesState = ref.watch(zoneNotifierProvider);
    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        // footer: CustomFooter(
        //   builder: (BuildContext context, LoadStatus? mode) {
        //     if (mode == LoadStatus.noMore) {
        //       return Container(height: 0);
        //     }
        //     if (mode == LoadStatus.idle) {
        //       return Container(height: 0); // Empty when idle
        //     } else if (mode == LoadStatus.loading) {
        //       return const Center(
        //           child:
        //               CircularProgressIndicator()); // Circular progress during loading
        //     } else if (mode == LoadStatus.failed) {
        //       return const Center(
        //           child: Text("فشل")); // Show message if loading fails
        //     } else if (mode == LoadStatus.canLoading) {
        //       return const Center(child: Text("اسحب لجلب المزيد"));
        //     } else {
        //       return Container(); // Hide when there is no data to load
        //     }
        //   },
        // ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomAppBar(
                  title: widget.PageTitle,
                  showBackButton: true,
                ),
                // addressProvider.isFetching
                //     ? Center(child: CircularProgressIndicator())
                //     : addressProvider.addresses.isNotEmpty
                zonesState.when(
                  data: (data) => _buildUi(data),
                  loading: () =>
                      const Center(child: const CircularProgressIndicator()),
                  error: (error, stackTrace) => Center(
                    child: Text(error.toString()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: AppSpaces.allMedium,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: Theme.of(context).colorScheme.outline,
            ),
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20))),
        child: Expanded(
          child: FillButton(
            color: context.colorScheme.primary,
            icon: SvgPicture.asset(
              "assets/svg/navigation_add.svg",
              color: Colors.white,
            ),
            reverse: true,
            label: "إضافة عنوان جديد",
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return GestureDetector(
                      child: Container(
                          child: AdressSheet(
                        isEditing: false,
                      )),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }

  ListView _buildUi(List<Zone> zones) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: AppSpaces.horizontalMedium,
      itemCount: zones.length,
      itemBuilder: (context, index) =>
          buildZoneCart(zones[index], Theme.of(context)),
    );
  }

  Widget buildZoneCart(Zone zone, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFFF1F2F4), // specify the border color
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            //? Location Icon
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFEDE7F6),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                "assets/svg/savedLocation.svg",
                color: theme.colorScheme.primary,
              ),
            ),
          ),
          //? Location Name and Address
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  zone.name ?? 'لايوجد',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  zone.governorate?.name ?? 'لايوجد',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          //? Edit Icon
          IconButton(
            icon: SvgPicture.asset(
              "assets/svg/pin.svg",
              color: const Color(0xFFFFE500),
            ),
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return GestureDetector(
                      child: Container(
                          child: AdressSheet(
                        // address: address,
                        isEditing: true,
                      )),
                    );
                  });
            },
          ),
          //? Delete Icon
          IconButton(
            icon: SvgPicture.asset(
              "assets/svg/49. TrashSimple.svg",
              color: const Color(0xffE96363),
            ),
            onPressed: () {
              
            },
          ),
        ],
      ),
    );
  }
}
