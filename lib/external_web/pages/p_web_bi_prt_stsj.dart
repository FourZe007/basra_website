import 'package:flutter/material.dart';
import 'package:stsj/external_web/utilities/global.dart';
import 'dart:ui_web' as ui;
import 'package:web/web.dart' as web;

class PWebBIPartSTSJ extends StatefulWidget {
  const PWebBIPartSTSJ({super.key});

  @override
  State<PWebBIPartSTSJ> createState() => _MyPageState();
}

class _MyPageState extends State<PWebBIPartSTSJ> {
  String currentURL = '';
  final String viewID = "part-stsj-iframe";

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
  void initState() {
    currentURL = linkBISparepartSTSJ;
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
