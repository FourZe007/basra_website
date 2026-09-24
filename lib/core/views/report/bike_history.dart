import 'package:flutter/material.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';

class BikesHistoryPage extends StatefulWidget {
  const BikesHistoryPage({super.key});

  @override
  State<BikesHistoryPage> createState() => _BikesHistoryPageState();
}

class _BikesHistoryPageState extends State<BikesHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(56),
        child: CustomAppBar(
          goBack: RoutesConstant.menu,
        ),
      ),
    );
  }
}
