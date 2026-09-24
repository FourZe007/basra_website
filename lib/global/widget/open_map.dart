import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:stsj/core/providers/Provider.dart';
import 'package:stsj/global/widget/app_bar.dart';
import 'package:stsj/router/router_const.dart';

class OpenMap extends StatelessWidget {
  const OpenMap({super.key});

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<MenuState>(context);

    // Stateful Widget Usage
    // String url = '';
    // Uri uri = Uri.parse('');
    //
    // @override
    // void initState() {
    //   super.initState();
    //   url = window.location.href;
    //   uri = Uri.parse(url);
    //   print('Uri: $uri');
    // }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1024) {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(
                56,
              ),
              child: CustomAppBar(
                goBack: RoutesConstant.managerActivities,
              ),
            ),
            body: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  state.getLat,
                  state.getLng,
                ),
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.stsj.sipsales',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 110.0,
                      point: LatLng(
                        state.getLat,
                        state.getLng,
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Colors.black,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(
                MediaQuery.of(context).size.height * 0.085,
              ),
              child: CustomAppBar(
                goBack: RoutesConstant.managerActivities,
                imageSize: 35,
                profileRadius: 15,
                returnButtonSize: 20,
              ),
            ),
            body: FlutterMap(
              options: MapOptions(
                initialCenter: LatLng(
                  state.getLat,
                  state.getLng,
                ),
                initialZoom: 15.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.stsj.sipsales',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 80.0,
                      height: 110.0,
                      point: LatLng(
                        state.getLat,
                        state.getLng,
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: Colors.black,
                        size: 50.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
