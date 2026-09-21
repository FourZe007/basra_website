import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:stsj/external_web/utilities/global.dart';
import 'package:web/web.dart' as web;
import 'package:go_router/go_router.dart';
import 'package:stsj/router/router_const.dart';

class PWebBIMktGoogleReview extends StatefulWidget {
  const PWebBIMktGoogleReview({super.key});

  @override
  State<PWebBIMktGoogleReview> createState() => _MyPageState();
}

class _MyPageState extends State<PWebBIMktGoogleReview> {
  String currentURL = '';
  final String viewID = "googlereview-iframe";

  void reloadPage(String url) {
    setState(() {
      ui.platformViewRegistry.registerViewFactory(viewID, (int viewId) {
        final element = web.HTMLIFrameElement()
          ..src = url
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = 'calc(100% + 30px)';
        return element;
      });
    });
  }

  @override
  initState() {
    currentURL = linkBIGoogleReview;
    reloadPage(currentURL);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            context.replaceNamed(RoutesConstant.menu);
          },
        ),
        title: const Text('Google Review',
            style: TextStyle(color: Colors.black)),
      ),
      body: HtmlElementView(key: UniqueKey(), viewType: viewID),
    );
  }
}
