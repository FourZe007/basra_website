import 'package:flutter/material.dart';
import 'package:stsj/booking-service/global/api.dart';
import 'package:stsj/booking-service/global/global.dart';
import 'package:stsj/booking-service/global/model.dart';
import 'package:stsj/booking-service/popupdialog/kotak_pesan.dart';
import 'package:stsj/booking-service/widget/button/tombol.dart';
import 'package:stsj/booking-service/widget/textfield/customuserinput.dart';
import 'package:stsj/global/theme/app_theme.dart';

class DeleteAcc extends StatefulWidget {
  const DeleteAcc({super.key});

  @override
  State<DeleteAcc> createState() => _DeleteAccState();
}

class _DeleteAccState extends State<DeleteAcc> {
  String? userInput = '';
  List<ModelResultMessage> remove = [];
  List<ModelUserLogin> user = [];

  void setUserInput(String value) {
    userInput = value;
  }

  void delete() async {
    if (userInput!.isNotEmpty) {
      if (userInput!.split('8')[0] == '' || userInput!.split('8')[0] == '0') {
        if (userInput!.split('8')[0] == '0') {
          String temp = userInput!.substring(1);
          userInput = temp;
          temp = '';
        }
        user = await GlobalAPI.getUserLogin(
          userInput!,
          '',
        );

        if (user[0].flag == 0) {
          remove = await GlobalAPI.modifyAccount(
            '4',
            user[0].memberID,
            '',
            '',
            '',
            '',
            '',
          );
        } else {
          // ignore: use_build_context_synchronously
          GlobalFunction.tampilkanDialog(
            context,
            KotakPesan(
              'WARNING',
              user[0].memo,
            ),
          );
        }
      } else {
        remove = await GlobalAPI.modifyAccount(
          '4',
          userInput!,
          '',
          '',
          '',
          '',
          '',
        );
      }
    } else {
      GlobalFunction.tampilkanDialog(
        context,
        const KotakPesan(
          'WARNING',
          'Mohon masukkan Nomor Telepon atau Member ID terlebih dahulu.',
        ),
      );
    }

    user = [];
    remove = [];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBackground,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.mutedSurface,
            borderRadius: BorderRadius.circular(AppRadii.lg),
            border: Border.all(color: AppColors.border, width: 1.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: AppColors.secondaryMaroon,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person_remove_outlined,
                    size: 28,
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Hapus Akun Member FixUP Moto',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Masukkan Nomor Telepon atau Member ID akun yang ingin dihapus secara permanen.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 22),
              CustomUserInput(
                setUserInput,
                userInput!,
                mode: 0,
                hint: 'nomor telepon atau member ID',
                isIcon: true,
                icon: Icons.badge_outlined,
                autoFocus: true,
                isWidth: true,
                width: double.infinity,
              ),
              const SizedBox(height: 18),
              Tombol(
                'HAPUS AKUN',
                delete,
                tinggi: 44,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
