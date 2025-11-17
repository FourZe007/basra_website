import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/core/models/Dashboard/delivery_monthly.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/core/views/sales_dashboard/delivery_monthly_detail.dart';
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
  bool isOverlayVisible = false, waitAPI = false;
  List<DeliveryMonthlyModel> lKalendar = [];
  OverlayEntry? overlayEntry;

  Widget wAdaPengiriman(DateTime day, List<DeliveryMonthlyModel> x) {
    var warnaApprove = x[0].approve < x[0].qty ? Colors.red : Colors.green;
    var warnaKirim = x[0].qty < x[0].totaltruck ? Colors.red : Colors.green;

    return MouseRegion(
      onHover: (event) => showOverlay(x),
      onExit: (event) => hideOverlay(),
      child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        Container(
          decoration: BoxDecoration(
              border:
                  BorderDirectional(bottom: BorderSide(color: Colors.black)),
              color: Colors.grey[300]),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(day.toString().substring(8, 10),
                style: GlobalFont.mediumbigfontMBold),
          ]),
        ),
        Container(
          decoration: BoxDecoration(
              border:
                  BorderDirectional(bottom: BorderSide(color: Colors.black)),
              color: warnaApprove),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Expanded(
                flex: 3,
                child:
                    Text('Total Approve', style: GlobalFont.bigfontMWhiteBold)),
            Expanded(
              flex: 1,
              child: Text('${x[0].approve.toString()} / ${x[0].qty.toString()}',
                  style: GlobalFont.bigfontMWhiteBold),
            ),
          ]),
        ),
        Container(
          decoration: BoxDecoration(
              border:
                  BorderDirectional(bottom: BorderSide(color: Colors.black)),
              color: warnaKirim),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
                flex: 3,
                child:
                    Text('Total Truck', style: GlobalFont.bigfontMWhiteBold)),
            Expanded(
              flex: 1,
              child: Text(
                  '${x[0].qty.toString()} / ${x[0].totaltruck.toString()}',
                  style: GlobalFont.bigfontMWhiteBold),
            ),
          ]),
        ),
        Container(
          decoration: BoxDecoration(
              border:
                  BorderDirectional(bottom: BorderSide(color: Colors.black)),
              color: Colors.grey[300]),
          child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                  NumberFormat.currency(
                          decimalDigits: 0, locale: 'id', symbol: 'Rp. ')
                      .format(x[0].appamount),
                  style: GlobalFont.bigfontMBold),
            )
          ]),
        )
      ]),
    );
  }

  Widget wTidakAdaPengiriman(DateTime day) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
              border:
                  BorderDirectional(bottom: BorderSide(color: Colors.black)),
              color: Colors.grey[300]),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(day.toString().substring(8, 10),
                style: GlobalFont.mediumbigfontMBold),
          ]),
        ),
      ),
    ]);
  }

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
        headerMargin: EdgeInsets.symmetric(horizontal: 10),
        titleTextStyle: GlobalFont.gigafontMBold,
        rightChevronIcon: Row(children: [
          Icon(Icons.local_shipping, color: Colors.black, size: 40),
          SizedBox(width: 5),
          Text('${lKalendar[0].totaltruck} Unit',
              style: GlobalFont.giantfontMBold),
        ]),
        formatButtonVisible: false,
        leftChevronVisible: false,
      ),
      daysOfWeekHeight: MediaQuery.of(context).size.height * 0.1,
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
      rowHeight: MediaQuery.of(context).size.height * 0.15,
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

        if (x[0].qty == 0) {
          return wTidakAdaPengiriman(day);
        } else {
          return wAdaPengiriman(day, x);
        }
      }, todayBuilder: (context, day, focusedDay) {
        var x = lKalendar
            .where((x) =>
                x.tanggal.substring(8, 10) ==
                focusedDay.toString().substring(8, 10))
            .toList();

        if (x[0].qty == 0) {
          return wTidakAdaPengiriman(day);
        } else {
          return wAdaPengiriman(day, x);
        }
      }),
      onDaySelected: (selectedDay, focusedDay) async {
        var x = lKalendar
            .where((x) =>
                x.tanggal.substring(8, 10) ==
                selectedDay.toString().substring(8, 10))
            .toList();

        x[0].qty != 0
            ? GlobalFunction.tampilkanDialog(context, false,
                DeliveryMonthlyDetail(selectedDay, searchDelivery))
            : GlobalFunction.showSnackbar(
                context, 'Tidak Ada Pengiriman Untuk Tanggal Yang Anda Pilih');
      },
    );
  }

  void showOverlay(List<DeliveryMonthlyModel> list) {
    if (isOverlayVisible) return;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).size.height * 0.05,
        left: MediaQuery.of(context).size.width * 0.4,
        right: MediaQuery.of(context).size.width * 0.05,
        child: Material(
          animationDuration: Duration(seconds: 1),
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Colors.black)),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.2,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                childAspectRatio: 1 / .15,
              ),
              itemCount: list[0].detail.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return Row(children: [
                  Expanded(
                      child: Text(list[0].detail[index].expensename,
                          style: GlobalFont.mediumfontM)),
                  Expanded(
                    child: Text(
                        NumberFormat.currency(
                                decimalDigits: 0, locale: 'id', symbol: 'Rp. ')
                            .format(list[0].detail[index].appamountdt),
                        style: GlobalFont.mediumfontM),
                  )
                ]);
              },
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry!);
    setState(() => isOverlayVisible = true);
  }

  void hideOverlay() {
    if (!isOverlayVisible) return;
    overlayEntry!.remove();
    overlayEntry = null;
    setState(() => isOverlayVisible = false);
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

  void setDate(String value) async {
    lKalendar = [];
    setState(() => date = value);
  }

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
        Expanded(
            child: waitAPI
                ? Center(child: CircularProgressIndicator(color: Colors.black))
                : lKalendar.isEmpty
                    ? Container()
                    : SingleChildScrollView(child: kalendarDelivery()))
      ]),
    );
  }
}
