import 'package:flutter/material.dart';
import 'package:stsj/external_web/utilities/global.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';
import 'dart:ui_web' as ui;
import 'package:web/web.dart' as web;

class MonitoringNetwork extends StatefulWidget {
  const MonitoringNetwork({super.key});

  @override
  State<MonitoringNetwork> createState() => _MonitoringNetworkState();
}

class _MonitoringNetworkState extends State<MonitoringNetwork> {
  final String viewID = "network";

  @override
  void initState() {
    ui.platformViewRegistry.registerViewFactory(
      viewID,
      (int viewId) {
        final element = web.HTMLIFrameElement()
          ..src = spreadSheetNetwork
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';
        return element;
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: CustomAppBar(
          goBack: RoutesConstant.menu,
        ),
      ),
      body: HtmlElementView(viewType: viewID),
    );
  }
}
