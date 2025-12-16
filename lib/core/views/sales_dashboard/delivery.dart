import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/core/models/Dashboard/delivery.dart';
import 'package:stsj/core/models/Dashboard/driver.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/core/views/sales_dashboard/delivery_biaya.dart';
import 'package:stsj/global/api.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/function.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/global/widget/dropdown/sip_delivery_driver_dropdown.dart';
import 'package:stsj/global/widget/dropdown/sis_branch_shop_dropdown.dart';
import 'package:stsj/global/widget/card/delivery_card.dart';
import 'package:stsj/global/widget/open_dialog.dart';
import 'package:stsj/global/widget/text_display.dart';
import 'package:stsj/router/router_const.dart';

class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  String companyId = '';
  String employeeId = '';
  String date = '';
  String branchShop = '';
  String driverName = ''; // ~:New:~
  // String branchId = '';
  // String shopId = '';
  ValueNotifier<bool> searchTriggerNotifier = ValueNotifier(false);
  bool isLoading = false, waitAPI = false;
  List<ModelDriver> driver = [];
  List<ModelDriver> filterdriver = [];

  // dummy data
  CheckListDetailsModel detail1 = CheckListDetailsModel(
    transNumber: '1234567890',
    customerId: '1234567890',
    customerName: 'Customer Name',
    shippingAddress: 'address',
    shippingCity: 'city',
    lat: 0.0,
    lng: 0.0,
    qtyNota: 0,
    koli: 0,
    deliveryStatus: 0,
    deliveryTime: '',
    deliveryImageThumb: '',
    deliveryNote: 'Delivery Note',
    deliveryLat: 0.0,
    deliveryLng: 0.0,
    line: 0,
    deliveryOrder: 99,
  );

  CheckListDetailsModel detail2 = CheckListDetailsModel(
    transNumber: '1234567890',
    customerId: '1234567890',
    customerName: 'Customer Name',
    shippingAddress: 'address',
    shippingCity: 'city',
    lat: 0.0,
    lng: 0.0,
    qtyNota: 0,
    koli: 0,
    deliveryStatus: 0,
    deliveryTime: '13:30:15',
    deliveryImageThumb: '',
    deliveryNote: 'Delivery Note',
    deliveryLat: 0.0,
    deliveryLng: 0.0,
    line: 0,
    deliveryOrder: 99,
  );

  CheckListDetailsModel detail3 = CheckListDetailsModel(
    transNumber: '1234567890',
    customerId: '1234567890',
    customerName: 'Customer Name',
    shippingAddress: 'address',
    shippingCity: 'city',
    lat: 0.0,
    lng: 0.0,
    qtyNota: 0,
    koli: 0,
    deliveryStatus: 1,
    deliveryTime: '13:30:15',
    deliveryImageThumb: '',
    deliveryNote: 'Delivery Note',
    deliveryLat: 0.0,
    deliveryLng: 0.0,
    line: 0,
    deliveryOrder: 99,
  );

  void setEmployeId(String value) {
    employeeId = value;
    searchTriggerNotifier.value = false;
  }

  void setDate(String value) {
    setState(() {
      date = value;
    });
  }

  void setBranchShop(String value) {
    branchShop = value;
    var x = driver.where((x) => x.shopName == value).toList();
    if (x.isNotEmpty) {
      driverName = x[0].employeeName;
      filterdriver = [];
      filterdriver.addAll(x);
      filterdriver.insert(
          0,
          ModelDriver(
              employeeId: '',
              employeeName: '',
              branchId: '',
              shopId: '',
              shopName: ''));
    }
  }

  void setDriver(String value) => setState(() {
        driverName = value;
      });

  void triggerIsLoading() {
    log('Trigger Loading');
    isLoading = !isLoading;
    print('isLoading: $isLoading');
  }

  Future<void> setDateByGoogle(
    BuildContext context,
    String tgl,
  ) async {
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
    } else {
      // Nothing happened
    }
  }

  // ~:Image Preview Function:~
  // void viewImage(
  //   BuildContext parentContext,
  //   MenuState state,
  //   String img,
  // ) async {
  //   if (img.isNotEmpty) {
  //     showDialog(
  //       context: context,
  //       barrierDismissible: true,
  //       builder: (context) => Dialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         backgroundColor: Colors.blue.shade50,
  //         elevation: 16,
  //         child: Container(
  //           width: MediaQuery.of(context).size.width * 0.35,
  //           height: MediaQuery.of(context).size.height * 0.9,
  //           decoration: BoxDecoration(
  //             color: Colors.white,
  //             borderRadius: BorderRadius.circular(15.0),
  //           ),
  //           padding: EdgeInsets.symmetric(
  //             horizontal: MediaQuery.of(context).size.width * 0.0175,
  //             vertical: MediaQuery.of(context).size.height * 0.025,
  //           ),
  //           child: Column(
  //             children: [
  //               Expanded(
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.only(
  //                     topLeft: Radius.circular(15.0),
  //                     topRight: Radius.circular(15.0),
  //                   ),
  //                   child: Image.memory(
  //                     base64Decode(img),
  //                     fit: BoxFit.cover,
  //                     width: MediaQuery.of(context).size.width * 0.325,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   } else {
  //     GlobalFunction.showSnackbar(
  //       context,
  //       'Gambar tidak tersedia.',
  //     );
  //   }
  // }

  void getFilterData(
    BuildContext context,
    MenuState menuState,
  ) async {
    menuState.deliveryList.clear();
    if (date == '') {
      setDate(
        DateTime.now().toString().substring(0, 10),
      );
    } else {
      // Do nothing
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    companyId = prefs.getString('CompanyName') ?? '';

    for (var branch in menuState.getBranchShopList) {
      if (branch.name == branchShop) {
        menuState.branchId = branch.branchId;
        menuState.shopId = branch.shopId;
        break;
      }
    }

    await prefs.setString('branchId', menuState.getBranchId);
    await prefs.setString('shopId', menuState.getShopId);
    await prefs.setString('employeeId', employeeId);
    await prefs.setString('date', date);

    // Get Filter Data --> Succeed
    // print('Get Filter Data');
    // print('Company ID: $companyId');
    // print('Employee ID: $employeeId');
    // print('Branch ID: $branchId');
    // print('Shop ID: $shopId');
    // print('Date: $date');
    // print('Branch Shop: $branchShop');
  }

  void searchDelivery(
    MenuState menuState,
  ) async {
    log('Employee ID: $employeeId');
    log('Branch Shop: $branchShop');
    log('Driver: $driverName');
    log('isLoading: $isLoading');

    if (isLoading) {
      GlobalFunction.showSnackbar(
        context,
        'Mohon Tunggu.',
      );
    } else {
      if (branchShop.isEmpty || driverName.isEmpty) {
        GlobalFunction.showSnackbar(
          context,
          'Mohon periksa kembali filter anda.',
        );
      } else {
        searchTriggerNotifier.value = false;
        getFilterData(
          context,
          menuState,
        );
        searchTriggerNotifier.value = true;
      }
    }
  }

  void openMap(
    MenuState menuState, {
    bool isRoute = false,
  }) {
    print('isLoading: $isLoading');
    if (isLoading) {
      GlobalFunction.showSnackbar(
        context,
        'Mohon Tunggu',
      );
    } else {
      print('Delivery List: ${menuState.getDeliveryList.length}');

      try {
        if (searchTriggerNotifier.value) {
          if (menuState.getDeliveryList.isNotEmpty &&
              menuState.getDeliveryList[0].employeeId.isNotEmpty) {
            if (!isRoute) {
              context.goNamed(RoutesConstant.mapDelivery);
            } else {
              GlobalFunction.showSnackbar(
                context,
                'Coming Soon.',
              );
            }
          } else {
            GlobalFunction.showSnackbar(
              context,
              'Data tidak ditemukan.',
            );
          }
        } else {
          GlobalFunction.showSnackbar(
            context,
            'Gagal membuka peta, periksa kembali filter anda.',
          );
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  // Note -> Not working perfectly
  void resetData(
    MenuState menuState,
  ) {
    print('Reset Data');
    setState(() {
      setEmployeId('');
      setBranchShop('');
      setDate('');
      searchTriggerNotifier.value = false;
      menuState.resetDeliveryData();
    });
  }

  void loadDriver() async {
    setState(() => waitAPI = true);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final companyId = prefs.getString('CompanyName') ?? '';
    driver = await GlobalAPI.getSISDrivers(companyId);
    driver.insert(
        0,
        ModelDriver(
            employeeId: '',
            employeeName: '',
            branchId: '',
            shopId: '',
            shopName: ''));
    setState(() => waitAPI = false);
  }

  @override
  void initState() {
    super.initState();
    searchTriggerNotifier.value = false;
    Provider.of<MenuState>(context, listen: false).resetDeliveryData();
    Provider.of<MenuState>(context, listen: false).loadSisBranches();
    loadDriver();
  }

  @override
  Widget build(BuildContext context) {
    if (waitAPI) {
      return Center(child: CircularProgressIndicator(color: Colors.black));
    } else {
      final menuState = Provider.of<MenuState>(context);
      return Scaffold(
        appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.065),
          child: CustomAppBar(
            goBack: RoutesConstant.menu,
          ),
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.01,
              right: MediaQuery.of(context).size.width * 0.01,
              top: MediaQuery.of(context).size.height * 0.01,
            ),
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.01,
              right: MediaQuery.of(context).size.width * 0.01,
              top: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Column(
              children: [
                // ==================================================================
                // =========================== Filter ===============================
                // ==================================================================
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Filter Title
                      InkWell(
                        onTap: null,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.filter_alt_rounded,
                                size: 25.0,
                                color: Colors.black,
                              ),
                              Text(
                                'Filter',
                                style: GlobalFont.mediumgiantfontR,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 10.0),

                      // Filter Content
                      Expanded(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              ValueListenableBuilder<List<String>>(
                                valueListenable:
                                    menuState.getBranchNameListNotifier,
                                builder: (context, value, _) {
                                  if (value.isEmpty) {
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.01,
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
                                      duration:
                                          const Duration(milliseconds: 500),
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      child: SisBranchShopDropdown(
                                        listData: value,
                                        inputan: branchShop,
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
                              // ~:Driver Auto Complete:~
                              // DriverAutoComplete(
                              //   employeeId,
                              //   setEmployeId,
                              // ),

                              // ~:Driver Dropdown:~
                              ValueListenableBuilder<List<String>>(
                                valueListenable:
                                    menuState.getFilteredDriverNameListNotifier,
                                builder: (context, value, _) {
                                  if (value.isEmpty) {
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      child: SipDeliveryDriverDropdown(
                                        listData: const [],
                                        inputan: '',
                                        hint: 'Nama Driver',
                                        handle: () {},
                                        disable: true,
                                      ),
                                    );
                                  } else {
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal:
                                            MediaQuery.of(context).size.width *
                                                0.01,
                                        vertical:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      child: SipDeliveryDriverDropdown(
                                        listData: filterdriver,
                                        inputan: driverName,
                                        hint: 'Nama Driver',
                                        handle: setDriver,
                                        disable: false,
                                      ),
                                    );
                                  }
                                },
                              ),
                              SizedBox(width: 10.0),
                              InkWell(
                                onTap: () async {
                                  await setDateByGoogle(
                                    context,
                                    date,
                                  );
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(Icons.date_range_rounded),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.003,
                                      ),
                                      Text(
                                        date == ''
                                            ? Format.tanggalFormat(
                                                DateTime.now()
                                                    .toString()
                                                    .substring(0, 10),
                                              )
                                            : Format.tanggalFormat(date),
                                        style: GlobalFont.mediumgiantfontR,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.0),
                              InkWell(
                                onTap: () => searchDelivery(menuState),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  child: const Icon(
                                    Icons.search_rounded,
                                    size: 25.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              // ~:Come back later:~
                              // SizedBox(width: 10.0),
                              // InkWell(
                              //   onTap: () => resetData(menuState),
                              //   child: Container(
                              //     height:
                              //         MediaQuery.of(context).size.height * 0.05,
                              //     alignment: Alignment.center,
                              //     decoration: BoxDecoration(
                              //       color: Colors.grey[400],
                              //       borderRadius: BorderRadius.circular(15.0),
                              //     ),
                              //     padding: EdgeInsets.symmetric(horizontal: 15.0),
                              //     child: Text(
                              //       'Reset',
                              //       style: GlobalFont.mediumgiantfontR,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(width: 10.0),

                      // Filter Map Button
                      InkWell(
                        onTap: () => openMap(menuState),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.05,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 15.0),
                          child: Text(
                            'Detil Lokasi',
                            style: GlobalFont.mediumgiantfontR,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // =================================================================
                // ========================== Devider ==============================
                // =================================================================
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),

                // =================================================================
                // ========================== Content ==============================
                // =================================================================
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ValueListenableBuilder(
                      valueListenable: searchTriggerNotifier,
                      builder: (context, value, _) {
                        log('Value Notifier: $value');
                        if (value) {
                          // triggerIsLoading();
                          isLoading = false;
                          if (menuState.getDeliveryList.isNotEmpty) {
                            List<CheckListDetailsModel> deliveryDetail =
                                menuState.getDeliveryList[0].deliveryDetail;

                            return Column(
                              children: [
                                // ===============================================
                                // ============= Driver Identity =================
                                // ===============================================
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.height *
                                            0.005,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: ExpansionTile(
                                      initiallyExpanded: true,
                                      title: Row(children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text('Identitas Pengemudi',
                                              style:
                                                  GlobalFont.mediumgiantfontR),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                  child:
                                                      LinearProgressIndicator(
                                                    backgroundColor:
                                                        Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    value: menuState
                                                            .getDeliveryList[0]
                                                            .persenterkirim /
                                                        100,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(Colors.blue),
                                                  ),
                                                ),
                                                Text(
                                                    'Total Koli ${menuState.getDeliveryList[0].totaltekirim} / ${menuState.getDeliveryList[0].totalkoli} (${menuState.getDeliveryList[0].persenterkirim} %)',
                                                    style: GlobalFont
                                                        .mediumbigfontMBold),
                                              ]),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                SizedBox(
                                                  height: 30,
                                                  child:
                                                      LinearProgressIndicator(
                                                    backgroundColor:
                                                        Colors.grey[300],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    value: menuState
                                                            .getDeliveryList[0]
                                                            .persentokoterkirim /
                                                        100,
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                            Color>(Colors.red),
                                                  ),
                                                ),
                                                Text(
                                                    'Total Toko ${menuState.getDeliveryList[0].totaltokoterkirim} / ${menuState.getDeliveryList[0].totaltoko} (${menuState.getDeliveryList[0].persentokoterkirim} %)',
                                                    style: GlobalFont
                                                        .mediumbigfontMBold),
                                              ]),
                                        ),
                                        Expanded(flex: 1, child: SizedBox()),
                                      ]),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      childrenPadding: EdgeInsets.symmetric(
                                        horizontal: 15.0,
                                        vertical: 10.0,
                                      ),
                                      children: [
                                        SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.135,
                                          child: Row(children: [
                                            // Data Pengemudi
                                            Expanded(
                                              child: SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      menuState
                                                          .getDeliveryList[0]
                                                          .employeeName,
                                                      style: GlobalFont
                                                          .mediumgiantfontRBold,
                                                    ),
                                                    Text(
                                                      '${menuState.getDeliveryList[0].employeeId} (ID)',
                                                      style:
                                                          GlobalFont.bigfontR,
                                                    ),
                                                    Text(
                                                      '${menuState.getDeliveryList[0].drivingLicense} (SIM)',
                                                      style:
                                                          GlobalFont.bigfontR,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // Data Kendaraan
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Data Kendaraan',
                                                        style: GlobalFont
                                                            .bigfontRBold,
                                                      ),
                                                      TextDisplay(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        'Plat nomor:',
                                                        menuState
                                                            .getDeliveryList[0]
                                                            .plateNumber,
                                                      ),
                                                      TextDisplay(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        'Nomor IMEI:',
                                                        menuState
                                                            .getDeliveryList[0]
                                                            .imeiNumber,
                                                      ),
                                                      TextDisplay(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        'Nomor chasis:',
                                                        menuState
                                                            .getDeliveryList[0]
                                                            .chasisNumber,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Data Keberangkatan
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Keberangkatan',
                                                    style:
                                                        GlobalFont.bigfontRBold,
                                                  ),
                                                  Text(
                                                    (menuState
                                                            .getDeliveryList[0]
                                                            .startTime
                                                            .isNotEmpty)
                                                        ? 'Pukul ${menuState.getDeliveryList[0].startTime}'
                                                        : '-',
                                                    style: GlobalFont.bigfontR,
                                                  ),
                                                  Text(
                                                    (menuState
                                                            .getDeliveryList[0]
                                                            .startKm
                                                            .isNotEmpty)
                                                        ? '${menuState.getDeliveryList[0].startKm} (KM)'
                                                        : '-',
                                                    style: GlobalFont.bigfontR,
                                                  ),
                                                  InkWell(
                                                    onTap: () => GlobalFunction
                                                        .viewImage(
                                                      context,
                                                      menuState,
                                                      'START',
                                                      menuState.getDeliveryList
                                                              .isNotEmpty
                                                          ? menuState
                                                              .getDeliveryList[
                                                                  0]
                                                              .activityNumber
                                                          : '',
                                                      '',
                                                    ),
                                                    hoverColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    child: Text(
                                                      'Lihat Gambar',
                                                      style: GlobalFont
                                                          .bigfontRBlue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Data Kedatangan
                                            Expanded(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Kedatangan',
                                                      style: GlobalFont
                                                          .bigfontRBold,
                                                    ),
                                                    Text(
                                                      (menuState
                                                              .getDeliveryList[
                                                                  0]
                                                              .endTime
                                                              .isNotEmpty)
                                                          ? 'Pukul ${menuState.getDeliveryList[0].endTime}'
                                                          : '-',
                                                      style:
                                                          GlobalFont.bigfontR,
                                                    ),
                                                    Text(
                                                      (menuState
                                                              .getDeliveryList[
                                                                  0]
                                                              .endKm
                                                              .isNotEmpty)
                                                          ? '${menuState.getDeliveryList[0].endKm} (KM)'
                                                          : '-',
                                                      style:
                                                          GlobalFont.bigfontR,
                                                    ),
                                                    InkWell(
                                                      onTap: () =>
                                                          GlobalFunction
                                                              .viewImage(
                                                        context,
                                                        menuState,
                                                        'END',
                                                        menuState
                                                                .getDeliveryList
                                                                .isNotEmpty
                                                            ? menuState
                                                                .getDeliveryList[
                                                                    0]
                                                                .activityNumber
                                                            : '',
                                                        '',
                                                      ),
                                                      hoverColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      child: Text(
                                                        'Lihat Gambar',
                                                        style: GlobalFont
                                                            .bigfontRBlue,
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                            Expanded(
                                              child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Approval Biaya',
                                                      style: GlobalFont
                                                          .bigfontRBold,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Icon(
                                                            menuState
                                                                        .getDeliveryList[
                                                                            0]
                                                                        .flagApproval ==
                                                                    0
                                                                ? Icons.info
                                                                : Icons
                                                                    .check_circle,
                                                            color: menuState
                                                                        .getDeliveryList[
                                                                            0]
                                                                        .flagApproval ==
                                                                    0
                                                                ? Colors
                                                                    .red[900]
                                                                : Colors.green[
                                                                    900]),
                                                        SizedBox(width: 5),
                                                        Text(
                                                            menuState
                                                                        .getDeliveryList[
                                                                            0]
                                                                        .flagApproval ==
                                                                    0
                                                                ? 'PENDING'
                                                                : 'SUDAH APPROVE',
                                                            style: GlobalFont
                                                                .bigfontR),
                                                      ],
                                                    ),
                                                    Text('',
                                                        style: GlobalFont
                                                            .bigfontR),
                                                    InkWell(
                                                      onTap: () => wOpenDialog(
                                                          context,
                                                          true,
                                                          DeliveryBiaya(
                                                              menuState
                                                                  .getDeliveryList[
                                                                      0]
                                                                  .activityNumber,
                                                              menuState
                                                                  .getDeliveryList,
                                                              searchDelivery)),
                                                      hoverColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      child: Text(
                                                        'Lihat Rincian',
                                                        style: GlobalFont
                                                            .bigfontRBlue,
                                                      ),
                                                    )
                                                  ]),
                                            ),
                                          ]),
                                        )
                                      ]),
                                ),

                                // Devider
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),

                                // ===============================================
                                // =========== Delivery Activities ===============
                                // ===============================================
                                Expanded(
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2.65,
                                    children:
                                        deliveryDetail.asMap().entries.map(
                                      (details) {
                                        int index = details.key;
                                        CheckListDetailsModel detail =
                                            details.value;

                                        if (deliveryDetail.length ==
                                            index + 1) {
                                          if (menuState.getDeliveryList[0]
                                              .endTime.isNotEmpty) {
                                            return DeliveryCard(
                                              detail,
                                              destinationTime: menuState
                                                  .getDeliveryList[0].startTime,
                                            );
                                          } else {
                                            return DeliveryCard(detail);
                                          }
                                        } else {
                                          if (deliveryDetail[index + 1]
                                                  .deliveryTime
                                                  .isNotEmpty &&
                                              deliveryDetail.length != index) {
                                            return DeliveryCard(
                                              detail,
                                              destinationTime:
                                                  deliveryDetail[index + 1]
                                                      .deliveryTime,
                                            );
                                          } else {
                                            return DeliveryCard(detail);
                                          }
                                        }
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            isLoading = true;
                            return FutureBuilder(
                              future: menuState.fetchDeliveryChecklist(
                                companyId,
                                menuState.getBranchId,
                                menuState.getShopId,
                                driverName,
                                date,
                                onDeliveryPage: true,
                              ),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  // triggerIsLoading();
                                  isLoading = false;
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
                                      SizedBox(height: 10.0),
                                      Text(
                                        'Loading...',
                                        style: GlobalFont.bigfontR,
                                      ),
                                    ],
                                  );
                                } else if (snapshot.hasError) {
                                  // triggerIsLoading();
                                  isLoading = false;
                                  return const Center(
                                    child:
                                        Text('Mohon maaf, terjadi kesalahan'),
                                  );
                                } else if (!snapshot.hasData ||
                                    snapshot.data![0].employeeId.isEmpty) {
                                  // triggerIsLoading();
                                  isLoading = false;
                                  return const Center(
                                    child: Text('Data tidak tersedia'),
                                  );
                                } else {
                                  // triggerIsLoading();
                                  isLoading = false;
                                  List<CheckListDetailsModel> deliveryDetail =
                                      snapshot.data![0].deliveryDetail;

                                  return Column(
                                    children: [
                                      // ===============================================
                                      // ============= Driver Identity =================
                                      // ===============================================
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(
                                          horizontal: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.005,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.grey,
                                              blurRadius: 5.0,
                                            ),
                                          ],
                                        ),
                                        child: ExpansionTile(
                                          initiallyExpanded: true,
                                          title: Text(
                                            'Identitas Pengemudi',
                                            style: GlobalFont.mediumgiantfontR,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          childrenPadding: EdgeInsets.symmetric(
                                            horizontal: 15.0,
                                            vertical: 10.0,
                                          ),
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.135,
                                              child: Row(
                                                children: [
                                                  // Data Pengemudi
                                                  Expanded(
                                                    child: SizedBox(
                                                      height:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .height,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            snapshot.data![0]
                                                                .employeeName,
                                                            style: GlobalFont
                                                                .mediumgiantfontRBold,
                                                          ),
                                                          Text(
                                                            '${snapshot.data![0].employeeId} (ID)',
                                                            style: GlobalFont
                                                                .bigfontR,
                                                          ),
                                                          Text(
                                                            '${snapshot.data![0].drivingLicense} (SIM)',
                                                            style: GlobalFont
                                                                .bigfontR,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          SizedBox(
                                                            height: 30,
                                                            child:
                                                                LinearProgressIndicator(
                                                              backgroundColor:
                                                                  Colors.grey[
                                                                      300],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              value: menuState
                                                                      .getDeliveryList[
                                                                          0]
                                                                      .persenterkirim /
                                                                  100,
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .blue),
                                                            ),
                                                          ),
                                                          Text(
                                                              'Total Koli ${menuState.getDeliveryList[0].totaltekirim} / ${menuState.getDeliveryList[0].totalkoli} (${menuState.getDeliveryList[0].persenterkirim} %)',
                                                              style: GlobalFont
                                                                  .mediumbigfontMBold),
                                                        ]),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    flex: 2,
                                                    child: Stack(
                                                        alignment:
                                                            Alignment.center,
                                                        children: [
                                                          SizedBox(
                                                            height: 30,
                                                            child:
                                                                LinearProgressIndicator(
                                                              backgroundColor:
                                                                  Colors.grey[
                                                                      300],
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              value: menuState
                                                                      .getDeliveryList[
                                                                          0]
                                                                      .persentokoterkirim /
                                                                  100,
                                                              valueColor:
                                                                  AlwaysStoppedAnimation<
                                                                          Color>(
                                                                      Colors
                                                                          .blue),
                                                            ),
                                                          ),
                                                          Text(
                                                              'Total Toko ${menuState.getDeliveryList[0].totaltokoterkirim} / ${menuState.getDeliveryList[0].totaltoko} (${menuState.getDeliveryList[0].persentokoterkirim} %)',
                                                              style: GlobalFont
                                                                  .mediumbigfontMBold),
                                                        ]),
                                                  ),
                                                  Expanded(
                                                      flex: 1,
                                                      child: SizedBox()),

                                                  // Data Kendaraan
                                                  Expanded(
                                                    flex: 2,
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Data Kendaraan',
                                                              style: GlobalFont
                                                                  .bigfontRBold,
                                                            ),
                                                            TextDisplay(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.25,
                                                              'Plat nomor:',
                                                              snapshot.data![0]
                                                                  .plateNumber,
                                                            ),
                                                            TextDisplay(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.25,
                                                              'Nomor IMEI:',
                                                              snapshot.data![0]
                                                                  .imeiNumber,
                                                            ),
                                                            TextDisplay(
                                                              MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.25,
                                                              'Nomor chasis:',
                                                              snapshot.data![0]
                                                                  .chasisNumber,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // Data Keberangkatan
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Keberangkatan',
                                                          style: GlobalFont
                                                              .bigfontRBold,
                                                        ),
                                                        Text(
                                                          (snapshot
                                                                  .data![0]
                                                                  .startTime
                                                                  .isNotEmpty)
                                                              ? 'Pukul ${snapshot.data![0].startTime}'
                                                              : '-',
                                                          style: GlobalFont
                                                              .bigfontR,
                                                        ),
                                                        Text(
                                                          (snapshot
                                                                  .data![0]
                                                                  .startKm
                                                                  .isNotEmpty)
                                                              ? '${snapshot.data![0].startKm} (KM)'
                                                              : '-',
                                                          style: GlobalFont
                                                              .bigfontR,
                                                        ),
                                                        InkWell(
                                                          onTap: () =>
                                                              GlobalFunction
                                                                  .viewImage(
                                                            context,
                                                            menuState,
                                                            'START',
                                                            menuState
                                                                    .getDeliveryList
                                                                    .isNotEmpty
                                                                ? menuState
                                                                    .getDeliveryList[
                                                                        0]
                                                                    .activityNumber
                                                                : '',
                                                            '',
                                                          ),
                                                          hoverColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          child: Text(
                                                            'Lihat Gambar',
                                                            style: GlobalFont
                                                                .bigfontRBlue,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // Data Kedatangan
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Kedatangan',
                                                          style: GlobalFont
                                                              .bigfontRBold,
                                                        ),
                                                        Text(
                                                          (snapshot
                                                                  .data![0]
                                                                  .endTime
                                                                  .isNotEmpty)
                                                              ? 'Pukul ${snapshot.data![0].endTime}'
                                                              : '-',
                                                          style: GlobalFont
                                                              .bigfontR,
                                                        ),
                                                        Text(
                                                          (snapshot
                                                                  .data![0]
                                                                  .endKm
                                                                  .isNotEmpty)
                                                              ? '${snapshot.data![0].endKm} (KM)'
                                                              : '-',
                                                          style: GlobalFont
                                                              .bigfontR,
                                                        ),
                                                        InkWell(
                                                          onTap: () =>
                                                              GlobalFunction
                                                                  .viewImage(
                                                            context,
                                                            menuState,
                                                            'END',
                                                            menuState
                                                                    .getDeliveryList
                                                                    .isNotEmpty
                                                                ? menuState
                                                                    .getDeliveryList[
                                                                        0]
                                                                    .activityNumber
                                                                : '',
                                                            '',
                                                          ),
                                                          hoverColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          child: Text(
                                                            'Lihat Gambar',
                                                            style: GlobalFont
                                                                .bigfontRBlue,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Approval Biaya',
                                                            style: GlobalFont
                                                                .bigfontRBold,
                                                          ),
                                                          Row(
                                                            children: [
                                                              Icon(
                                                                  menuState.getDeliveryList[0].flagApproval == 0
                                                                      ? Icons
                                                                          .info
                                                                      : Icons
                                                                          .check_circle,
                                                                  color: menuState
                                                                              .getDeliveryList[
                                                                                  0]
                                                                              .flagApproval ==
                                                                          0
                                                                      ? Colors.red[
                                                                          900]
                                                                      : Colors.green[
                                                                          900]),
                                                              SizedBox(
                                                                  width: 5),
                                                              Text(
                                                                  menuState.getDeliveryList[0].flagApproval ==
                                                                          0
                                                                      ? 'PENDING'
                                                                      : 'SUDAH APPROVE',
                                                                  style: GlobalFont
                                                                      .bigfontR),
                                                            ],
                                                          ),
                                                          Text('',
                                                              style: GlobalFont
                                                                  .bigfontR),
                                                          InkWell(
                                                            onTap: () => wOpenDialog(
                                                                context,
                                                                true,
                                                                DeliveryBiaya(
                                                                    menuState
                                                                        .getDeliveryList[
                                                                            0]
                                                                        .activityNumber,
                                                                    menuState
                                                                        .getDeliveryList,
                                                                    searchDelivery)),
                                                            hoverColor: Colors
                                                                .transparent,
                                                            focusColor: Colors
                                                                .transparent,
                                                            child: Text(
                                                              'Lihat Rincian',
                                                              style: GlobalFont
                                                                  .bigfontRBlue,
                                                            ),
                                                          )
                                                        ]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // Devider
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),

                                      // ===============================================
                                      // =========== Delivery Activities ===============
                                      // ===============================================
                                      Expanded(
                                        child: GridView.count(
                                          crossAxisCount: 2,
                                          childAspectRatio: 2.65,
                                          padding: EdgeInsets.zero,
                                          physics: BouncingScrollPhysics(),
                                          children: deliveryDetail
                                              .asMap()
                                              .entries
                                              .map(
                                            (details) {
                                              int index = details.key;
                                              CheckListDetailsModel detail =
                                                  details.value;

                                              if (deliveryDetail.length ==
                                                  index + 1) {
                                                if (menuState.getDeliveryList[0]
                                                    .endTime.isNotEmpty) {
                                                  return DeliveryCard(
                                                    detail,
                                                    destinationTime: menuState
                                                        .getDeliveryList[0]
                                                        .startTime,
                                                  );
                                                } else {
                                                  return DeliveryCard(detail);
                                                }
                                              } else {
                                                if (deliveryDetail[index + 1]
                                                        .deliveryTime
                                                        .isNotEmpty &&
                                                    deliveryDetail.length !=
                                                        index) {
                                                  return DeliveryCard(
                                                    detail,
                                                    destinationTime:
                                                        deliveryDetail[
                                                                index + 1]
                                                            .deliveryTime,
                                                  );
                                                } else {
                                                  return DeliveryCard(detail);
                                                }
                                              }
                                            },
                                          ).toList(),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            );
                          }
                        } else {
                          // triggerIsLoading();
                          isLoading = false;
                          if (menuState.getDeliveryList.isNotEmpty) {
                            List<CheckListDetailsModel> deliveryDetail =
                                menuState.getDeliveryList[0].deliveryDetail;

                            return Column(
                              children: [
                                // ===============================================
                                // ============= Driver Identity =================
                                // ===============================================
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.height *
                                            0.005,
                                    vertical: 15,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.grey,
                                        blurRadius: 5.0,
                                      ),
                                    ],
                                  ),
                                  child: ExpansionTile(
                                    initiallyExpanded: true,
                                    title: Text(
                                      'Identitas Pengemudi',
                                      style: GlobalFont.mediumgiantfontR,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    childrenPadding: EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 10.0,
                                    ),
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.135,
                                        child: Row(
                                          children: [
                                            // Data Pengemudi
                                            Expanded(
                                              child: SizedBox(
                                                height: MediaQuery.of(context)
                                                    .size
                                                    .height,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      menuState
                                                          .getDeliveryList[0]
                                                          .employeeName,
                                                      style: GlobalFont
                                                          .mediumgiantfontRBold,
                                                    ),
                                                    Text(
                                                      '${menuState.getDeliveryList[0].employeeId} (ID)',
                                                      style:
                                                          GlobalFont.bigfontR,
                                                    ),
                                                    Text(
                                                      '${menuState.getDeliveryList[0].drivingLicense} (SIM)',
                                                      style:
                                                          GlobalFont.bigfontR,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),

                                            // Data Kendaraan
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        'Data Kendaraan',
                                                        style: GlobalFont
                                                            .bigfontRBold,
                                                      ),
                                                      TextDisplay(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        'Plat nomor:',
                                                        menuState
                                                            .getDeliveryList[0]
                                                            .plateNumber,
                                                      ),
                                                      TextDisplay(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        'Nomor IMEI:',
                                                        menuState
                                                            .getDeliveryList[0]
                                                            .imeiNumber,
                                                      ),
                                                      TextDisplay(
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.25,
                                                        'Nomor chasis:',
                                                        menuState
                                                            .getDeliveryList[0]
                                                            .chasisNumber,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Data Keberangkatan
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Keberangkatan',
                                                    style:
                                                        GlobalFont.bigfontRBold,
                                                  ),
                                                  Text(
                                                    (menuState
                                                            .getDeliveryList[0]
                                                            .startTime
                                                            .isNotEmpty)
                                                        ? 'Pukul ${menuState.getDeliveryList[0].startTime}'
                                                        : '-',
                                                    style: GlobalFont.bigfontR,
                                                  ),
                                                  Text(
                                                    (menuState
                                                            .getDeliveryList[0]
                                                            .startKm
                                                            .isNotEmpty)
                                                        ? '${menuState.getDeliveryList[0].startKm} (KM)'
                                                        : '-',
                                                    style: GlobalFont.bigfontR,
                                                  ),
                                                  InkWell(
                                                    onTap: () => GlobalFunction
                                                        .viewImage(
                                                      context,
                                                      menuState,
                                                      'START',
                                                      menuState.getDeliveryList
                                                              .isNotEmpty
                                                          ? menuState
                                                              .getDeliveryList[
                                                                  0]
                                                              .activityNumber
                                                          : '',
                                                      '',
                                                    ),
                                                    hoverColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    child: Text(
                                                      'Lihat Gambar',
                                                      style: GlobalFont
                                                          .bigfontRBlue,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            // Data Kedatangan
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Kedatangan',
                                                    style:
                                                        GlobalFont.bigfontRBold,
                                                  ),
                                                  Text(
                                                    (menuState
                                                            .getDeliveryList[0]
                                                            .endTime
                                                            .isNotEmpty)
                                                        ? 'Pukul ${menuState.getDeliveryList[0].endTime}'
                                                        : '-',
                                                    style: GlobalFont.bigfontR,
                                                  ),
                                                  Text(
                                                    (menuState
                                                            .getDeliveryList[0]
                                                            .endKm
                                                            .isNotEmpty)
                                                        ? '${menuState.getDeliveryList[0].endKm} (KM)'
                                                        : '-',
                                                    style: GlobalFont.bigfontR,
                                                  ),
                                                  InkWell(
                                                    onTap: () => GlobalFunction
                                                        .viewImage(
                                                      context,
                                                      menuState,
                                                      'END',
                                                      menuState.getDeliveryList
                                                              .isNotEmpty
                                                          ? menuState
                                                              .getDeliveryList[
                                                                  0]
                                                              .activityNumber
                                                          : '',
                                                      '',
                                                    ),
                                                    hoverColor:
                                                        Colors.transparent,
                                                    focusColor:
                                                        Colors.transparent,
                                                    child: Text(
                                                      'Lihat Gambar',
                                                      style: GlobalFont
                                                          .bigfontRBlue,
                                                    ),
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

                                // Devider
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.01,
                                ),

                                // ===============================================
                                // =========== Delivery Activities ===============
                                // ===============================================
                                Expanded(
                                  child: GridView.count(
                                    crossAxisCount: 2,
                                    childAspectRatio: 2.65,
                                    children:
                                        deliveryDetail.asMap().entries.map(
                                      (details) {
                                        int index = details.key;
                                        CheckListDetailsModel detail =
                                            details.value;

                                        if (deliveryDetail.length ==
                                            index + 1) {
                                          if (menuState.getDeliveryList[0]
                                              .endTime.isNotEmpty) {
                                            return DeliveryCard(
                                              detail,
                                              destinationTime: menuState
                                                  .getDeliveryList[0].startTime,
                                            );
                                          } else {
                                            return DeliveryCard(detail);
                                          }
                                        } else {
                                          if (deliveryDetail[index + 1]
                                                  .deliveryTime
                                                  .isNotEmpty &&
                                              deliveryDetail.length != index) {
                                            return DeliveryCard(
                                              detail,
                                              destinationTime:
                                                  deliveryDetail[index + 1]
                                                      .deliveryTime,
                                            );
                                          } else {
                                            return DeliveryCard(detail);
                                          }
                                        }
                                      },
                                    ).toList(),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const Center(
                              child: Text('Data tidak tersedia'),
                            );
                          }
                        }
                      },
                    ),

                    // Note --> without database
                    // child: GridView.count(
                    //   crossAxisCount: 2,
                    //   childAspectRatio: 2.75,
                    //   children: [
                    //     DeliveryCard(detail1),
                    //     DeliveryCard(detail2),
                    //     DeliveryCard(detail3),
                    //     DeliveryCard(detail1),
                    //     DeliveryCard(detail2),
                    //     DeliveryCard(detail3),
                    //   ],
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
