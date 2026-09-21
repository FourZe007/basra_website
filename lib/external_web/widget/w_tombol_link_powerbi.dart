import 'package:flutter/material.dart';
import 'package:stsj/global/theme/app_theme.dart';

class WTombolLinkPowerBI extends StatelessWidget {
  const WTombolLinkPowerBI(
      this.label, this.pathImage, this.url, this.warna, this.handle,
      {super.key});

  final String label, pathImage, url;
  final Color warna;
  final Function handle;

  @override
  Widget build(BuildContext context) {
    final bool isActive = (warna == Colors.white);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => handle(url),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isActive ? AppColors.accentYellow : AppColors.darkGrey,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isActive ? AppColors.accentYellow : AppColors.border,
                width: 1.0,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: AppColors.accentYellow.withValues(alpha: 0.25),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  pathImage,
                  height: 18,
                  width: 18,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      
                      fontSize: 11,
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? AppColors.onAccentYellow : AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
