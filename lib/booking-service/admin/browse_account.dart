import 'package:flutter/material.dart';
import 'package:stsj/booking-service/global/api.dart';
import 'package:stsj/booking-service/global/global.dart';
import 'package:stsj/booking-service/global/model.dart';
import 'package:stsj/booking-service/label/label_table.dart';
import 'package:stsj/booking-service/popupdialog/kotak_pesan.dart';
import 'package:stsj/booking-service/widget/button/text.dart';
import 'package:stsj/booking-service/widget/button/tombol.dart';
import 'package:stsj/booking-service/widget/format.dart';
import 'package:stsj/booking-service/widget/textfield/customtextfield.dart';
import 'package:stsj/global/theme/app_theme.dart';

class BrowseUserAccount extends StatefulWidget {
  const BrowseUserAccount({super.key});

  @override
  State<BrowseUserAccount> createState() => _BrowseUserAccountState();
}

class _BrowseUserAccountState extends State<BrowseUserAccount> {
  String userInput = '';
  int _searchResetVersion = 0;
  bool isID = false;
  bool isName = false;
  bool isPhone = false;
  List<ModelBrowseUserDetail1> listDetail1 = [];
  List<ModelBrowseUserDetail2> listDetail2 = [];
  bool isActive = false;

  void setUserInput(String value) {
    userInput = value;
  }

  void clearAll() {
    GlobalVar.browseAccList = [];
    GlobalVar.tempList = [];
    listDetail1 = [];
    listDetail2 = [];
  }

  void resetSearch() {
    setState(() {
      clearAll();
      userInput = '';
      _searchResetVersion++;
    });
  }

  void searchAccount() async {
    setState(() => clearAll());

    if (userInput != '') {
      if (userInput[0] == '0') {
        isID = true;
      } else if (userInput[0] == '8') {
        isPhone = true;
      } else {
        isName = true;
      }
    }

    GlobalVar.tempList = await GlobalAPI.getUserData(
      'MEMBERSHIP',
      isID == true ? userInput : '',
      isName == true ? userInput : '',
      '',
      isPhone == true ? userInput : '',
      '',
    );
    setState(() {});

    if (GlobalVar.tempList.isNotEmpty) {
      generatedPage();
      if (GlobalVar.currentPage > 1) {
        refreshPage();
      } else {
        loadFirstPage();
      }
    }

    isID = false;
    isName = false;
    isPhone = false;

    setState(() {});
    if (!mounted) return;
    if (GlobalVar.tempList.isEmpty) {
      GlobalFunction.tampilkanDialog(
        context,
        const KotakPesan(
          'INFORMASI',
          'Data member tidak ditemukan.',
        ),
      );
    }
  }

  void viewDetail1(int index) {
    if (GlobalVar.browseAccList.isNotEmpty) {
      final List<ModelBrowseUserDetail1> detailItems =
          List<ModelBrowseUserDetail1>.from(
              GlobalVar.browseAccList[index].detail);
      final String totalPoints =
          GlobalVar.browseAccList[index].points.toString();

      if (detailItems.isNotEmpty) {
        GlobalFunction.tampilkanDialog(
          context,
          Builder(
            builder: (dialogContext) => Container(
              width: 520,
              constraints: const BoxConstraints(maxHeight: 540),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryMaroon,
                          borderRadius: BorderRadius.circular(AppRadii.sm),
                        ),
                        child: const Icon(
                          Icons.stars_rounded,
                          color: AppColors.primaryRed,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Riwayat Poin Member',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Total Poin: $totalPoints',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        tooltip: 'Tutup',
                        icon: const Icon(Icons.close_rounded, size: 20),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.border, height: 24),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0; i < detailItems.length; i++)
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBackground,
                                borderRadius:
                                    BorderRadius.circular(AppRadii.md),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: AppColors.secondaryMaroon,
                                      borderRadius:
                                          BorderRadius.circular(AppRadii.sm),
                                    ),
                                    child: Text(
                                      '+${detailItems[i].pointQty}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.primaryRed,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          detailItems[i].pointName,
                                          style: const TextStyle(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          Format.tanggalFormat(
                                              detailItems[i].transDate),
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
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
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        GlobalFunction.tampilkanDialog(
          context,
          const KotakPesan(
            'INFORMASI',
            'Belum ada riwayat poin (Detail 1 kosong).',
          ),
        );
      }
      listDetail1 = [];
    }
  }

  void viewDetail2(int index) {
    if (GlobalVar.browseAccList.isNotEmpty) {
      final List<ModelBrowseUserDetail2> voucherItems =
          List<ModelBrowseUserDetail2>.from(
              GlobalVar.browseAccList[index].detail2);

      if (voucherItems.isNotEmpty) {
        GlobalFunction.tampilkanDialog(
          context,
          Builder(
            builder: (dialogContext) => Container(
              width: 520,
              constraints: const BoxConstraints(maxHeight: 540),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryMaroon,
                          borderRadius: BorderRadius.circular(AppRadii.sm),
                        ),
                        child: const Icon(
                          Icons.card_giftcard_rounded,
                          color: AppColors.primaryRed,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Voucher yang Ditukarkan',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Total Voucher: ${voucherItems.length}',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        tooltip: 'Tutup',
                        icon: const Icon(Icons.close_rounded, size: 20),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.border, height: 24),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (int i = 0; i < voucherItems.length; i++)
                            Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: voucherItems[i].voucherState == 0
                                    ? AppColors.deepBackground
                                    : AppColors.primaryBackground,
                                borderRadius:
                                    BorderRadius.circular(AppRadii.md),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    voucherItems[i].voucherName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Kode: ${voucherItems[i].voucherNumber}',
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primaryRed,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Wrap(
                                    spacing: 16,
                                    runSpacing: 4,
                                    children: [
                                      Text(
                                        'Redeem: ${Format.tanggalFormat(voucherItems[i].redeemDate)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      Text(
                                        'Expired: ${Format.tanggalFormat(voucherItems[i].expiredDate)}',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        GlobalFunction.tampilkanDialog(
          context,
          const KotakPesan(
            'INFORMASI',
            'Belum ada riwayat voucher (Detail 2 kosong).',
          ),
        );
      }
      listDetail2 = [];
    }
  }

  void submitNextPage() {
    setState(() {
      GlobalVar.currentPage += 1;
      refreshPage();
    });
  }

  void submitPrevPage() {
    setState(() {
      GlobalVar.currentPage -= 1;
      refreshPage();
    });
  }

  void generatedPage() {
    var temp = GlobalVar.tempList.length % 10;
    if (temp == 0) {
      GlobalVar.totalPage = GlobalVar.tempList.length / 10;
    } else {
      GlobalVar.totalPage =
          ((GlobalVar.tempList.length / 10) - (temp / 10)) + 1;
    }
  }

  void loadFirstPage() {
    if (GlobalVar.tempList.length > 10) {
      for (var i = 0; i < 10; i++) {
        GlobalVar.browseAccList.add(GlobalVar.tempList[i]);
      }
      GlobalVar.indexawal = 0;
      GlobalVar.indexakhir = 10;
    } else {
      for (var i = 0; i < GlobalVar.tempList.length; i++) {
        GlobalVar.browseAccList.add(GlobalVar.tempList[i]);
      }
      GlobalVar.indexawal = 0;
      GlobalVar.indexakhir = GlobalVar.tempList.length;
    }
  }

  void refreshPage() {
    GlobalVar.browseAccList = [];
    GlobalVar.indexawal = ((GlobalVar.currentPage * 10) - 10);
    if ((GlobalVar.currentPage * 10) > GlobalVar.tempList.length) {
      GlobalVar.indexakhir = GlobalVar.tempList.length;
    } else {
      GlobalVar.indexakhir = (GlobalVar.currentPage * 10);
    }

    for (var i = GlobalVar.indexawal; i < GlobalVar.indexakhir; i++) {
      if (i > GlobalVar.tempList.length - 1) {
        break;
      } else {
        GlobalVar.browseAccList.add(GlobalVar.tempList[i]);
      }
    }
  }

  @override
  void initState() {
    GlobalVar.browseAccList = [];
    userInput = '';
    super.initState();
  }

  @override
  void dispose() {
    GlobalVar.browseAccList = [];
    GlobalVar.tempList = [];
    userInput = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isCompact = screenWidth < 768;
    final bool stackSearch = screenWidth < 560;

    return Container(
      color: AppColors.primaryBackground,
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isCompact ? 14 : 24,
          vertical: 18,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Card
            Container(
              padding: EdgeInsets.all(isCompact ? 16 : 20),
              decoration: BoxDecoration(
                color: AppColors.mutedSurface,
                borderRadius: BorderRadius.circular(AppRadii.lg),
                border: Border.all(color: AppColors.border, width: 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryMaroon,
                          borderRadius: BorderRadius.circular(AppRadii.sm),
                        ),
                        child: const Icon(
                          Icons.manage_search_rounded,
                          color: AppColors.primaryRed,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pencarian Akun Member FixUP Moto',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            SizedBox(height: 2),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (stackSearch)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          setUserInput,
                          userInput,
                          double.infinity,
                          key: ValueKey('browse_search_$_searchResetVersion'),
                          hint: 'ID, nama, atau nomor telepon member...',
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Tombol(
                                'RESET',
                                resetSearch,
                                isTiny: true,
                                isOutlined: true,
                                tinggi: 42,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Tombol(
                                'CARI',
                                searchAccount,
                                isTiny: true,
                                tinggi: 42,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: CustomTextField(
                            setUserInput,
                            userInput,
                            double.infinity,
                            key: ValueKey('browse_search_$_searchResetVersion'),
                            hint: 'ID, nama, atau nomor telepon member...',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Tombol(
                          'RESET',
                          resetSearch,
                          isTiny: true,
                          isOutlined: true,
                          tinggi: 44,
                          lebar: 90,
                        ),
                        const SizedBox(width: 10),
                        Tombol(
                          'CARI',
                          searchAccount,
                          isTiny: true,
                          tinggi: 44,
                          lebar: 100,
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // Table Card
            Container(
              decoration: BoxDecoration(
                color: AppColors.mutedSurface,
                borderRadius: BorderRadius.circular(AppRadii.lg),
                border: Border.all(color: AppColors.border, width: 1.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (GlobalVar.browseAccList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Wrap(
                        alignment: WrapAlignment.spaceBetween,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 12,
                        runSpacing: 6,
                        children: [
                          const Text(
                            'Hasil Pencarian Member',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (GlobalVar.currentPage > 1)
                                IconButton(
                                  onPressed: submitPrevPage,
                                  icon: const Icon(
                                    Icons.chevron_left_rounded,
                                    color: AppColors.primaryRed,
                                  ),
                                ),
                              Text(
                                '${GlobalVar.indexawal + 1} - ${GlobalVar.indexakhir} dari ${GlobalVar.tempList.length}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              if (GlobalVar.currentPage < GlobalVar.totalPage)
                                IconButton(
                                  onPressed: submitNextPage,
                                  icon: const Icon(
                                    Icons.chevron_right_rounded,
                                    color: AppColors.primaryRed,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      columnWidths: const {
                        0: FixedColumnWidth(56),
                        1: FixedColumnWidth(110),
                        2: FixedColumnWidth(175),
                        3: FixedColumnWidth(170),
                        4: FixedColumnWidth(210),
                        5: FixedColumnWidth(160),
                        6: FixedColumnWidth(120),
                        7: FixedColumnWidth(120),
                        8: FixedColumnWidth(110),
                        9: FixedColumnWidth(110),
                      },
                      border: const TableBorder(
                        horizontalInside:
                            BorderSide(color: AppColors.border, width: 1.0),
                      ),
                      children: [
                        const TableRow(
                          decoration:
                              BoxDecoration(color: AppColors.primaryRed),
                          children: [
                            LabelTable('NO', Alignment.center, 0,
                                isAlign: true),
                            LabelTable('STATUS', Alignment.center, 0,
                                isAlign: true),
                            LabelTable('MEMBER ID', Alignment.center, 0,
                                isAlign: true),
                            LabelTable('NAMA MEMBER', Alignment.centerLeft, 0),
                            LabelTable('EMAIL', Alignment.centerLeft, 0),
                            LabelTable('NO. TELEPON', Alignment.center, 0,
                                isAlign: true),
                            LabelTable('TOTAL MOTOR', Alignment.center, 0,
                                isAlign: true),
                            LabelTable('TOTAL POIN', Alignment.center, 0,
                                isAlign: true),
                            LabelTable('RIWAYAT POIN', Alignment.center, 0,
                                isAlign: true),
                            LabelTable('VOUCHER', Alignment.center, 0,
                                isAlign: true),
                          ],
                        ),
                        for (var i = 0;
                            i < GlobalVar.browseAccList.length;
                            i++)
                          TableRow(
                            decoration: BoxDecoration(
                              color: i.isEven
                                  ? AppColors.mutedSurface
                                  : AppColors.primaryBackground,
                            ),
                            children: [
                              LabelTable('${i + 1}', Alignment.center, 1,
                                  isAlign: true),
                              LabelTable(
                                GlobalVar.browseAccList[i].status,
                                Alignment.center,
                                1,
                                isAlign: true,
                              ),
                              LabelTable(
                                GlobalVar.browseAccList[i].memberID,
                                Alignment.center,
                                1,
                                isAlign: true,
                              ),
                              LabelTable(
                                GlobalVar.browseAccList[i].memberName,
                                Alignment.centerLeft,
                                1,
                              ),
                              LabelTable(
                                GlobalVar.browseAccList[i].email.isNotEmpty
                                    ? GlobalVar.browseAccList[i].email
                                    : '-',
                                Alignment.centerLeft,
                                1,
                              ),
                              LabelTable(
                                '+62${GlobalVar.browseAccList[i].phoneNumber}',
                                Alignment.center,
                                1,
                                isAlign: true,
                              ),
                              LabelTable(
                                GlobalVar.browseAccList[i].qty.toString(),
                                Alignment.center,
                                1,
                                isAlign: true,
                              ),
                              LabelTable(
                                GlobalVar.browseAccList[i].points.toString(),
                                Alignment.center,
                                1,
                                isAlign: true,
                              ),
                              TextPressable('Lihat', () => viewDetail1(i)),
                              TextPressable('Lihat', () => viewDetail2(i)),
                            ],
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
    );
  }
}
