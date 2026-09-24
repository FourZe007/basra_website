import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/models/Dashboard/delivery.dart';
import 'package:stsj/core/models/Dashboard/delivery_history.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/font.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/global/widget/truck_live_map.dart';
import 'package:stsj/router/router_const.dart';

class DeliveryMap extends StatefulWidget {
  const DeliveryMap({super.key});

  @override
  State<DeliveryMap> createState() => _DeliveryMapState();
}

class _DeliveryMapState extends State<DeliveryMap> {
  @override
  Widget build(BuildContext context) {
    final menuState = Provider.of<MenuState>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(56),
        child: CustomAppBar(
          goBack: RoutesConstant.delivery,
        ),
      ),
      body: Builder(
        builder: (context) {
          List<DeliveryModel> delivery = menuState.getDeliveryList;
          List<DeliveryHistoryModel> history = menuState.getDeliveryHistoryList;

          if (delivery.isEmpty) {
            return FutureBuilder(
              future: menuState.fetchDeliveryChecklist('', '', '', '', ''),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Colors.black,
                        ),
                        SizedBox(height: 10.0),
                        Text(
                          'Loading...',
                          style: GlobalFont.bigfontR,
                        ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text('Mohon maaf, terjadi kesalahan'),
                  );
                } else if (!snapshot.hasData ||
                    snapshot.data![0].employeeId.isEmpty) {
                  return const Center(
                    child: Text('Data tidak tersedia'),
                  );
                } else {
                  return TruckLiveMap(
                    snapshot.data![0].deliveryDetail,
                    snapshot.data![0].deliveryDetail[0].lat,
                    snapshot.data![0].deliveryDetail[0].lng,
                  );
                }
              },
            );
          } else {
            if (history.isEmpty) {
              return const Center(
                child: Text('Data tidak tersedia'),
              );
            } else {
              List<CheckListDetailsModel> detail = delivery[0].deliveryDetail;

              return TruckLiveMap(
                detail,
                double.parse(
                  history[menuState.getDeliveryHistoryList.length - 1].lat,
                ),
                double.parse(
                  history[menuState.getDeliveryHistoryList.length - 1].lng,
                ),
              );
            }
          }
        },
      ),
    );
  }
}
