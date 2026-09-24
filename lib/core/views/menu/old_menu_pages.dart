// ignore_for_file: must_call_super

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/core/views/components/dashboard_menu.dart';
import 'package:stsj/core/views/components/activity_menu.dart';
import 'package:stsj/global/widget/dropdown/static_menu_dropdown.dart';
import 'package:stsj/router/router_const.dart';
import 'package:stsj/global/widget/app_bar.dart';

class MenuPages extends StatefulWidget {
  const MenuPages({super.key});

  @override
  State<MenuPages> createState() => _MenuPagesState();
}

class _MenuPagesState extends State<MenuPages>
    with AutomaticKeepAliveClientMixin<MenuPages> {
  String staticMenu = '';

  void setStaticMenu(
    MenuState state,
    String value,
  ) {
    staticMenu = value;
    print('Static Menu: $staticMenu');
    state.staticMenuNotifier.value = value;
  }

  @override
  Widget build(BuildContext context) {
    final menuPagesState = Provider.of<MenuState>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(56),
        child: CustomAppBar(goBack: RoutesConstant.homepage),
      ),
      body: Container(
        color: Color.fromARGB(255, 231, 230, 230),
        alignment: Alignment.center,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: MediaQuery.of(context).size.height * 0.5,
          padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.05,
          ),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 244, 243, 243),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.height * 0.75,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  // border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.01,
                  vertical: MediaQuery.of(context).size.height * 0.005,
                ),
                child: StaticMenuDropdown(
                  inputan: staticMenu,
                  hint: 'jenis',
                  handle: setStaticMenu,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.025,
              ),
              ValueListenableBuilder(
                valueListenable: menuPagesState.staticMenuNotifier,
                builder: (context, value, child) {
                  if (value == 'sales') {
                    return DashboardMenuComponent();
                  } else if (value == 'activity') {
                    return ActivityMenuComponent();
                  } else {
                    return Text('Please choose your type.');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
