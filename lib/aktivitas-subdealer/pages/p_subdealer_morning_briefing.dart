import 'package:flutter/material.dart';
import 'package:stsj/aktivitas-subdealer/pages/p_subdealer_history.dart';
import 'package:stsj/global/font.dart';

class PSubDealerMorningBriefing extends StatelessWidget {
  const PSubDealerMorningBriefing(this.index, {super.key});
  final int index;

  Card kartuPeserta(String header, detail) {
    return Card(
      color: Colors.blueGrey[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            color: Colors.blue[900],
          ),
          child: Text(header,
              style: GlobalFont.mediumbigfontMWhite,
              textAlign: TextAlign.center),
        ),
        Text(detail, style: GlobalFont.petafontRBold)
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    var list = showActivityReport[index].morningBriefing;
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
                child: Text('MORNING BRIEFING',
                    style: GlobalFont.bigfontCWhiteBold),
              ),
              Expanded(
                child: Text(
                    'LOKASI : ${list[0].lokasi.isEmpty ? ' - ' : list[0].lokasi}',
                    style: GlobalFont.bigfontCWhiteBold,
                    textAlign: TextAlign.end),
              )
            ]),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 2),
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                  child: Text(list[0].topic.isEmpty ? ' - ' : list[0].topic,
                      style: GlobalFont.bigfontMBold),
                ),
              ]),
              Container(
                padding: EdgeInsets.all(5),
                child: Row(children: [
                  Expanded(
                      flex: 2,
                      child:
                          kartuPeserta('PESERTA', list[0].peserta.toString())),
                  Expanded(
                      flex: 2,
                      child:
                          kartuPeserta('SHOP MANAGER', list[0].sm.toString())),
                  Expanded(
                      flex: 2,
                      child:
                          kartuPeserta('SALES COUNTER', list[0].sc.toString())),
                  Expanded(
                      flex: 2,
                      child: kartuPeserta(
                          'SALESMAN', list[0].salesman.toString())),
                  Expanded(
                      flex: 2,
                      child: kartuPeserta('OTHER', list[0].other.toString())),
                ]),
              )
            ]),
          )
        ]),
      ),
    );
  }
}
