// import 'dart:convert';
// import 'package:dashboard_fixup/activity_point/models/model_manager_activities.dart';
// import 'package:dashboard_fixup/activity_point/services/api.dart';
// import 'package:dashboard_fixup/activity_point/widgets/container_score.dart';
// import 'package:dashboard_fixup/activity_point/widgets/image_fullscreen.dart';
// import 'package:dashboard_fixup/activity_point/widgets/view_map.dart';
// import 'package:dashboard_fixup/dashboard_fixup/widgets/snackbar_info.dart';
// import 'package:flutter/material.dart';

// class CardActivity extends StatefulWidget {
//   const CardActivity(this.judul, this.warna, this.model, {super.key});
//   final String judul;
//   final Color warna;
//   final ModelManagerActivities model;

//   @override
//   State<CardActivity> createState() => _CardActivityState();
// }

// class _CardActivityState extends State<CardActivity> {
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }

//   void updatePoin1(bool val) async {
//     try {
//       await ApiPoint.updateScore(val ? 1 : 0, null, null, widget.model, 'ARMA VIEYYA').then(
//         (_) => setState(() => widget.model.point1Final = val ? 1 : 0),
//       );
//     } catch (e) {
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(info(true, e.toString()));
//     }
//   }

//   void updatePoint2(bool val) async {
//     try {
//       await ApiPoint.updateScore(null, val ? 1 : 0, null, widget.model, 'ARMA VIEYYA').then(
//         (_) => setState(() => widget.model.point2Final = val ? 1 : 0),
//       );
//     } catch (e) {
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(info(true, e.toString()));
//     }
//   }

//   void updatePoint3(bool val) async {
//     try {
//       await ApiPoint.updateScore(null, null, val ? 1 : 0, widget.model, 'ARMA VIEYYA').then(
//         (_) => setState(() => widget.model.point3Final = val ? 1 : 0),
//       );
//     } catch (e) {
//       if (mounted) ScaffoldMessenger.of(context).showSnackBar(info(true, e.toString()));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Container(
//           padding: EdgeInsets.all(5),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(topLeft: Radius.circular(5), topRight: Radius.circular(5)),
//             color: widget.warna,
//           ),
//           child: Text(
//             widget.judul,
//             style: TextStyle(fontSize: 20, color: Colors.white),
//             textAlign: TextAlign.center,
//           ),
//         ),
//         widget.model.employeeId == ''
//             ? Center(
//                 heightFactor: 1.5,
//                 child: Text(
//                   'Belum ada data diupload',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
//                 ),
//               )
//             : Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     GestureDetector(
//                       onTap: () {
//                         showDialog(
//                           context: context,
//                           builder: (BuildContext context) {
//                             return ImageFS(widget.model.currentTime, widget.model.currentDate, widget.model.employeeId, widget.model.actId);
//                           },
//                         );
//                       },
//                       child: AspectRatio(
//                         //aspectRatio: 16 / 9,
//                         aspectRatio: 4 / 3,
//                         child: Hero(
//                           tag: widget.model.currentTime,
//                           child: Image.memory(base64Decode(widget.model.picThumb), fit: BoxFit.contain),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 5),
//                     Row(
//                       children: [
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: Row(
//                             children: [
//                               Icon(Icons.access_time_filled, size: 20, color: Colors.grey.shade400),
//                               const SizedBox(width: 5),
//                               Text(
//                                 widget.model.currentTime,
//                                 style: TextStyle(fontSize: 13.5, color: Colors.black),
//                               ),
//                               const SizedBox(width: 5),
//                               widget.model.flag == 1
//                                   ? Icon(
//                                       Icons.warning_rounded,
//                                       color: Colors.red,
//                                       size: 20,
//                                     )
//                                   : const SizedBox()
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Expanded(
//                           child: Row(
//                             children: [
//                               Icon(Icons.location_pin, size: 20, color: Colors.grey.shade400),
//                               const SizedBox(width: 5),
//                               TextButton(
//                                 onPressed: () {
//                                   showDialog(
//                                     context: context,
//                                     builder: (BuildContext context) {
//                                       return ViewMap(widget.model.lat, widget.model.lng);
//                                     },
//                                   );
//                                 },
//                                 style: ElevatedButton.styleFrom(padding: EdgeInsets.all(0), overlayColor: Colors.transparent),
//                                 child: Text(
//                                   'Buka Peta',
//                                   style: TextStyle(fontSize: 13.5, color: Colors.black),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                       ],
//                     ),
//                     const SizedBox(height: 5),
//                     Padding(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//                       child: Tooltip(
//                         message: widget.model.actDesc.trimLeft(),
//                         preferBelow: false,
//                         child: Text(
//                           ' CAPTION',
//                           style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 1),
//                     Expanded(
//                       child: Container(
//                         margin: EdgeInsets.symmetric(horizontal: 10),
//                         padding: EdgeInsets.only(left: 3, top: 2, bottom: 2),
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.black12, width: 1.2),
//                           borderRadius: BorderRadius.circular(5),
//                           color: Colors.grey.shade100,
//                         ),
//                         // child: Listener(
//                         //   onPointerSignal: (pointerSignal) {
//                         //     if (pointerSignal is PointerScrollEvent) {
//                         //       GestureBinding.instance.pointerSignalResolver.register(pointerSignal, (event) {});
//                         //     }
//                         //   },
//                         child: SelectionArea(
//                           child: Scrollbar(
//                             controller: _scrollController,
//                             thumbVisibility: true,
//                             radius: const Radius.circular(10.0),
//                             thickness: 8.0,
//                             child: SingleChildScrollView(
//                               physics: const ClampingScrollPhysics(),
//                               hitTestBehavior: HitTestBehavior.translucent,
//                               controller: _scrollController,
//                               child: SizedBox(
//                                 width: double.infinity,
//                                 child: Text(
//                                   widget.model.actDesc.trimLeft(),
//                                   style: TextStyle(fontSize: 13.5),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         //),
//                       ),
//                     ),
//                     const SizedBox(height: 12),
//                     IntrinsicHeight(
//                       child: Container(
//                         padding: EdgeInsets.symmetric(horizontal: 5),
//                         margin: EdgeInsets.symmetric(horizontal: 10),
//                         decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
//                         child: Row(
//                           children: [
//                             Expanded(
//                               child: ContainerScore(widget.model.point1Final == 1 ? true : false, Icons.access_time, updatePoin1),
//                             ),
//                             VerticalDivider(),
//                             Expanded(
//                               child: ContainerScore(widget.model.point2Final == 1 ? true : false, Icons.photo_outlined, updatePoint2),
//                             ),
//                             VerticalDivider(),
//                             Expanded(
//                               child: ContainerScore(widget.model.point3Final == 1 ? true : false, Icons.description_outlined, updatePoint3),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 14),
//                   ],
//                 ),
//               ),
//       ],
//     );
//   }
// }
