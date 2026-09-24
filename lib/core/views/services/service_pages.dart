import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_grid/simple_grid.dart';
import 'package:stsj/global/widget/app_bar.dart';

import 'package:stsj/core/views/Services/MotorcyleHistory/MotorcycleHistory_pages.dart';
import 'package:stsj/core/views/Services/component/left_drawer_service.dart';

class ReportPages extends HookWidget {
  ReportPages({super.key});

  @override
  Widget build(BuildContext context) {
    var currentPage = useState<int>(0);

    void _changePage(int newPage) {
      currentPage.value = newPage;
    }

    Widget _getCurrentPageWidget() {
      switch (currentPage.value) {
        case 0:
          return MotorCycleHistoryPages();

        default:
          return MotorCycleHistoryPages();
      }
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(56),
        child: CustomAppBar(),
      ),
      drawer: LeftDrawerService(
          currentPage: currentPage.value, onItemSelected: _changePage),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            constraints: BoxConstraints(maxWidth: 900),
            child: SpGrid(
              width: MediaQuery.of(context).size.width,
              children: [
                SpGridItem(
                  xs: 12,
                  sm: 12,
                  md: 12,
                  lg: 12,
                  child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255), // A
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.2), // Warna bayangan
                            spreadRadius: 5, // Menyebar lebar bayangan
                            blurRadius: 7, // Blur bayangan
                            offset: Offset(0, 3), // Offset bayangan
                          ),
                        ],
                      ),
                      child: _getCurrentPageWidget()),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
