import 'package:flutter/material.dart';
import 'package:stsj/aktivitas-subdealer/pages/p_subdealer_data_leasing.dart';
import 'package:stsj/aktivitas-subdealer/pages/p_subdealer_data_payment.dart';
import 'package:stsj/aktivitas-subdealer/pages/p_subdealer_data_salesman.dart';
import 'package:stsj/aktivitas-subdealer/pages/p_subdealer_data_stu.dart';
import 'package:stsj/aktivitas-subdealer/pages/p_subdealer_history.dart';
import 'package:stsj/global/font.dart';

class PSubDealerDailyReport extends StatelessWidget {
  const PSubDealerDailyReport(this.index, {super.key});
  final int index;

  @override
  Widget build(BuildContext context) {
    var list = showActivityReport[index].dailyReport;
    return Expanded(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: Colors.white),
        margin: EdgeInsets.all(8),
        child: Column(children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                color: Colors.black),
            padding: EdgeInsets.all(8),
            child: Row(children: [
              Expanded(
                child: Text('DAILY REPORT',
                    style: GlobalFont.bigfontCWhiteBold,
                    textAlign: TextAlign.start),
              ),
              Expanded(
                child: Text('PIC : ${list[0].pic}',
                    style: GlobalFont.bigfontCWhiteBold,
                    textAlign: TextAlign.end),
              )
            ]),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: SingleChildScrollView(
                child: Column(children: [
                  SizedBox(height: 5),
                  Row(children: [
                    Expanded(
                      child: Text('DATA STU',
                          style: GlobalFont.bigfontCBold,
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      child: Text('DATA PAYMENT',
                          style: GlobalFont.bigfontCBold,
                          textAlign: TextAlign.center),
                    ),
                  ]),
                  IntrinsicHeight(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: PSubDealerDataSTU(index)),
                          Expanded(child: PSubDealerDataPayment(index)),
                        ]),
                  ),
                  SizedBox(height: 5),
                  Row(children: [
                    Expanded(
                      child: Text('DATA LEASING',
                          style: GlobalFont.bigfontCBold,
                          textAlign: TextAlign.center),
                    ),
                    Expanded(
                      child: Text('DATA SALESMAN',
                          style: GlobalFont.bigfontCBold,
                          textAlign: TextAlign.center),
                    ),
                  ]),
                  IntrinsicHeight(
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: PSubDealerDataLeasing(index)),
                          Expanded(child: PSubDealerDataSalesman(index)),
                        ]),
                  ),
                  SizedBox(height: 10)
                ]),
              ),
            ),
          ),
          SizedBox(height: 10)
        ]),
      ),
    );
  }
}
