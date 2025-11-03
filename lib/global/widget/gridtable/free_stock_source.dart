import 'package:flutter/material.dart';
import 'package:stsj/core/models/Report/free_stock_result.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

/// An object to set the employee collection data source to the datagrid. This
/// is used to map the employee data to the datagrid widget.
class FreeStockDataSource extends DataGridSource {
  /// Creates the employee data source class with required details.
  FreeStockDataSource({
    required this.freeStockData,
    required this.isSaveEnabled,
  }) {
    print('Free Stock Data Source: ${freeStockData.length}');
    _freeStockData = freeStockData.asMap().entries.map<DataGridRow>((data) {
      FreeStockResultModel freeStock = data.value;
      int index = data.key;

      final freeStockData = DataGridRow(
        cells: [
          DataGridCell<String>(
            columnName: 'header',
            value: (index + 1).toString(),
          ),
          DataGridCell<String>(
            columnName: 'unitID',
            value: freeStock.unitId,
          ),
          DataGridCell<String>(
            columnName: 'unitName',
            value: freeStock.unitName,
          ),
          DataGridCell<String>(
            columnName: 'color',
            value: '${freeStock.colorName} (${freeStock.color})',
          ),
          DataGridCell<String>(
            columnName: 'stock',
            value: freeStock.freeStock.toString(),
          ),
          DataGridCell<String>(
            columnName: 'editableStock',
            value: freeStock.adjustStock.toString(),
          ),
        ],
      );

      return freeStockData;
    }).toList();
  }

  List<FreeStockResultModel> freeStockData = [];
  Function isSaveEnabled = () {};

  List<FreeStockResultModel> get getFreeStockData => freeStockData;

  List<DataGridRow> _freeStockData = [];

  @override
  List<DataGridRow> get rows => _freeStockData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    int index = _freeStockData.indexOf(row);

    return DataGridRowAdapter(
      color: index % 2 != 0 ? Colors.grey[200] : Colors.white,
      cells: row.getCells().asMap().entries.map<Widget>((e) {
        int i = e.key;
        DataGridCell data = e.value;
        TextEditingController controller = TextEditingController(
          text: data.value.toString(),
        );

        if (i == 4) {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            // child: NumberInputField(
            //   initialValue: data.value.toString(),
            //   minValue: -1000,
            //   maxValue: 1000,
            //   index: index,
            // ),
            child: SizedBox(
              width: 80,
              child: TextField(
                controller: controller,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  print('Free Stock Data length: ${getFreeStockData.length}');
                  try {
                    print(
                        'Adjust stock (before): ${getFreeStockData[index].adjustStock}');
                    getFreeStockData[index].adjustStock = int.parse(value);
                    print(
                        'Adjust stock (after): ${getFreeStockData[index].adjustStock}');

                    if (int.tryParse(data.value) != int.tryParse(value)) {
                      // Call the function to enable the save button
                      isSaveEnabled(true);
                    } else {
                      // Call the function to disable the save button
                      isSaveEnabled(false);
                    }
                  } catch (e) {
                    // Handle the error if the input is not a valid integer
                    print('Error: $e');
                  }
                },
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 8),
                ),
              ),
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(8.0),
            child: Text(data.value.toString()),
          );
        }
      }).toList(),
    );
  }
}
