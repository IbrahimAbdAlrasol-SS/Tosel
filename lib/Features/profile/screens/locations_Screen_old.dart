import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:Tosell/core/constants/spaces.dart';
import 'package:Tosell/core/widgets/CustomAppBar.dart';

class LocationsScreenOld extends ConsumerStatefulWidget {
  final String PageTitle;
  const LocationsScreenOld({super.key, required this.PageTitle});

  @override
  ConsumerState<LocationsScreenOld> createState() => _LocationsScreenOldState();
}

class _LocationsScreenOldState extends ConsumerState<LocationsScreenOld> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // await ref
    // .read(addressControllerProvider.notifier)
    // .getAddresses(page: 1, isLoadMore: false);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // final state = ref.read(addressControllerProvider);
    // if (state.pagination != null &&
    // state.pagination!.totalPages >= (state.pagination!.currentPage ?? 1)) {
    // await ref.read(addressControllerProvider.notifier).getAddresses(
    //       page: (state.pagination!.currentPage ?? 1),
    //       isLoadMore: true,
    //     );
    // _refreshController.loadComplete();
    // } else {
    // _refreshController.loadNoData();
    // }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    // var addressProvider = ref.watch(addressControllerProvider);

    return Scaffold(
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        footer: CustomFooter(
          builder: (BuildContext context, LoadStatus? mode) {
            if (mode == LoadStatus.noMore) {
              return Container(height: 0);
            }
            if (mode == LoadStatus.idle) {
              return Container(height: 0); // Empty when idle
            } else if (mode == LoadStatus.loading) {
              return const Center(
                  child:
                      CircularProgressIndicator()); // Circular progress during loading
            } else if (mode == LoadStatus.failed) {
              return const Center(
                  child: Text("فشل")); // Show message if loading fails
            } else if (mode == LoadStatus.canLoading) {
              return const Center(child: Text("اسحب لجلب المزيد"));
            } else {
              return Container(); // Hide when there is no data to load
            }
          },
        ),
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
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: AppSpaces.horizontalMedium,
                  itemCount: 1,
                  itemBuilder: (context, index) =>
                      //   buildAddressCart(
                      //       addressProvider.addresses[index], theme),
                      // )
                      // :
                      const Center(child: Text("لا يوجد عناوين محفوظة")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget buildAddressCart(Address address, ThemeData theme) {
  //   return Container(
  //     margin: EdgeInsets.only(bottom: 12),
  //     padding: EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(32),
  //       border: Border.all(
  //         color: Color(0xFFF1F2F4), // specify the border color
  //         width: 1,
  //       ),
  //     ),
  //     child: Row(
  //       children: [
  //         Padding(
  //           padding: const EdgeInsets.only(left: 8.0),
  //           //? Location Icon
  //           child: Container(
  //             padding: EdgeInsets.all(8),
  //             decoration: BoxDecoration(
  //               color: Color(0xFFEDE7F6),
  //               shape: BoxShape.circle,
  //             ),
  //             child: SvgPicture.asset(
  //               "assets/svg/savedLocation.svg",
  //               color: theme.colorScheme.primary,
  //             ),
  //           ),
  //         ),
  //         //? Location Name and Address
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 address.name ?? "",
  //                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  //               ),
  //               SizedBox(height: 4),
  //               Text(
  //                 address.streetName ?? "",
  //                 style: TextStyle(fontSize: 14, color: Colors.grey),
  //               ),
  //             ],
  //           ),
  //         ),
  //         //? Edit Icon
  //         IconButton(
  //           icon: SvgPicture.asset(
  //             "assets/svg/pin.svg",
  //             color: Color(0xFFDBBC06),
  //           ),
  //           onPressed: () {
  //             showModalBottomSheet(
  //                 isScrollControlled: true,
  //                 context: context,
  //                 builder: (BuildContext context) {
  //                   return GestureDetector(
  //                     child: Container(
  //                         child: AddAdressSheet(
  //                       address: address,
  //                       isEditing: true,
  //                     )),
  //                   );
  //                 });
  //           },
  //         ),
  //         //? Delete Icon
  //         IconButton(
  //           icon: SvgPicture.asset(
  //             "assets/svg/trash.svg",
  //             color: Color(0xFFD54444),
  //           ),
  //           onPressed: () {},
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
