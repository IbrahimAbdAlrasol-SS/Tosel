// import 'package:Toseel/core/constants/spaces.dart';
// import 'package:Toseel/core/widgets/FillButton.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

// import '../../application/providers/location_provider.dart';

// class SelectLocationScreen extends ConsumerStatefulWidget {
//   const SelectLocationScreen({super.key});

//   @override
//   ConsumerState<ConsumerStatefulWidget> createState() =>
//       _SelectLocationScreenState();
// }

// class _SelectLocationScreenState extends ConsumerState<SelectLocationScreen> {
//   GoogleMapController? _mapController;

//   @override
//   void initState() {
//     super.initState();
//     _determinePosition();
//   }

//   Future<void> _determinePosition() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Enable location services to continue")),
//       );
//       return;
//     }

//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Location permission denied")),
//         );
//         return;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text("Location permissions are permanently denied")),
//       );
//       return;
//     }

//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );

//     LatLng userLocation = LatLng(position.latitude, position.longitude);

//     ref.read(locationProvider.notifier).setLocation(userLocation);

//     _mapController?.animateCamera(CameraUpdate.newLatLng(userLocation));
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//   }

//   void _onMarkerDrag(LatLng newPosition) {
//     ref.read(locationProvider.notifier).setLocation(newPosition);
//   }

//   void _confirmLocation() {
//     final selectedLocation = ref.read(locationProvider);
//     if (selectedLocation == null) return;
//     Navigator.pop(context, selectedLocation); // Return the selected location
//   }

//   @override
//   Widget build(BuildContext context) {
//     final selectedLocation = ref.watch(locationProvider);

//     return Scaffold(
//         appBar: AppBar(title: const Text("اختر العنوان")),
//         body: selectedLocation == null
//             ? const Center(child: CircularProgressIndicator())
//             : GoogleMap(
//                 onMapCreated: _onMapCreated,
//                 initialCameraPosition: CameraPosition(
//                   target: selectedLocation,
//                   zoom: 15.0,
//                 ),
//                 onCameraMove: (CameraPosition position) {
//                   ref
//                       .read(locationProvider.notifier)
//                       .setLocation(position.target);
//                 },
//                 markers: {
//                   Marker(
//                     markerId: const MarkerId("selected-location"),
//                     position: selectedLocation,
//                     draggable: true,
//                     onDragEnd: _onMarkerDrag,
//                   ),
//                 },
//               ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//         floatingActionButton: Padding(
//           padding: AppSpaces.horizontalMedium,
//           child: FillButton(label: "تأكيد", onPressed: _confirmLocation),
//         ));
//   }
// }
