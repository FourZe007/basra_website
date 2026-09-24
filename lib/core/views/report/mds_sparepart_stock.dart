import 'package:flutter/material.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';

class MdsSparepartStockPage extends StatefulWidget {
  const MdsSparepartStockPage({super.key});

  @override
  State<MdsSparepartStockPage> createState() => _MdsSparepartStockPageState();
}

class _MdsSparepartStockPageState extends State<MdsSparepartStockPage> {
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
