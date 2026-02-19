import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/activity_point/models/model_manager_activities.dart';
import 'package:stsj/activity_point/models/model_manager_type.dart';
import 'package:stsj/activity_point/services/api.dart';
import 'package:stsj/activity_point/widgets/card_activity.dart';
import 'package:stsj/activity_point/widgets/dropdown_area.dart';
import 'package:stsj/activity_point/widgets/dropdown_cabang.dart';
import 'package:stsj/core/models/Activities/area.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/dashboard-fixup/utilities/format.dart';
import 'package:stsj/dashboard-fixup/widgets/datepicker_custom.dart';
import 'package:stsj/dashboard-fixup/widgets/snackbar_info.dart';
import 'package:stsj/global/globalVar.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';
import 'package:url_launcher/url_launcher.dart';

class ManagerActivities2 extends StatefulWidget {
  const ManagerActivities2({super.key});

  @override
  State<ManagerActivities2> createState() => _ManagerActivities2State();
}

class _ManagerActivities2State extends State<ManagerActivities2> {
  late String cabang, area, tgl, rTgl;
  late bool loading;
  late List<String> provinceList;
  late List<ModelAreas> areaList;
  late List<ModelManagerType> listDatas;
  late int _currentPage;
  final PageController _pageController = PageController(initialPage: 0);

  void setCabang(String value) async {
    await Provider.of<MenuState>(context, listen: false).fetchAreas(value);
    setState(() {
      cabang = value;
      area = '';
      areaList = Provider.of<MenuState>(context, listen: false).getAreaList;
    });
  }

  void setArea(String value) => setState(() => area = value);
  void setTgl(String value) => setState(() => tgl = value);

  @override
  void initState() {
    setAwal();
    reset();
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> setAwal() async {
    await Provider.of<MenuState>(context, listen: false).loadProvinces();
    setState(() {
      provinceList = Provider.of<MenuState>(context, listen: false).getProvinceList;
    });
  }

  void reset() {
    provinceList = Provider.of<MenuState>(context, listen: false).getProvinceList;
    areaList = [];
    listDatas = [];
    cabang = '';
    area = '';
    tgl = DateTime.now().toString().substring(0, 10);
    rTgl = '';
    loading = false;
    _currentPage = 0;
  }

  void onPageChanged(int idx) => setState(() => _currentPage = idx);

  void find() async {
    try {
      setState(() => loading = true);

      List<ModelManagerActivities> listData = await ApiPoint.getManagerAct(GlobalVar.username, cabang, area, tgl);
      if (listData.isEmpty) {
        throw ('Hasil Tidak Ditemukan');
      } else {
        setState(() {
          rTgl = tgl;
          List<String> tmpDealer = [];
          tmpDealer.addAll(listData.map((e) => e.bsName).toSet().toList());

          listDatas.clear();
          _currentPage = 0;
          for (var tmp in tmpDealer) {
            listDatas.add(
              ModelManagerType(
                dealer: tmp,
                morningBriefing: listData.firstWhere((element) => element.actGroupId == '00' && element.bsName == tmp),
                visitMarket: listData.firstWhere((element) => element.actGroupId == '01' && element.bsName == tmp),
                recruitmentInterview: listData.firstWhere((element) => element.actGroupId == '02' && element.bsName == tmp),
                dailyReport: listData.firstWhere((element) => element.actGroupId == '03' && element.bsName == tmp),
              ),
            );
          }

          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        listDatas.clear();
        _currentPage = 0;
        loading = false;
      });
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(info(true, e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: CustomAppBar(
          goBack: RoutesConstant.menu,
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(right: BorderSide(color: Colors.black26, width: 1.5)),
              ),
              child: Column(
                children: [
                  Text('FILTER', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                  const SizedBox(height: 8),
                  DropdownCabang(provinceList, cabang, 'Pilih Cabang', setCabang, disable: loading),
                  const SizedBox(height: 8),
                  DropdownArea(areaList, area, 'Pilih Area', setArea, disable: cabang == '' || loading ? true : false),
                  const SizedBox(height: 8),
                  DatepickerCustom(tgl, setTgl, readOnly: loading),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: loading ? null : () => find(),
                    style: ButtonStyle(
                      padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 16, horizontal: 20)),
                      backgroundColor: const WidgetStatePropertyAll(Colors.indigo),
                      shape: WidgetStatePropertyAll<RoundedRectangleBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                    ),
                    child: const Text('  CARI   ', style: TextStyle(fontSize: 13, color: Colors.white, letterSpacing: 1)),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: listDatas.isEmpty || loading
                        ? const SizedBox()
                        : Container(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade100),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text('DEALER', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                      Text(
                                        Format.tanggalFormat(rTgl),
                                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black26),
                                      )
                                    ],
                                  ),
                                  Divider(height: 10, endIndent: 2, color: Colors.black12, thickness: 1.3),
                                  const SizedBox(height: 5),
                                  ...listDatas.asMap().map((idx, value) {
                                    return MapEntry(
                                      idx,
                                      GestureDetector(
                                        onTap: () => _pageController.jumpToPage(idx),
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            color: _currentPage == idx ? Colors.indigo.shade50 : Colors.transparent,
                                            border: _currentPage == idx ? Border.all(color: Colors.indigo) : Border(),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(value.dealer, style: TextStyle(fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    );
                                  }).values,
                                ],
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: loading
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.indigo,
                      valueColor: AlwaysStoppedAnimation(Colors.cyan.shade200),
                      strokeWidth: 5.0,
                    ),
                  )
                : PageView.builder(
                    controller: _pageController,
                    scrollDirection: Axis.vertical,
                    itemCount: listDatas.length,
                    pageSnapping: true,
                    allowImplicitScrolling: true,
                    onPageChanged: (value) => onPageChanged(value),
                    itemBuilder: (context, idx) {
                      ModelManagerActivities briefing = listDatas[idx].morningBriefing;
                      ModelManagerActivities visit = listDatas[idx].visitMarket;
                      ModelManagerActivities recruitment = listDatas[idx].recruitmentInterview;
                      ModelManagerActivities report = listDatas[idx].dailyReport;
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            // Center(
                            //   child: Text(
                            //     listDatas[idx].dealer,
                            //     style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, letterSpacing: 1.3, color: Colors.indigo.shade900),
                            //     maxLines: 1,
                            //   ),
                            // ),
                            // const SizedBox(height: 12),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                        child: CardActivity('Morning Briefing', Color(0xFFF6BD60), briefing),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                        child: CardActivity('Visit Market', Color(0xFF118AB2), visit),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                        child: CardActivity('Recruitment Interview', Color(0xFF2A9D8F), recruitment),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Material(
                                      elevation: 5.0,
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.white,
                                      child: Container(
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
                                        child: CardActivity('Daily Report', Color(0xFFF28482), report),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
