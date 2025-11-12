// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/aktivitas-subdealer/helper/api_aktivitas_subdealer.dart';
import 'package:stsj/aktivitas-subdealer/helper/model_aktivitas_subdealer.dart';
import 'package:stsj/core/models/Activities/activities.dart';
import 'package:stsj/core/models/Activities/point_calculation.dart';
import 'package:stsj/core/models/Activities/activity_route.dart';
import 'package:stsj/core/models/Activities/area.dart';
import 'package:stsj/core/models/Activities/branch_shop.dart';
import 'package:stsj/core/models/Activities/details_processing.dart';
import 'package:stsj/core/models/Activities/image.dart';
import 'package:stsj/core/models/Activities/manager_activities.dart';
import 'package:stsj/core/models/Activities/points_type.dart';
import 'package:stsj/core/models/Activities/province.dart';
import 'package:stsj/core/models/Activities/return_result.dart';
import 'package:stsj/core/models/Activities/salesman.dart';
import 'package:stsj/core/models/Activities/salesman_activities.dart';
import 'package:stsj/core/models/Activities/weekly_report.dart';
import 'package:stsj/core/models/Activities/weekly_report_type.dart';
import 'package:stsj/core/models/AuthModel/DataAuth.dart';
import 'package:stsj/core/models/AuthModel/user_access.dart';
import 'package:stsj/core/models/Dashboard/branch_shop.dart';
import 'package:stsj/core/models/Dashboard/delivery.dart';
import 'package:stsj/core/models/Dashboard/delivery_approval.dart';
import 'package:stsj/core/models/Dashboard/delivery_memo.dart';
import 'package:stsj/core/models/Dashboard/delivery_history.dart';
import 'package:stsj/core/models/Dashboard/delivery_monthly.dart';
import 'package:stsj/core/models/Dashboard/driver.dart';
import 'package:stsj/core/models/Dashboard/picking_packing.dart';
import 'package:stsj/core/models/Report/absent_history.dart';
import 'package:stsj/core/models/Report/free_stock_modif.dart';
import 'package:stsj/core/models/Report/free_stock_result.dart';
import 'package:stsj/core/models/Report/mbrowse_salesman.dart';
import 'package:stsj/core/models/SalesDashboardModel/free_stock_model.dart';
import 'package:stsj/dashboard-fixup/utilities/utils.dart';
import 'package:stsj/global/api.dart';
import 'package:stsj/router/router_const.dart';
import 'package:url_launcher/url_launcher.dart';

class LoadingModel with ChangeNotifier {
  bool _isLoading = true;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

class UserIDmodel with ChangeNotifier {
  List<String> _user = [];

  List<String> get getUserList => _user;

  void setUser(List<String> value) {
    _user = value;
    notifyListeners();
  }
}

class PtModel with ChangeNotifier {
  void getPTClicked(String pt) async {
    SharedPreferences ptClicked = await SharedPreferences.getInstance();
    ptClicked.setString("PT", pt);
  }

  String _ClickPT = "";

  String get getPT => _ClickPT;

  void setPT(String value) {
    _ClickPT = value;
    getPTClicked(_ClickPT);
    notifyListeners();
  }
}

class MenuState with ChangeNotifier {
  // ===================================================================
  // ======================== App Management ===========================
  // ===================================================================
  bool isLoading = false;

  bool get getIsLoading => isLoading;

  void setIsLoading() {
    isLoading = !isLoading;
    notifyListeners();
  }

  // =================================================================
  // ================= User Company Authorization ====================
  // =================================================================

  List<String> companyAuthorization = [];
  List<String> get getCompanyAuthorization => companyAuthorization;

  Future<void> readCompanyAuthorization() async {
    final prefs = await SharedPreferences.getInstance();
    companyAuthorization.clear();
    if (prefs.getBool('STSJ')!) companyAuthorization.add('STSJ');
    if (prefs.getBool('SS')!) companyAuthorization.add('SS');
    if (prefs.getBool('SP')!) companyAuthorization.add('SP');
    if (prefs.getBool('SPAA')!) companyAuthorization.add('SPAA');
    if (prefs.getBool('SAMP')!) companyAuthorization.add('SAMP');
    if (prefs.getBool('ST')!) companyAuthorization.add('ST');
    if (prefs.getBool('RSSM')!) companyAuthorization.add('RSSM');
    if (prefs.getBool('Spr')!) companyAuthorization.add('Spr');
  }

  // =================================================================
  // ======================== User Account ===========================
  // =================================================================
  String userId = '';
  String get getUserId => userId;

  String entryLevelId = '';
  String get getEntryLevelId => entryLevelId;

  String entryLevelName = '';
  String get getEntryLevelName => entryLevelName;

  String password = '';
  String get getPassword => password;

  String companyName = '';
  String get getCompanyName => companyName;

  String branchId = '';
  String get getBranchId => branchId;

  String shopId = '';
  String get getShopId => shopId;

  List<DataDT> userCompanyAccList = [];
  List<DataDT> get getUserCompanyAccList => userCompanyAccList;

  // ================================================================
  // ======================== User Access ===========================
  // ================================================================
  List<ModelUserAccess> userAccessList = [];

  List<ModelUserAccess> get getUserAccessList => userAccessList;

  List<String> headerList = [];

  List<String> get getHeaderList => headerList;

  // List<bool> headerStateList = [];

  // List<bool> get getHeaderStateList => headerStateList;

  // List<UserAccessModel> subHeaderList = [];

  // List<UserAccessModel> get getSubHeaderList => subHeaderList;

  List<String> subHeaderList = [];

  List<String> get getSubHeaderList => subHeaderList;

  List<String> subHeaderAllowEditList = [];

  List<String> get getsubHeaderAllowEditList => subHeaderAllowEditList;

  Future<void> loadSubHeader() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    subHeaderList.clear();
    subHeaderList.addAll(prefs.getStringList('subheader') ?? []);
    notifyListeners();

    print('Load Sub Header: ${subHeaderList.length}');
  }

  Future<List<ModelUserAccess>> fetchUserAccess(
    String companyName,
    String entryLevelId,
  ) async {
    log('fetchUserAccess');
    print('Company Name: $companyName');
    print('Entry Level ID: $entryLevelId');

    List<ModelUserAccess> temp = [];
    temp.addAll(await GlobalAPI.fetchUserAccess(
      companyName,
      entryLevelId,
    ));

    // for (ModelUserAccess data in userAccessList) {
    //   print(
    //     '${data.category}; ${data.menuNumber}; ${data.menuName}; ${data.isAllow}',
    //   );
    // }

    return temp;
  }

  // ================================================================
  // ============================ FPM ===============================
  // ================================================================
  List<Map<String, String>> filteredDashboardList = [];
  List<Map<String, String>> get getFilteredDashboardList =>
      filteredDashboardList;

  void setFilteredDashboardList(List<Map<String, String>> value) {
    filteredDashboardList = value;
    notifyListeners();
  }

  Future<void> readDashboardList() async {
    await loadSubHeader();
    List<Map<String, String>> temp = [];
    for (Map<String, String> e in dashboardList) {
      if (getSubHeaderList.contains(e['acc']) && e['acc'] != '000') {
        print('${e['acc']} added');
        temp.add(e);
      } else if (e['acc'] == '000') {
        print('${e['acc']} added');
        temp.add(e);
      } else {
        // do nothing
      }
    }
    setFilteredDashboardList(temp);
    notifyListeners();
  }

  String workshopName = '';
  String get getWorkshopName => workshopName;

  void setWorkshopName(String value) {
    workshopName = value;
    notifyListeners();
  }

  String fpmDateFilter = '';
  String get getFpmDateFilter => fpmDateFilter;

  void setFpmDateFilter(String value) {
    fpmDateFilter = value;
    notifyListeners();
  }

  // ================================================================
  // ========================= Dashboard ============================
  // ================================================================
  List<ModelBranches> branchShopList = [];

  List<ModelBranches> get getBranchShopList => branchShopList;

  List<String> branchNameList = [];
  List<String> get getBranchNameList => branchNameList;

  ValueNotifier<List<String>> branchNameListNotifier = ValueNotifier([]);
  ValueNotifier<List<String>> get getBranchNameListNotifier =>
      branchNameListNotifier;

  void setBranchNameListNotifier(List<String> value) {
    branchNameListNotifier.value = value;
    notifyListeners();
  }

  ValueNotifier<String> branchNameNotifier = ValueNotifier('');

  void setBranchNameNotifier(String value) {
    branchNameNotifier.value = value;
    notifyListeners();
  }

  List<ModelDriver> driverList = [];

  List<ModelDriver> get getDriverList => driverList;

  Future<void> loadSisBranches() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    log('Branch Name List (before): ${getBranchNameList.length}');
    log('${prefs.getStringList('branches')}');
    if (branchNameList.isNotEmpty) {
      log('Branch Name List is not empty');
      branchNameList = [];
      log('Branch Name List: ${getBranchNameList.length}');
    }
    for (var data in prefs.getStringList('branches')!) {
      branchNameList.add(data);
    }
    //branchNameList.addAll(prefs.getStringList('branches'));
    log('Branch Name List (after): ${getBranchNameList.length}');
    setBranchNameListNotifier(prefs.getStringList('branches') ?? []);
    notifyListeners();
  }

  Future<void> fetchSISBranches() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('UserID') ?? '';
    final companyId = prefs.getString('CompanyName') ?? '';

    print('xxUser ID: $userId');
    print('xxCompany ID: $companyId');

    branchShopList = [];
    branchShopList.addAll(await GlobalAPI.getSISBranchShop(userId, companyId));

    log(branchShopList.length.toString());

    prefs.remove('branches');
    await prefs.setStringList(
      'branches',
      branchShopList.map((e) => e.name).toList(),
    );

    // if (prefs.getStringList('branches') == null) {
    //   await prefs.setStringList(
    //     'branches',
    //     branchShopList.map((e) => e.name).toList(),
    //   );
    // }
  }

  Future<void> fetchSISDriver() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final companyId = prefs.getString('CompanyName') ?? '';

    print('Company ID: $companyId');

    driverList = [];
    driverList.addAll(await GlobalAPI.getSISDrivers(companyId));
    // print('Driver List: ${driverList.length}');

    filteredDriverList = [];
    filteredDriverList.addAll(driverList);
    // print('Filtered Driver List: ${filteredDriverList.length}');
  }

  List<ModelDriver> filteredDriverList = [];

  List<ModelDriver> get getFilteredDriverList => filteredDriverList;

  Future<void> filterDriver(String selectedBranch) async {
    if (branchShopList.isEmpty) {
      await fetchSISBranches();
    }
    List<ModelBranches> temp = [];
    print(selectedBranch);
    // log('Branch Shop (before): ${branchShopList.length}');
    temp.addAll(branchShopList.where((e) => e.name == selectedBranch));
    print(temp.length);
    // log('Branch Shop (after): ${temp.length}');

    if (driverList.isEmpty) {
      await fetchSISDriver();
    }
    // log('Driver List (before): ${filteredDriverList.length}');
    filteredDriverList = [];
    filteredDriverList.addAll(
      driverList
          .where((e) =>
              (e.shopId == temp[0].shopId && e.branchId == temp[0].branchId))
          .toList(),
    );

    // log('Driver List (after): ${filteredDriverList.length}');
    notifyListeners();
    // log('filterDriver called. New filtered list length: ${filteredDriverList.length}');
    log('New Driver list');
    for (var x in filteredDriverList) {
      print(x.employeeName);
    }
  }

  List<String> filteredDriverNameList = [];
  List<String> get getFilteredDriverNameList => filteredDriverNameList;

  void setFilteredDriverNameList(List<String> value) {
    filteredDriverNameList.add('');
    filteredDriverNameList = value;
    notifyListeners();
  }

  ValueNotifier<List<String>> filteredDriverNameListNotifier =
      ValueNotifier<List<String>>([]);
  ValueNotifier<List<String>> get getFilteredDriverNameListNotifier =>
      filteredDriverNameListNotifier;

  void setFilteredDriverNameListNotifier(List<String> value) {
    filteredDriverNameListNotifier.value = value;
    notifyListeners();
  }

  bool isTruckCameraFocus = true;

  bool get getIsTruckCameraFocus => isTruckCameraFocus;

  void setTruckCameraFocus() {
    isTruckCameraFocus = !isTruckCameraFocus;
    notifyListeners();
  }

  bool isMovementPaused = false;

  bool get getIsMovementPaused => isMovementPaused;

  void setMovementPaused() {
    isMovementPaused = !isMovementPaused;
    notifyListeners();
  }

  int deliveryHistoryLength = 0;

  int get getDeliveryHistoryLength => deliveryHistoryLength;

  List<DeliveryModel> deliveryList = [];

  List<DeliveryModel> get getDeliveryList => deliveryList;

  List<DeliveryHistoryModel> deliveryHistoryList = [];

  List<DeliveryHistoryModel> get getDeliveryHistoryList => deliveryHistoryList;

  Future<List<DeliveryModel>> fetchDeliveryChecklist(
    String companyId,
    String branchId,
    String shopId,
    String driverName,
    String currentDate, {
    bool onDeliveryPage = false,
  }) async {
    String employeeId = '';
    for (ModelDriver driver in filteredDriverList) {
      if (driver.employeeName == driverName) {
        employeeId = driver.employeeId;
        break;
      }
    }

    if (onDeliveryPage) {
      // Saved as Cache Data
      log('Save Delivery Checklist');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('branchId', branchId);
      prefs.setString('shopId', shopId);
      prefs.setString('employeeId', employeeId);
      prefs.setString('currentDate', currentDate);
    } else {
      // Fetch from Cache Data
      log('Fetch Delivery Checklist');
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      companyId = prefs.getString('CompanyName') ?? '';
      branchId = prefs.getString('branchId') ?? '';
      shopId = prefs.getString('shopId') ?? '';
      employeeId = prefs.getString('employeeId') ?? '';
      currentDate = prefs.getString('currentDate') ?? '';
    }

    print('');
    log('Fetch Delivery Checklist');
    print('Company ID: $companyId');
    print('Employee ID: $employeeId');
    print('Branch ID: $branchId');
    print('Shop ID: $shopId');
    print('Date: $currentDate');
    print('');

    deliveryList.clear();
    deliveryList.addAll(
      await GlobalAPI.fetchDeliveryList(
        companyId,
        branchId,
        shopId,
        employeeId,
        currentDate,
      ),
    );

    print('Delivery length: ${deliveryList.length}');
    // print('Delivery Details length: ${deliveryList[0].deliveryDetail.length}');
    print('IMEI Number: ${deliveryList[0].imeiNumber}');

    deliveryHistoryList.clear();
    deliveryHistoryList.addAll(
      await GlobalAPI.fetchDeliveryHistory(
        deliveryList[0].chasisNumber,
        currentDate,
      ),
    );

    print('Delivery History length: ${deliveryHistoryList.length}');

    // deliveryHistoryLength = deliveryHistoryList.length;
    // print('Delivery History length: ${deliveryHistoryList.length}');

    notifyListeners();

    return deliveryList;
  }

  void resetDeliveryData() {
    deliveryList.clear();
    filteredDriverList.clear();
    filteredDriverNameList.clear();
    // notifyListeners();
  }

  String highDefinitionImage = '';

  String get getHighDefinitionImage => highDefinitionImage;

  // "Companyid":"STSJ",
  // "Jenis":"DETAIL", // START/END/DETAIL
  // "TransNo":"5198DAT24110005",
  // "ShippingCLNo":"5198PCL24111076" // KHUSUS UNTUK DETAIL
  Future<String> fetchDeliveryHDImage(
    String timelineType,
    String transNumber,
    String shippingNumber,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final companyId = prefs.getString('CompanyName') ?? '';

    highDefinitionImage = '';
    highDefinitionImage = await GlobalAPI.fetchDeliveryHDImage(
      companyId,
      timelineType,
      transNumber,
      shippingNumber,
    );
    // print('HD Image: $highDefinitionImage');
    if (highDefinitionImage.isEmpty) {
      print('HD image is not available, $highDefinitionImage');
    }

    return highDefinitionImage;
  }

  List<DeliveryMemoModel> deliveryMemoList = [];

  List<DeliveryMemoModel> get getDeliveryMemoList => deliveryMemoList;

  String status = '';

  String get getStatus => status;

  Future<List<dynamic>> fetchDeliveryMemo(
    String branchId,
    String shopId,
    String transNumber,
  ) async {
    print('Branch ID: $branchId');
    print('Shop ID: $shopId');
    print('Trans ID: $transNumber');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final companyId = prefs.getString('CompanyName') ?? '';

    await GlobalAPI.fetchDeliveryMemo(
      companyId,
      branchId,
      shopId,
      transNumber,
    ).then((Map<String, dynamic> result) {
      print('Map return result: ${result.values.length}');
      deliveryMemoList.clear();
      for (var entry in result.entries) {
        if (entry.key == 'data') deliveryMemoList.addAll(entry.value);
        if (entry.key == 'status') status = entry.value;
      }
    });

    print('Delivery Memo List length: ${deliveryMemoList.length}');
    print('Status: $status');

    return [deliveryMemoList, status];
  }

  // ================================================================
  // ============================ Map ===============================
  // ================================================================
  bool isReset = false;

  void setIsReset() {
    isReset = !isReset;
    notifyListeners();
  }

  void resetData() {
    isRouteListOpen = false;
    isFilterOpen = true;
    // routeID = '';
    // routeStartDate = '';
    // routeEndDate = '';
    activityRouteList.clear();
    activityRouteDetailsList.clear();
    imageList.clear();
    selectedImage = 0;
    isActive = 0;
    previewImageDir = '';
    isMapCarousel = false;
    isActivitiesCarousel = false;
    notifyListeners();
  }

  void refreshPage() {
    notifyListeners();
  }

  bool isRouteListOpen = false;
  bool isFilterOpen = true;

  bool get getIsRouteListOpen => isRouteListOpen;

  // String routeID = '';
  // String routeStartDate = '';
  // String routeEndDate = '';

  // String get getRouteID => routeID;
  // String get getRouteStartDate => routeStartDate;
  // String get getRouteEndDate => routeEndDate;

  // void setRouteID(String value) {
  //   routeID = value;
  // }

  // void setRouteStartDate(String value) {
  //   routeStartDate = value;
  // }

  // void setRouteEndDate(String value) {
  //   routeEndDate = value;
  // }

  void toggleRouteList() {
    isRouteListOpen = !isRouteListOpen;
    notifyListeners();
  }

  void toggleFilter() {
    isFilterOpen = !isFilterOpen;
  }

  List<ModelActivityRoute> activityRouteList = [];

  int index = 0;

  List<ModelActivityRoute> get getActivityRoute => activityRouteList;

  int get getImageIndex => index;

  void setImageIndex(int i) {
    index = i;
  }

  Future<List<ModelActivityRoute>> fetchActivityRoute(
    String employeeID,
    String date,
  ) async {
    activityRouteList.clear();
    activityRouteList = await GlobalAPI.fetchActivityRoute(
      employeeID,
      date,
    );

    return activityRouteList;
  }

  // ==================================================================
  // ===================== Image Pre-Processing =======================
  // ==================================================================
  List<ModelActivityRouteDetails> activityRouteDetailsList = [];

  List<ModelActivityRouteDetails> get fetchActivityRouteDetails =>
      activityRouteDetailsList;

  List<List<ModelImage>> imageList = [[]];

  List<List<ModelImage>> get fetchImageList => imageList;

  Future<ModelDetailsProcessing> fetchDetailsProcessing(int index) async {
    activityRouteDetailsList.clear();
    for (int i = 0; i < activityRouteList[index].detail.length; i++) {
      activityRouteDetailsList.add(activityRouteList[index].detail[i]);
    }

    imageList.clear();
    for (int i = 0; i < activityRouteList[index].detail.length; i++) {
      ModelActivityRouteDetails detail = activityRouteList[index].detail[i];

      List<ModelImage> temp = [];
      if (detail.pic1 != '') {
        temp.add(ModelImage(imageDir: detail.pic1, isSelected: true));

        if (detail.pic2 != '') {
          temp.add(ModelImage(imageDir: detail.pic2));
        }
        if (detail.pic3 != '') {
          temp.add(ModelImage(imageDir: detail.pic3));
        }
        if (detail.pic4 != '') {
          temp.add(ModelImage(imageDir: detail.pic4));
        }
        if (detail.pic5 != '') {
          temp.add(ModelImage(imageDir: detail.pic5));
        }
      } else {
        // do nothing if the first photo is not available
      }

      imageList.add(temp);
    }

    return ModelDetailsProcessing(
      routeDetails: activityRouteDetailsList,
      images: imageList,
    );
  }

  // ==================================================================
  // ==================== Carousel Route Details ======================
  // ==================================================================
  int selectedImage = 0;

  void resetSelectImage() {
    selectedImage = 0;
    notifyListeners();
  }

  int get getSelectedImage => selectedImage;

  void setSelectImage(int onImageChangeIindex) {
    selectedImage = onImageChangeIindex;
    // Delete -> remove later
    // imageList[onPageChangeIndex][selectedImage].isSelected = true;
    // for (int i = 0; i < imageList[onPageChangeIndex].length; i++) {
    //   if (i != onImageChangeIindex) {
    //     imageList[onPageChangeIndex][i].isSelected = false;
    //   }
    // }
    notifyListeners();
  }

  // Note -> Carousel Index Usage
  int isActive = 0;

  int get getIsActive => isActive;

  void resetIsActive() {
    isActive = 0;
  }

  void onCarouselChanged(int index) {
    isActive = index;
  }

  // ==================================================================
  // ======================== Image Preview ===========================
  // ==================================================================
  String previewImageDir = '';

  String get getPreviewImageDir => previewImageDir;

  bool isMapCarousel = false;

  bool get getIsMapCarousel => isMapCarousel;

  bool isActivitiesCarousel = false;

  bool get getIsActivitiesCarousel => isActivitiesCarousel;

  void setPreviewImageDir(String value) {
    previewImageDir = value;
    notifyListeners();
  }

  void setIsMapCarousel(bool value) {
    isMapCarousel = value;
    notifyListeners();
  }

  void setIsActivitiesCarousel(bool value) {
    isActivitiesCarousel = value;
    notifyListeners();
  }

  void openMapImageView(
    BuildContext context,
    String imageDir,
    bool isCarousel,
  ) {
    setPreviewImageDir(imageDir);
    setIsMapCarousel(isCarousel);

    if (isCarousel) {
      context.goNamed(RoutesConstant.carouselImageView);
    } else {
      context.goNamed(RoutesConstant.routeImageView);
    }
  }

  // ==================================================================
  // ====================== Salesman Identity =========================
  // ==================================================================
  List<ModelSalesman> salesman = [];

  List<ModelSalesman> get getSalesman => salesman;

  String username = '';

  Future<List<ModelSalesman>> fetchSalesmanList({String user = ''}) async {
    if (user == '') {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      username = prefs.getString('UserID') ?? '';
    }

    salesmanList.clear();
    salesmanList = await GlobalAPI.fetchSalesman(username);

    return salesmanList;
  }

  // ==================================================================
  // ====================== Sales Activities ==========================
  // ==================================================================
  List<ModelSalesman> salesmanList = [];

  List<ModelSalesman> get getSalesmanList => salesmanList;

  List<ModelSalesmanActivities> salesmanActivitiesList = [];

  List<ModelSalesmanActivities> get getSalesmanActivities =>
      salesmanActivitiesList;

  Future<ModelActivities> fetchSalesActivities(
    String employeeID,
    String date,
  ) async {
    salesman.clear();
    salesman.addAll(salesmanList.where((list) => list.id == employeeID));

    salesmanActivitiesList.clear();
    salesmanActivitiesList = await GlobalAPI.fetchSalesmanActivities(
      employeeID,
      date,
    );

    print('Salesman Activities List length: ${salesmanActivitiesList.length}');

    return ModelActivities(
      salesman: salesman,
      activities: salesmanActivitiesList,
    );
  }

  // ==================================================================
  // ===================== Manager Activities =========================
  // ==================================================================
  List<ModelManagerActivities> managerActivitiesList = [];

  List<ModelManagerActivities> get getManagerActivities =>
      managerActivitiesList;

  List<String> provinceList = [];

  List<String> get getProvinceList => provinceList;

  List<ModelAreas> areaList = [];

  List<ModelAreas> get getAreaList => areaList;

  ValueNotifier<String> provinceNotifier = ValueNotifier('');
  ValueNotifier<String> areaNotifier = ValueNotifier('');

  ValueNotifier<String> get getAreaNotifier => areaNotifier;

  void setProvinceNotifier(String value) {
    provinceNotifier.value = value;
    notifyListeners();
  }

  void setAreaNotifier(String value) {
    // print('Area Notifier (before): ${areaNotifier.value}');
    areaNotifier.value = value;
    notifyListeners();
    // print('Area Notifier (after): ${areaNotifier.value}');
  }

  Future<void> loadHeader() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    headerList.clear();
    headerList.addAll(prefs.getStringList('header') ?? []);
    notifyListeners();

    print('Load Menu Header: ${headerList.length}');
  }

  Future<void> loadProvinces() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    provinceList.clear();
    provinceList.addAll(prefs.getStringList('provinces') ?? []);
    notifyListeners();

    print('Load Provinces: ${provinceList.length}');
  }

  Future<void> fetchProvinces() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('UserID') ?? '';

    List<ModelProvinces> temp = [];
    temp.addAll(await GlobalAPI.getProvinces(userId));

    await prefs.setStringList(
      'provinces',
      temp.map((e) => e.provinceName).toList(),
    );
  }

  Future<List<ModelAreas>> fetchAreas(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    areaList.clear();
    areaList.addAll(
      await GlobalAPI.getAreas(prefs.getString('UserID') ?? '', value),
    );
    notifyListeners();

    return areaList;
  }

  List<ModelManagerActivities> morningBriefingList = [];
  List<ModelManagerActivities> visitMarketList = [];
  List<ModelManagerActivities> recruitmentInterviewList = [];
  List<ModelManagerActivities> dailyReportList = [];

  List<ModelManagerActivities> get getMorningBriefingList =>
      morningBriefingList;
  List<ModelManagerActivities> get getVisitMarketList => visitMarketList;
  List<ModelManagerActivities> get getRecruitmentInterviewList =>
      recruitmentInterviewList;
  List<ModelManagerActivities> get getDailyReportList => dailyReportList;

  Future<List> fetchManagerActivities(
    String province,
    String area,
    String date,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('UserID') ?? '';

    // print('Fetch Manager Activities');
    // print(username);
    // print(province);
    // print(area);
    // print(date);

    managerActivitiesList.clear();
    managerActivitiesList = await GlobalAPI.fetchManagerActivities(
      username,
      province,
      area == '' ? province : area,
      date,
    );

    print('Manager Activities List length: ${managerActivitiesList.length}');

    morningBriefingList.clear();
    morningBriefingList.addAll(managerActivitiesList
        .where((list) => list.actName == 'MORNING BRIEFING'));

    visitMarketList.clear();
    visitMarketList.addAll(
        managerActivitiesList.where((list) => list.actName == 'VISIT MARKET'));

    recruitmentInterviewList.clear();
    recruitmentInterviewList.addAll(managerActivitiesList
        .where((list) => list.actName == 'RECRUITMENT & INTERVIEW'));

    dailyReportList.clear();
    dailyReportList.addAll(
        managerActivitiesList.where((list) => list.actName == 'DAILY REPORT'));

    print('Morning Briefing List length: ${morningBriefingList.length}');
    print('Visit Market List length: ${visitMarketList.length}');
    print(
        'Recruitment Interview List length: ${recruitmentInterviewList.length}');
    print('Daily Report List length: ${dailyReportList.length}');

    if (morningBriefingList.length == managerActivitiesList.length / 4 &&
        visitMarketList.length == managerActivitiesList.length / 4 &&
        recruitmentInterviewList.length == managerActivitiesList.length / 4 &&
        dailyReportList.length == managerActivitiesList.length / 4) {
      return [
        morningBriefingList,
        visitMarketList,
        recruitmentInterviewList,
        dailyReportList
      ];
    } else {
      return [];
    }
  }

  String imgDir = '';

  String get getImgDir => imgDir;

  Future<List<String>> fetchImageDir(
    String date,
    String employeeId,
    String actId,
    double lat,
    double lng,
  ) async {
    // print('Latitude: $lat');
    // print('Longitude: $lng');

    imgDir = '';
    if (actId == '02') {
      imgDir = await GlobalAPI.fetchImageDirectory(
        date,
        employeeId,
        actId,
      );

      if (imgDir == '' && actId == '02') {
        imgDir = await GlobalAPI.fetchImageDirectory(
          date,
          employeeId,
          '04',
        );
      }
    } else {
      imgDir = await GlobalAPI.fetchImageDirectory(
        date,
        employeeId,
        actId,
      );
    }

    if (imgDir.length % 2 == 0) {
      print('Image directory length is EVEN');
    } else {
      print('Image directory length is ODD');
    }

    // List<Placemark> address = [];
    // try {
    //   await placemarkFromCoordinates(lat, lng)
    //       .then((value) => address.addAll(value));
    //
    //   print('Placemark length: ${address.length}');
    // } catch (e) {
    //   print('Error: $e');
    // }

    return [imgDir, ''];
  }

  // ==================================================================
  // ================== View In Map for Manager =======================
  // ==================================================================
  double lat = 0.0;
  double lng = 0.0;

  double get getLat => lat;

  double get getLng => lng;

  void setLat(double value) {
    lat = value;
    notifyListeners();
  }

  void setLng(double value) {
    lng = value;
    notifyListeners();
  }

  Future<List<double>> getLatLng() async {
    print('Lat: $lat');
    print('Lng: $lng');

    return [lat, lng];
  }

  // ==================================================================
  // ========================== New Menu ==============================
  // ==================================================================
  ValueNotifier<String> staticMenuNotifier = ValueNotifier('dashboard');

  ValueNotifier<String> get getStaticMenuNotifier => staticMenuNotifier;

  void setStaticMenuNotifier(String value) {
    staticMenuNotifier.value = value;
    // notifyListeners();
  }

  // ==================================================================
  // ======================== Weekly Report ===========================
  // ==================================================================
  List<ModelWeeklyReportType> weeklyReportTypeList = [];

  List<ModelWeeklyReportType> get getWeeklyReportTypeList =>
      weeklyReportTypeList;

  List<ModelWeeklyReport> weeklyReportList = [];

  List<ModelWeeklyReport> get getWeeklyReportList => weeklyReportList;

  List<ModelBranchShop> branchList = [];

  List<ModelBranchShop> get getBranchList => branchList;

  List<String> branchNameOnlyList = [];

  List<String> get getBranchNameOnlyList => branchNameOnlyList;

  Future<List<ModelWeeklyReportType>> fetchWeeklyReport(
    String province,
    String area,
    String beginDate,
    String endDate,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('UserID') ?? '';

    branchList.clear();
    branchList.addAll(await GlobalAPI.fetchBranchShop(username, '', ''));

    branchNameOnlyList.clear();
    for (var value in branchList) {
      branchNameOnlyList.add(value.shopName);
    }

    weeklyReportTypeList.clear();
    for (var value in branchList) {
      weeklyReportTypeList.add(await GlobalAPI.fetchWeeklyReport(
        username,
        province,
        area,
        beginDate,
        endDate,
      ).then((list) {
        // weeklyReportList.clear();
        // weeklyReportList.addAll(
        //   list.where((element) => element.shopName == 'SURYA INTI PUTRA PERAK'),
        // );
        //
        // branchShopList.clear();
        // branchShopList.add('SURYA INTI PUTRA PERAK');
        //
        // print(weeklyReportList.length);
        //
        // for (var value in weeklyReportList) {
        //   if (value.isActAvailable == 1) {
        //     value.total += 1;
        //   }
        // }
        //
        // print('List length: ${list.length}');

        List<ModelWeeklyReport> briefing = [];
        briefing.addAll(
          list.where(
            (element) =>
                element.actId == '00' && element.shopName == value.shopName,
          ),
        );
        // print('Briefing length: ${briefing.length}');
        List<ModelWeeklyReport> visit = [];
        visit.addAll(
          list.where(
            (element) =>
                element.actId == '01' && element.shopName == value.shopName,
          ),
        );
        // print('Visit length: ${visit.length}');
        List<ModelWeeklyReport> recruitment = [];
        recruitment.addAll(
          list.where(
            (element) =>
                element.actId == '02' && element.shopName == value.shopName,
          ),
        );
        // print('Recruitment length: ${recruitment.length}');
        List<ModelWeeklyReport> daily = [];
        daily.addAll(
          list.where(
            (element) =>
                element.actId == '03' && element.shopName == value.shopName,
          ),
        );
        // print('Daily length: ${daily.length}');

        return ModelWeeklyReportType(
          branchName: value.shopName,
          morningBriefing: briefing,
          visitMarket: visit,
          recruitmentInterview: recruitment,
          dailyReport: daily,
        );
      }));
    }

    weeklyReportTypeList.removeWhere((element) =>
        element.morningBriefing.isEmpty &&
        element.dailyReport.isEmpty &&
        element.recruitmentInterview.isEmpty &&
        element.dailyReport.isEmpty);

    // print('Weekly Report list: ${weeklyReportList.length}');
    // print('Branch Shop list: ${branchShopList.length}');
    print('Weekly Report list: ${weeklyReportTypeList.length}');

    return weeklyReportTypeList;
  }

  // ==================================================================
  // ====================== Activities Point ==========================
  // ==================================================================
  List<ModelPointsType> activitiesPointList = [];

  List<ModelPointsType> get getActivitiesPointList => activitiesPointList;

  Future<List<ModelPointsType>> fetchActivitiesPoint(
    String province,
    String area,
    String beginDate,
    String endDate,
  ) async {
    // print('Province: $province');
    // print('Area: $area');
    // print('Begin Date: $beginDate');
    // print('End Date: $endDate');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('UserID') ?? '';

    await GlobalAPI.fetchActivitiesPoint(
      username,
      province,
      area,
      beginDate,
      endDate,
    ).then((list) {
      List<String> date = [];
      date.addAll(list.map((e) => e.date).toSet().toList());

      // for (var data in date) {
      //   print('Date: $data');
      // }

      activitiesPointList.clear();
      for (var date in date) {
        // print('Date: $date');
        List<ModelPointCalculation> briefing = [];
        briefing.addAll(
          list.where(
            (element) => element.actId == '00' && element.date == date,
          ),
        );
        // print('Briefing length: ${briefing.length}');

        List<ModelPointCalculation> visit = [];
        visit.addAll(
          list.where(
            (element) => element.actId == '01' && element.date == date,
          ),
        );
        // print('Visit length: ${visit.length}');

        List<ModelPointCalculation> recruitment = [];
        recruitment.addAll(
          list.where(
            (element) => element.actId == '02' && element.date == date,
          ),
        );
        // print('Recruitment length: ${recruitment.length}');

        List<ModelPointCalculation> daily = [];
        daily.addAll(
          list.where(
            (element) => element.actId == '03' && element.date == date,
          ),
        );
        // print('Daily length: ${daily.length}');

        activitiesPointList.add(
          ModelPointsType(
            date: date,
            morningBriefing: briefing,
            visitMarket: visit,
            recruitmentInterview: recruitment,
            dailyReport: daily,
          ),
        );
      }
    });

    print('Point List length: ${activitiesPointList.length}');

    return activitiesPointList;
  }

  // ==================================================================
  // ===================== Point Calculation ==========================
  // ==================================================================
  int point1 = 0;
  int point2 = 0;
  int point3 = 0;

  int get getPoint1 => point1;
  int get getPoint2 => point2;
  int get getPoint3 => point3;

  List<ModelPointCalculation> pointCalculationList = [];

  List<ModelPointCalculation> get getPointCalculationList =>
      pointCalculationList;

  List<Map<String, dynamic>> modifyPoint = [];

  List<ModelReturnResult> returnResult = [];

  void setPoint1(String value, ModelPointCalculation point) {
    point.point1 = int.parse(value);
  }

  void setPoint2(String value, ModelPointCalculation point) {
    point.point2 = int.parse(value);
  }

  void setPoint3(String value, ModelPointCalculation point) {
    point.point3 = int.parse(value);
  }

  Future<List<ModelPointCalculation>> fetchPointCalculation(
    String province,
    String area,
    String date,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('UserID') ?? '';

    pointCalculationList.clear();
    pointCalculationList.addAll(await GlobalAPI.fetchPointCalculation(
      username,
      province,
      area,
      date,
    ));

    return pointCalculationList;
  }

  Future<List<ModelReturnResult>> fetchModifyPoint(
    List<Map<String, dynamic>> map,
  ) async {
    // print('First Data Only');
    // for (var value in map) {
    //   value.forEach((key, value) {
    //     print('$key: $value');
    //   });
    // }

    returnResult.clear();
    returnResult.addAll(await GlobalAPI.fetchModifyPoint(map));

    return returnResult;
  }

  // ~:NEW:~
  // ==================================================================
  // ====================== Absent History ============================
  // ==================================================================
  ValueNotifier<bool> searchTriggerNotifier = ValueNotifier(false);
  ValueNotifier<bool> get getSearchTriggerNotifier => searchTriggerNotifier;

  void setSearchTriggerNotifier(bool value) {
    searchTriggerNotifier.value = value;
    // print('Search Trigger new value: ${searchTriggerNotifier.value}');
    notifyListeners();
  }

  bool isAbsentLoading = false;

  bool get getIsAbsentLoading => isAbsentLoading;

  void setIsAbsentLoading(bool value) {
    isAbsentLoading = value;
    notifyListeners();
  }

  // ~:Reset Absent History:~
  Future<void> resetAbsentHistory() async {
    // log('Reset Absent History');
    setSelectedBranch('');
    setSelectedShop('');
    setSelectedLocation('');
    setSelectedSalesman('');
    setSipSalesmanHistoryList([]);
    notifyListeners();
    searchTriggerNotifier.value = false;
    notifyListeners();
  }

  String selectedBranch = '';
  String selectedShop = '';
  String selectedLocation = '';
  String selectedSalesman = '';

  // ~:New:~
  String selectedStatus = 'Aktif';
  // ~:New:~

  String get getSelectedBranch => selectedBranch;
  String get getSelectedShop => selectedShop;
  String get getSelectedLocation => selectedLocation;
  String get getSelectedSalesman => selectedSalesman;

  // ~:New:~
  String get getSelectedStatus => selectedStatus;
  // ~:New:~

  void setSelectedBranch(String value) {
    selectedBranch = value;
    searchTriggerNotifier.value = false;
    notifyListeners();
  }

  void setSelectedShop(String value) {
    selectedShop = value;
    searchTriggerNotifier.value = false;
    notifyListeners();
  }

  void setSelectedLocation(String value) {
    selectedLocation = value;
    searchTriggerNotifier.value = false;
    notifyListeners();
  }

  void setSelectedSalesman(String value) {
    print('Set Salesman');
    selectedSalesman = value;
    searchTriggerNotifier.value = false;
    print(selectedSalesman);
    print(searchTriggerNotifier.value);
    notifyListeners();
  }

  void setSelectedStatus(String value) {
    selectedStatus = value;
    searchTriggerNotifier.value = false;
    notifyListeners();
  }

  List<SipSalesBranchesModel> sipBranchList = [];
  List<SipSalesBranchesModel> get getSipBranchList => sipBranchList;
  List<String> sipBranchNameList = [];
  List<String> get getSipBranchNameList => sipBranchNameList;

  Future<void> loadSipBranches() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    // log('SIP Branch Name List (before): ${getSipBranchNameList.length}');
    if (sipBranchNameList.isNotEmpty) {
      // log('SIP Branch Name List is not empty');
      sipBranchNameList = [];
      // log('SIP Branch Name List: ${getSipBranchNameList.length}');
    }

    sipBranchNameList.addAll(prefs.getStringList('sipBranches') ?? []);
    notifyListeners();
    log('SIP Branch Name List: ${getSipBranchNameList.length}');
  }

  Future<void> fetchSipSalesBranches(String companyCode) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('UserID') ?? '';
    print('User Idxx: $userId');
    print('Company Codexx: $companyCode');

    sipBranchList.clear();
    sipBranchList.addAll(await GlobalAPI.getSipSalesBranches(
      companyCode,
      userId,
    ));
    print('SIP Branch List: ${sipBranchList.length}');
    for (var i in sipBranchList) {
      print(i.branchName);
    }

    // await prefs.setStringList(
    //   'sipBranches',
    //   sipBranchList.map((e) => e.branchName).toList(),
    // );

    if (prefs.getStringList('sipBranches') == null ||
        prefs.getStringList('sipBranches')!.isEmpty) {
      log('SIP Branch Name List is empty');
      await prefs.setStringList(
        'sipBranches',
        sipBranchList.map((e) => e.branchName).toList(),
      );
    } else {
      log('SIP Branch Name List is not empty');
    }

    await loadSipBranches();
  }

  List<SipSalesShopsModel> sipShopList = [];
  List<SipSalesShopsModel> get getSipShopList => sipShopList;
  List<String> sipShopNameList = [];
  List<String> get getSipShopNameList => sipShopNameList;

  Future<void> loadSipShops({String branch = ''}) async {
    // print('Branch: $branch');
    // log('SIP Branch Name List (before): ${getSipShopList.length}');
    if (sipShopNameList.isNotEmpty) {
      // log('SIP Branch Name List is not empty');
      sipShopNameList.clear();
      // log('SIP Branch Name List: ${getSipShopList.length}');
    }

    await fetchSipSalesShops(branch).then((list) {
      sipShopNameList.addAll(list.map((e) => e.shopName).toList());
      notifyListeners();
    });
    // log('SIP Branch Name List (after): ${getSipShopList.length}');
  }

  Future<List<SipSalesShopsModel>> fetchSipSalesShops(String branch) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('UserID') ?? '';
    final companyCode = prefs.getString('CompanyCode') ?? '';
    // print('User ID: $userId');

    if (sipBranchList.isEmpty) {
      // print('SIP Branch List is empty');
      sipBranchList.addAll(await GlobalAPI.getSipSalesBranches(
        companyCode,
        userId,
      ));
    }

    sipShopList.clear();
    sipShopList.addAll(await GlobalAPI.getSipSalesShops(
      userId,
      sipBranchList.where((e) => e.branchName == branch).first.branchCode,
    ));
    // print('SIP Shop List: ${sipShopList.length}');

    return sipShopList;
  }

  List<SipSalesLocationModel> sipLocationList = [];
  List<SipSalesLocationModel> get getSipLocationList => sipLocationList;
  List<String> sipLocationNameList = [];
  List<String> get getSipLocationNameList => sipLocationNameList;

  Future<void> loadSipLocation({String branch = '', String shop = ''}) async {
    // print('Branch: $branch');
    // print('Shop: $shop');
    // log('SIP Branch Name List (before): ${getSipShopList.length}');
    if (sipLocationNameList.isNotEmpty) {
      // log('SIP Branch Name List is not empty');
      sipLocationNameList.clear();
      // log('SIP Branch Name List: ${getSipShopList.length}');
    }

    await fetchSipSalesLocation(branch, shop).then((list) {
      sipLocationNameList.addAll(list.map((e) => e.locationName).toList());
      notifyListeners();
    });
  }

  Future<List<SipSalesLocationModel>> fetchSipSalesLocation(
    String branch,
    String shop,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('UserID') ?? '';
    final companyCode = prefs.getString('CompanyCode') ?? '';
    // print('User ID: $userId');

    if (sipBranchList.isEmpty) {
      // print('SIP Branch List is empty');
      sipBranchList.addAll(await GlobalAPI.getSipSalesBranches(
        companyCode,
        userId,
      ));
    }

    sipLocationList.clear();
    sipLocationList.addAll(await GlobalAPI.getSipSalesLocation(
      userId,
      sipBranchList.where((e) => e.branchName == branch).first.branchCode,
      sipShopList.where((e) => e.shopName == shop).first.shopCode,
    ));
    // print('SIP Shop List: ${sipShopList.length}');

    return sipLocationList;
  }

  List<SipSalesmanModel> sipSalesmanList = [];
  List<SipSalesmanModel> get getSipSalesmanList => sipSalesmanList;

  Future<void> filterSipSalesman() async {
    try {
      if (sipSalesmanList.isEmpty) {
        await fetchSipSalesman();
      }

      sipSalesmanList.clear();
      sipSalesmanList.addAll(await fetchSipSalesman(
        branch: getSelectedBranch,
        shop: getSelectedShop,
        location: getSelectedLocation,
      ));

      log('filter Salesman List: ${sipSalesmanList.length}');
      notifyListeners();
    } catch (e) {
      log('FilterSipSalesman Error: $e');
    }
  }

  Future<List<SipSalesmanModel>> fetchSipSalesman({
    String branch = '',
    String shop = '',
    String location = '',
  }) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('UserID') ?? '';

    // print('UserID: $userId');
    if (branch.isNotEmpty && shop.isNotEmpty && location.isNotEmpty) {
      branch =
          sipBranchList.where((e) => e.branchName == branch).first.branchCode;
      shop = sipShopList.where((e) => e.shopName == shop).first.shopCode;
      location = sipLocationList
          .where((e) => e.locationName == location)
          .first
          .locationId;
    }
    // print('Branch: $branch');
    // print('Shop: $shop');
    // print('Location: $location');

    List<SipSalesmanModel> temp = [];
    // Note --> fix the parameter passed to API again!
    temp.addAll(await GlobalAPI.getSipSalesman(
      userId,
      branch,
      shop,
      location,
    ));
    // log('fetch Salesman List: ${temp.length}');

    return temp;
  }

  List<SipSalesmanHistoryModel> sipSalesmanHistoryList = [];

  List<SipSalesmanHistoryModel> get getSipSalesmanHistoryList =>
      sipSalesmanHistoryList;

  void setSipSalesmanHistoryList(List<SipSalesmanHistoryModel> value) {
    sipSalesmanHistoryList = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>> fetchSipSalesmanHistory(
    String branch,
    String shop,
    String location,
    String employee,
    String beginDate,
    String endDate,
  ) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('UserID') ?? '';
    final companyCode = prefs.getString('CompanyName') ?? '';

    print('Fetch Sip Salesman History Parameters');
    print('UserID: $userId');
    print('Company Code: $companyCode');

    String branchCode = '';
    if (branch.isNotEmpty) {
      branchCode =
          sipBranchList.where((e) => e.branchName == branch).first.branchCode;
      print('Branch: $branchCode');
    }

    String shopCode = '';
    if (shop.isNotEmpty) {
      shopCode = sipShopList.where((e) => e.shopName == shop).first.shopCode;
      print('Shop: $shopCode');
    }

    String locationCode = '';
    if (location.isNotEmpty) {
      locationCode = sipLocationList
          .where((e) => e.locationName == location)
          .first
          .locationId;
      print('Location: $locationCode');
    }

    print('Employee Name: $employee');
    print('Begin Date: $beginDate');
    print('End Date: $endDate');

    try {
      sipSalesmanHistoryList.clear();
      sipSalesmanHistoryList.addAll(await GlobalAPI.getSipSalesmanHistory(
        companyCode,
        userId,
        branchCode,
        shopCode,
        locationCode,
        employee,
        beginDate,
        endDate,
      ));
      // print('Salesman History length: ${sipSalesmanHistoryList.length}');

      if (sipSalesmanHistoryList.isNotEmpty) {
        print('Salesman History length: ${sipSalesmanHistoryList.length}');
        return {
          'status': 'success',
          'data': sipSalesmanHistoryList,
        };
      } else {
        print('Salesman History is empty');
        return {
          'status': 'failed',
          'data': [],
        };
      }
    } catch (e) {
      print('FetchSipSalesmanHistory Error: $e');
      return {
        'status': 'error',
        'data': [],
      };
    }
  }

  Future<void> getExportData(
    String type,
    String branch,
    String shop,
    String locationId,
    String employeeId,
    String startDate,
    String endDate,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('UserID') ?? '';
    String companyName = prefs.getString('CompanyName') ?? '';

    if (branch.isNotEmpty) {
      branch =
          sipBranchList.where((e) => e.branchName == branch).first.branchCode;
      print('Branch: $branch');
    }

    if (shop.isNotEmpty) {
      shop = sipShopList.where((e) => e.shopName == shop).first.shopCode;
      print('Shop: $shop');
    }

    if (locationId.isNotEmpty) {
      locationId = sipLocationList
          .where((e) => e.locationName == locationId)
          .first
          .locationId;
      print('Location: $locationId');
    }

    String baseUrl =
        "https://wsip.yamaha-jatim.co.id:2449/Report/ExportXls?PT=BASRA&Param={'PT':'BASRA','ReportName':'$type','Filter1':'$companyName','Filter2':'$userId','Filter3':'$branch','Filter4':'$shop','Filter5':'$locationId','Filter6':'$employeeId','Filter7':'$startDate','Filter8':'$endDate','Filter9':'','Filter10':'','Filter11':'','Filter12':'','Filter13':'','Filter14':'','Filter15':''}";
    print('Base URL: $baseUrl');

    try {
      await launchUrl(Uri.parse(baseUrl));
    } catch (e) {
      print(e.toString());
    }
  }

  List<MBrowseSalesman> browseSalesmanList = [];

  List<MBrowseSalesman> get getBrowseSalesmanList => browseSalesmanList;

  void setBrowseSalesmanList(List<MBrowseSalesman> value) {
    browseSalesmanList = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>> fetchBrowseSalesman(
    String branch,
    String shop,
    String location,
    String employee,
    String isActive,
  ) async {
    // "PT":"",
    // "UserID":"ANA ISMALIA",
    // "Branch":"",
    // "Shop":"",
    // "LocationID":"",
    // "EmployeeID":"",
    // "Active":"1" // OPTIONAL : 1 - AKTIF , 0 - TIDAK AKTIF, kalau tidak dipasingkan, default = AKTIF
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('UserID') ?? '';
    final companyCode = prefs.getString('CompanyName') ?? '';

    print('Fetch Browse Salesman Parameters');
    print('UserID: $userId');
    print('Company Code: $companyCode');

    String branchCode = '';
    if (branch.isNotEmpty) {
      branchCode =
          sipBranchList.where((e) => e.branchName == branch).first.branchCode;
      print('Branch: $branchCode');
    }

    String shopCode = '';
    if (shop.isNotEmpty) {
      shopCode = sipShopList.where((e) => e.shopName == shop).first.shopCode;
      print('Shop: $shopCode');
    }

    String locationCode = '';
    if (location.isNotEmpty) {
      locationCode = sipLocationList
          .where((e) => e.locationName == location)
          .first
          .locationId;
      print('Location: $locationCode');
    }

    try {
      String fetchState = '';
      browseSalesmanList.clear();
      await GlobalAPI.fetchBrowseSalesman(
        companyCode,
        userId,
        branchCode,
        shopCode,
        locationCode,
        employee,
        isActive,
      ).then((value) {
        fetchState = value['status'];
        if (value['status'] == 'success') {
          browseSalesmanList.addAll(value['data']);
          print('Browse Salesman List length: ${browseSalesmanList.length}');
        }
      });
      // print('Salesman History length: ${sipSalesmanHistoryList.length}');

      if (browseSalesmanList.isNotEmpty && fetchState == 'success') {
        print('Browse Salesman length: ${browseSalesmanList.length}');
        return {
          'status': 'success',
          'data': browseSalesmanList,
        };
      } else {
        print('Browse Salesman is empty');
        return {
          'status': 'failed',
          'data': [],
        };
      }
    } catch (e) {
      print('FetchSipSalesmanHistory Error: $e');
      return {
        'status': 'error',
        'data': [],
      };
    }
  }

  // ====================================================================
  // ======================== Picking & Packing =========================
  // ====================================================================
  ValueNotifier<List<String>> pickingPicListNotifier =
      ValueNotifier<List<String>>([]);
  ValueNotifier<List<String>> get getPickingPicListNotifier =>
      pickingPicListNotifier;

  void setPickingPicListNotifier(
    List<String> value, {
    bool isEmpty = false,
  }) {
    pickingPicListNotifier.value.clear();
    if (!isEmpty) {
      pickingPicListNotifier.value.add('');
    }
    pickingPicListNotifier.value.addAll(value);
    notifyListeners();
  }

  List<String> pickingPicList = [];
  List<String> get getPickingPicList => pickingPicList;

  void setPickingPicList(List<String> value) {
    pickingPicList = value;
    notifyListeners();
  }

  Future<void> fetchPickingPIC(String branchName) async {
    await GlobalAPI.fetchPickingPIC(
      branchShopList.where((e) => e.name == branchName).first.branchId,
      branchShopList.where((e) => e.name == branchName).first.shopId,
    ).then((res) {
      if (res['status'] == 'success') {
        pickingPicList.clear();
        pickingPicList.add('');
        pickingPicList.addAll(res['data']);
        setPickingPicListNotifier(res['data']);
        print('Picking PIC List length: ${pickingPicList.length}');

        for (String name in pickingPicList) {
          print(name);
        }
      } else {
        pickingPicList.clear();
        print('Picking PIC List is empty');
      }
    });
    notifyListeners();
  }

  String ppBranchName = '';
  String get getPPBranchName => ppBranchName;

  void setPpBranchName(String value) {
    ppBranchName = value;
    notifyListeners();
  }

  List<PickPackModel> pickingList = [];
  List<PickPackModel> get getPickingList => pickingList;

  void setPackingPicList(List<String> value) {
    packingPicList = value;
    notifyListeners();
  }

  Future<Map<String, dynamic>> fetchPickingData(
    String date,
    String pic,
  ) async {
    print('Branch Shop name: $getPPBranchName');
    print(
        'Branch Id: ${branchShopList.where((e) => e.name == getPPBranchName).first.branchId}');
    print(
        'Shop Id: ${branchShopList.where((e) => e.name == getPPBranchName).first.shopId}');

    Map<String, dynamic> res = {
      'status': 'not found',
      'data': [],
    };

    await GlobalAPI.fetchPickingData(
      branchShopList.where((e) => e.name == getPPBranchName).first.branchId,
      branchShopList.where((e) => e.name == getPPBranchName).first.shopId,
      date,
      pic,
    ).then((results) {
      res.update('status', (_) => results['status']);
      if (results['status'] == 'success') {
        pickingList.clear();
        pickingList.addAll(results['data']);

        res.update('data', (_) => pickingList);
      } else {
        pickingList.clear();
      }

      return res;
    });

    return res;
  }

  List<PickPackDetailsModel> pickingDetailsList = [];
  List<PickPackDetailsModel> get getPickingDetailsList => pickingDetailsList;

  Future<Map<String, dynamic>> fetchPickingDetails(
    String date,
    String pic,
  ) async {
    print('Branch Shop name: $getPPBranchName');
    print(
        'Branch Id: ${branchShopList.where((e) => e.name == getPPBranchName).first.branchId}');
    print(
        'Shop Id: ${branchShopList.where((e) => e.name == getPPBranchName).first.shopId}');

    Map<String, dynamic> res = {
      'status': 'not found',
      'data': [],
    };

    await GlobalAPI.fetchPickingDetails(
      branchShopList.where((e) => e.name == getPPBranchName).first.branchId,
      branchShopList.where((e) => e.name == getPPBranchName).first.shopId,
      date,
      pic,
    ).then((results) {
      res.update('status', (_) => results['status']);
      if (results['status'] == 'success') {
        pickingDetailsList.clear();
        pickingDetailsList.addAll(results['data']);

        res.update('data', (_) => pickingDetailsList);
      } else {
        pickingDetailsList.clear();
      }

      return res;
    });

    return res;
  }

  ValueNotifier<List<String>> packingPicListNotifier =
      ValueNotifier<List<String>>([]);
  ValueNotifier<List<String>> get getPackingPicListNotifier =>
      packingPicListNotifier;

  void setPackingPicListNotifier(
    List<String> value, {
    bool isEmpty = false,
  }) {
    packingPicListNotifier.value.clear();
    if (!isEmpty) {
      packingPicListNotifier.value.add('');
    }
    packingPicListNotifier.value.addAll(value);
    notifyListeners();
  }

  List<String> packingPicList = [];
  List<String> get getPackingPicList => packingPicList;

  Future<void> fetchPackingPIC(String branchName) async {
    await GlobalAPI.fetchPackingPIC(
      branchShopList.where((e) => e.name == branchName).first.branchId,
      branchShopList.where((e) => e.name == branchName).first.shopId,
    ).then((res) {
      if (res['status'] == 'success') {
        packingPicList.clear();
        packingPicList.add('');
        packingPicList.addAll(res['data']);
        setPackingPicListNotifier(res['data']);
        print('Packing PIC List length: ${packingPicList.length}');

        // for (String name in packingPicList) {
        //   print(name);
        // }
      } else {
        packingPicList.clear();
        print('Packing PIC List is empty');
      }
    });
    notifyListeners();
  }

  List<PickPackModel> packingList = [];
  List<PickPackModel> get getPackingList => packingList;

  Future<Map<String, dynamic>> fetchPackingData(
    String date,
    String pic,
  ) async {
    print('Branch Shop name: $getPPBranchName');
    print(
        'Branch Id: ${branchShopList.where((e) => e.name == getPPBranchName).first.branchId}');
    print(
        'Shop Id: ${branchShopList.where((e) => e.name == getPPBranchName).first.shopId}');

    Map<String, dynamic> res = {
      'status': 'not found',
      'data': [],
    };

    await GlobalAPI.fetchPackingData(
      branchShopList.where((e) => e.name == getPPBranchName).first.branchId,
      branchShopList.where((e) => e.name == getPPBranchName).first.shopId,
      date,
      pic,
    ).then((results) {
      res.update('status', (_) => results['status']);
      if (results['status'] == 'success') {
        packingList.clear();
        packingList.addAll(results['data']);

        res.update('data', (_) => packingList);
      } else {
        packingList.clear();
      }

      return res;
    });

    return res;
  }

  List<PickPackDetailsModel> packingDetailsList = [];
  List<PickPackDetailsModel> get getPackingDetailsList => packingDetailsList;

  Future<Map<String, dynamic>> fetchPackingDetails(
    String date,
    String pic,
  ) async {
    print('Branch Shop name: $getPPBranchName');
    print(
        'Branch Id: ${branchShopList.where((e) => e.name == getPPBranchName).first.branchId}');
    print(
        'Shop Id: ${branchShopList.where((e) => e.name == getPPBranchName).first.shopId}');

    Map<String, dynamic> res = {
      'status': 'not found',
      'data': [],
    };

    await GlobalAPI.fetchPackingDetails(
      branchShopList.where((e) => e.name == getPPBranchName).first.branchId,
      branchShopList.where((e) => e.name == getPPBranchName).first.shopId,
      date,
      pic,
    ).then((results) {
      res.update('status', (_) => results['status']);
      if (results['status'] == 'success') {
        packingDetailsList.clear();
        packingDetailsList.addAll(results['data']);

        res.update('data', (_) => packingDetailsList);
      } else {
        packingDetailsList.clear();
      }

      return res;
    });

    return res;
  }

  // ~:Free Stock:~
  String selectedFreeStockBranch = '';
  String get getSelectedFreeStockBranch => selectedFreeStockBranch;

  void setSelectedFreeStockBranch(String value) {
    selectedFreeStockBranch = value;
    //notifyListeners();
  }

  List<FreeStockModel> freeStockList = [];
  List<FreeStockModel> get getFreeStockList => freeStockList;

  ValueNotifier<List<String>> freeStockBranchNameList =
      (ValueNotifier<List<String>>([]));
  ValueNotifier<List<String>> get getFreeStockBranchNameList =>
      freeStockBranchNameList;

  Future<Map<String, dynamic>> fetchBranchFreeStock() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('UserID') ?? '';
    Map<String, dynamic> temp = {};

    await GlobalAPI.fetchFSBranchList(username).then((res) {
      temp = res;
      if (res['status'] == 'success') {
        freeStockList.clear();
        freeStockList.addAll(res['data']);
        print('FS Branch List length: ${freeStockList.length}');

        freeStockBranchNameList.value.clear();
        freeStockBranchNameList.value.addAll(
          freeStockList.map((e) => e.branchName).toList(),
        );
      }
    });
    notifyListeners();

    return temp;
  }

  void resetFreeStockFilter() {
    setFreeStockResult({
      'status': '',
      'data': <FreeStockResultModel>[],
    });
    setSelectedFreeStockBranch('');
  }

  ValueNotifier<bool> isValueChanged = ValueNotifier<bool>(false);
  ValueNotifier<bool> get getIsValueChanged => isValueChanged;

  void setIsValueChanged(bool value) {
    isValueChanged.value = value;
    // notifyListeners();
  }

  Map<String, dynamic> freeStockResult = {
    'status': '',
    'data': <FreeStockResultModel>[],
  };
  Map<String, dynamic> get getFreeStockResult => freeStockResult;

  void setFreeStockResult(Map<String, dynamic> value) {
    freeStockResult = value;
    // notifyListeners();
  }

  Future<Map<String, dynamic>> fetchFreeStockResult() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('UserID') ?? '';

    Map<String, dynamic> temp = {};

    print('Username: $username');
    print(
      'Branch Id: ${getFreeStockList.where((e) => e.branchName == getSelectedFreeStockBranch).first.branchId}',
    );
    print('Date: ${DateTime.now().toString().substring(0, 10)}');

    await GlobalAPI.fetchFreeStockData(
      username,
      freeStockList
          .where((e) => e.branchName == getSelectedFreeStockBranch)
          .first
          .branchId,
      DateTime.now().toString().substring(0, 10),
    ).then((res) {
      temp = res;
      if (res['status'] == 'success') {
        freeStockResult.update('status', (_) => res['status']);
        freeStockResult.update('data', (_) => res['data']);
        print(
          'FS Result List length: ${(freeStockResult['data'] as List).length}',
        );
        return temp;
      } else {
        freeStockResult.update('status', (_) => res['status']);
      }
    });
    notifyListeners();

    return temp;
  }

  List<FreeStockModifModel> stockModifList = [];
  List<FreeStockModifModel> get getStockModifList => stockModifList;

  void setStockModifList(List<FreeStockModifModel> value) {
    stockModifList = value;
    notifyListeners();
  }

  Future<String> modifyFreeStock() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString('UserID') ?? '';

    List<Map<String, dynamic>> mapModifyStock =
        (getFreeStockResult['data'] as List<FreeStockResultModel>).map((data) {
      return {
        'Branch': getFreeStockList
            .where((e) => e.branchName == getSelectedFreeStockBranch)
            .first
            .branchId,
        'UnitID': data.unitId,
        'Color': data.color,
        'Qty': data.adjustStock,
        'UserID': username,
      };
    }).toList();

    print('Converted Stock Modif List to Map');
    for (var data in mapModifyStock) {
      print(data);
    }

    return await GlobalAPI.modifyFreeStock(mapModifyStock);
  }
  // ~:Free Stock:~
  // ~:NEW:~
}
