import 'package:flutter/material.dart';
import 'package:stsj/core/models/Report/mbrowse_salesman.dart';
import 'package:stsj/global/widget/gridtable/salesman_data_source.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class SalesmanList extends StatefulWidget {
  const SalesmanList(
    this.salesmanDataList, {
    super.key,
  });

  final List<MBrowseSalesman> salesmanDataList;

  @override
  State<SalesmanList> createState() => _SalesmanListState();
}

class _SalesmanListState extends State<SalesmanList> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 800;

    return SfDataGrid(
      source: SalesmanDataSource(salesmanData: widget.salesmanDataList),
      columnWidthMode:
          isMobile ? ColumnWidthMode.auto : ColumnWidthMode.fill,
      checkboxShape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(20.0),
      ),
      columns: <GridColumn>[
        GridColumn(
          columnName: 'branch',
          minimumWidth: 100,
          label: Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text('Cabang'),
          ),
        ),
        GridColumn(
          columnName: 'shop',
          minimumWidth: 150,
          label: Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text('Toko'),
          ),
        ),
        GridColumn(
          columnName: 'location',
          minimumWidth: 120,
          label: Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text('Penempatan'),
          ),
        ),
        GridColumn(
          columnName: 'id',
          minimumWidth: 120,
          label: Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text('NIP'),
          ),
        ),
        GridColumn(
          columnName: 'name',
          minimumWidth: 150,
          label: Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text(
              'Nama',
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        GridColumn(
          columnName: 'level',
          minimumWidth: 100,
          label: Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text('Level'),
          ),
        ),
        GridColumn(
          columnName: 'status',
          minimumWidth: 100,
          label: Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text('status'),
          ),
        ),
        GridColumn(
          columnName: 'photo',
          minimumWidth: 80,
          label: Container(
            padding: EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: Text('Foto'),
          ),
        ),
      ],
    );
  }
}
