import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_grid/simple_grid.dart';
import 'package:stsj/router/router_const.dart';
import 'package:stsj/global/widget/app_bar.dart';

class OtorisasiMutasiPages extends HookWidget {
  final ScrollController _scrollController = ScrollController();

  final List<String> branches = [
    'Branch A',
    'Branch B',
    'Branch C',
    'Branch D'
  ];

  @override
  Widget build(BuildContext context) {
    final selectedBranch = useState('Branch A');

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 231, 230, 230),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            56,
          ),
          child: CustomAppBar(goBack: RoutesConstant.menu),
        ),
        body: LayoutBuilder(
            builder: (context, constraints) => Center(
                  child: SingleChildScrollView(
                    child: Center(
                      child: Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.5), // Warna bayangan
                              spreadRadius: 5, // Menyebar lebar bayangan
                              blurRadius: 7, // Blur bayangan
                              offset: Offset(0, 3), // Offset bayangan
                            ),
                          ],
                        ),
                        child: SpGrid(children: [
                          SpGridItem(
                              xs: 12,
                              sm: 12,
                              md: 12,
                              lg: 10,
                              child: Wrap(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 20),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.grey,
                                        width: 0.2,
                                      ),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: selectedBranch.value,
                                        isDense: true,
                                        onChanged: (newValue) {
                                          selectedBranch.value = newValue!;
                                        },
                                        items: branches.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                  Container(
                                      child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context)
                                          .size
                                          .width, // Menyamakan lebar dengan parent
                                    ),
                                    child: PaginatedDataTable(
                                      columns: const <DataColumn>[
                                        DataColumn(
                                          label: Text(
                                            'No Mutasi',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Tanggal',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Tujuan Kirim',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Keterangan',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Pembuat',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Keputusan',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),
                                      ],
                                      source: YourDataTableSource(),
                                      rowsPerPage: 12,
                                    ),
                                  )),
                                ],
                              )),
                        ]),
                      ),
                    ),
                  ),
                )));
  }
}

class YourDataTableSource extends DataTableSource {
  @override
  DataRow getRow(int index) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text('6001MMO23100002')),
        DataCell(Text('2023-10-02')),
        DataCell(Text('SIP KEDUNGDORO')),
        DataCell(
          Text('1 FAZZIO CONNECTED NEO (BEJ100) BIRU 2023'),
        ),
        DataCell(Text('FLORENSIA ANINDYA W')),
        DataCell(Text('Keputusan')),
      ],
    );
  }

  @override
  int get rowCount => 1;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
