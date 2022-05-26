import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  final PopupController _popupController = PopupController();

  MapController _mapController = MapController();
  double _zoom = 7;
  List<LatLng> _latLngList = [];
  List<Marker> _markers = [];

  @override
  void initState() {
    refreshMarkers();
    super.initState();
  }

  refreshMarkers() {
    _markers = _latLngList
        .map((point) => Marker(
              point: point,
              width: 60,
              height: 60,
              builder: (context) => Icon(
                Icons.handshake_outlined,
                size: 30,
                color: Colors.black,
              ),
            ))
        .toList();
    setState(() {});
  }

  _getGeoLocationPosition(MapController controller) async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      _mapController.move(LatLng(9, 53), 12);
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {});
      print(position.latitude);
      print(position.longitude);
      _mapController.move(LatLng(position.latitude, position.longitude), 12);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          onMapCreated: (controller) {
            if (mounted) {
              _getGeoLocationPosition(controller);
            }
          },
          boundsOptions: FitBoundsOptions(padding: EdgeInsets.all(8.0)),
          zoom: _zoom,
          plugins: [
            MarkerClusterPlugin(),
          ],
          //onTap: (_) => _popupController.hidePopup(),
        ),
        layers: [
          TileLayerOptions(
            minZoom: 2,
            maxZoom: 18,
            backgroundColor: Colors.black,
            // errorImage: ,
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerClusterLayerOptions(
            maxClusterRadius: 190,
            disableClusteringAtZoom: 16,
            size: Size(50, 50),
            fitBoundsOptions: FitBoundsOptions(
              padding: EdgeInsets.all(50),
            ),
            markers: _markers,
            polygonOptions: PolygonOptions(
                borderColor: Colors.blueAccent,
                color: Colors.black12,
                borderStrokeWidth: 3),
            popupOptions: PopupOptions(
                popupSnap: PopupSnap.markerTop,
                popupController: _popupController,
                popupBuilder: (_, marker) => Container(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: Colors.white,
                        ),
                        width: 200,
                        height: 100,
                        child: Column(
                          children: const [
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Thema: Unternehmensinterne Kommunikation",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                    fontSize: 12,
                                ),
                                // textAlign: TextAlign.left
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                "Teilnehmer:",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                ),
                                // textAlign: TextAlign.left
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(0),
                              child: Text(
                                "Paul Franken Otto Gmbh",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                ),
                                // textAlign: TextAlign.left
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(0),
                              child: Text(
                                "Melina Hikisch Novomind",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 12,
                                ),
                                // textAlign: TextAlign.left
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
            builder: (context, markers) {
              return Container(
                alignment: Alignment.center,
                decoration:
                BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                child: Text('${markers.length}'),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _latLngList.add(LatLng(53.5754728, 9.9076184));
          _latLngList.add(LatLng(53.4754728, 9.9576184));
          _latLngList.add(LatLng(53.6754728, 9.7076184));
          _latLngList.add(LatLng(53.7754728, 9.8076184));

          refreshMarkers();
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.navigation),
      ),
    );
  }
}
