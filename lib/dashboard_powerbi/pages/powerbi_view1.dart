import 'package:flutter/material.dart';
import 'package:stsj/dashboard_powerbi/utilities/global.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';
import 'dart:ui_web' as ui;
import 'package:web/web.dart' as web;

class PowerbiView1 extends StatefulWidget {
  const PowerbiView1({super.key});

  @override
  State<PowerbiView1> createState() => _PowerbiView1State();
}

class _PowerbiView1State extends State<PowerbiView1> {
  final String viewID = "power-bi-iframe";

  @override
  void initState() {
    ui.platformViewRegistry.registerViewFactory(
      viewID,
      (int viewId) {
        final element = web.HTMLIFrameElement()
          ..src = linkBI
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = 'calc(100% + 30px)';
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
