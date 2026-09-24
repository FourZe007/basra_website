import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_grid/simple_grid.dart';
import 'package:stsj/router/router_const.dart';
import 'package:stsj/global/widget/app_bar.dart';

class OtoriasiDiscountPages extends HookWidget {
  final ScrollController _scrollController = ScrollController();

  final List<String> branches = [
    'Branch A',
    'Branch B',
    'Branch C',
    'Branch D'
  ];

  OtoriasiDiscountPages({super.key});

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
            builder: (context, constraints) => SingleChildScrollView(
                  child: Center(
                    child: Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.grey.withOpacity(0.5), // Warna bayangan
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
                                      vertical: 20, horizontal: 20),
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
                                  constraints: BoxConstraints(
                                      minWidth: constraints.minWidth),
                                  child: PaginatedDataTable(
                                    columnSpacing: 20,
                                    columns: const <DataColumn>[
                                      DataColumn(
                                        label: Text(
                                          'No SPK',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Tanggal',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Tipe',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Harga Kosong',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'BBN',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Potongan Toko',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Subsidi Leasing',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Campaign',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Komisi Broker',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Uang Muka',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Sisa Piutang',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Leasing',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Keterangan',
                                          style: TextStyle(
                                              fontStyle: FontStyle.italic),
                                        ),
                                      ),
                                    ],
                                    source: YourDataTableSource(),
                                    rowsPerPage: 9,
                                  ),
                                ),
                              ],
                            )),
                      ]),
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
        DataCell(Text('123')),
        DataCell(Text('2023-10-02')),
        DataCell(Text('Sedan')),
        DataCell(Text('25000000')),
        DataCell(Text('1500000')),
        DataCell(Text('500000')),
        DataCell(Text('0')),
        DataCell(Text('0')),
        DataCell(Text('0')),
        DataCell(Text('2000000')),
        DataCell(Text('21500000')),
        DataCell(Text('Leasing A')),
        DataCell(Text('')),
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
