//favourite
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sightseeing/Widgets/InfoPage.dart';
import 'package:sightseeing/Widgets/Helper/route.dart';
import 'package:sightseeing/Widgets/translations.dart';
import 'package:sightseeing/Widgets/Helper/global_variables.dart' as global;
import 'package:sightseeing/Helper/settingMarkers.dart' as getData;

class FavouritePlacesScreen extends StatefulWidget {
  @override
  FavouriteWidgetState createState() => FavouriteWidgetState();
}

class FavouriteWidgetState extends State<FavouritePlacesScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppTranslations.of(context).text("favourite_title")),
            actions: <Widget>[
              FloatingActionButton(
                backgroundColor: global.backgroundColor,
                onPressed: () async {
                await routeMode(context);
                  //Route für neue Tour
                  calculateRoute(1, global.favourites);
                  //back to map
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
                child: Icon(Icons.room),
              )
            ],
            backgroundColor: global.backgroundColor),
        body: favList());
  }

  Widget favList() {
    return ListView.builder(
        itemCount: global.favourites.length,
        itemBuilder: (context, index) {
          return Container(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide()),
              ),
              child: Column(children: <Widget>[
                Container(
                    margin: EdgeInsets.symmetric(vertical: 18.5),
                    child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      new BigDialogScreen(data: [
                                        getData.data[int.parse(
                                            global.favourites[index])]['title'],
                                        getData.data[int.parse(
                                                global.favourites[index])]
                                            [global.description],
                                        getData.data[int.parse(
                                                global.favourites[index])]
                                            ['images'],
                                        getData.data[int.parse(
                                            global.favourites[index])]['url'],
                                        getData.data[int.parse(
                                            global.favourites[index])]['id']
                                      ])));
                          //new fav list
                        },
                        trailing: Icon(
                          (Icons.keyboard_arrow_right),
                          size: 25,
                        ),
                        leading: ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 64,
                            minHeight: 64,
                            maxWidth: 64,
                            maxHeight: 64,
                          ),
                          child: Image.network(
                              getData.data[int.parse(global.favourites[index])]
                                  ['images'][0],
                              fit: BoxFit.cover),
                        ),
                        title: Text(
                            getData.data[int.parse(global.favourites[index])]
                                ['title'],
                            style: TextStyle(fontSize: global.fontSize))))
              ]));
        });
  }
}
