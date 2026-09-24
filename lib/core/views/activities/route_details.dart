import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';

class RouteDetailsPage extends StatefulWidget {
  const RouteDetailsPage({super.key});

  @override
  State<RouteDetailsPage> createState() => _RouteDetailsPageState();
}

class _RouteDetailsPageState extends State<RouteDetailsPage> {
  @override
  Widget build(BuildContext context) {
    final routeDetailsState = Provider.of<MenuState>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(56),
        child: CustomAppBar(
          goBack: RoutesConstant.map,
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: routeDetailsState.activityRouteDetailsList
              .asMap()
              .entries
              .map((entry) {
            final route = entry.value;

            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25.0),
                  topLeft: Radius.circular(25.0),
                ),
              ),
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.025,
              ),
              child: SingleChildScrollView(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.015,
                          ),
                          (routeDetailsState
                                      .imageList[routeDetailsState.getIsActive]
                                      .isNotEmpty &&
                                  routeDetailsState
                                              .imageList[
                                                  routeDetailsState.getIsActive]
                                                  [routeDetailsState
                                                      .getSelectedImage]
                                              .imageDir
                                              .length %
                                          4 ==
                                      0)
                              ? InkWell(
                                  onTap: () {
                                    routeDetailsState.openMapImageView(
                                      context,
                                      routeDetailsState
                                          .imageList[
                                              routeDetailsState.getIsActive][
                                              routeDetailsState
                                                  .getSelectedImage]
                                          .imageDir,
                                      false,
                                    );
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[350],
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                              0.01,
                                      vertical:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20.0),
                                      child: Image.memory(
                                        base64Decode(
                                          routeDetailsState
                                              .imageList[
                                                  routeDetailsState.getIsActive]
                                                  [routeDetailsState
                                                      .getSelectedImage]
                                              .imageDir,
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.25,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.01,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.01,
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.01,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.01,
                                  ),
                                  child: Text(
                                    'Photos are not available',
                                    style: GlobalFont.mediumgiantfontR,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // (routeDetailsState
                          //             .imageList[routeDetailsState.getIsActive]
                          //             .length >
                          //         1)
                          //     ? SizedBox(
                          //         height:
                          //             MediaQuery.of(context).size.height * 0.12,
                          //         child: ListView(
                          //           scrollDirection: Axis.horizontal,
                          //           children: routeDetailsState.imageList[
                          //                   routeDetailsState.getIsActive]
                          //               .asMap()
                          //               .entries
                          //               .map((entry) {
                          //             // final int index = entry.key;
                          //             final ModelImage image = entry.value;
                          //
                          //             return InkWell(
                          //               onTap: () =>
                          //                   routeDetailsState.openImageView(
                          //                 context,
                          //                 routeDetailsState
                          //                     .imageList[
                          //                         routeDetailsState.getIsActive]
                          //                         [routeDetailsState
                          //                             .getSelectedImage]
                          //                     .imageDir,
                          //                 false,
                          //               ),
                          //               child: Container(
                          //                 width: MediaQuery.of(context)
                          //                         .size
                          //                         .width *
                          //                     0.3,
                          //                 decoration: BoxDecoration(
                          //                   borderRadius:
                          //                       BorderRadius.circular(20.0),
                          //                   border: (image.isSelected == true)
                          //                       ? Border.all(
                          //                           color: Colors.red,
                          //                           width: 3.0,
                          //                         )
                          //                       : Border.all(
                          //                           color: Colors.transparent,
                          //                         ),
                          //                 ),
                          //                 margin: const EdgeInsets.symmetric(
                          //                   horizontal: 5.0,
                          //                   vertical: 5.0,
                          //                 ),
                          //                 child: ClipRRect(
                          //                   borderRadius:
                          //                       BorderRadius.circular(20.0),
                          //                   child: Image.memory(
                          //                     base64Decode(
                          //                       image.imageDir,
                          //                     ),
                          //                     fit: BoxFit.cover,
                          //                   ),
                          //                 ),
                          //               ),
                          //             );
                          //           }).toList(),
                          //         ),
                          //       )
                          //     : const SizedBox(),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.01,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.01,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.01,
                              vertical:
                                  MediaQuery.of(context).size.height * 0.01,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                route.contactName != ''
                                    ? Container(
                                        margin: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        child: Wrap(
                                          direction: Axis.vertical,
                                          children: [
                                            Text(
                                              'Customer Name',
                                              style: GlobalFont.giantfontRBold,
                                            ),
                                            Text(
                                              route.contactName,
                                              style:
                                                  GlobalFont.mediumgiantfontR,
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                route.contactNumber != ''
                                    ? Container(
                                        margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        child: Wrap(
                                          direction: Axis.vertical,
                                          children: [
                                            Text(
                                              'Phone Number',
                                              style: GlobalFont.giantfontRBold,
                                            ),
                                            Text(
                                              '+62${route.contactNumber}',
                                              style:
                                                  GlobalFont.mediumgiantfontR,
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                                route.actDesc != ''
                                    ? Container(
                                        margin: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        child: Wrap(
                                          direction: Axis.vertical,
                                          children: [
                                            Text(
                                              'Description',
                                              style: GlobalFont.giantfontRBold,
                                            ),
                                            Text(
                                              route.actDesc,
                                              style:
                                                  GlobalFont.mediumgiantfontR,
                                            ),
                                          ],
                                        ),
                                      )
                                    : const SizedBox(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
