import 'package:buddy/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: DataBaseMethods().getMeetingMarker(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading");
            }
            List<Map<String, dynamic> > _latLngList = [];
            try {
              snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                Map<String, dynamic> informations = {};

                LatLng point = LatLng(data["lat"], data["long"]);
                informations.addAll({"point": point});
                informations.addAll({"name1": data["name1"]});
                informations.addAll({"name2": data["name2"]});
                informations.addAll({"topic": data["topic"]});
                _latLngList.add(informations);
              }).toList();
            } catch (e) {
            }
            return MeetingMap(latLngList: _latLngList);
          }),
    );
  }


}

class MeetingMap extends StatefulWidget {
  List<Map<String, dynamic>> latLngList = [];

  MeetingMap({required this.latLngList});

  @override
  _MeetingMapState createState() => _MeetingMapState();
}

class _MeetingMapState extends State<MeetingMap> {
  final PopupController _popupController = PopupController();

  MapController _mapController = MapController();
  double _zoom = 11;
  List<Marker> _markers = [];

  @override
  void initState() {
    refreshMarkers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: LatLng(53.5754728,9.9876184),
          interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
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
        onTap: (tap, point) {_popupController.hideAllPopups();}
      ),
      layers: [
        TileLayerOptions(
          minZoom: 2,
          maxZoom: 18,
          backgroundColor: Colors.black,
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerClusterLayerOptions(
          maxClusterRadius: 190,
          disableClusteringAtZoom: 12,
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
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: Text(
                              getInformationWithPoint(marker.point, "topic"),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Padding(
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
                              getInformationWithPoint(marker.point, "name1"),
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
                              getInformationWithPoint(marker.point, "name2"),
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
    );
  }

  getInformationWithPoint(LatLng latLng, String field){
    for(int i= 0;i<widget.latLngList.length;i++){
      if(widget.latLngList[i]["point"] == latLng){
        return widget.latLngList[i][field];
      }
    }
  }

  refreshMarkers() {
    _markers = widget.latLngList
        .map((point) => Marker(
              point: point["point"],
              width: 60,
              height: 60,
              builder: (context) => Icon(
                Icons.location_on_sharp,
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
      _mapController.move(LatLng(position.latitude, position.longitude), 12);
    }
  }
}
