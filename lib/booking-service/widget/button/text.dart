import 'package:flutter/material.dart';
import 'package:stsj/global/theme/app_theme.dart';

class TextPressable extends StatefulWidget {
  const TextPressable(this.text, this.handle, {super.key});

  final String text;
  final Function handle;

  @override
  State<TextPressable> createState() => _TextPressableState();
}

class _TextPressableState extends State<TextPressable> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => isActive = true),
        onExit: (_) => setState(() => isActive = false),
        child: GestureDetector(
          onTap: () => widget.handle(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primaryRed
                  : AppColors.secondaryMaroon,
              borderRadius: BorderRadius.circular(AppRadii.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.visibility_outlined,
                  size: 14,
                  color: isActive ? Colors.white : AppColors.primaryRed,
                ),
                const SizedBox(width: 4),
                Text(
                  widget.text,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isActive ? Colors.white : AppColors.primaryRed,
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
