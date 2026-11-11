import 'package:flutter/material.dart';
import 'package:stsj/dashboard-fixup/models/dashboard5_model.dart';
import 'package:stsj/dashboard-fixup/widgets/button_custom.dart';

class DialogMotor extends StatefulWidget {
  const DialogMotor(this.data, {super.key});
  final Dashboard5 data;

  @override
  State<DialogMotor> createState() => _DialogMotorState();
}

class _DialogMotorState extends State<DialogMotor> {
  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          children: [
            TextSpan(
              text: '$label : ',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = (screenSize.width * 0.85).clamp(280.0, 520.0);

    return AlertDialog(
      actionsPadding:
          const EdgeInsets.only(bottom: 15, top: 10, left: 24, right: 24),
      contentPadding:
          const EdgeInsets.only(top: 24, right: 24, left: 24, bottom: 8),
      content: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: screenSize.height * 0.75,
        ),
        child: SizedBox(
          width: dialogWidth,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.data.memberId,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Text(
                  'DETAIL MOTOR',
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                ...widget.data.detail.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isNarrow = constraints.maxWidth < 360;
                        final imgSize = isNarrow ? 120.0 : 140.0;
                        final imageWidget = Container(
                          height: imgSize,
                          width: imgSize,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/no-image.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                        final detailsWidget = Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildDetailRow('Plat', e.plateNo),
                            _buildDetailRow('Tipe', e.unitId),
                            _buildDetailRow('Tahun', e.year),
                            _buildDetailRow('Warna', e.color),
                            _buildDetailRow('Noka', e.chasisNo),
                            _buildDetailRow('Nosin', e.engineNo),
                          ],
                        );

                        if (isNarrow) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              imageWidget,
                              const SizedBox(height: 12),
                               SizedBox(
                                width: double.infinity,
                                child: detailsWidget,
                              ),
                            ],
                          );
                        }
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            imageWidget,
                            const SizedBox(width: 20),
                            Expanded(child: detailsWidget),
                          ],
                        );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      actions: [
        ButtonCustom('Tutup', () => Navigator.pop(context)),
      ],
    );
  }
}
