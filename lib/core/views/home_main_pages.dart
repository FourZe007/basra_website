// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_grid/simple_grid.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/static/screenConstant.dart' as screenHeight;

import 'package:stsj/core/views/components/home_menu.dart';

class HomePages extends StatefulWidget {
  @override
  _HomePagesState createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages>
    with AutomaticKeepAliveClientMixin<HomePages> {
  bool isLoading = false; // Initialize with a default value

  // String NamaUserID = '';
  // String EntryLevelID = '';
  // String EntryLevelName = '';
  // String Password = '';
  // String companyName = '';
  //
  // String getGreeting(String currentTime) {
  //   final hour = int.parse(currentTime.split(":")[0]);
  //
  //   if (hour >= 6 && hour < 12) {
  //     return "Selamat Pagi";
  //   } else if (hour >= 12 && hour < 16) {
  //     return "Selamat Siang";
  //   } else if (hour >= 16 && hour < 18) {
  //     return "Selamat Sore";
  //   } else {
  //     return "Selamat Malam";
  //   }
  // }

  Future<void> fetchData(MenuState state) async {
    // setState(() {
    //   isLoading = true;
    // });
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      bool status = prefs.getBool("Status") ?? false;

      if (status == true) {
        state.userId = prefs.getString("UserID") ?? '';
        state.entryLevelId = prefs.getString("EntryLevelID") ?? '';
        state.entryLevelName = prefs.getString("EntryLevelName") ?? '';
        state.password = prefs.getString("Password") ?? '';
        state.companyName = prefs.getString('CompanyName') ?? '';

        // Check for null values and provide default values if needed
        // await state.fetchSalesmanList();
        // print('Salesman List length: ${state.getSalesmanList.length}');
        await state.fetchSISDriver();
        await state.fetchProvinces();
        // Added before go to menu page too to make sure branch name changed
        await state.fetchSISBranches();
        // .then((_) => state.fetchAreas());
        // print('Provinces List length: ${state.getProvinceList.length}');
        await state
            .fetchUserAccess(state.getCompanyName, state.getEntryLevelId)
            .then((data) async {
          state.userAccessList.addAll(data);

          // Note --> disable for a while to display dashboard menu as the initial page
          // Delivery Page is still considered as global page who can be accessed by all users
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
          // state.headerList.addAll(data.map((e) => e.category).toSet().toList());
          state.headerList.addAll(data.map((e) {
            if (e.isAllowView == 1) {
              return e.category;
            } else {
              return '-';
            }
          }).toList());
          // print('Header list length: ${state.headerList.length}');
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
        // Handle the case where "Status" is not true or data is missing
        print("Data di SharedPreferences kosong atau Status tidak benar.");
      }
    } catch (e) {
      // Handle any exceptions here
      print('Error: ${e.toString()}');
    }
    // finally {
    //   setState(() {
    //     isLoading = false;
    //   });
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    // fetchData(Provider.of<MenuState>(context, listen: false));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    double screenWidth = MediaQuery.of(context).size.width;
    bool screen = screenWidth >= screenHeight.screen;
    final state = Provider.of<MenuState>(context);
    print('Current route: ${GoRouterState.of(context).name}');

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: CustomAppBar(),
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchData(state),
          builder: (context, snapshot) {
            return SpGrid(
              spacing: 50,
              runSpacing: 50,
              alignment: WrapAlignment.center,
              width: MediaQuery.of(context).size.width,
              children: [
                SpGridItem(
                  xs: 12,
                  sm: 5,
                  md: 5,
                  lg: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    height: screen ? 400 : 250,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: screen ? 100 : 80,
                            backgroundImage: NetworkImage(
                              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            state.getUserId,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 25,
                            ),
                          ),
                          Text(state.getEntryLevelName),
                        ],
                      ),
                    ),
                  ),
                ),
                SpGridItem(
                  xs: 12,
                  sm: 7,
                  md: 7,
                  lg: 8,
                  child: Container(
                    height: screen ? 400 : 250,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: MediaQuery.of(context).size.height * 0.025,
                    ),
                    child: HomeMenuComponent(),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
