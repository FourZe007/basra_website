import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:stsj/core/service/ReusableService.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class FilterDatesV2 extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();

  static Map<String, dynamic> selectedDates = {
    "bulan": DateTime.now().month,
    "hari": [
      for (var i = 1; i <= DateTime.now().day; i++) i,
    ],
    "tahun": DateTime.now().year
  };

  static DateRangePickerSelectionMode currentSelectionMode =
      DateRangePickerSelectionMode.multiple;

  static List<PickerDateRange> rangeDate = [];
}

class _MyWidgetState extends State<FilterDatesV2> {
  // Menyimpan tanggal yang dipilih

  DateRangePickerController _datePickerController = DateRangePickerController();

  String textToogle = "Range";

  bool clearListDate = true;

  bool setText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void _toggleSelectionMode() {
      setState(() {
        if (FilterDatesV2.currentSelectionMode ==
            DateRangePickerSelectionMode.multiple) {
          FilterDatesV2.currentSelectionMode =
              DateRangePickerSelectionMode.range;
          textToogle = "multiple";
          setText = false;
        } else {
          FilterDatesV2.currentSelectionMode =
              DateRangePickerSelectionMode.multiple;
          textToogle = "Range";
          setText = true;
        }
      });
    }

    Future<void> _showDialog(BuildContext context) async {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Filter By Tanggal'),
            content: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                String _selectedDate = '';
                String _dateCount = '';
                String _range = '';
                String _rangeCount = '';
                return Container(
                  height: 500,
                  width: MediaQuery.of(context).size.width < 550 ? MediaQuery.of(context).size.width * 0.9 : 500,
                  child: Column(
                    children: <Widget>[
                      setText
                          ? Text(
                              '* Filter tanggal dengan bulan dan tahun yang sesuai',
                              style: TextStyle(color: Colors.red),
                            )
                          : SizedBox(),
                      setText
                          ? Text(
                              'Tanggal yang dipilih: ${FilterDatesV2.selectedDates['hari']}')
                          : SizedBox(),
                      setText
                          ? Text(
                              'bulan yang dipilih: ${ServiceReusable.cekbulan(FilterDatesV2.selectedDates['bulan'])}')
                          : SizedBox(),
                      setText
                          ? Text(
                              'tahun yang dipilih: ${FilterDatesV2.selectedDates['tahun']}')
                          : SizedBox(),
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          // ElevatedButton(
                          //   onPressed: () {
                          //     setState(() {
                          //       _toggleSelectionMode();
                          //     });
                          //   },
                          //   child: Text(" ${textToogle}"),
                          // ),
                          SizedBox(
                            width: 5,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                FilterDatesV2.selectedDates['hari'].clear();

                                for (int i = 1; i <= DateTime.now().day; i++) {
                                  FilterDatesV2.selectedDates['hari'].add(
                                    i,
                                  );
                                }

                                FilterDatesV2.selectedDates['bulan'] =
                                    DateTime.now().month;
                                FilterDatesV2.selectedDates['tahun'] =
                                    DateTime.now().year;
                                _datePickerController.selectedDates = null;
                              });
                            },
                            child: Text("Clear Filter Tanggal"),
                          ),
                        ],
                      ),
                      SfDateRangePicker(
                        showNavigationArrow: true,

                        view: DateRangePickerView
                            .month, // Atur tampilan ke "bulan"
                        onSelectionChanged:
                            (DateRangePickerSelectionChangedArgs args) {
                          // setState(() {
                          //   if (args.value is PickerDateRange) {
                          //     _range =
                          //         '${DateFormat('dd/MM/yyyy').format(args.value.startDate)} -'
                          //         // ignore: lines_longer_than_80_chars
                          //         ' ${DateFormat('dd/MM/yyyy').format(args.value.endDate ?? args.value.startDate)}';
                          //   } else if (args.value is DateTime) {
                          //     _selectedDate = args.value.toString();
                          //   } else if (args.value is List<DateTime>) {
                          //     _dateCount = args.value.length.toString();
                          //     FilterDatesV2.selectedDates['hari'].clear();

                          //     for (DateTime date in args.value) {
                          //       FilterDatesV2.selectedDates['hari']
                          //           .add(date.day);
                          //     }
                          //   } else {
                          //     _rangeCount = args.value.length.toString();
                          //   }
                          // });
                        },

                        controller: _datePickerController,
                        selectionMode: FilterDatesV2.currentSelectionMode,
                        onSubmit: (val) {
                          setState(() {
                            if (val == null) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                  'Pilih tanggal yang ingin dipilih',
                                ),
                                duration: Duration(milliseconds: 500),
                              ));
                            }

                            if (val != null &&
                                val is Iterable &&
                                val is List<DateTime>) {
                              FilterDatesV2.selectedDates['hari'].clear();
                              for (DateTime item in val) {
                                FilterDatesV2.selectedDates['hari']
                                    .add(item.day);
                                FilterDatesV2.selectedDates['bulan'] =
                                    item.month;
                                FilterDatesV2.selectedDates['tahun'] =
                                    item.year;
                              }

                              FilterDatesV2.selectedDates['hari'].sort();
                            } else if (val != null && val is PickerDateRange) {
                              FilterDatesV2.rangeDate.add(val);
                            }
                          });
                        },
                        onViewChanged: (DateRangePickerViewChangedArgs args) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            // This code will be executed after the widget tree is fully built and ready.
                            setState(() {
                              DateTime? newStartDate =
                                  args.visibleDateRange.startDate;
                              DateTime? newEndDate =
                                  args.visibleDateRange.endDate;

                              // Calculate the next and previous months
                              DateTime nextMonth = newStartDate!.add(Duration(
                                  days:
                                      30)); // Assuming 30 days as the next month's duration
                              DateTime previousMonth = newStartDate.subtract(
                                  Duration(
                                      days:
                                          30)); // Assuming 30 days as the previous month's duration

                              if (args.view == DateRangePickerView.month &&
                                  (newStartDate.month != nextMonth.month ||
                                      newStartDate.month !=
                                          previousMonth.month ||
                                      newEndDate?.month != nextMonth.month ||
                                      newEndDate?.month !=
                                          previousMonth.month)) {
                                _datePickerController.selectedDates = null;
                              }
                              // Add your additional binding here
                            });
                          });
                        },

                        showActionButtons: true,
                        onCancel: () {
                          setState(() {
                            FilterDatesV2.selectedDates['hari'].clear();

                            for (int i = 1; i <= DateTime.now().day; i++) {
                              FilterDatesV2.selectedDates['hari'].add(
                                i,
                              );
                            }

                            FilterDatesV2.selectedDates['bulan'] =
                                DateTime.now().month;
                            FilterDatesV2.selectedDates['tahun'] =
                                DateTime.now().year;
                            _datePickerController.selectedDates = null;
                          });

                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text(
                              'Selection Cancelled',
                            ),
                            duration: Duration(milliseconds: 500),
                          ));
                        },

                        initialSelectedRange: PickerDateRange(
                          DateTime.now().subtract(const Duration(days: 4)),
                          DateTime.now().add(const Duration(days: 3)),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: <Widget>[],
          );
        },
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
              elevation: MaterialStateProperty.all<double>(0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: BorderSide(color: Colors.grey, width: 1.0),
                ),
              ),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 20)),
            ),
            onPressed: () {
              _showDialog(context);
            },
            child: Row(
              children: [
                Text('Tanggal'),
                Icon(Icons.arrow_drop_down),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
