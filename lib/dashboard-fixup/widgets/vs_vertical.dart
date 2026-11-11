import 'package:flutter/material.dart';
import 'package:stsj/core/cleanArc/dashboard_service/helpers/format.dart';

class VSVertical extends StatefulWidget {
  const VSVertical(this.n1, this.n2, this.lylm, {super.key});
  final int n1;
  final int n2;
  final String lylm;

  @override
  State<VSVertical> createState() => _VSVerticalState();
}

class _VSVerticalState extends State<VSVertical> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    widget.n1 > widget.n2
                        ? Icons.arrow_upward_rounded
                        : Icons.arrow_downward_rounded,
                    color: widget.n1 > widget.n2 ? Colors.indigo : Colors.orange,
                    size: 42,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    Format.thousandFormat(
                      (widget.n1 - widget.n2).abs().toString(),
                    ),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                widget.lylm == 'LY' ? 'VS Last Year' : 'VS Last Month',
                style: const TextStyle(fontSize: 13, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
