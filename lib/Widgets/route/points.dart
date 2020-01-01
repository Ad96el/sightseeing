import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sightseeing/Widgets/Helper/global_variables.dart' as global;
import 'package:sightseeing/Widgets/route/polyline.dart';

List<LatLng> polylineCoordinates = [];
int counter = 0;

getPoints(int tour, double startLat, double startLng, double destLat,
    double destLng, String mode) async {
//neue Tour/Route -> alte Punkte entfernen
  if (polylineCoordinates.isNotEmpty && tour == 1) {
    polylineCoordinates.clear();
  }
  print(mode);
  PolylinePoints polylinePoints = PolylinePoints();
  global.result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyC4JX6wKBovFccNuPVVgRT0jgCy-W2-4EE',
      startLat,
      startLng,
      destLat,
      destLng,
      mode);

  if (global.result.isNotEmpty) {
    global.result.forEach((PointLatLng point) {
      polylineCoordinates.add(LatLng(point.latitude, point.longitude));
    });
  }
  await _addPolyLine();
}

_addPolyLine() async {
  PolylineId id = PolylineId("poly");
  Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      consumeTapEvents: true,
      color: Colors.red,
      width: 10);
  global.polylines[id] = polyline;
  //print(global.polylines.length);
}
