import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:stsj/external_web/utilities/global.dart';
import 'package:web/web.dart' as web;

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
      body: HtmlElementView(key: UniqueKey(), viewType: viewID),
    );
  }
}
