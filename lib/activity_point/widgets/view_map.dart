import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewMap extends StatelessWidget {
  const ViewMap(this.lat, this.lng, {super.key});
  final double lat;
  final double lng;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Stack(
        children: [
          SfMaps(
            layers: [
              MapTileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                zoomPanBehavior: MapZoomPanBehavior(
                  focalLatLng: MapLatLng(lat, lng),
                  zoomLevel: 15,
                  minZoomLevel: 10,
                  maxZoomLevel: 15,
                  showToolbar: false,
                  enableDoubleTapZooming: true,
                  enableMouseWheelZooming: true,
                  enablePanning: true,
                  enablePinching: true,
                ),
                initialMarkersCount: 1,
                markerBuilder: (BuildContext context, int index) {
                  return MapMarker(
                    latitude: lat,
                    longitude: lng,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: CircleAvatar(
                          backgroundColor: Colors.black,
                          child: Icon(Icons.person, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              color: Colors.white.withValues(alpha: 0.7),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('\u00a9 ', style: TextStyle(fontSize: 10)),
                  TextButton(
                    onPressed: () async => await launchUrl(Uri.parse('https://www.openstreetmap.org/copyright')),
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.all(0)),
                      overlayColor: WidgetStatePropertyAll(Colors.transparent),
                    ),
                    child: const Text('OpenStreetMap', style: TextStyle(fontSize: 10, decoration: TextDecoration.underline)),
                  ),
                  const Text(' constributors     2026     IT Basra Corporation', style: TextStyle(fontSize: 10))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
