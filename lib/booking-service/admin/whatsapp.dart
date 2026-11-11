import 'package:flutter/material.dart';
import 'package:stsj/booking-service/global/api.dart';
import 'package:stsj/booking-service/global/global.dart';
import 'package:stsj/booking-service/global/model.dart';
import 'package:stsj/booking-service/popupdialog/kotak_pesan.dart';
import 'package:stsj/booking-service/progressindicator/circle_loading.dart';
import 'package:stsj/booking-service/widget/button/tombol.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class WhatsappPage extends StatefulWidget {
  const WhatsappPage({super.key});

  @override
  State<WhatsappPage> createState() => _WhatsappPageState();
}

class _WhatsappPageState extends State<WhatsappPage> {
  bool isLoading = false;

  ModelWhatsappStatus whatsappStatus = ModelWhatsappStatus(
    id: '',
    createdAt: '',
    status: '',
    phoneNumber: '',
    connectedAt: '',
    disconnectedAt: '',
    disconnectedReason: '',
  );

  ModelWhatsappQR whatsappQR = ModelWhatsappQR(
    qrCode: '',
    imageUrl: '',
  );

  Future<ModelWhatsappStatus> fetchGetWhatsapp() async {
    whatsappStatus = await GlobalAPI.getWhatsappStatus('poco-phone');
    return whatsappStatus;
  }

  void generateCode() async {
    whatsappQR = await GlobalAPI.getWhatsappQR('poco-phone');

    if (await url_launcher.canLaunchUrl(Uri.parse(whatsappQR.imageUrl))) {
      await url_launcher.launchUrl(Uri.parse(whatsappQR.imageUrl));
    } else {
      throw 'Could not launch ${Uri.parse(whatsappQR.imageUrl)}';
    }
  }

  @override
  void initState() {
    whatsappQR = ModelWhatsappQR(
      qrCode: '',
      imageUrl: '',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ModelWhatsappStatus>(
      future: fetchGetWhatsapp(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircleLoading());
        } else if (snapshot.hasData) {
          final bool isConnected = snapshot.data!.status == 'connected';

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
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: isConnected
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFFFE4E6),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isConnected
                            ? Icons.check_circle_outline_rounded
                            : Icons.link_off_rounded,
                        size: 32,
                        color: isConnected
                            ? AppColors.accentGreen
                            : AppColors.accentCoral,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Status Integrasi WhatsApp Gateway',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isConnected
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFFFE4E6),
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                      ),
                      child: Text(
                        isConnected ? 'CONNECTED (TERHUBUNG)' : 'DISCONNECTED',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: isConnected
                              ? AppColors.accentGreen
                              : AppColors.accentCoral,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: Tombol(
                        'GENERATE QR CODE',
                        () {
                          if (isConnected) {
                            GlobalFunction.tampilkanDialog(
                              context,
                              const KotakPesan(
                                'INFORMASI',
                                'Status WhatsApp sedang terhubung. QR Code baru hanya dapat dibuat saat status Disconnected.',
                              ),
                            );
                          } else {
                            generateCode();
                          }
                        },
                        disable: isConnected,
                        tinggi: 44,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(
          child: Text(
            'Data status WhatsApp tidak ditemukan.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        );
      },
    );
  }
}
