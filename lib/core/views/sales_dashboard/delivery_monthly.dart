import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/core/models/Dashboard/delivery_monthly.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/api.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/function.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/global/widget/dropdown/sis_branch_shop_dropdown.dart';
import 'package:stsj/router/router_const.dart';
import 'package:table_calendar/table_calendar.dart';

class DeliveryMonthly extends StatefulWidget {
  const DeliveryMonthly({super.key});

  @override
  State<DeliveryMonthly> createState() => _MyPageState();
}

class _MyPageState extends State<DeliveryMonthly> {
  String companyid = '', branchshop = '', date = '';
  bool waitAPI = false;
  List<DeliveryMonthlyModel> lKalendar = [];

  TableCalendar kalendarDelivery() {
    return TableCalendar(
      focusedDay: DateTime.parse(date),
      firstDay: DateTime.utc(
          int.parse(date.substring(0, 4)), int.parse(date.substring(5, 7)), 01),
      lastDay: DateTime.utc(
          int.parse(date.substring(0, 4)), int.parse(date.substring(5, 7)), 31),
      calendarStyle: CalendarStyle(
        tablePadding: EdgeInsets.all(10),
        cellMargin: EdgeInsets.all(10),
        tableBorder: TableBorder.all(
            borderRadius: BorderRadius.circular(20), color: Colors.black),
      ),
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        leftChevronVisible: false,
        rightChevronVisible: false,
        titleCentered: true,
        titleTextStyle: GlobalFont.giantfontMBold,
      ),
      daysOfWeekHeight: MediaQuery.of(context).size.height * 0.05,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: GlobalFont.bigfontMWhiteBold,
        weekendStyle: GlobalFont.bigfontMWhiteBold,
        decoration: BoxDecoration(
          color: Colors.blue[900]!,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
      locale: 'id',
      rowHeight: MediaQuery.of(context).size.height * 0.1,
      calendarBuilders: CalendarBuilders(dowBuilder: (context, day) {
        return Padding(
          padding: const EdgeInsets.all(5),
          child: Text(DateFormat('EEEE', 'id').format(day),
              textAlign: TextAlign.center, style: GlobalFont.bigfontMWhiteBold),
        );
      }, defaultBuilder: (context, day, focusedDay) {
        var x = lKalendar
            .where((x) =>
                x.tanggal.substring(8, 10) == day.toString().substring(8, 10))
            .toList();

        var warnaKalendar = x[0].qty == 0
            ? Colors.grey[600]
            : x[0].approve < x[0].qty
                ? Colors.red[900]
                : Colors.green[900];

        return Container(
          color: warnaKalendar,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(day.toString().substring(8, 10),
                  style: GlobalFont.mediumbigfontMWhiteBold),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${x[0].approve.toString()} / ${x[0].qty.toString()}',
                  style: GlobalFont.gigafontRBoldWhite),
            ])
          ]),
        );
      }, todayBuilder: (context, day, focusedDay) {
        var x = lKalendar
            .where((x) =>
                x.tanggal.substring(8, 10) ==
                focusedDay.toString().substring(8, 10))
            .toList();

        var warnaKalendar = x[0].qty == 0
            ? Colors.grey[600]
            : x[0].approve < x[0].qty
                ? Colors.red[900]
                : Colors.green[900];

        return Container(
          color: warnaKalendar,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(day.toString().substring(8, 10),
                  style: GlobalFont.mediumbigfontMWhiteBold),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text('${x[0].approve.toString()} / ${x[0].qty.toString()}',
                  style: GlobalFont.gigafontRBoldWhite),
            ])
          ]),
        );
      }),
      onDaySelected: (selectedDay, focusedDay) {
        print(selectedDay);
      },
    );
  }

  Future<void> setDateByGoogle(BuildContext context, String tgl) async {
    tgl = tgl == '' ? DateTime.now().toString().substring(0, 10) : tgl;

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tgl == '' ? DateTime.now() : DateTime.parse(tgl),
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 1, 1, 0),
    );

    if (picked != null && picked != DateTime.parse(tgl)) {
      tgl = picked.toString().substring(0, 10);
      setDate(tgl);
    }
  }

  void setBranchShop(dynamic value) => branchshop = value;

  void setDate(String value) => setState(() {
        lKalendar = [];
        date = value;
      });

  void searchDelivery(MenuState state) async {
    if (branchshop.isEmpty) {
      GlobalFunction.showSnackbar(context, 'Nama Cabang Wajib Di Pilih');
    } else {
      setState(() => waitAPI = true);

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      companyid = prefs.getString('CompanyName') ?? '';

      if (date == '') setDate(DateTime.now().toString().substring(0, 10));

      for (var branch in state.getBranchShopList) {
        if (branch.name == branchshop) {
          state.branchId = branch.branchId;
          state.shopId = branch.shopId;
          break;
        }
      }

      await prefs.setString('branchId', state.getBranchId);
      await prefs.setString('shopId', state.getShopId);
      await prefs.setString('date', date);

      lKalendar = await GlobalAPI.fetchDeliveryMonthly(
          companyid, state.branchId, state.shopId, date);

      setState(() => waitAPI = false);
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<MenuState>(context, listen: false).resetDeliveryData();
    Provider.of<MenuState>(context, listen: false).loadSisBranches();
  }

  @override
  Widget build(BuildContext context) {
    final menuState = Provider.of<MenuState>(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
        child: CustomAppBar(goBack: RoutesConstant.menu),
      ),
      body: Column(children: [
        SizedBox(height: 15),
        Row(children: [
          SizedBox(width: 10),
          InkWell(
            onTap: null,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(15.0)),
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(Icons.filter_alt_rounded,
                        size: 25.0, color: Colors.black),
                    Text('Filter', style: GlobalFont.mediumgiantfontR)
                  ]),
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ValueListenableBuilder<List<String>>(
                    valueListenable: menuState.getBranchNameListNotifier,
                    builder: (context, value, _) {
                      if (value.isEmpty) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.height * 0.05,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.01,
                            vertical: MediaQuery.of(context).size.height * 0.01,
                          ),
                          child: SisBranchShopDropdown(
                            listData: const [],
                            inputan: '',
                            hint: 'Cabang',
                            handle: () {},
                            disable: true,
                            isDriver: true,
                          ),
                        );
                      } else {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          width: MediaQuery.of(context).size.width * 0.15,
                          height: MediaQuery.of(context).size.height * 0.05,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.01,
                            vertical: MediaQuery.of(context).size.height * 0.01,
                          ),
                          child: SisBranchShopDropdown(
                            listData: value,
                            inputan: branchshop,
                            hint: 'Cabang',
                            handle: setBranchShop,
                            disable: false,
                            isDriver: true,
                          ),
                        );
                      }
                    },
                  ),
                  SizedBox(width: 10.0),
                  InkWell(
                    onTap: () async {
                      await setDateByGoogle(context, date);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.date_range_rounded),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.003,
                            ),
                            Text(
                              date == ''
                                  ? Format.tanggalFormat(DateTime.now()
                                      .toString()
                                      .substring(0, 10))
                                  : Format.tanggalFormat(date),
                              style: GlobalFont.mediumgiantfontR,
                            )
                          ]),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  InkWell(
                    onTap: () => searchDelivery(menuState),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: const Icon(
                        Icons.search_rounded,
                        size: 25.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ]),
        SizedBox(height: 15),
        Expanded(
            child: waitAPI
                ? Center(child: CircularProgressIndicator(color: Colors.black))
                : lKalendar.isEmpty
                    ? Container()
                    : kalendarDelivery())
      ]),
    );
  }
}
