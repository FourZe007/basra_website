import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/booking-service/global/api.dart';
import 'package:stsj/booking-service/global/global.dart';
import 'package:stsj/booking-service/popupdialog/kotak_pesan.dart';
import 'package:stsj/booking-service/progressindicator/circle_loading.dart';
import 'package:stsj/booking-service/state_management/state_workshop.dart';
import 'package:stsj/booking-service/widget/card/kartu.dart';
import 'package:stsj/booking-service/widget/dropdown/branchasset.dart';
import 'package:stsj/booking-service/widget/format.dart';
import 'package:stsj/global/theme/app_theme.dart';

class Workshops extends StatefulWidget {
  const Workshops({super.key});

  @override
  State<Workshops> createState() => _WorkshopsState();
}

class _WorkshopsState extends State<Workshops> {
  DateTime? selectedDateTime;

  bool isActive = false;

  String cabang = 'FixUP MOTO - KUTISARI';

  String shop = '';
  String beginDate = '';
  String endDate = '';
  String bookingID = '';
  String status = '';

  final DateTime _currentTime = DateTime.now();
  bool _isUserAllowed = false;

  int counter = 0;

  bool branchState = false;

  final TextEditingController bookingIDController = TextEditingController();
  final ScrollController _workshopsScrollController = ScrollController();

  void _scrollLeft() {
    if (_workshopsScrollController.hasClients) {
      final current = _workshopsScrollController.offset;
      final target = (current - 320.0).clamp(
        0.0,
        _workshopsScrollController.position.maxScrollExtent,
      );
      _workshopsScrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _scrollRight() {
    if (_workshopsScrollController.hasClients) {
      final current = _workshopsScrollController.offset;
      final target = (current + 320.0).clamp(
        0.0,
        _workshopsScrollController.position.maxScrollExtent,
      );
      _workshopsScrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void setCabang(String value) {
    setState(() {
      cabang = value;
    });
  }

  void setBookingID(String value) {
    bookingID = value;
  }

  void browseBooking(WorkshopState state) async {
    for (var data in state.getBranchesList) {
      if (cabang == data.name) {
        setState(() {
          shop = data.shop;
        });
        break;
      }
    }

    if (bookingID != '') {
      state.browseBookList.clear();
      state.browseBookList.addAll(await GlobalAPI.fetchBrowseBookReq(
        shop,
        '',
        '',
        '',
        '',
        bookingID,
        '',
      ));

      if (!mounted) return;
      if (state.browseBookList.isEmpty) {
        GlobalFunction.tampilkanDialog(
          context,
          const KotakPesan(
            'INFORMASI',
            'Kode Booking tidak ditemukan pada cabang yang dipilih.',
          ),
        );
      }

      setState(() {});
    } else {
      // ignore: use_build_context_synchronously
      GlobalFunction.tampilkanDialog(
        context,
        const KotakPesan(
          'INFORMASI',
          'Mohon masukkan Kode Booking terlebih dahulu.',
        ),
      );
    }
  }

  Future<List<dynamic>> branchProcess(WorkshopState state) async {
    state.branchesList = [];
    state.rows = [];
    state.branchesList.addAll(await GlobalAPI.fetchBranches('BRANCHSHOP'));

    state.rows.addAll(
      List.generate(
        state.branchesList.length,
        (index) => Kartu(
          state.branchesList[index].name,
          state.branchesList[index].address,
          state.branchesList[index].operation,
          state.branchesList[index].phone != ''
              ? state.branchesList[index].phone
              : 'Coming Soon',
          '',
          isUserAllowed: _isUserAllowed,
          isOpen: state.branchesList[index].isOpen,
        ),
      ),
    );

    if (_currentTime.hour >= 9 && _currentTime.hour <= 17) {
      _isUserAllowed = true;
    } else {
      _isUserAllowed = false;
    }

    return [state.getRows, state.branchesList];
  }

  @override
  void initState() {
    branchProcess(Provider.of<WorkshopState>(context, listen: false));
    super.initState();
  }

  @override
  void dispose() {
    _workshopsScrollController.dispose();
    bookingIDController.dispose();
    super.dispose();
  }

  Widget _buildFixupBanner(bool isCompact) {
    if (isCompact) {
      return Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF141416),
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(color: AppColors.border, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(AppRadii.sm),
              child: Image.asset(
                'assets/images/fixup-book-logo.jpg',
                height: 56,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'FixUP Moto — Daftar Bengkel & Booking',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              'Pilih cabang bengkel resmi FixUP Moto dan lakukan booking servis langsung',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11.5,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF141416),
        borderRadius: BorderRadius.circular(AppRadii.lg),
        border: Border.all(color: AppColors.border, width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadii.sm),
            child: Image.asset(
              'assets/images/fixup-book-logo.jpg',
              height: 64,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'FixUP Moto - Daftar Bengkel & Booking',
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill(String statusText) {
    final String upper = statusText.toUpperCase();
    Color bg;
    Color fg;
    if (upper == 'TERKONFIRMASI') {
      bg = const Color(0xFFDCFCE7);
      fg = AppColors.accentGreen;
    } else if (upper == 'DITOLAK') {
      bg = const Color(0xFFFFE4E6);
      fg = AppColors.accentCoral;
    } else {
      bg = const Color(0xFFFEF3C7);
      fg = const Color(0xFFD97706);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadii.pill),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const Text(
            ' :  ',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value.isNotEmpty ? value : '-',
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final workshopState = Provider.of<WorkshopState>(context);
    final bool isCompact = MediaQuery.of(context).size.width < 720;

    return FutureBuilder(
      future: branchProcess(workshopState),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircleLoading());
        } else if (snapshot.hasError) {
          return const Center(
            child: Text('Gagal memuat daftar bengkel, silakan coba lagi.'),
          );
        } else if (!snapshot.hasData ||
            (snapshot.data![0].isEmpty && snapshot.data![1].isEmpty)) {
          return const Center(
            child: Text('Tidak ada data bengkel.'),
          );
        } else {
          final data = snapshot.data!;

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
                  _buildFixupBanner(isCompact),
                  // ── 1. Daftar Bengkel Card ─────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.mutedSurface,
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                      border: Border.all(color: AppColors.border, width: 1.0),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        tilePadding: EdgeInsets.symmetric(
                          horizontal: isCompact ? 16 : 20,
                          vertical: 6,
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
                            Icons.storefront_rounded,
                            color: AppColors.primaryRed,
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          'Daftar Bengkel',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        children: [
                          const Divider(color: AppColors.border, height: 20),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.primaryBackground,
                                  borderRadius: BorderRadius.circular(AppRadii.md),
                                  border: Border.all(color: AppColors.border, width: 1.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        size: 14,
                                      ),
                                      tooltip: 'Scroll Left',
                                      color: AppColors.textPrimary,
                                      splashRadius: 18,
                                      constraints: const BoxConstraints(
                                        minWidth: 36,
                                        minHeight: 34,
                                      ),
                                      padding: EdgeInsets.zero,
                                      onPressed: _scrollLeft,
                                    ),
                                    Container(
                                      width: 1,
                                      height: 18,
                                      color: AppColors.border,
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_forward_ios_rounded,
                                        size: 14,
                                      ),
                                      tooltip: 'Scroll Right',
                                      color: AppColors.textPrimary,
                                      splashRadius: 18,
                                      constraints: const BoxConstraints(
                                        minWidth: 36,
                                        minHeight: 34,
                                      ),
                                      padding: EdgeInsets.zero,
                                      onPressed: _scrollRight,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 385,
                            child: RawScrollbar(
                              controller: _workshopsScrollController,
                              thumbVisibility: true,
                              trackVisibility: true,
                              thickness: 8.0,
                              radius: const Radius.circular(4),
                              thumbColor: AppColors.primaryRed.withValues(alpha: 0.8),
                              trackColor: AppColors.deepBackground,
                              trackBorderColor: AppColors.border,
                              interactive: true,
                              padding: const EdgeInsets.only(top: 8),
                              child: ScrollConfiguration(
                                behavior: ScrollConfiguration.of(context).copyWith(
                                  dragDevices: {
                                    PointerDeviceKind.touch,
                                    PointerDeviceKind.mouse,
                                    PointerDeviceKind.trackpad,
                                  },
                                ),
                                child: SingleChildScrollView(
                                  controller: _workshopsScrollController,
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: Row(
                                      children: data[0],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ── 2. Cek Status Booking Card ─────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.mutedSurface,
                      borderRadius: BorderRadius.circular(AppRadii.lg),
                      border: Border.all(color: AppColors.border, width: 1.0),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: true,
                        tilePadding: EdgeInsets.symmetric(
                          horizontal: isCompact ? 16 : 20,
                          vertical: 6,
                        ),
                        childrenPadding: EdgeInsets.fromLTRB(
                          isCompact ? 16 : 20,
                          4,
                          isCompact ? 16 : 20,
                          24,
                        ),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryMaroon,
                            borderRadius: BorderRadius.circular(AppRadii.sm),
                          ),
                          child: const Icon(
                            Icons.confirmation_number_outlined,
                            color: AppColors.primaryRed,
                            size: 20,
                          ),
                        ),
                        title: const Text(
                          'Cek Status Booking',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        children: [
                          const Divider(color: AppColors.border, height: 20),
                          if (isCompact)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                BranchAsset(
                                  setCabang,
                                  cabang,
                                  data[1],
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: bookingIDController,
                                  decoration: const InputDecoration(
                                    hintText: 'Masukkan Kode Booking ID',
                                    prefixIcon: Icon(
                                      Icons.qr_code_scanner_rounded,
                                      size: 18,
                                      color: AppColors.primaryRed,
                                    ),
                                  ),
                                  onChanged: setBookingID,
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 44,
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        browseBooking(workshopState),
                                    icon: const Icon(Icons.search_rounded,
                                        size: 18),
                                    label: const Text('Cek Status'),
                                  ),
                                ),
                              ],
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: BranchAsset(
                                    setCabang,
                                    cabang,
                                    data[1],
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  flex: 5,
                                  child: SizedBox(
                                    height: 44,
                                    child: TextField(
                                      controller: bookingIDController,
                                      decoration: const InputDecoration(
                                        hintText: 'Masukkan Kode Booking ID...',
                                        prefixIcon: Icon(
                                          Icons.qr_code_scanner_rounded,
                                          size: 18,
                                          color: AppColors.primaryRed,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 10,
                                        ),
                                      ),
                                      onChanged: setBookingID,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                SizedBox(
                                  height: 44,
                                  child: ElevatedButton.icon(
                                    onPressed: () =>
                                        browseBooking(workshopState),
                                    icon: const Icon(Icons.search_rounded,
                                        size: 18),
                                    label: const Text('Cek Status'),
                                  ),
                                ),
                              ],
                            ),

                          // Hasil Pencarian Booking
                          if (workshopState.getBrowseBookList.isNotEmpty) ...[
                            const SizedBox(height: 24),
                            Center(
                              child: ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 560),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBackground,
                                    borderRadius:
                                        BorderRadius.circular(AppRadii.md),
                                    border: Border.all(
                                      color: AppColors.primaryRed
                                          .withValues(alpha: 0.3),
                                      width: 1.2,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Wrap(
                                        alignment: WrapAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        spacing: 12,
                                        runSpacing: 8,
                                        children: [
                                          const Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.receipt_long_rounded,
                                                size: 18,
                                                color: AppColors.primaryRed,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                'Detail Tiket Booking',
                                                style: TextStyle(
                                                  fontSize: 14.5,
                                                  fontWeight: FontWeight.w700,
                                                  color: AppColors.textPrimary,
                                                ),
                                              ),
                                            ],
                                          ),
                                          _buildStatusPill(
                                            workshopState
                                                .browseBookList[0].status,
                                          ),
                                        ],
                                      ),
                                      const Divider(
                                        color: AppColors.border,
                                        height: 24,
                                      ),
                                      _buildInfoRow(
                                        'Nama Customer',
                                        workshopState.browseBookList[0].uName,
                                      ),
                                      _buildInfoRow(
                                        'No. Telepon',
                                        '+62${workshopState.browseBookList[0].uPhoneNo}',
                                      ),
                                      _buildInfoRow(
                                        'Tanggal Service',
                                        Format.tanggalFormat(
                                          workshopState
                                              .browseBookList[0].bookDate,
                                        ),
                                      ),
                                      _buildInfoRow(
                                        'Jam Kedatangan',
                                        workshopState
                                            .browseBookList[0].bookTime,
                                      ),
                                      _buildInfoRow(
                                        'Tipe Motor',
                                        workshopState.browseBookList[0].unitID,
                                      ),
                                      _buildInfoRow(
                                        'Keluhan',
                                        workshopState.browseBookList[0].notes,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
