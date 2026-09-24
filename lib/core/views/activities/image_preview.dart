import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';

// ignore: must_be_immutable
class ImageView extends StatefulWidget {
  const ImageView({super.key});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    final mapImageViewState = Provider.of<MenuState>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(56),
        child: CustomAppBar(
          goBack: mapImageViewState.isMapCarousel
              ? RoutesConstant.carouselRouteDetails
              : RoutesConstant.routeDetails,
        ),
      ),
      body: PhotoView(
        maxScale: PhotoViewComputedScale.covered * 2,
        minScale: PhotoViewComputedScale.contained,
        backgroundDecoration: const BoxDecoration(
          color: Colors.white,
        ),
        imageProvider: MemoryImage(
          base64Decode(mapImageViewState.getPreviewImageDir),
        ),
      ),
    );
  }
}
