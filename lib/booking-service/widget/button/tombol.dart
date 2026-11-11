import 'package:flutter/material.dart';
import 'package:stsj/global/theme/app_theme.dart';

class Tombol extends StatefulWidget {
  const Tombol(
    this.namaButton,
    this.handle, {
    this.disable = false,
    this.lebar = 100,
    this.tinggi = 40,
    this.isTiny = false,
    this.isOutlined = false,
    super.key,
  });

  final bool disable;
  final String namaButton;
  final Function handle;
  final double lebar;
  final double tinggi;
  final bool isTiny;
  final bool isOutlined;

  @override
  State<Tombol> createState() => _TombolState();
}

class _TombolState extends State<Tombol> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final bool isResetOrCancel =
        widget.namaButton.toUpperCase() == 'RESET' ||
        widget.namaButton.toUpperCase() == 'CANCEL' ||
        widget.isOutlined;

    final Color bgColor = widget.disable
        ? AppColors.darkerBackground
        : isResetOrCancel
            ? (_isHovered ? AppColors.secondaryMaroon : AppColors.mutedSurface)
            : (_isHovered ? AppColors.accentYellowHover : AppColors.primaryRed);

    final Color fgColor = widget.disable
        ? AppColors.textMuted
        : isResetOrCancel
            ? AppColors.primaryRed
            : Colors.white;

    final Color borderColor = widget.disable
        ? AppColors.border
        : isResetOrCancel
            ? AppColors.primaryRed.withValues(alpha: 0.4)
            : AppColors.primaryRed;

    return MouseRegion(
      cursor: widget.disable
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          if (!widget.disable && widget.handle != () {}) {
            widget.handle();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: BoxConstraints(
            minWidth: widget.lebar,
            minHeight: widget.tinggi,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor, width: 1.2),
            borderRadius: BorderRadius.circular(AppRadii.md),
            color: bgColor,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.namaButton,
                style: TextStyle(
                  color: fgColor,
                  fontSize: widget.isTiny ? 12.5 : 13.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
