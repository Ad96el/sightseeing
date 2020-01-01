import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sightseeing/Widgets/InfoPage.dart';
import 'package:sightseeing/Widgets/translations.dart';
import 'package:sightseeing/Widgets/Helper/global_variables.dart' as global;
import '../Helper/popupMenuItem.dart';
import '../Helper/route.dart';

class MyRoute extends StatefulWidget {
  @override
  _MyRoute createState() => _MyRoute();
}

class _MyRoute extends State<MyRoute> {
  Widget myList(List list) {
    return ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Container();
          }

          return ListTile(
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            title:
                Text(list[index], style: TextStyle(fontSize: global.fontSize)),
            onTap: () async{
            await  routeMode(context);
              calculateRoute(1, global.filter[index - 1]);
              Navigator.popUntil(context, ModalRoute.withName('/'));
               global.mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      zoom: 14.851564,
      target: LatLng(
        global.currenlocation['latitude'],
        global.currenlocation['longitude'],
      ),
    )));
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppTranslations.of(context).text("route_title")),
            backgroundColor: global.backgroundColor),
        body: myList(MyfilterSettings.filter));
  }
}
