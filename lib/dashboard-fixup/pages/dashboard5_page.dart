import 'package:flutter/material.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';
import 'package:stsj/core/cleanArc/dashboard_service/widgets/snackbar_info.dart';
import 'package:stsj/dashboard-fixup/models/dashboard5_model.dart';
import 'package:stsj/dashboard-fixup/pages/dashboard5_detail.dart';
import 'package:stsj/dashboard-fixup/services/api.dart';
import 'package:stsj/dashboard-fixup/utilities/basepage.dart';
import 'package:stsj/dashboard-fixup/widgets/button_custom.dart';
import 'package:stsj/dashboard-fixup/widgets/dialog_motor.dart';
import 'package:stsj/dashboard-fixup/widgets/text_static.dart';
import 'package:stsj/dashboard-fixup/widgets/textfield_custom.dart';
import 'package:stsj/dashboard-fixup/widgets/textfield_phone.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';

class Dashboard5Page extends StatefulWidget {
  const Dashboard5Page({
    super.key,
  });

  @override
  State<Dashboard5Page> createState() => _Dashboard5PageState();
}

class _Dashboard5PageState extends State<Dashboard5Page>
    with BasePage, AutomaticKeepAliveClientMixin<Dashboard5Page> {
  late bool _expandHeader;
  late List<Dashboard5> listDashboard5;
  late String id, nama, hp;

  void setId(String value) => id = value;
  void setNama(String value) => nama = value;
  void setHp(String value) => hp = value;

  @override
  void initState() {
    setAwal();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future setAwal() async {
    setState(() => loading = true);

    _expandHeader = true;
    reset();

    setState(() => loading = false);
  }

  void reset() {
    id = '';
    nama = '';
    hp = '';
    listDashboard5 = [];
  }

  Future export() async {}

  void refresh() async {
    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 100));
    setState(() {
      reset();
      loading = false;
    });
  }

  void find() async {
    setState(() => loading = true);

    try {
      listDashboard5 = await SampApi.getDashboard5(id, nama, hp);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(info(false, e.toString()));
      }
    }

    setState(() => loading = false);
  }

  void viewAsset(Dashboard5 data) {
    showDialog(
      context: context,
      builder: (BuildContext context) => DialogMotor(data),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.blue[50]!.withAlpha(200),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: CustomAppBar(
          goBack: RoutesConstant.menu,
        ),
      ),
      body: startUpPage(
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpansionPanelList(
                  animationDuration: const Duration(milliseconds: 400),
                  dividerColor: Colors.transparent,
                  elevation: 0,
                  expandedHeaderPadding: const EdgeInsets.all(0.0),
                  expansionCallback: (idx, isExpand) {
                    setState(() => _expandHeader = !isExpand);
                  },
                  children: [
                    //HEADER
                    ExpansionPanel(
                      backgroundColor: Colors.indigo.withAlpha(80),
                      isExpanded: _expandHeader,
                      canTapOnHeader: true,
                      headerBuilder: (context, isExpand) {
                        return Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            top: 4.0,
                            bottom: 4.0,
                          ),
                          child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 8,
                            runSpacing: 6,
                            children: [
                              const Text(
                                'HEADER',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                children: [
                                  ButtonCustom('Export', export),
                                  ButtonCustom('Reset', refresh),
                                  ButtonCustom('Cari', find),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                      body: Container(
                        color: Colors.white.withGreen(250),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 4.0,
                            horizontal: 20.0,
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              final fieldId = Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TextStatic('Member ID'),
                                  TextfieldCustom(
                                    inputan: id,
                                    hint: 'Inputkan Member ID',
                                    handle: setId,
                                  ),
                                ],
                              );
                              final fieldNama = Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TextStatic('Nama'),
                                  TextfieldCustom(
                                    inputan: nama,
                                    hint: 'Inputkan Nama',
                                    handle: setNama,
                                  ),
                                ],
                              );
                              final fieldHp = Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const TextStatic('Telepon'),
                                  TextfieldPhone(
                                    inputan: hp,
                                    hint: 'Inputkan Nomer Telepon',
                                    handle: setHp,
                                  ),
                                ],
                              );

                              if (constraints.maxWidth < 600) {
                                return Column(
                                  children: [
                                    fieldId,
                                    fieldNama,
                                    fieldHp,
                                    const SizedBox(height: 15),
                                  ],
                                );
                              }

                              return Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(flex: 1, child: fieldId),
                                      const SizedBox(width: 24),
                                      Expanded(flex: 1, child: fieldNama),
                                      const SizedBox(width: 24),
                                      Expanded(flex: 1, child: fieldHp),
                                      if (constraints.maxWidth >= 900) ...[
                                        const SizedBox(width: 24),
                                        const Expanded(
                                          flex: 1,
                                          child: SizedBox(),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //DETAIL
                Flexible(child: Dashboard5Detail(listDashboard5, viewAsset)),
                const SizedBox(height: 20),
              ],
            ),
            //*FOOTER
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                color: Colors.white.withOpacity(0.7),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('\u00a9 ', style: TextStyle(fontSize: 10)),
                    Text(
                      ' 2025 IT Basra Corporation',
                      style: TextStyle(fontSize: 10),
                    )
                  ],
                ),
              ),
            ),
            //*TANGGAL
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                color: Colors.white.withOpacity(0.7),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      Format.tanggalFormat(
                        DateTime.now().toString().substring(0, 10),
                      ),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
