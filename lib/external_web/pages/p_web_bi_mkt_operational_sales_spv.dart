import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';
import 'package:stsj/external_web/utilities/global.dart';
import 'package:web/web.dart' as web;
import 'package:go_router/go_router.dart';
import 'package:stsj/router/router_const.dart';

class PWebBiMktOperationalSalesSpv extends StatefulWidget {
  const PWebBiMktOperationalSalesSpv({super.key});

  @override
  State<PWebBiMktOperationalSalesSpv> createState() => _MyPageState();
}

class _MyPageState extends State<PWebBiMktOperationalSalesSpv> {
  String currentURL = '';
  final String viewID = "operationalsalesspv-iframe";

  void reloadPage(String url) {
    setState(() {
      ui.platformViewRegistry.registerViewFactory(viewID, (int viewId) {
        final element = web.HTMLIFrameElement()
          ..src = url
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.zoom = '80%';
        //..style.height = 'calc(100% + 30px)';
        return element;
      });
    });
  }

  @override
  void initState() {
    currentURL = linkBIOperationalSalesSupervisor;
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
        title: const Text('Operational Sales Supervisor', style: TextStyle(color: Colors.black)),
      ),
      body: HtmlElementView(key: UniqueKey(), viewType: viewID),
    );
  }
}
