// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:stsj/global/theme/app_theme.dart';

class UserTimeAsset extends StatefulWidget {
  UserTimeAsset(this.setData, this.inputan, {this.mode = 1, super.key});

  final Function setData;
  String inputan = 'Select your schedule';
  final int mode;

  @override
  State<UserTimeAsset> createState() => UserTimeAssetState();
}

class UserTimeAssetState extends State<UserTimeAsset> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      height: 46.0,
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
            Icons.access_time_rounded,
            size: 18,
            color: AppColors.primaryRed,
          ),
          items: const [
            DropdownMenuItem(
              value: '09:00',
              child: Text(
                '09:00 - 10:00 WIB',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            DropdownMenuItem(
              value: '10:00',
              child: Text(
                '10:00 - 11:00 WIB',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            DropdownMenuItem(
              value: '14:00',
              child: Text(
                '14:00 - 15:00 WIB',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 13.5,
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
