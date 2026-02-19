import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/activity_point/models/point_sm_hd.dart';
import 'package:stsj/activity_point/pages/daily_report.dart';
import 'package:stsj/activity_point/pages/morning_briefing.dart';
import 'package:stsj/activity_point/pages/recruitment_interview.dart';
import 'package:stsj/activity_point/pages/visit_market.dart';
import 'package:stsj/activity_point/widgets/dropdown_dealer.dart';
import 'package:stsj/core/models/AuthModel/Auth_Model.dart';
import 'package:stsj/dashboard-fixup/utilities/format.dart';
import 'package:stsj/global/globalVar.dart';
import 'package:stsj/router/router_const.dart';
import 'package:tab_container/tab_container.dart';

class ActivitiesPoint2 extends StatefulWidget {
  const ActivitiesPoint2(this.listDatas, {super.key});
  final List<PointSMHD> listDatas;

  @override
  State<ActivitiesPoint2> createState() => _ActivitiesPoint2State();
}

class _ActivitiesPoint2State extends State<ActivitiesPoint2> {
  DateTime today = DateTime.now();
  late int dealer;

  void setDealer(int value) => setState(() => dealer = value);

  @override
  void initState() {
    dealer = 0;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: AppBar(
          centerTitle: true,
          backgroundColor: const Color(0xFF9EDDFF),
          toolbarHeight: MediaQuery.of(context).size.height * 0.065,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, size: 25),
            onPressed: () => Navigator.pop(context),
          ),
          title: Image.asset('assets/images/stsj.png', width: 50),
          actions: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(GlobalVar.username, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(width: 10),
            Container(
              margin: EdgeInsets.only(right: 5),
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                    radius: 20,
                  ),
                  Positioned(
                    right: 0,
                    child: PopupMenuButton<String>(
                      icon: Icon(null),
                      onSelected: (value) {
                        if (value == 'logout') {
                          return;
                        }
                      },
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'logout',
                          child: Text('Logout'),
                          onTap: () async {
                            // ~:Reset User Auth:~
                            await Auth.resetAuth();

                            final SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.clear();

                            if (context.mounted) context.go(RoutesConstant.login);

                            Fluttertoast.showToast(
                              msg: 'Logout berhasil!', // message
                              textColor: Colors.black,
                              toastLength: Toast.LENGTH_LONG, // length
                              gravity: ToastGravity.CENTER, // location
                              webPosition: 'center',
                              webBgColor: 'linear-gradient(to right, #00FF00, #00FF00)',
                              timeInSecForIosWeb: 2, // duration
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(' Pilih Dealer', style: TextStyle(fontSize: 13, color: Colors.grey)),
                              const SizedBox(height: 2),
                              DropdownDealer(widget.listDatas, dealer, 'Pilih Dealer', setDealer),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Progres Dealer', style: TextStyle(fontSize: 13, color: Colors.grey)),
                              const SizedBox(height: 2),
                              Text(
                                '${widget.listDatas[dealer].totalPoint} / ${widget.listDatas[dealer].targetQty} Poin',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: (today.day / DateUtils.getDaysInMonth(today.year, today.month)) == 1 ? Colors.green : Colors.red),
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: LinearProgressIndicator(
                                      value: widget.listDatas[dealer].targetQty == 0
                                          ? 0
                                          : (widget.listDatas[dealer].totalPoint / widget.listDatas[dealer].targetQty).toDouble(),
                                      valueColor: AlwaysStoppedAnimation(
                                          (widget.listDatas[dealer].totalPoint / widget.listDatas[dealer].targetQty) >= 1
                                              ? Colors.green
                                              : Colors.red),
                                      backgroundColor: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(5),
                                      minHeight: 8,
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    '${widget.listDatas[dealer].persentase}%',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.grey.shade400),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                    child: TabContainer(
                      tabEdge: TabEdge.top,
                      tabsStart: 0,
                      tabsEnd: 1,
                      childPadding: const EdgeInsets.all(10.0),
                      selectedTextStyle: const TextStyle(color: Colors.white, fontSize: 14.0, fontWeight: FontWeight.bold),
                      unselectedTextStyle: const TextStyle(color: Colors.black, fontSize: 13.0),
                      colors: const [
                        Color(0xFFF6BD60),
                        Color(0xFF118AB2),
                        Color(0xFF2A9D8F),
                        Color(0xFFF28482),
                      ],
                      tabs: const [
                        Text('Morning Briefing'),
                        Text('Visit Market '),
                        Text('Recruitment & Interview'),
                        Text('Daily Report'),
                      ],
                      children: [
                        MorningBriefing(widget.listDatas[dealer].detail.where((element) => element.activityId == '00').toList()),
                        VisitMarket(widget.listDatas[dealer].detail.where((element) => element.activityId == '01').toList()),
                        RecruitmentInterview(widget.listDatas[dealer].detail.where((element) => element.activityId == '02').toList()),
                        DailyReport(widget.listDatas[dealer].detail.where((element) => element.activityId == '03').toList()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              color: Colors.white.withValues(alpha: 0.7),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: Text(Format.tanggalFormat(today.toString().substring(0, 10)), style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
