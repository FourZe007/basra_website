import 'package:flutter/material.dart';
import 'package:stsj/booking-service/booking.dart';
import 'package:stsj/booking-service/global/global.dart';
import 'package:stsj/booking-service/popupdialog/kotak_pesan.dart';
import 'package:stsj/global/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: must_be_immutable
class Kartu extends StatefulWidget {
  Kartu(
    this.branchName,
    this.branchAddress,
    this.branchOpt,
    this.branchPhone1,
    this.branchPhone2, {
    this.isUserAllowed = false,
    this.isOpen = false,
    super.key,
  });

  String branchName = '';
  String branchAddress = '';
  String branchOpt = '';
  String branchPhone1 = '';
  String branchPhone2 = '';
  bool isUserAllowed;
  bool isOpen;

  @override
  State<Kartu> createState() => _KartuState();
}

class _KartuState extends State<Kartu> {
  bool isWhatsappActive = false;
  bool isBookActive = false;
  bool isCardHovered = false;

  void redirectToWhatsAppWeb() async {
    String formattedPhone =
        widget.branchPhone1.replaceAll(RegExp(r'[^0-9]'), '');
    if (formattedPhone.startsWith('0')) {
      formattedPhone = '62${formattedPhone.substring(1)}';
    } else if (!formattedPhone.startsWith('62')) {
      formattedPhone = '62$formattedPhone';
    }

    final Uri waUri = Uri.parse('https://wa.me/$formattedPhone');
    if (await canLaunchUrl(waUri)) {
      await launchUrl(waUri);
    } else {
      throw 'Could not launch WhatsApp Web';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool hasPhone =
        widget.branchPhone1.isNotEmpty && widget.branchPhone1 != 'Coming Soon';
    final double cardWidth =
        (MediaQuery.of(context).size.width - 72).clamp(250.0, 340.0);

    return MouseRegion(
      onEnter: (_) => setState(() => isCardHovered = true),
      onExit: (_) => setState(() => isCardHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: cardWidth,
        margin: const EdgeInsets.only(right: 18, bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.mutedSurface,
          borderRadius: BorderRadius.circular(AppRadii.lg),
          border: Border.all(
            color: isCardHovered
                ? AppColors.primaryRed.withValues(alpha: 0.45)
                : AppColors.border,
            width: isCardHovered ? 1.5 : 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withValues(alpha: isCardHovered ? 0.07 : 0.03),
              blurRadius: isCardHovered ? 16 : 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Workshop Image Header + Status Badge ─────────────────────────
            Stack(
              children: [
                Container(
                  height: 155,
                  width: double.infinity,
                  color: AppColors.deepBackground,
                  child: const Image(
                    image: AssetImage('assets/images/cropped.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: widget.isOpen
                          ? const Color(0xFFDCFCE7)
                          : AppColors.mutedSurface.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(AppRadii.pill),
                      border: Border.all(
                        color: widget.isOpen
                            ? AppColors.accentGreen.withValues(alpha: 0.35)
                            : AppColors.border,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: widget.isOpen
                                ? AppColors.accentGreen
                                : AppColors.textMuted,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.isOpen ? 'BEROPERASI' : 'COMING SOON',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: widget.isOpen
                                ? AppColors.accentGreen
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Workshop Details ─────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.branchName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(
                            Icons.location_on_outlined,
                            size: 15,
                            color: AppColors.primaryRed,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.branchAddress,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textSecondary,
                              height: 1.35,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 15,
                          color: AppColors.primaryRed,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            widget.branchOpt.isNotEmpty
                                ? widget.branchOpt
                                : 'Jam operasional mengikuti cabang',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const Divider(color: AppColors.border, height: 20),

                    // ── Action Buttons (WhatsApp + Book Now) ─────────────────
                    Row(
                      children: [
                        Expanded(
                          child: Tooltip(
                            message: hasPhone
                                ? 'Chat via WhatsApp (${widget.branchPhone1})'
                                : 'Nomor WhatsApp belum tersedia',
                            waitDuration: const Duration(milliseconds: 300),
                            child: MouseRegion(
                              cursor: hasPhone
                                  ? SystemMouseCursors.click
                                  : SystemMouseCursors.basic,
                              onEnter: (_) =>
                                  setState(() => isWhatsappActive = true),
                              onExit: (_) =>
                                  setState(() => isWhatsappActive = false),
                              child: GestureDetector(
                                onTap: hasPhone ? redirectToWhatsAppWeb : null,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  height: 40,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: hasPhone
                                        ? (isWhatsappActive
                                            ? const Color(0xFFDCFCE7)
                                            : AppColors.darkGrey)
                                        : AppColors.deepBackground,
                                    borderRadius:
                                        BorderRadius.circular(AppRadii.md),
                                    border: Border.all(
                                      color: hasPhone
                                          ? (isWhatsappActive
                                              ? AppColors.accentGreen
                                              : AppColors.border)
                                          : AppColors.border,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Image(
                                        width: 16,
                                        height: 16,
                                        image: AssetImage(
                                          'assets/images/whatsapp-icons.png',
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Flexible(
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          alignment: Alignment.center,
                                          child: Text(
                                            hasPhone
                                                ? widget.branchPhone1
                                                : 'Segera',
                                            maxLines: 1,
                                            softWrap: false,
                                            style: TextStyle(
                                              fontSize: hasPhone &&
                                                      widget.branchPhone1
                                                              .length >
                                                          13
                                                  ? 11.0
                                                  : 12.0,
                                              fontWeight: FontWeight.w600,
                                              color: hasPhone
                                                  ? AppColors.textPrimary
                                                  : AppColors.textMuted,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          onEnter: (_) => setState(() => isBookActive = true),
                          onExit: (_) => setState(() => isBookActive = false),
                          child: GestureDetector(
                            onTap: () {
                              if (widget.isOpen) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        Booking(widget.branchName),
                                  ),
                                );
                              } else {
                                GlobalFunction.tampilkanDialog(
                                  context,
                                  const KotakPesan(
                                    'INFORMASI',
                                    'Mohon maaf, cabang bengkel ini belum beroperasi.',
                                  ),
                                );
                              }
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              constraints: const BoxConstraints(minWidth: 76),
                              decoration: BoxDecoration(
                                color: widget.isOpen
                                    ? (isBookActive
                                        ? AppColors.accentYellowHover
                                        : AppColors.primaryRed)
                                    : AppColors.darkerBackground,
                                borderRadius:
                                    BorderRadius.circular(AppRadii.md),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Book',
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: widget.isOpen
                                          ? Colors.white
                                          : AppColors.textMuted,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: 15,
                                    color: widget.isOpen
                                        ? Colors.white
                                        : AppColors.textMuted,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
