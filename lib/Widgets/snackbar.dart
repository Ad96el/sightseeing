// ui
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; 
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sightseeing/Helper/settingMarkers.dart';
import 'package:sightseeing/Widgets/Helper/popupMenuItem.dart';
import 'myGoogleMaps.dart' as maps;

import 'translations.dart';
import 'package:sightseeing/Widgets/Helper/global_variables.dart' as global;
import 'package:sightseeing/Widgets/Settings/ListObject.dart';
import 'package:sightseeing/Widgets/Settings/language.dart';
import 'package:sightseeing/Widgets/Settings/favourite.dart'; 
import 'package:sightseeing/Widgets/Settings/exampleRoutes.dart';
 
//home
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String filter;
  List list;
 // double searchedPlaceLng, searchedPlaceLat;
  //var foundPlace = 0;

  prepData() async {
    list = await loadData();
  }

  choiceFilter(String choice) async {
    if (choice == 'alle löschen') {
      print(choice);
      setState(() {
        global.filters = ['default'];
      });
    } else if (global.filters.contains(choice)) {
      return;
    } else if (global.filters[0] == 'default') {
      print('choice');
      List tmp = global.filters;
      tmp.remove('default');
      tmp.add(choice);
      setState(() {
        global.filters = tmp;
      });
      print(tmp);
    } else {
      List tmp = global.filters;
      tmp.add(choice);
      setState(() {
        global.filters = tmp;
      });
    }
    Set<Marker> poi = await settingMarkers(context, global.filters);
    print(poi.length);
    setState(() {
      global.myMarkers = poi;
    });
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(backgroundColor: global.backgroundColor, actions: [
      RaisedButton(
        child: Icon(Icons.delete, color: Colors.white),
        color: global.backgroundColor,
        onPressed: () {
          setState(() {
            global.polylines = {};
          });
        },
      ),
                  PopupMenuButton<String>(
              onSelected: choiceFilter,
              itemBuilder: (BuildContext context) {
                return MyfilterSettings.filter.map((String fil) {
                  return PopupMenuItem<String>(
                    value: fil,
                    child: Text(fil),
                  );
                }).toList();
              },
            )
    ]);
  }

//drawer setting options
  Drawer _settingsDrawer() {
    const settings_icon = [
      Icons.place,
      Icons.favorite,
      Icons.language,
      Icons.lock,
      Icons.filter_hdr,
      Icons.info
    ];

 

    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container(
          height: 100.0,
          child: DrawerHeader(
            padding: EdgeInsets.fromLTRB(20.0, 20.0, 0.0, 20.0),
            child: Text(AppTranslations.of(context).text("settings_title"),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: global.fontSize + 2)),
            decoration: BoxDecoration(color: global.backgroundColor),
          ),
        ),
        ListTile(
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            leading: Icon(settings_icon[0]),
            title: Text(AppTranslations.of(context).text("places_title"),
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: global.fontSize)),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ListObject()));
            }),
        ListTile(
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            leading: Icon(settings_icon[1]),
            title: Text(AppTranslations.of(context).text("favourite_title"),
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: global.fontSize)),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FavouritePlacesScreen()));
            }),
        ListTile(
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            leading: Icon(settings_icon[2]),
            title: Text(AppTranslations.of(context).text("language_title"),
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: global.fontSize)),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LanguageScreen()));
            }),
        ListTile(
            contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
            leading: Icon(settings_icon[4]),
            title: Text(AppTranslations.of(context).text("route_title"),
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: global.fontSize)),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => MyRoute()));
            }),
 
      ],
    ));
  }

//home screen
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: buildAppBar(context),
        key: _scaffoldKey,
        body: maps.MyGoogleMap(),
        drawer: _settingsDrawer());
  }
}
