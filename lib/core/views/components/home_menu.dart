import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/core/models/AuthModel/Auth_Model.dart';
import 'package:stsj/dashboard-fixup/utilities/utils.dart';
import 'package:stsj/global/function.dart';
import 'package:stsj/router/router_const.dart';

class HomeMenuComponent extends HookWidget {
  const HomeMenuComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final stsjAuth = useState(false);
    final rssmAuth = useState(false);
    final sampAuth = useState(false);
    final spaauth = useState(false);
    final ssAuth = useState(false);
    final stAuth = useState(false);
    final spAuth = useState(false);
    final sprAuth = useState(false);

    final loadingmenu = useState(true);

    Future<void> fetchDataDT() async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print('fetchDataDT');
        stsjAuth.value = prefs.getBool('STSJ') ?? false;
        // print('STSJ Access: ${sprAuth.value}');
        ssAuth.value = prefs.getBool('SS') ?? false;
        // print('SS Access: ${ssAuth.value}');
        spAuth.value = prefs.getBool('SP') ?? false;
        // print('SP Access: ${spAuth.value}');
        spaauth.value = prefs.getBool('SPAA') ?? false;
        // print('SPAA Access: ${spaauth.value}');
        sampAuth.value = prefs.getBool('SAMP') ?? false;
        // print('SAMP Access: ${sampAuth.value}');
        stAuth.value = prefs.getBool('ST') ?? false;
        // print('ST Access: ${stAuth.value}');
        rssmAuth.value = prefs.getBool('RSSM') ?? false;
        // print('RSSM Access: ${rssmAuth.value}');
        sprAuth.value = prefs.getBool('Spr') ?? false;
        // print('Spr Access: ${sprAuth.value}');

        loadingmenu.value = false;
      } catch (e) {
        Fluttertoast.showToast(
          msg: "Terjadi Kesalahan $e", // message
          toastLength: Toast.LENGTH_LONG, // length
          gravity: ToastGravity.CENTER, // location
          webPosition: "center",
          webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
          timeInSecForIosWeb: 2, // duration
        );
      }
    }

    useEffect(() {
      fetchDataDT();
      print("useeffect menu dijalankan");
      stsjAuth.value = Auth.stsjAuth;
      rssmAuth.value = Auth.rssmAuth;
      sampAuth.value = Auth.sampAuth;
      spaauth.value = Auth.spaauth;
      ssAuth.value = Auth.ssAuth;
      stAuth.value = Auth.stAuth;
      sprAuth.value = Auth.spAuth;

      return null;
    }, []);
    // const double height = 10;
    final homeMenuState = Provider.of<MenuState>(context);

    return FutureBuilder(
      future: fetchDataDT(),
      builder: (context, _) {
        if (loadingmenu.value) {
          return CircularProgressIndicator();
        } else {
          return SingleChildScrollView(
            child: Wrap(
              runSpacing: 30,
              // Atur jarak antara menu ikon di sini

              children: [
                _buildMenuIcon(
                  'assets/images/stsj.png',
                  'STSJ',
                  'SURYA TIMUR SAKTI JATIM',
                  RoutesConstant.menu,
                  stsjAuth.value,
                  homeMenuState,
                ),
                _buildMenuIcon(
                  'assets/images/rssm.png',
                  'RSSM',
                  'RODA SAKTI SURYA MEGAH',
                  RoutesConstant.menu,
                  rssmAuth.value,
                  homeMenuState,
                ),
                _buildMenuIcon(
                  'assets/images/SAMP.png',
                  'SAMP',
                  'SAPTA AJI MANUNGGAL PRIMA',
                  RoutesConstant.menu,
                  sampAuth.value,
                  homeMenuState,
                ),
                _buildMenuIcon(
                  'assets/images/SPAA.png',
                  'SPAA',
                  'SURYA PERKASA ANUGRAH ABADI',
                  RoutesConstant.menu,
                  spaauth.value,
                  homeMenuState,
                ),
                _buildMenuIcon(
                  'assets/images/SS.png',
                  'SS',
                  'SURYA SEJAHTERA',
                  RoutesConstant.menu,
                  ssAuth.value,
                  homeMenuState,
                ),
                _buildMenuIcon(
                  'assets/images/ST.png',
                  'ST',
                  'SURYA TERANG',
                  RoutesConstant.menu,
                  stAuth.value,
                  homeMenuState,
                ),
                _buildMenuIcon(
                  'assets/images/SP.png',
                  'SP',
                  'SURYA PRIMA',
                  RoutesConstant.menu,
                  spAuth.value,
                  homeMenuState,
                ),
                _buildMenuIcon(
                  'assets/images/SPr.png',
                  'SPr',
                  'SURYA PRATAMA',
                  RoutesConstant.menu,
                  sprAuth.value,
                  homeMenuState,
                ),
              ],
            ),
          );
        }
      },
    );
  }

  void permissionCheck(
    BuildContext context,
    PtModel loginpt,
    MenuState state,
    String route,
    String companyCode,
  ) async {
    state.setStaticMenuNotifier('');
    loginpt.setPT(companyCode);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // print('Company Name: ${prefs.getString('CompanyName')}');
    for (var data in state.getUserCompanyAccList) {
      print('${data.pt} - $companyCode');
      if (data.pt == companyCode) {
        state.entryLevelId = data.accessId;
        prefs.setString('EntryLevelID', data.accessId);
        prefs.setString('EntryLevelName', data.accessName);
        prefs.setString('CompanyName', companyCode);
      }
    }

    state.entryLevelId = prefs.getString('EntryLevelID') ?? '';
    state.entryLevelName = prefs.getString('EntryLevelName') ?? '';
    state.companyName = prefs.getString('CompanyName') ?? '';

    state
        .fetchUserAccess(companyCode, state.getEntryLevelId)
        .then((access) async {
      print('Access length: ${access.length}');

      // ~:Get Branches:~
      await state.fetchSipSalesBranches(companyCode);
      if (access.isNotEmpty) {
        state.userAccessList.addAll(access);

        // Note --> disable for a while to display dashboard menu as the initial page
        // Delivery Page is still considered as global page who can be accessed by all users
        String category = '';
        for (var userAccess in access) {
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
        // state.headerList.addAll(access.map((e) => e.category).toSet().toList());
        state.headerList.addAll(access.map((e) {
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
        state.subHeaderList.addAll(access.map((e) {
          if (e.isAllowView == 1) {
            return e.menuNumber;
          } else {
            return '-';
          }
        }));
        await prefs.setStringList('subheader', state.subHeaderList);

        print('~:List of Sub Header:~');
        for (var value in state.getSubHeaderList) {
          print(value);
        }

        print('');
        List<Map<String, String>> temp = [];
        for (Map<String, String> e in dashboardList) {
          if (state.getSubHeaderList.contains(e['acc']) && e['acc'] != '000') {
            print('${e['acc']} added');
            temp.add(e);
          } else if (e['acc'] == '000') {
            print('${e['acc']} added');
            temp.add(e);
          } else {
            // do nothing
          }
        }
        state.setFilteredDashboardList(temp);

        print('~:Filtered FPM Dashboard Access Result:~');
        for (var value in state.getFilteredDashboardList) {
          print('${value['text']}');
        }

        if (context.mounted) context.goNamed(route);
      } else {
        if (context.mounted) {
          GlobalFunction.showSnackbar(
            context,
            'Mohon maaf, menu ini tidak dapat anda akses.',
          );
        }
      }
    });
  }

  Widget _buildMenuIcon(
    String imagePath,
    String tooltip,
    String desc,
    String route,
    bool shouldShowIcon,
    MenuState state,
  ) {
    final isHovered = ValueNotifier<bool>(false);

    if (!shouldShowIcon) {
      // If shouldShowIcon is false, return an empty SizedBox
      return SizedBox();
    }

    return MouseRegion(
      onEnter: (_) {
        isHovered.value = true;
      },
      onExit: (_) {
        isHovered.value = false;
      },
      child: ValueListenableBuilder<bool>(
        valueListenable: isHovered,
        builder: (context, hovered, child) {
          final loginpt = context.read<PtModel>();
          final menuState = context.read<MenuState>();

          return SizedBox(
            width: 200,
            child: Column(
              children: [
                AnimatedContainer(
                  width: 150.0,
                  height: 100.0,
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(hovered ? 10.0 : 0.0),
                  child: CircleAvatar(
                    backgroundColor: Color.fromARGB(115, 255, 255, 255),
                    radius: 10,
                    child: IconButton(
                      icon: Image.asset(
                        imagePath,
                      ),
                      // tooltip: tooltip,
                      onPressed: () => permissionCheck(
                        context,
                        loginpt,
                        menuState,
                        route,
                        tooltip,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 7,
                ),
                Text(
                  desc,
                  style: TextStyle(fontSize: 12),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
