// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:stsj/global/theme/app_theme.dart';

class StatusAsset extends StatefulWidget {
  StatusAsset(this.setData, this.inputan, {this.mode = 1, super.key});

  final Function setData;
  String inputan = 'Select your schedule';
  final int mode;

  @override
  State<StatusAsset> createState() => StatusAssetState();
}

class StatusAssetState extends State<StatusAsset> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: 44.0,
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(AppRadii.md),
        border: Border.all(color: AppColors.border, width: 1.0),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          dropdownColor: AppColors.mutedSurface,
          borderRadius: BorderRadius.circular(AppRadii.md),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: AppColors.primaryRed,
          ),
          items: const [
            DropdownMenuItem(
              value: '',
              child: Text(
                'SEMUA STATUS (ALL)',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            DropdownMenuItem(
              value: 'MENUNGGU KONFIRMASI',
              child: Text(
                'MENUNGGU KONFIRMASI',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            DropdownMenuItem(
              value: 'TERKONFIRMASI',
              child: Text(
                'TERKONFIRMASI',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            DropdownMenuItem(
              value: 'DITOLAK',
              child: Text(
                'DITOLAK',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          onChanged: (newvalues) {
            if (widget.inputan != newvalues) {
              widget.setData(newvalues);
              setState(() {
                widget.inputan = newvalues!;
              });
            }
          },
          value: widget.inputan,
          isDense: true,
        ),
      ),
    );
  }
}
