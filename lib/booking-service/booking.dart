import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stsj/booking-service/global/api.dart';
import 'package:stsj/booking-service/global/global.dart';
import 'package:stsj/booking-service/global/model.dart';
import 'package:stsj/booking-service/popupdialog/kotak_pesan.dart';
import 'package:stsj/booking-service/popupdialog/kotak_pesan2.dart';
import 'package:stsj/booking-service/widget/button/tombol.dart';
import 'package:stsj/booking-service/widget/custom_date_picker.dart';
import 'package:stsj/booking-service/widget/dropdown/timeasset_user.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:stsj/global/widget/app_bar.dart';

// ignore: must_be_immutable
class Booking extends StatefulWidget {
  Booking(this.branchName, {super.key});

  String branchName = '';

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  String bookingID = '';
  String branch = '31';
  String shop = '01';
  String plate = '';
  String status = '';
  String userID = '';

  String nama = '';
  String noTelp = '';
  String tanggal = '';
  String waktu = '09:00';
  String tipeMotor = '';
  String keluhan = '';

  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _noTelpController = TextEditingController();
  final TextEditingController _tipeMotorController = TextEditingController();
  final TextEditingController _plateController = TextEditingController();
  final TextEditingController _keluhanController = TextEditingController();

  List<ModelResultMessage> listModelBooking = [];

  void bookService() async {
    if (widget.branchName == 'FixUP MOTO - KUTISARI') {
      shop = '01';
    } else if (widget.branchName == 'FixUP MOTO - DARMO') {
      shop = '02';
    } else {
      shop = '0';
    }

    if (plate == '') {
      plate = '-';
    }

    listModelBooking = await GlobalAPI.fetchInsertBookReq(
      '1',
      bookingID,
      tanggal,
      waktu,
      branch,
      shop,
      nama,
      noTelp,
      plate,
      tipeMotor,
      keluhan,
      status,
      userID,
    );

    cancelService();

    if (listModelBooking[0].resultMessage !=
        'JAM BOOKING YANG DIPILIH TELAH PENUH, SILAHKAN PILIH TANGGAL/JAM BERBEDA') {
      // ignore: use_build_context_synchronously
      GlobalFunction.tampilkanDialog(
        context,
        KotakPesan2(
          'BOOKING BERHASIL',
          'Kode Booking anda: ${listModelBooking[0].resultMessage}',
          'Mohon simpan kode booking anda untuk verifikasi di bengkel.',
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      GlobalFunction.tampilkanDialog(
        context,
        KotakPesan(
          'INFORMASI',
          listModelBooking[0].resultMessage,
        ),
      );
    }
  }

  void cancelService() {
    Navigator.pop(context);
  }

  void setName(String value) {
    nama = value;
  }

  void setNoTelp(String value) {
    noTelp = value;
  }

  void setTanggal(String value) {
    tanggal = value;
  }

  void setWaktu(String value) {
    waktu = value;
  }

  void setTipeMotor(String value) {
    tipeMotor = value;
  }

  void setPlatNo(String value) {
    plate = value;
  }

  void setKeluhan(String value) {
    keluhan = value;
  }

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();
    final nextTwoDays = today.add(const Duration(days: 1));
    tanggal = nextTwoDays.toString().split(' ')[0];
  }

  @override
  void dispose() {
    _namaController.dispose();
    _noTelpController.dispose();
    _tipeMotorController.dispose();
    _plateController.dispose();
    _keluhanController.dispose();
    super.dispose();
  }

  Widget _buildLabel(String text, {bool isRequired = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          if (isRequired)
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
    final bool isSmallScreen = MediaQuery.of(context).size.width <= 540;

    return Scaffold(
      backgroundColor: AppColors.primaryBackground,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CustomAppBar(
          isRoutes: false,
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 14 : 20,
            vertical: isSmallScreen ? 16 : 28,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.mutedSurface,
                borderRadius: BorderRadius.circular(AppRadii.lg),
                border: Border.all(color: AppColors.border, width: 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ── Card Header (Enterprise Red) ───────────────────────────
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallScreen ? 18 : 24,
                      vertical: 18,
                    ),
                    color: AppColors.primaryRed,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(AppRadii.md),
                          ),
                          child: const Icon(
                            Icons.build_circle_outlined,
                            color: Colors.white,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Formulir Booking Service',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                widget.branchName,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Form Fields ────────────────────────────────────────────
                  Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 18 : 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildLabel('Nama Pelanggan'),
                        TextField(
                          controller: _namaController,
                          inputFormatters: [UpperCaseText()],
                          decoration: const InputDecoration(
                            hintText: 'Masukkan nama lengkap',
                            prefixIcon: Icon(
                              Icons.person_outline_rounded,
                              size: 18,
                              color: AppColors.primaryRed,
                            ),
                          ),
                          onChanged: setName,
                        ),
                        const SizedBox(height: 18),

                        _buildLabel('Nomor Telepon / WhatsApp'),
                        TextField(
                          controller: _noTelpController,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [UpperCaseText()],
                          decoration: const InputDecoration(
                            hintText: 'Contoh: 81234567890 (tanpa angka 0 di depan)',
                            prefixIcon: Icon(
                              Icons.phone_outlined,
                              size: 18,
                              color: AppColors.primaryRed,
                            ),
                          ),
                          onChanged: setNoTelp,
                        ),
                        const SizedBox(height: 18),

                        if (isSmallScreen) ...[
                          _buildLabel('Tanggal Kedatangan'),
                          CustomDatetimePicker(tanggal, setTanggal, true),
                          const SizedBox(height: 18),
                          _buildLabel('Jam Kedatangan (Pukul)'),
                          UserTimeAsset(setWaktu, waktu),
                        ] else
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Tanggal Kedatangan'),
                                    CustomDatetimePicker(
                                      tanggal,
                                      setTanggal,
                                      true,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Jam Kedatangan (Pukul)'),
                                    UserTimeAsset(setWaktu, waktu),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 18),

                        if (isSmallScreen) ...[
                          _buildLabel('Tipe Motor'),
                          TextField(
                            controller: _tipeMotorController,
                            inputFormatters: [UpperCaseText()],
                            decoration: const InputDecoration(
                              hintText: 'Contoh: YAMAHA NMAX',
                              prefixIcon: Icon(
                                Icons.two_wheeler_rounded,
                                size: 18,
                                color: AppColors.primaryRed,
                              ),
                            ),
                            onChanged: setTipeMotor,
                          ),
                          const SizedBox(height: 18),
                          _buildLabel('Nomor Plat Kendaraan',
                              isRequired: false),
                          TextField(
                            controller: _plateController,
                            inputFormatters: [UpperCaseText()],
                            decoration: const InputDecoration(
                              hintText: 'Contoh: L 1234 SBY (Opsional)',
                              prefixIcon: Icon(
                                Icons.pin_outlined,
                                size: 18,
                                color: AppColors.primaryRed,
                              ),
                            ),
                            onChanged: setPlatNo,
                          ),
                        ] else
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Tipe Motor'),
                                    TextField(
                                      controller: _tipeMotorController,
                                      inputFormatters: [UpperCaseText()],
                                      decoration: const InputDecoration(
                                        hintText: 'Contoh: YAMAHA NMAX',
                                        prefixIcon: Icon(
                                          Icons.two_wheeler_rounded,
                                          size: 18,
                                          color: AppColors.primaryRed,
                                        ),
                                      ),
                                      onChanged: setTipeMotor,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildLabel('Nomor Plat (Opsional)',
                                        isRequired: false),
                                    TextField(
                                      controller: _plateController,
                                      inputFormatters: [UpperCaseText()],
                                      decoration: const InputDecoration(
                                        hintText: 'Contoh: L 1234 SBY',
                                        prefixIcon: Icon(
                                          Icons.pin_outlined,
                                          size: 18,
                                          color: AppColors.primaryRed,
                                        ),
                                      ),
                                      onChanged: setPlatNo,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        const SizedBox(height: 18),

                        _buildLabel('Keluhan / Catatan Service'),
                        TextField(
                          controller: _keluhanController,
                          maxLines: 3,
                          inputFormatters: [UpperCaseText()],
                          decoration: const InputDecoration(
                            hintText:
                                'Tuliskan keluhan kendaraan atau jenis servis berkala...',
                            alignLabelWithHint: true,
                          ),
                          onChanged: setKeluhan,
                        ),
                        const SizedBox(height: 26),

                        // ── Form Actions ─────────────────────────────────────
                        if (isSmallScreen)
                          Row(
                            children: [
                              Expanded(
                                child: Tombol(
                                  'Cancel',
                                  cancelService,
                                  isOutlined: true,
                                  tinggi: 42,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Tombol(
                                  'Book',
                                  bookService,
                                  tinggi: 42,
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Tombol(
                                'Cancel',
                                cancelService,
                                isOutlined: true,
                                lebar: 120,
                                tinggi: 42,
                              ),
                              const SizedBox(width: 12),
                              Tombol(
                                'Book',
                                bookService,
                                lebar: 150,
                                tinggi: 42,
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UpperCaseText extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
