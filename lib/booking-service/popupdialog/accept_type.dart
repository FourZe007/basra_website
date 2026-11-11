// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:stsj/booking-service/global/api.dart';
import 'package:stsj/booking-service/global/global.dart';
import 'package:stsj/booking-service/global/model.dart';
import 'package:stsj/booking-service/label/label_static.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class AcceptType extends StatefulWidget {
  AcceptType(this.isAccept, this.isReject, this.header, this.detail,
      {this.bookingCode = '',
      this.bookingName = '',
      this.phoneNumber = '',
      super.key});

  bool isAccept;
  bool isReject;
  final String header;
  final String detail;
  String bookingCode;
  String bookingName;
  String phoneNumber;

  @override
  State<AcceptType> createState() => _AcceptTypeState();
}

class _AcceptTypeState extends State<AcceptType> {
  ModelSendMessage mapSendMessage = ModelSendMessage(resultMessage: '');

  @override
  Widget build(BuildContext context) {
    void submit() {
      Navigator.pop(context);
    }

    void sendMessage() async {
      widget.isAccept = true;
      widget.isReject = false;

      print('Sent Message');
      print(widget.isAccept);
      print(widget.isReject);

      widget.phoneNumber = widget.phoneNumber.substring(1);
      String number = '62${widget.phoneNumber}';
      print('Phone Number: $number');

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

    void redirectToWhatsAppWeb() async {
      widget.isAccept = true;
      widget.isReject = false;

      widget.phoneNumber = widget.phoneNumber.substring(1);
      widget.phoneNumber = '62${widget.phoneNumber}';
      print('Phone Number: ${widget.phoneNumber}');

      String message =
          'Selamat!\nKode booking ${widget.bookingCode} atas nama ${widget.bookingName} sudah terverifikasi\nMohon hadir 1 jam sebelum jam service';

      if (await canLaunchUrl(Uri.parse(
          'https://web.whatsapp.com/send?phone=${widget.phoneNumber}&text=$message'))) {
        await launchUrl(Uri.parse(
            'https://web.whatsapp.com/send?phone=${widget.phoneNumber}&text=$message'));
      } else {
        throw 'Could not launch WhatsApp Web';
      }
    }

    return SizedBox(
      width: 300,
      height: 150,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [LabelStatic(widget.header, GlobalFont.tinymediumfontM)],
          ),
          const Divider(
              color: Colors.black, thickness: 2, indent: 10, endIndent: 10),
          Expanded(
            flex: 1,
            child: LabelStatic(widget.detail, GlobalFont.tinymediumfontM),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: sendMessage,
                  child: const Text('OTP'),
                ),
                const SizedBox(width: 15.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: submit,
                  child: const Text('Exit'),
                ),
                const SizedBox(width: 15.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  onPressed: () {
                    redirectToWhatsAppWeb();
                  },
                  child: const Text('Pesan'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
