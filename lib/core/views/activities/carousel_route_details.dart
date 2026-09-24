import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/core/views/activities/image_carousel.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';

class CarouselRouteDetailsPage extends StatefulWidget {
  const CarouselRouteDetailsPage({super.key});

  @override
  State<CarouselRouteDetailsPage> createState() =>
      _CarouselRouteDetailsPageState();
}

class _CarouselRouteDetailsPageState extends State<CarouselRouteDetailsPage> {
  int carouselActiveIndex = 0;
  dynamic carouselController;

  void rightNavigator() {
    carouselController.nextPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  void leftNavigator() {
    carouselController.previousPage(
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    final carouselRouteDetailsState = Provider.of<MenuState>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(56),
        child: CustomAppBar(
          goBack: RoutesConstant.map,
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: Row(
                children: [
                  IconButton(
                    onPressed: leftNavigator,
                    icon: Icon(
                      Icons.keyboard_arrow_left_rounded,
                      size: 30.0,
                    ),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: FlutterCarousel(
                      options: FlutterCarouselOptions(
                        aspectRatio: 1.0,
                        viewportFraction: 1.0,
                        height: MediaQuery.of(context).size.height * 0.85,
                        controller: carouselController,
                        // scrollPhysics: NeverScrollableScrollPhysics(),
                        onPageChanged: (index, reason) {
                          carouselRouteDetailsState.resetSelectImage();
                          carouselRouteDetailsState.onCarouselChanged(index);
                          setState(() {
                            carouselActiveIndex = index;
                          });
                        },
                      ),
                      items: carouselRouteDetailsState.activityRouteDetailsList
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
                            horizontal:
                                MediaQuery.of(context).size.width * 0.025,
                          ),
                          child: SingleChildScrollView(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[350],
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: ImageCarousel(),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.8,
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                      style: GlobalFont
                                                          .giantfontRBold,
                                                    ),
                                                    Text(
                                                      route.contactName,
                                                      style: GlobalFont
                                                          .mediumgiantfontR,
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
                                                      style: GlobalFont
                                                          .giantfontRBold,
                                                    ),
                                                    Text(
                                                      '+62${route.contactNumber}',
                                                      style: GlobalFont
                                                          .mediumgiantfontR,
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
                                                      style: GlobalFont
                                                          .giantfontRBold,
                                                    ),
                                                    Text(
                                                      route.actDesc,
                                                      style: GlobalFont
                                                          .mediumgiantfontR,
                                                    ),
                                                  ],
                                                ),
                                              )
                                            : const SizedBox(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  IconButton(
                    onPressed: rightNavigator,
                    icon: Icon(
                      Icons.keyboard_arrow_right_rounded,
                      size: 30.0,
                    ),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Dot Indicator
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.0425,
                alignment: Alignment.center,
                child: DotsIndicator(
                  dotsCount: carouselRouteDetailsState.imageList.length,
                  position: carouselRouteDetailsState.getIsActive,
                  decorator: DotsDecorator(
                    size: const Size(8.0, 8.0),
                    activeSize: const Size(12.0, 12.0),
                    activeColor: Colors.blue[700],
                    // activeColor: Colors.blue,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
