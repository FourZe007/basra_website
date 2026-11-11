import 'package:flutter/material.dart';
import 'package:stsj/booking-service/widget/format.dart';
import 'package:stsj/global/theme/app_theme.dart';

class CustomDatetimePicker extends StatefulWidget {
  const CustomDatetimePicker(this.tgl, this.handle, this.isDisable, {Key? key})
      : super(key: key);
  final String tgl;
  final Function handle;
  final bool isDisable;

  @override
  State<CustomDatetimePicker> createState() => _DatePicker1State();
}

class _DatePicker1State extends State<CustomDatetimePicker> {
  String tgl = '';

  @override
  void initState() {
    tgl = widget.tgl == ''
        ? DateTime.now().toString().substring(0, 10)
        : widget.tgl;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomDatetimePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.tgl != oldWidget.tgl && widget.tgl.isNotEmpty) {
      tgl = widget.tgl;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: tgl == '' ? DateTime.now() : DateTime.parse(tgl),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryRed,
              onPrimary: Colors.white,
              surface: AppColors.mutedSurface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != DateTime.parse(tgl)) {
      setState(() {
        tgl = picked.toString().substring(0, 10);
      });
      widget.handle(tgl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadii.md),
      onTap: () => _selectDate(context),
      child: Container(
        height: 44.0,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.darkGrey,
          borderRadius: BorderRadius.circular(AppRadii.md),
          border: Border.all(
            color: AppColors.border,
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              size: 16,
              color: AppColors.primaryRed,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                Format.tanggalFormat(tgl),
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
