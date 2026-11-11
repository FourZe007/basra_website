import 'package:flutter/material.dart';
import 'package:stsj/booking-service/global/api.dart';
import 'package:stsj/booking-service/global/global.dart';
import 'package:stsj/booking-service/global/model.dart';
import 'package:stsj/booking-service/label/label_static.dart';
import 'package:stsj/booking-service/popupdialog/accept_type.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class CustomExpansion extends StatefulWidget {
  CustomExpansion(this.name, this.phoneNumber, this.date, this.time,
      this.unitType, this.complaint,
      {super.key});

  String name = '';
  String phoneNumber = '';
  String date = '';
  String time = '';
  String unitType = '';
  String complaint = '';

  @override
  State<CustomExpansion> createState() => _CustomExpansionState();
}

class _CustomExpansionState extends State<CustomExpansion> {
  bool isExpanded = false;

  ModelSendMessage mapSendMessage = ModelSendMessage(resultMessage: '');

  String message =
      'Selamat!\nKode booking {123456789} atas nama {Joseph} sudah terverifikasi\nMohon hadir 1 jam sebelum jam service';

  void sendMessage() async {
    print('Sent Message');

    mapSendMessage = await GlobalAPI.fetchSendMessage(
      '6281338518880',
      'Test123',
      'realme-pad-mini',
      'text',
    );

    print('Send OTP result: ${mapSendMessage.resultMessage}');

    if (mapSendMessage.resultMessage == 'pending') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP Code sent successfully"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP Code failed to send"),
        ),
      );
    }
  }

  void redirectToWhatsAppWeb(String phoneNumber, String message) async {
    if (await canLaunchUrl(Uri.parse(
        'https://web.whatsapp.com/send?phone=$phoneNumber&text=$message'))) {
      await launchUrl(Uri.parse(
          'https://web.whatsapp.com/send?phone=$phoneNumber&text=$message'));
    } else {
      throw 'Could not launch WhatsApp Web';
    }
  }

  @override
  void initState() {
    super.initState();

    print('~:Get Data Result:~');
    print(widget.name);
    print(widget.phoneNumber);
    print(widget.date);
    print(widget.time);
    print(widget.unitType);
    print(widget.complaint);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            childrenPadding: const EdgeInsets.all(15.0),
            title: (isExpanded == false)
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 400,
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          '${widget.phoneNumber} - ${widget.name}',
                          style: GlobalFont.gigafontC,
                        ),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 3.5),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        onPressed: () {
                          GlobalFunction.tampilkanDialog(
                            context,
                            AcceptType(
                              GlobalVar.isAccept,
                              GlobalVar.isReject,
                              'Pilih Cara Verifikasi',
                              'OTP atau Pesan Whatsapp',
                            ),
                          );
                        },
                        child: const Text('Accept'),
                      ),
                      SizedBox(width: MediaQuery.of(context).size.width / 60),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {},
                        child: const Text('Reject'),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LabelStatic(
                        '${widget.phoneNumber} - ${widget.name}',
                        GlobalFont.gigafontC,
                      ),
                    ],
                  ),
            onExpansionChanged: (value) {
              setState(() {
                isExpanded = value;
              });
            },
            initiallyExpanded: isExpanded,
            backgroundColor: Colors.black12,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama Customer'),
                      SizedBox(height: 15.0),
                      Text('No Telepon'),
                      SizedBox(height: 15.0),
                      Text('Tanggal'),
                      SizedBox(height: 15.0),
                      Text('Pukul'),
                      SizedBox(height: 15.0),
                      Text('Tipe Motor'),
                      SizedBox(height: 15.0),
                      Text('Keluhan'),
                      SizedBox(height: 20.0),
                    ],
                  ),
                  const SizedBox(width: 180),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(':'),
                      SizedBox(height: 15.0),
                      Text(':'),
                      SizedBox(height: 15.0),
                      Text(':'),
                      SizedBox(height: 15.0),
                      Text(':'),
                      SizedBox(height: 15.0),
                      Text(':'),
                      SizedBox(height: 15.0),
                      Text(':'),
                      SizedBox(height: 20.0),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name),
                      const SizedBox(height: 15.0),
                      Text(widget.phoneNumber),
                      const SizedBox(height: 15.0),
                      Text(widget.date),
                      const SizedBox(height: 15.0),
                      Text(widget.time),
                      const SizedBox(height: 15.0),
                      Text(widget.unitType),
                      const SizedBox(height: 15.0),
                      Text(widget.complaint),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ],
              ),
              (isExpanded == true)
                  ? SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                            onPressed: () {
                              GlobalFunction.tampilkanDialog(
                                context,
                                AcceptType(
                                  GlobalVar.isAccept,
                                  GlobalVar.isReject,
                                  'Pilih Cara Verifikasi',
                                  'OTP atau Pesan Whatsapp',
                                ),
                              );
                            },
                            child: const Text('Accept'),
                          ),
                          const SizedBox(width: 15.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {},
                            child: const Text('Reject'),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        const SizedBox(height: 10.0),
      ],
    );
  }
}
