import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/models/Report/free_stock_result.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/function.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/global/widget/dropdown/sis_branch_shop_dropdown.dart';
import 'package:stsj/global/widget/gridtable/free_stock_source.dart';
import 'package:stsj/router/router_const.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BranchFreeStockPage extends StatefulWidget {
  const BranchFreeStockPage({super.key});

  @override
  State<BranchFreeStockPage> createState() => _BranchFreeStockPageState();
}

class _BranchFreeStockPageState extends State<BranchFreeStockPage> {
  bool isLoading = false;
  bool isSaving = false;

  void setIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  void setIsSaving() {
    setState(() {
      isSaving = !isSaving;
    });
  }

  void search(MenuState state) async {
    state.setSearchTriggerNotifier(true);
    // ~:Fetch and load data:~
    setIsLoading();
    try {
      await state.fetchFreeStockResult();
    } catch (e) {
      print('Error: $e');
    } finally {
      setIsLoading();
      // ~:Set search trigger to false:~
      state.setSearchTriggerNotifier(false);
    }
  }

  void textCustomDialog(
    String title,
    String content, {
    MenuState? state,
  }) {
    GlobalFunction.tampilkanDialog(
      context,
      true,
      Container(
        width: MediaQuery.of(context).size.width * 0.2,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: GlobalFont.giantfontRBold,
            ),
            SizedBox(height: 10.0),
            Text(
              content,
              style: GlobalFont.bigfontR,
            ),
            SizedBox(height: 15.0),
            ElevatedButton(
              onPressed: () {
                if (title == 'SUKSES') {
                  search(state!);
                }

                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Container(
                width: 60,
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  'Tutup',
                  style: GlobalFont.bigfontR,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void saveStockModification(MenuState state) async {
    print('Modify Free Stock');
    for (FreeStockResultModel data in state.getFreeStockResult['data']) {
      print(data.adjustStock);
    }
    print('');

    String status = '';
    try {
      setIsSaving();
      status = await state.modifyFreeStock();
    } catch (e) {
      print('Error: $e');
      textCustomDialog('ERROR', 'Terjadi kesalahan, mohon coba lagi.');
    } finally {
      setIsSaving();

      if (status == 'success') {
        textCustomDialog('SUKSES', 'Data berhasil diubah.', state: state);
      } else if (status == 'failed') {
        textCustomDialog('GAGAL', 'Data gagal diubah.');
      } else if (status == 'error' || status == '') {
        textCustomDialog('ERROR', 'Terjadi kesalahan, mohon coba lagi.');
      } else if (status == 'not found') {
        textCustomDialog('NOT FOUND', '404: Data tidak ditemukan.');
      }
    }
  }

  @override
  void initState() {
    Provider.of<MenuState>(context, listen: false).fetchBranchFreeStock();
    // Provider.of<MenuState>(context, listen: false)
    //     .setSearchTriggerNotifier(false);
    Provider.of<MenuState>(context, listen: false).resetFreeStockFilter();
    Provider.of<MenuState>(context, listen: false).setIsValueChanged(false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MenuState>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          MediaQuery.of(context).size.height * 0.065,
        ),
        child: CustomAppBar(
          goBack: RoutesConstant.menu,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.01,
          vertical: MediaQuery.of(context).size.height * 0.01,
        ),
        padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.01,
          right: MediaQuery.of(context).size.width * 0.01,
          top: MediaQuery.of(context).size.height * 0.01,
        ),
        child: Wrap(
          runSpacing: 15,
          children: [
            // ==================================================================
            // =========================== Filter ===============================
            // ==================================================================
            // ==================================================================
            // =========================== Filter ===============================
            // ==================================================================
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16.0),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Filter Badge
                  Container(
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.filter_alt_rounded,
                          size: 16.0,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 6.0),
                        const Text(
                          'Filter',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12.0),

                  // ~:Branch Shop Name:~
                  Expanded(
                    child: SizedBox(
                      height: 36,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          // ~:Branch:~
                          ValueListenableBuilder<List<String>>(
                            valueListenable: state.getFreeStockBranchNameList,
                            builder: (context, value, _) {
                              if (value.isEmpty) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  width: 250,
                                  height: 36,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFCBD5E1),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.01,
                                  ),
                                  child: SisBranchShopDropdown(
                                    listData: const [],
                                    inputan: '',
                                    hint: 'Cabang',
                                    handle: () {},
                                    disable: true,
                                    isFreeStock: true,
                                  ),
                                );
                              } else {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  width: 250,
                                  height: 36,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE2E8F0),
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.01,
                                  ),
                                  child: SisBranchShopDropdown(
                                    listData: value,
                                    inputan: state.selectedFreeStockBranch,
                                    hint: 'Cabang',
                                    handle: state.setSelectedFreeStockBranch,
                                    disable: false,
                                    isFreeStock: true,
                                  ),
                                );
                              }
                            },
                          ),

                          const SizedBox(width: 8.0),

                          // ~:Search Button:~
                          InkWell(
                            onTap: () => search(state),
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              height: 36,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14.0),
                              decoration: BoxDecoration(
                                color: const Color(0xFF1E293B),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.search_rounded,
                                    size: 16.0,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 6.0),
                                  const Text(
                                    'Cari',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
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

                  const SizedBox(width: 12.0),

                  // ~:Save Button:~
                  ValueListenableBuilder(
                    valueListenable: state.getIsValueChanged,
                    builder: (context, value, _) {
                      if (value) {
                        return InkWell(
                          onTap: () => saveStockModification(state),
                          borderRadius: BorderRadius.circular(10.0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            height: 36,
                            padding: const EdgeInsets.symmetric(horizontal: 14.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Builder(
                              builder: (context) {
                                if (isSaving) {
                                  return const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2.0,
                                    ),
                                  );
                                }
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.save_rounded,
                                      size: 16.0,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 6.0),
                                    const Text(
                                      'Save',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 13.0,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return InkWell(
                          onTap: null,
                          borderRadius: BorderRadius.circular(10.0),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            height: 36,
                            padding: const EdgeInsets.symmetric(horizontal: 14.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: const Color(0xFF94A3B8), // Disabled grey
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.save_rounded,
                                  size: 16.0,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 6.0),
                                const Text(
                                  'Save',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 13.0,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),

            // =================================================================
            // ========================== Content ==============================
            // =================================================================
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.83,
              child: ValueListenableBuilder(
                valueListenable: state.getSearchTriggerNotifier,
                builder: (context, value, _) {
                  final status = state.getFreeStockResult['status'];
                  List<FreeStockResultModel> freeStockList =
                      state.getFreeStockResult['data'];
                  print('Free stock length: ${freeStockList.length}');

                  print('Search Trigger: $value');
                  if (!value && freeStockList.isEmpty) {
                    return Center(
                      child: Text('Data tidak tersedia.'),
                    );
                  } else {
                    if (isLoading) {
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
                    } else {
                      if (status == 'failed') {
                        return Center(
                          child: Text('Data tidak ditemukan.'),
                        );
                      } else if (status == 'not found' || status == 'error') {
                        return Center(
                          child: Text(
                            'terjadi kesalahan, mohon coba lagi.',
                          ),
                        );
                      } else if (freeStockList.isEmpty) {
                        return Center(
                          child: Text('Data tidak tersedia.'),
                        );
                      } else {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: SfDataGrid(
                            source: FreeStockDataSource(
                              freeStockData: freeStockList,
                              isSaveEnabled: state.setIsValueChanged,
                            ),
                            columnWidthMode: ColumnWidthMode.fill,
                            checkboxShape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            columns: <GridColumn>[
                              GridColumn(
                                columnName: 'header',
                                width: MediaQuery.of(context).size.width * 0.05,
                                label: Container(
                                  padding: EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: Text('No'),
                                ),
                              ),
                              GridColumn(
                                columnName: 'unitID',
                                label: Container(
                                  padding: EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: Text('Kode Unit'),
                                ),
                              ),
                              GridColumn(
                                columnName: 'unitName',
                                label: Container(
                                  padding: EdgeInsets.all(16.0),
                                  alignment: Alignment.center,
                                  child: Text('Nama Unit'),
                                ),
                              ),
                              GridColumn(
                                columnName: 'color',
                                label: Container(
                                  padding: EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('Warna'),
                                ),
                              ),
                              GridColumn(
                                columnName: 'stock',
                                label: Container(
                                  padding: EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('Stock'),
                                ),
                              ),
                              GridColumn(
                                columnName: 'editableStock',
                                label: Container(
                                  padding: EdgeInsets.all(8.0),
                                  alignment: Alignment.center,
                                  child: Text('Adjust Stock'),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
