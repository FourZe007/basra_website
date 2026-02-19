import 'package:flutter/material.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';

class DatepickerCustom extends StatefulWidget {
  const DatepickerCustom(this.tgl, this.handle, {this.readOnly = false, super.key});
  final String tgl;
  final Function handle;
  final bool readOnly;

  @override
  State<DatepickerCustom> createState() => _DatepickerCustomState();
}

class _DatepickerCustomState extends State<DatepickerCustom> {
  String tgl = '';

  @override
  void initState() {
    tgl = widget.tgl;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.parse(tgl == '' ? DateTime.now().toString() : tgl),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orange,
              onPrimary: Colors.white,
              onSurface: Colors.indigo.shade300,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.indigo,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() => tgl = picked.toString().substring(0, 10));
      widget.handle(tgl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: widget.readOnly ? true : false,
      child: InkWell(
        onTap: () => widget.readOnly ? null : _selectDate(context),
        child: Container(
          height: 34,
          padding: const EdgeInsets.only(left: 6, top: 2, bottom: 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: widget.readOnly ? Colors.white60 : Colors.transparent,
            border: Border.all(width: 1.3, color: Colors.black54),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 2),
                child: Icon(Icons.date_range_rounded, size: 19),
              ),
              const SizedBox(width: 7),
              Text(
                Format.tanggalFormat(tgl),
                style: const TextStyle(fontSize: 13, letterSpacing: 0.3),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
