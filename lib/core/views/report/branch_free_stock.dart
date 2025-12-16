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
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: [
                  // Filter Title
                  InkWell(
                    onTap: null,
                    child: Container(
                      width: 90,
                      height: 40,
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

                  // ~:Divider:~
                  SizedBox(width: 10),

                  // ~:Branch Shop Name:~
                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Wrap(
                        spacing: 10,
                        children: [
                          // ~:Branch:~
                          ValueListenableBuilder<List<String>>(
                            valueListenable: state.getFreeStockBranchNameList,
                            builder: (context, value, _) {
                              if (value.isEmpty) {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  width: 250,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(15.0),
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
                                    isFreeStock: true,
                                  ),
                                );
                              } else {
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 500),
                                  width: 250,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(15.0),
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

                          // ~:Search Button:~
                          InkWell(
                            onTap: () => search(state),
                            borderRadius: BorderRadius.circular(15.0),
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

                  // ~:Divider:~
                  SizedBox(width: 10),

                  // ~:Save Button:~
                  ValueListenableBuilder(
                    valueListenable: state.getIsValueChanged,
                    builder: (context, value, _) {
                      if (value) {
                        return InkWell(
                          onTap: () => saveStockModification(state),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: 70,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Builder(
                              builder: (context) {
                                if (isSaving) {
                                  return SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: CircularProgressIndicator(
                                      color: Colors.black,
                                    ),
                                  );
                                }
                                return Text(
                                  'Save',
                                  style: GlobalFont.mediumgiantfontR,
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return InkWell(
                          onTap: null,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            width: 70,
                            height: 40,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10.0),
                            child: Text(
                              'Save',
                              style: GlobalFont.mediumgiantfontR,
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
