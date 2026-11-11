import 'package:flutter/material.dart';
import 'package:stsj/booking-service/global/api.dart';
import 'package:stsj/booking-service/global/global.dart';
import 'package:stsj/booking-service/global/model.dart';
import 'package:stsj/booking-service/popupdialog/kotak_pesan.dart';
import 'package:stsj/booking-service/widget/button/tombol.dart';
import 'package:stsj/booking-service/widget/textfield/customuserinput.dart';
import 'package:stsj/global/theme/app_theme.dart';

class CreateUserAccount extends StatefulWidget {
  const CreateUserAccount({super.key});

  @override
  State<CreateUserAccount> createState() => _CreateUserAccountState();
}

class _CreateUserAccountState extends State<CreateUserAccount> {
  String name = '';
  String password = '';
  String number = '';
  String email = '';
  int _formResetVersion = 0;
  List<ModelResultMessage> list = [];

  void setName(String value) {
    name = value;
  }

  void setPassword(String value) {
    password = value;
  }

  void setNumber(String value) {
    number = value;
  }

  void setEmail(String value) {
    email = value;
  }

  void clearAll() {
    name = '';
    password = '';
    number = '';
    email = '';
    _formResetVersion++;
  }

  void createAccount() async {
    if (name != '' && password != '' && number != '') {
      list = await GlobalAPI.modifyAccount(
        '1',
        '',
        name,
        password,
        number,
        email,
        '',
      );

      if (!mounted) return;
      if (list[0].resultMessage != 'NO TELEPON SUDAH TERDAFTAR') {
        setState(() => clearAll());

        GlobalFunction.tampilkanDialog(
          context,
          const KotakPesan(
            'SUCCESS!',
            'Akun member berhasil dibuat.',
          ),
        );
      } else {
        GlobalFunction.tampilkanDialog(
          context,
          const KotakPesan(
            'FAILED!',
            'Nomor telepon sudah terdaftar.',
          ),
        );
      }
    } else {
      GlobalFunction.tampilkanDialog(
        context,
        const KotakPesan(
          'WARNING!',
          'Mohon lengkapi seluruh kolom bertanda bintang (*).',
        ),
      );
    }
  }

  @override
  void dispose() {
    name = '';
    password = '';
    number = '';
    email = '';
    list = [];
    super.dispose();
  }

  Widget _buildLabel(String label, {bool requiredField = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          if (requiredField)
            const Text(
              ' *',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryRed,
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBackground,
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryMaroon,
                        borderRadius: BorderRadius.circular(AppRadii.md),
                      ),
                      child: const Icon(
                        Icons.person_add_alt_1_rounded,
                        color: AppColors.primaryRed,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Registrasi Member Baru',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: AppColors.border, height: 32),

                _buildLabel('Nama Lengkap', requiredField: true),
                CustomUserInput(
                  setName,
                  name,
                  key: ValueKey('create_name_$_formResetVersion'),
                  mode: 0,
                  hint: 'nama lengkap',
                  isIcon: true,
                  icon: Icons.person_outline_rounded,
                  isCapital: true,
                  isWidth: true,
                  width: double.infinity,
                ),
                const SizedBox(height: 16),

                _buildLabel('Password', requiredField: true),
                CustomUserInput(
                  setPassword,
                  password,
                  key: ValueKey('create_pass_$_formResetVersion'),
                  mode: 0,
                  isPass: true,
                  hint: 'password akun',
                  icon: Icons.lock_outline_rounded,
                  isWidth: true,
                  width: double.infinity,
                ),
                const SizedBox(height: 16),

                _buildLabel('Nomor Telepon', requiredField: true),
                CustomUserInput(
                  setNumber,
                  number,
                  key: ValueKey('create_phone_$_formResetVersion'),
                  mode: 0,
                  hint: 'nomor telepon (contoh: 8123456789)',
                  isIcon: true,
                  icon: Icons.phone_outlined,
                  isWidth: true,
                  width: double.infinity,
                ),
                const SizedBox(height: 16),

                _buildLabel('Alamat Email (Opsional)'),
                CustomUserInput(
                  setEmail,
                  email,
                  key: ValueKey('create_email_$_formResetVersion'),
                  mode: 0,
                  hint: 'alamat email',
                  isIcon: true,
                  icon: Icons.mail_outline_rounded,
                  isWidth: true,
                  width: double.infinity,
                ),
                const SizedBox(height: 24),

                Tombol(
                  'SIMPAN MEMBER BARU',
                  createAccount,
                  tinggi: 44,
                  disable: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
