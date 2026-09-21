// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_grid/simple_grid.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/static/screenConstant.dart' as screenHeight;
import 'package:stsj/core/views/components/home_menu.dart';

class HomePages extends StatefulWidget {
  @override
  _HomePagesState createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> with AutomaticKeepAliveClientMixin<HomePages> {
  bool isLoading = false;
  late Future<void> _fetchDataFuture;

  @override
  void initState() {
    super.initState();
    final state = Provider.of<MenuState>(context, listen: false);
    _fetchDataFuture = fetchData(state);
  }

  Future<void> fetchData(MenuState state) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      bool status = prefs.getBool("Status") ?? false;

      if (status == true) {
        state.userId = prefs.getString("UserID") ?? '';
        state.entryLevelId = prefs.getString("EntryLevelID") ?? '';
        state.entryLevelName = prefs.getString("EntryLevelName") ?? '';
        state.password = prefs.getString("Password") ?? '';
        state.companyName = prefs.getString('CompanyName') ?? '';

        await state.fetchSISDriver();
        await state.fetchProvinces();
        await state.fetchSISBranches();
        await state.fetchUserAccess(state.getCompanyName, state.getEntryLevelId).then((data) async {
          state.userAccessList.addAll(data);

          String category = '';
          for (var userAccess in data) {
            if (userAccess.isAllowView == 1) {
              category = userAccess.category;
              break;
            }
          }
          if (category == 'DASHBOARD') {
            state.setStaticMenuNotifier('dashboard');
          } else if (category == 'SALES ACTIVITY') {
            state.setStaticMenuNotifier('activity');
          } else if (category == 'AUTHORIZATION') {
            state.setStaticMenuNotifier('authorization');
          } else if (category == 'INFORMATION') {
            state.setStaticMenuNotifier('report');
          } else if (category == 'TOOLS') {
            state.setStaticMenuNotifier('tools');
          } else {
            state.setStaticMenuNotifier('');
          }

          state.headerList.clear();
          state.headerList.addAll(data.map((e) {
            if (e.isAllowView == 1) {
              return e.category;
            } else {
              return '-';
            }
          }).toList());
          if (state.headerList.isEmpty) {
            state.headerList.add('dashboard');
          }
          await prefs.setStringList('header', state.headerList);

          state.subHeaderList.clear();
          state.subHeaderList.addAll(data.map((e) {
            if (e.isAllowView == 1) {
              return e.menuNumber;
            } else {
              return '-';
            }
          }));
          await prefs.setStringList('subheader', state.subHeaderList);
        });
      } else {
        debugPrint("Data di SharedPreferences kosong atau Status tidak benar.");
      }
    } catch (e) {
      debugPrint('Error: ${e.toString()}');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    double screenWidth = MediaQuery.of(context).size.width;
    bool screen = screenWidth >= screenHeight.screen;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: const CustomAppBar(),
      ),
      body: Center(
        child: FutureBuilder(
          future: _fetchDataFuture,
          builder: (context, snapshot) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: SpGrid(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                width: MediaQuery.of(context).size.width,
                children: [
                  // Company Selection Area
                  SpGridItem(
                    xs: 12,
                    sm: 12,
                    md: 10,
                    lg: 8,
                    child: Container(
                      height: screen ? 420 : 300,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.mutedSurface,
                        borderRadius: BorderRadius.circular(AppRadii.xl),
                        border: Border.all(color: AppColors.border, width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.06),
                            spreadRadius: 0,
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height * 0.02,
                        horizontal: 20,
                      ),
                      child: HomeMenuComponent(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
