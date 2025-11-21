// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:mediconsult/core/theming/app_colors.dart';
// import 'package:mediconsult/features/network/data/network_provider_response_model.dart';

// class ProvidersMapView extends StatefulWidget {
//   final List<NetworkProvider> providers;
//   final LatLng? userLocation;
//   final Function(NetworkProvider)? onProviderTap;

//   const ProvidersMapView({
//     super.key,
//     required this.providers,
//     this.userLocation,
//     this.onProviderTap,
//   });

//   @override
//   State<ProvidersMapView> createState() => _ProvidersMapViewState();
// }

// class _ProvidersMapViewState extends State<ProvidersMapView> {
//   final MapController _mapController = MapController();
//   NetworkProvider? _selectedProvider;

//   @override
//   void initState() {
//     super.initState();
//     // Don't auto-center on init, let the map load first
//   }

//   @override
//   void didUpdateWidget(ProvidersMapView oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.userLocation != oldWidget.userLocation ||
//         widget.providers != oldWidget.providers) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (mounted) {
//           _centerMapOnUserOrProviders();
//         }
//       });
//     }
//   }

//   void _centerMapOnUserOrProviders() {
//     try {
//       if (widget.userLocation != null) {
//         _mapController.move(widget.userLocation!, 13.0);
//       } else if (widget.providers.isNotEmpty) {
//         final firstProvider = widget.providers.first;
//         _mapController.move(
//           LatLng(firstProvider.latitude, firstProvider.longitude),
//           12.0,
//         );
//       }
//     } catch (e) {
//       // Map controller not ready yet
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         FlutterMap(
//           mapController: _mapController,
//           options: MapOptions(
//             initialCenter: widget.userLocation ??
//                 (widget.providers.isNotEmpty
//                     ? LatLng(
//                         widget.providers.first.latitude,
//                         widget.providers.first.longitude,
//                       )
//                     : const LatLng(30.0444, 31.2357)), // Cairo default
//             initialZoom: 12.0,
//             minZoom: 5.0,
//             maxZoom: 18.0,
//             onMapReady: () {
//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 if (mounted) {
//                   _centerMapOnUserOrProviders();
//                 }
//               });
//             },
//           ),
//           children: [
//             // Map Tiles
//             TileLayer(
//               urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//               userAgentPackageName: 'com.mediconsult.app',
//               maxZoom: 19,
//             ),

//             // Markers Layer
//             MarkerLayer(
//               markers: [
//                 // User location marker
//                 if (widget.userLocation != null)
//                   Marker(
//                     point: widget.userLocation!,
//                     width: 40.w,
//                     height: 40.h,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: AppColors.primaryClr,
//                         shape: BoxShape.circle,
//                         border: Border.all(
//                           color: AppColors.whiteClr,
//                           width: 3.w,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: AppColors.primaryClr.withValues(alpha: 0.3),
//                             blurRadius: 8.r,
//                             spreadRadius: 2.r,
//                           ),
//                         ],
//                       ),
//                       child: Icon(
//                         Icons.person,
//                         color: AppColors.whiteClr,
//                         size: 20.sp,
//                       ),
//                     ),
//                   ),

//                 // Provider markers
//                 ...widget.providers.map((provider) {
//                   final isSelected = _selectedProvider?.providerId == provider.providerId;
//                   return Marker(
//                     point: LatLng(provider.latitude, provider.longitude),
//                     width: isSelected ? 50.w : 40.w,
//                     height: isSelected ? 50.h : 40.h,
//                     child: GestureDetector(
//                       onTap: () {
//                         setState(() {
//                           _selectedProvider = provider;
//                         });
//                         widget.onProviderTap?.call(provider);
//                         _mapController.move(
//                           LatLng(provider.latitude, provider.longitude),
//                           15.0,
//                         );
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           color: isSelected
//                               ? AppColors.successClr
//                               : AppColors.errorClr,
//                           shape: BoxShape.circle,
//                           border: Border.all(
//                             color: AppColors.whiteClr,
//                             width: 3.w,
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: (isSelected
//                                       ? AppColors.successClr
//                                       : AppColors.errorClr)
//                                   .withValues(alpha: 0.3),
//                               blurRadius: 8.r,
//                               spreadRadius: 2.r,
//                             ),
//                           ],
//                         ),
//                         child: Icon(
//                           Icons.local_hospital,
//                           color: AppColors.whiteClr,
//                           size: isSelected ? 24.sp : 20.sp,
//                         ),
//                       ),
//                     ),
//                   );
//                 }),
//               ],
//             ),
//           ],
//         ),

//         // Recenter button
//         Positioned(
//           bottom: 20.h,
//           right: 20.w,
//           child: FloatingActionButton(
//             mini: true,
//             backgroundColor: AppColors.whiteClr,
//             onPressed: _centerMapOnUserOrProviders,
//             child: Icon(
//               Icons.my_location,
//               color: AppColors.primaryClr,
//               size: 20.sp,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
