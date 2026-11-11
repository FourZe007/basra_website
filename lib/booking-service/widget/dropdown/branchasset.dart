// ignore_for_file: file_names, must_be_immutable

import 'package:flutter/material.dart';
import 'package:stsj/booking-service/global/model.dart';
import 'package:stsj/global/theme/app_theme.dart';

class BranchAsset extends StatefulWidget {
  BranchAsset(
    this.setData,
    this.inputan,
    this.branchList, {
    this.mode = 1,
    super.key,
  });

  final Function setData;
  String inputan = '';
  final int mode;
  List<BranchDetail> branchList;

  @override
  State<BranchAsset> createState() => BranchAssetState();
}

class BranchAssetState extends State<BranchAsset> {
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
          items: [
            for (int i = 0; i < widget.branchList.length; i++)
              DropdownMenuItem<String>(
                value: widget.branchList[i].name,
                child: Text(
                  widget.branchList[i].name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
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
          value: (widget.inputan != '' &&
                  widget.branchList.any((e) => e.name == widget.inputan))
              ? widget.inputan
              : widget.branchList[0].name,
          isDense: true,
        ),
      ),
    );
  }
}
