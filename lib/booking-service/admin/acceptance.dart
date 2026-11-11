// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stsj/booking-service/global/api.dart';
import 'package:stsj/booking-service/global/global.dart';
import 'package:stsj/booking-service/global/model.dart';
import 'package:stsj/booking-service/popupdialog/kotak_pesan.dart';
import 'package:stsj/booking-service/progressindicator/circle_loading.dart';
import 'package:stsj/booking-service/widget/button/tombol.dart';
import 'package:stsj/booking-service/widget/custom_date_picker.dart';
import 'package:stsj/booking-service/widget/dropdown/branchasset.dart';
import 'package:stsj/booking-service/widget/dropdown/statusasset.dart';
import 'package:stsj/booking-service/widget/dropdown/timeasset_admin.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminAcceptance extends StatefulWidget {
  const AdminAcceptance({super.key});

  @override
  State<AdminAcceptance> createState() => _AdminAcceptanceState();
}

class _AdminAcceptanceState extends State<AdminAcceptance>
    with AutomaticKeepAliveClientMixin<AdminAcceptance> {
  @override
  bool get wantKeepAlive => true;
  bool isExpanded = true;
  bool isAccepted = false;

  List<ModelResultMessage> listNotifyBooking = [];
  List<ModelResultMessage> listSendNotification = [];
  List<ModelNotificationDetail> listGetNotification = [];
  List<ModelGetDeviceToken> listDeviceToken = [];

  // Filter Variable
  String dealerName = 'FixUP MOTO - KUTISARI';
  String dealer = '';
  String startDate = '';
  String endDate = '';
  String time = '';
  String status = '';

  String bookingID = '';
  String branch = '31';
  String shop = '01';
  String plate = '';
  String userID = '';

  String nama = '';
  String noTelp = '';
  String tanggal = '';
  String tipeMotor = '';
  String keluhan = '';

  String getNotifState = '';

  // Create Notification Variable
  List<ModelResultMessage> returnValue = [];

  // Branch Informations
  List<BranchDetail> branchList = [];

  ModelSendMessage mapSendMessage = ModelSendMessage(resultMessage: '');

  void checkUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('adminid') &&
        prefs.containsKey('password') &&
        prefs.containsKey('flag')) {
      GlobalUser.adminID = prefs.getString('adminid')!;
      GlobalUser.password = prefs.getString('password')!;
      GlobalUser.flag = prefs.getInt('flag')!;
    } else {
      GlobalUser.adminID = prefs.getString('UserID') ?? '';
      GlobalUser.password = '';
      GlobalUser.flag = 1;
    }
  }

  void setDealerName(String value) {
    dealerName = value;
  }

  void setStartDate(String value) {
    startDate = value;
  }

  void setEndDate(String value) {
    endDate = value;
  }

  void setTime(String value) {
    time = value;
  }

  void setStatus(String value) {
    status = value;
  }

  void redirectToWhatsAppWeb(ModelBooking data) async {
    String number = '+62${data.uPhoneNo}';

    if (await canLaunchUrl(Uri.parse('https://wa.me/$number'))) {
      await launchUrl(Uri.parse('https://wa.me/$number'));
    } else {
      throw 'Could not launch WhatsApp Web';
    }
  }

  void notifyService(ModelBooking data, bool isAccept) async {
    String number = '62${data.uPhoneNo}';

    String message = '';
    String popUpMessage = '';
    if (isAccept == true) {
      message =
          'Selamat!\nKode booking ${data.bookingID} atas nama ${data.uName} pada jam ${data.bookTime} sudah terverifikasi\nMohon hadir 1 jam sebelum jam service';
      popUpMessage = 'Approved & Message sent!';
    } else {
      message =
          'Mohon maaf, Kode booking ${data.bookingID} atas nama ${data.uName} pada jam ${data.bookTime} ditolak.\nMohon memilih hari dan jam service lain.';
      popUpMessage = 'Rejected & Message sent!';
    }

    mapSendMessage = await GlobalAPI.fetchSendMessage(
      number,
      message,
      'poco-phone',
      'text',
    );

    setState(() => GlobalVar.isLoading = true);

    // Modify Notification Data
    listNotifyBooking = await GlobalAPI.fetchInsertBookReq(
      '2',
      data.bookingID,
      data.bookDate,
      data.bookTime,
      '31',
      data.shop,
      data.uName,
      data.uPhoneNo,
      data.uPlateNo,
      data.unitID,
      data.notes,
      isAccept == true ? '0' : '1',
      GlobalUser.adminID,
    );

    findWorkshop();

    setState(() => GlobalVar.isLoading = false);

    if (mapSendMessage.resultMessage == 'pending') {
      GlobalVar.listUserLogin = await GlobalAPI.getUserLogin(
        data.uPhoneNo,
        '',
      );

      GlobalUser.userID = GlobalVar.listUserLogin[0].memberID;

      listDeviceToken = await GlobalAPI.fetchGetDeviceToken();
      GlobalUser.fCMToken = listDeviceToken[0].token;

      // Background Notif
      listSendNotification = await GlobalAPI.fetchModifyNotification(
        '1',
        GlobalUser.userID,
        data.bookingID,
        'Service Booking Confirmed',
        'Booking Service Anda Telah Dikonfirmasi.  Demi pelayan yang maksimal, kami harap anda  untuk datang 30 menit dari waktu yang ditentukan    Terima Kasih',
        '1',
        '0',
      );

      listGetNotification = await GlobalAPI.fetchGetNotification('', '');
      for (int i = 0; i < listGetNotification.length; i++) {
        if (listGetNotification[i].notifID == data.bookingID) {
          if (listGetNotification[i].notifType == 'Service Booking Confirmed') {
            getNotifState = await GlobalAPI.fetchSendNotification(
              GlobalUser.fCMToken,
              'Kami tunggu kehadiran anda!!',
              listGetNotification[i].notifType,
            );
            break;
          } else if (listGetNotification[i].notifType == 'Promotion') {
            getNotifState = await GlobalAPI.fetchSendNotification(
              GlobalUser.fCMToken,
              'Jangan lewatkan promo yang sedang berlaku',
              listGetNotification[i].notifType,
            );
            break;
          } else {
            getNotifState = await GlobalAPI.fetchSendNotification(
              GlobalUser.fCMToken,
              '',
              listGetNotification[i].notifType,
            );
            break;
          }
        }
      }

      GlobalFunction.tampilkanDialog(
        context,
        KotakPesan(
          'INFORMASI',
          popUpMessage,
        ),
      );
    } else {
      GlobalFunction.tampilkanDialog(
        context,
        KotakPesan(
          'INFORMASI',
          popUpMessage,
        ),
      );
    }
  }

  void clearall() {
    dealerName = 'FixUP MOTO - KUTISARI';
    startDate = '';
    endDate = '';
    time = '';
    status = '';
    GlobalVar.listBrowseBooking = [];

    startDate = DateTime.now().toString().split(' ')[0];
    endDate = DateTime.now().toString().split(' ')[0];
    DateTime currentDate = DateFormat('yyyy-MM-dd').parse(endDate);
    DateTime futureDate = currentDate.add(const Duration(days: 2));
    endDate = DateFormat('yyyy-MM-dd').format(futureDate);
    setState(() => GlobalVar.isLoading = true);
    checkUser(context);
    setState(() => GlobalVar.isLoading = false);
  }

  void resetWorkshop() {
    setState(() => clearall());
  }

  void findWorkshop() async {
    List<BranchDetail> branchListTemp = [];
    branchListTemp.addAll(await GlobalAPI.fetchBranches('BRANCHSHOP'));

    dealer = branchListTemp
        .where((element) => element.name == dealerName)
        .map((e) => e.shop)
        .toString()
        .substring(1, 3);
    branchListTemp.clear();

    GlobalVar.listBrowseBooking = await GlobalAPI.fetchBrowseBookReq(
      dealer,
      '',
      startDate,
      endDate,
      time,
      '',
      status,
    );
    setState(() {});

    if (GlobalVar.listBrowseBooking.isEmpty) {
      GlobalFunction.tampilkanDialog(
        context,
        const KotakPesan(
          'INFORMASI',
          'Tidak ditemukan data booking untuk filter yang dipilih.',
        ),
      );
    }
  }

  Future<List<BranchDetail>> fetchBranchDetails() async {
    branchList.clear();
    branchList.addAll(await GlobalAPI.fetchBranches('BRANCHSHOP'));
    return branchList;
  }

  @override
  void initState() {
    super.initState();

    if (startDate.isEmpty) {
      startDate = DateTime.now().toString().split(' ')[0];
      endDate = DateTime.now().toString().split(' ')[0];
      DateTime currentDate = DateFormat('yyyy-MM-dd').parse(endDate);
      DateTime futureDate = currentDate.add(const Duration(days: 2));
      endDate = DateFormat('yyyy-MM-dd').format(futureDate);
    }
    checkUser(context);
  }

  @override
  void dispose() {
    GlobalVar.listBrowseBooking = [];
    super.dispose();
  }

  // ── UI Helpers ─────────────────────────────────────────────────────────────

  Widget _buildFieldLabel(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primaryRed),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRangeSelector(double availableWidth) {
    final bool stackDates = availableWidth < 420;
    if (stackDates) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomDatetimePicker(startDate, setStartDate, false),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
              's/d',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          CustomDatetimePicker(endDate, setEndDate, false),
        ],
      );
    }

    return Row(
      children: [
        Expanded(
          child: CustomDatetimePicker(
            startDate,
            setStartDate,
            false,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            's/d',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Expanded(
          child: CustomDatetimePicker(
            endDate,
            setEndDate,
            false,
          ),
        ),
      ],
    );
  }

  Widget _buildKpiItem({
    required String title,
    required String count,
    required IconData icon,
    required Color accentColor,
    required Color softBgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.mutedSurface,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: softBgColor,
              borderRadius: BorderRadius.circular(AppRadii.sm),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: accentColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String statusText) {
    final String upper = statusText.toUpperCase();
    Color bgColor;
    Color textColor;
    IconData icon;

    if (upper == 'TERKONFIRMASI') {
      bgColor = const Color(0xFFDCFCE7);
      textColor = AppColors.accentGreen;
      icon = Icons.check_circle_rounded;
    } else if (upper == 'DITOLAK') {
      bgColor = const Color(0xFFFFE4E6);
      textColor = AppColors.accentCoral;
      icon = Icons.cancel_rounded;
    } else {
      bgColor = const Color(0xFFFEF3C7);
      textColor = const Color(0xFFD97706);
      icon = Icons.schedule_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: textColor),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              statusText,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCell(ModelBooking item) {
    final bool isPending = item.status == 'MENUNGGU KONFIRMASI';
    final bool isApproved = item.status == 'TERKONFIRMASI';
    final bool isRejected = item.status == 'DITOLAK';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Approve Button
          Tooltip(
            message: isPending ? 'Setujui Booking' : 'Status sudah diproses',
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadii.sm),
              onTap: isPending ? () => notifyService(item, true) : null,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isPending
                      ? const Color(0xFFDCFCE7)
                      : isApproved
                          ? AppColors.accentGreen
                          : AppColors.deepBackground,
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                  border: Border.all(
                    color: isPending || isApproved
                        ? AppColors.accentGreen.withValues(alpha: 0.4)
                        : AppColors.border,
                  ),
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 18,
                  color: isPending
                      ? AppColors.accentGreen
                      : isApproved
                          ? Colors.white
                          : AppColors.textDisabled,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),

          // Reject Button
          Tooltip(
            message: isPending ? 'Tolak Booking' : 'Status sudah diproses',
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadii.sm),
              onTap: isPending ? () => notifyService(item, false) : null,
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: isPending
                      ? const Color(0xFFFFE4E6)
                      : isRejected
                          ? AppColors.accentCoral
                          : AppColors.deepBackground,
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                  border: Border.all(
                    color: isPending || isRejected
                        ? AppColors.accentCoral.withValues(alpha: 0.4)
                        : AppColors.border,
                  ),
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 18,
                  color: isPending
                      ? AppColors.accentCoral
                      : isRejected
                          ? Colors.white
                          : AppColors.textDisabled,
                ),
              ),
            ),
          ),
          const SizedBox(width: 6),

          // WhatsApp Button
          Tooltip(
            message: 'Hubungi via WhatsApp',
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadii.sm),
              onTap: () => redirectToWhatsAppWeb(item),
              child: Container(
                width: 34,
                height: 34,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                  border: Border.all(
                    color: AppColors.accentGreen.withValues(alpha: 0.3),
                  ),
                ),
                child: Image.asset(
                  'assets/images/whatsapp-icons.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isCompact = screenWidth < 900;

    final int totalCount = GlobalVar.listBrowseBooking.length;
    final int pendingCount = GlobalVar.listBrowseBooking
        .where((e) => e.status == 'MENUNGGU KONFIRMASI')
        .length;
    final int approvedCount = GlobalVar.listBrowseBooking
        .where((e) => e.status == 'TERKONFIRMASI')
        .length;
    final int rejectedCount = GlobalVar.listBrowseBooking
        .where((e) => e.status == 'DITOLAK')
        .length;

    return Container(
      color: AppColors.primaryBackground,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 14 : 24,
          vertical: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── 1. Filter Panel Card (Putih-Merah BASRA) ─────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.mutedSurface,
                borderRadius: BorderRadius.circular(AppRadii.lg),
                border: Border.all(color: AppColors.border, width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: true,
                  tilePadding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 16 : 20,
                    vertical: 4,
                  ),
                  childrenPadding: EdgeInsets.fromLTRB(
                    isCompact ? 16 : 20,
                    4,
                    isCompact ? 16 : 20,
                    20,
                  ),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryMaroon,
                      borderRadius: BorderRadius.circular(AppRadii.sm),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      size: 18,
                      color: AppColors.primaryRed,
                    ),
                  ),
                  title: const Text(
                    'Filter Pencarian Booking',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  trailing: isCompact
                      ? null
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Tombol(
                              'RESET',
                              resetWorkshop,
                              isTiny: true,
                              isOutlined: true,
                              tinggi: 38,
                              lebar: 90,
                            ),
                            const SizedBox(width: 10),
                            Tombol(
                              'CARI DATA',
                              findWorkshop,
                              isTiny: true,
                              tinggi: 38,
                              lebar: 110,
                            ),
                          ],
                        ),
                  children: [
                    const Divider(color: AppColors.border, height: 20),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final bool stacked = constraints.maxWidth < 760;
                        if (stacked) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _buildFieldLabel(
                                  'CABANG DEALER / BENGKEL', Icons.store_rounded),
                              FutureBuilder<List<BranchDetail>>(
                                future: fetchBranchDetails(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(child: CircleLoading());
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.data == null ||
                                      snapshot.data!.isEmpty) {
                                    return const Text('Data cabang kosong');
                                  }
                                  return BranchAsset(
                                    setDealerName,
                                    dealerName,
                                    snapshot.data!,
                                  );
                                },
                              ),
                              const SizedBox(height: 14),
                              _buildFieldLabel(
                                  'JAM SERVICE', Icons.access_time_rounded),
                              AdminTimeAsset(setTime, time),
                              const SizedBox(height: 14),
                              _buildFieldLabel(
                                  'RENTANG TANGGAL BOOKING',
                                  Icons.date_range_rounded),
                              _buildDateRangeSelector(constraints.maxWidth),
                              const SizedBox(height: 14),
                              _buildFieldLabel(
                                  'STATUS BOOKING', Icons.flag_outlined),
                              StatusAsset(setStatus, status),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Tombol(
                                      'RESET',
                                      resetWorkshop,
                                      isOutlined: true,
                                      tinggi: 42,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Tombol(
                                      'CARI DATA',
                                      findWorkshop,
                                      tinggi: 42,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }

                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel(
                                        'CABANG DEALER / BENGKEL',
                                        Icons.store_rounded,
                                      ),
                                      FutureBuilder<List<BranchDetail>>(
                                        future: fetchBranchDetails(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const SizedBox(
                                              height: 44,
                                              child: Center(
                                                  child: CircleLoading()),
                                            );
                                          } else if (snapshot.hasError) {
                                            return Text(
                                                'Error: ${snapshot.error}');
                                          } else if (snapshot.data == null ||
                                              snapshot.data!.isEmpty) {
                                            return const Text(
                                                'Data cabang kosong');
                                          }
                                          return BranchAsset(
                                            setDealerName,
                                            dealerName,
                                            snapshot.data!,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel(
                                        'JAM KEDATANGAN (PUKUL)',
                                        Icons.access_time_rounded,
                                      ),
                                      AdminTimeAsset(setTime, time),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel(
                                        'PERIODE TANGGAL BOOKING',
                                        Icons.date_range_rounded,
                                      ),
                                      _buildDateRangeSelector(
                                          constraints.maxWidth / 2),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildFieldLabel(
                                        'STATUS VERIFIKASI',
                                        Icons.verified_outlined,
                                      ),
                                      StatusAsset(setStatus, status),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            if (isCompact) ...[
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Tombol(
                                    'RESET',
                                    resetWorkshop,
                                    isOutlined: true,
                                    tinggi: 40,
                                    lebar: 100,
                                  ),
                                  const SizedBox(width: 10),
                                  Tombol(
                                    'CARI DATA',
                                    findWorkshop,
                                    tinggi: 40,
                                    lebar: 120,
                                  ),
                                ],
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ── 2. Responsive Summary KPI Cards ──────────────────────────────
            LayoutBuilder(
              builder: (context, constraints) {
                final kpi1 = _buildKpiItem(
                  title: 'Total Booking',
                  count: '$totalCount',
                  icon: Icons.list_alt_rounded,
                  accentColor: AppColors.primaryRed,
                  softBgColor: AppColors.secondaryMaroon,
                );
                final kpi2 = _buildKpiItem(
                  title: 'Menunggu Konfirmasi',
                  count: '$pendingCount',
                  icon: Icons.pending_actions_rounded,
                  accentColor: const Color(0xFFD97706),
                  softBgColor: const Color(0xFFFEF3C7),
                );
                final kpi3 = _buildKpiItem(
                  title: 'Terkonfirmasi',
                  count: '$approvedCount',
                  icon: Icons.verified_rounded,
                  accentColor: AppColors.accentGreen,
                  softBgColor: const Color(0xFFDCFCE7),
                );
                final kpi4 = _buildKpiItem(
                  title: 'Ditolak',
                  count: '$rejectedCount',
                  icon: Icons.cancel_outlined,
                  accentColor: AppColors.accentCoral,
                  softBgColor: const Color(0xFFFFE4E6),
                );

                if (constraints.maxWidth >= 820) {
                  return Row(
                    children: [
                      Expanded(child: kpi1),
                      const SizedBox(width: 12),
                      Expanded(child: kpi2),
                      const SizedBox(width: 12),
                      Expanded(child: kpi3),
                      const SizedBox(width: 12),
                      Expanded(child: kpi4),
                    ],
                  );
                } else {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(child: kpi1),
                          const SizedBox(width: 10),
                          Expanded(child: kpi2),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(child: kpi3),
                          const SizedBox(width: 10),
                          Expanded(child: kpi4),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),

            const SizedBox(height: 16),

            // ── 3. Daftar Booking Table Card ─────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: AppColors.mutedSurface,
                borderRadius: BorderRadius.circular(AppRadii.lg),
                border: Border.all(color: AppColors.border, width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Responsive Table Card Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? 16 : 20,
                      vertical: 14,
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 12,
                      runSpacing: 8,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 4,
                              height: 18,
                              decoration: BoxDecoration(
                                color: AppColors.primaryRed,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Flexible(
                              child: Text(
                                'Daftar Antrean Booking Service',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryMaroon,
                                borderRadius:
                                    BorderRadius.circular(AppRadii.pill),
                              ),
                              child: Text(
                                '$totalCount Data',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryRed,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Text(
                          dealerName,
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(color: AppColors.border, height: 1),

                  // Table or Empty State
                  if (GlobalVar.listBrowseBooking.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 56),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: const BoxDecoration(
                              color: AppColors.secondaryMaroon,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.event_note_rounded,
                              size: 30,
                              color: AppColors.primaryRed,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Belum Ada Data Booking yang Ditampilkan',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Silakan pilih filter cabang serta rentang tanggal di atas, lalu klik tombol "CARI DATA".',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: constraints.maxWidth,
                            ),
                            child: Table(
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              columnWidths: const {
                                0: FixedColumnWidth(56),
                                1: FixedColumnWidth(145),
                                2: FixedColumnWidth(175),
                                3: FixedColumnWidth(115),
                                4: FixedColumnWidth(90),
                                5: FixedColumnWidth(155),
                                6: FixedColumnWidth(210),
                                7: FixedColumnWidth(195),
                                8: FixedColumnWidth(145),
                              },
                              border: const TableBorder(
                                horizontalInside: BorderSide(
                                  color: AppColors.border,
                                  width: 1.0,
                                ),
                              ),
                              children: [
                                // Table Header Row
                                const TableRow(
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryRed,
                                  ),
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 13),
                                      child: Text(
                                        'NO',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 13),
                                      child: Text(
                                        'NO. TELEPON',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 13),
                                      child: Text(
                                        'NAMA CUSTOMER',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 13),
                                      child: Text(
                                        'TANGGAL',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 13),
                                      child: Text(
                                        'PUKUL',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 13),
                                      child: Text(
                                        'JENIS MOTOR',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 13),
                                      child: Text(
                                        'KELUHAN',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 13),
                                      child: Text(
                                        'STATUS',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 13),
                                      child: Text(
                                        'AKSI',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.4,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                // Data Rows
                                for (var i = 0;
                                    i < GlobalVar.listBrowseBooking.length;
                                    i++)
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: i.isEven
                                          ? AppColors.mutedSurface
                                          : AppColors.primaryBackground,
                                    ),
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 12),
                                        child: Text(
                                          '${i + 1}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        child: Text(
                                          '0${GlobalVar.listBrowseBooking[i].uPhoneNo}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        child: Text(
                                          GlobalVar.listBrowseBooking[i].uName,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        child: Text(
                                          GlobalVar.tglFormat.format(
                                            DateTime.parse(
                                              GlobalVar.listBrowseBooking[i]
                                                  .bookDate,
                                            ),
                                          ),
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: AppColors.deepBackground,
                                            borderRadius: BorderRadius.circular(
                                                AppRadii.sm),
                                          ),
                                          child: Text(
                                            GlobalVar
                                                .listBrowseBooking[i].bookTime,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 12.5,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        child: Text(
                                          GlobalVar.listBrowseBooking[i].unitID,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        child: Text(
                                          GlobalVar.listBrowseBooking[i].notes
                                                  .isNotEmpty
                                              ? GlobalVar
                                                  .listBrowseBooking[i].notes
                                              : '-',
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 12),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: _buildStatusBadge(
                                            GlobalVar
                                                .listBrowseBooking[i].status,
                                          ),
                                        ),
                                      ),
                                      _buildActionCell(
                                        GlobalVar.listBrowseBooking[i],
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
