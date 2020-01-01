import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/services.dart';
import 'package:sightseeing/Widgets/InfoPage.dart';
import 'dart:convert';
import 'package:sightseeing/Widgets/Helper/global_variables.dart' as global;

List<dynamic> data;

Future<Set<Marker>> settingMarkers(BuildContext context, List filter) async {
  data = await loadData();
  Set<Marker> markers = <Marker>{};
  data.forEach((data) {
    if (filter[0] == 'default') {
      List cor = data['coordinates'];
      Marker pos = Marker(
          markerId: MarkerId(data['title']),
          position: LatLng(cor[0], cor[1]),
          onTap: () {},
          infoWindow: InfoWindow(
            title: data['title'],
            onTap: () {

              bootomCard(context, [
                data['title'],
                data[global.description],
                data['images'],
                data['url'],
                data['id'],
                data['coordinates']
              ]);
            },
          ),
          icon: BitmapDescriptor.defaultMarker);

      markers.add(pos);
    }
    data['categories'].forEach((cat) {
      if (filter.contains(cat)) {
        List cor = data['coordinates'];
        Marker pos = Marker(
            markerId: MarkerId(data['title']),
            position: LatLng(cor[0], cor[1]),
            onTap: () {},
            infoWindow: InfoWindow(
              title: data['title'],
              onTap: () {

                bootomCard(context, [
                  data['title'],
                  data[global.description],
                  data['images'],
                  data['url'],
                  data['id'],
                  data['coordinates']
                ]);
              },
            ),
            icon: BitmapDescriptor.defaultMarker);

        markers.add(pos);
      }
    });
  });

  return markers;
}

Future<List<dynamic>> loadData() async {
  final markersData = await rootBundle.loadString('ressources/data.json');
  final data = json.decode(markersData);
  List<dynamic> poi = data['objects'];
  return poi;
}

