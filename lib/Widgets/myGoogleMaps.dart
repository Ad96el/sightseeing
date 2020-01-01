import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sightseeing/Helper/settingMarkers.dart';
import 'package:sightseeing/Widgets/Helper/global_variables.dart' as global; 

class MyGoogleMap extends StatefulWidget {
  @override
  State<MyGoogleMap> createState() => _MyGoogleMap();
}

class _MyGoogleMap extends State<MyGoogleMap> {
  @override
  void initState() {
    super.initState();
    getMarkers();
    getCurrentLocation();
  }

 
 
  Marker mypos;

  CameraPosition defaultPosition = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(52.516284, 13.378015),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: 
          GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: defaultPosition,
              onMapCreated: gettingcontroller,
              markers: global.myMarkers,
              polylines: Set<Polyline>.of(global.polylines.values )
            ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            FloatingActionButton(
              backgroundColor: global.backgroundColor,
              onPressed: () {
                followUser();
              },
              child: Icon(Icons.gps_fixed),
            ),
          ],
        ));
  }

  gettingcontroller(GoogleMapController controller) {
    setState(() {
      global.mapController = controller;
    });
  }
 
  getCurrentLocation() async {
    Location location = new Location();
    location.onLocationChanged().listen((pos) {
      setState(() {
        global.currenlocation = pos;
      });
      myPos();
    });
  }

  followUser() async {
    global.mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      zoom: 14.851564,
      target: LatLng(
        global.currenlocation['latitude'],
        global.currenlocation['longitude'],
      ),
    )));
  }

  myPos() async {
    global.myMarkers.remove(mypos);
    mypos = Marker(
        markerId: MarkerId('myLocation'),
        position: LatLng(global.currenlocation['latitude'],
            global.currenlocation['longitude']),
 
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen));
    setState(() {
      global.myMarkers.add(mypos);
    });
  }

  getMarkers() async {
    Set<Marker> poi = await settingMarkers(context, global.filters);
    setState(() {
      global.myMarkers = poi;
    });
  }


}
