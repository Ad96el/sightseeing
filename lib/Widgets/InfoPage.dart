import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'translations.dart';
import 'package:sightseeing/Widgets/Helper/global_variables.dart' as global;
import 'package:url_launcher/url_launcher.dart';
import 'package:sightseeing/Widgets/route/points.dart';

void bootomCard(BuildContext context, List data) {
  global.latitude = data[5][0];
  global.longitude = data[5][1];

  //Beschränken BottomCard auf 128 Zeichen, Title + Subtitle
  global.title = data[0];
  int getLengthOfTitleString = global.title.length;
  int avoidOverflow = 125 - getLengthOfTitleString;

  showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
            height: 160,
            decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(10),
                    topRight: const Radius.circular(10))),
            child: InkWell(
                onTap: () {
                  //  Navigator.pop(context);
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) =>
                              new BigDialogScreen(data: data)));
                  // bigDialog(context, data);
                }, //bottomcard overview config
                child: SingleChildScrollView(
                  //SingleChildScrollView macht BottomCard Scrollbar, sonst könnte es durch
                  //zuviele Zeichen die Ansicht sprengen -> Bottom Overflow
                  //Festigen wäre auch ne Möglichkeit, aber scrollen ist besser
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: Text(data[0]),
                        subtitle:
                            Text(data[1].substring(0, avoidOverflow) + "..."),
                        trailing: new Image.network(data[2][0],
                            height: 80, width: 80),
                      ),
                      buttombar(context, data[4]),
                    ],
                  ),
                )));
      });
}

class BigDialogScreen extends StatefulWidget {
  @override
  BigDialogState createState() => BigDialogState();
  final List data;
  BigDialogScreen({this.data});
}

class BigDialogState extends State<BigDialogScreen> {
  List data;
  // BigDialogState(List data);
  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: bigDialog(context, data));
  }
}

Widget bigDialog(BuildContext context, List data) {
  //print(data);
  global.title = data[0];
  List image = [];

  data[2].forEach((im) => image.add(NetworkImage(im)));

  return Container(
      child: new SingleChildScrollView(
          child: new ConstrainedBox(
    constraints: new BoxConstraints(),
    child: new Column(children: <Widget>[
      new SizedBox(
        // pictures
        height: 200.0,
        width: double.infinity,
        //wegen carousel error
        child: new Carousel(
          animationDuration: myDuration,
          dotBgColor: Colors.transparent,
          images: image,
        ),
      ),
      buttombar(context, data[4]),
      new Container(
        // header
        width: double.infinity,
        padding:
            EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 16.0),

        child: new Text(
          data[0],
          textDirection: TextDirection.ltr,
          style: new TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      new Container(
        // body
        padding:
            EdgeInsets.only(left: 10.0, right: 10.0, top: 16.0, bottom: 16.0),
        child: new Text(
          data[1],
          textDirection: TextDirection.ltr,
          style: new TextStyle(
            height: 1.3,
            fontSize: 16.0,
            color: Colors.black,
          ),
        ),
      ),

      /*               
        GestureDetector(
        child: new Text("Quelle",  // url
          style: new TextStyle(
            color: Colors.blue, decoration: TextDecoration.underline)),
        
        onLongPress: urlLauncher(data[3]),
        
        )*/
    ]),
  )));

  // showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return dialog;
  //     });
}

Future<bool> setFavList() async {
  global.prefs = await SharedPreferences.getInstance();
  return global.prefs.setStringList(global.keyFavourites, global.favourites);
}

urlLauncher(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Duration myDuration = new Duration(hours: 10, minutes: 0, seconds: 10);

Widget buttombar(context, id) {
  var tmp;
  return ButtonTheme.bar(
    child: ButtonBar(
      alignment: MainAxisAlignment.start,
      children: <Widget>[
        FlatButton.icon(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //  Navigator.popUntil(context, ModalRoute.withName('/'));
              Navigator.pop(context);
            },
            label: Text("")),
        FlatButton.icon(
          icon: Icon(Icons.navigation),
          onPressed: () async {
            await routeMode(context);

            getPoints(
                1,
                global.currenlocation['latitude'],
                global.currenlocation['longitude'],
                global.latitude,
                global.longitude,
                global.mode);
          },
          label: Text(AppTranslations.of(context).text("route")),
        ),
        changeIcon(id),
        FlatButton.icon(
          icon: Icon(global.favIcon),
          onPressed: () {
            setFavList();
//adding or deleting place in fav list
            if (!global.favourites.contains(id.toString())) {
              global.favourites.add(id.toString());
              tmp = 1;
              global.text = "delfromfavourite";
            } else {
              global.favourites.remove(id.toString());
              tmp = 0;
              global.text = "add2favourite";
            }
            Navigator.pop(context);
            if (tmp == 1) {
              getAlertAdding(context);
            } else {
              getAlertRemoving(context);
            }
          },
          label: Text(AppTranslations.of(context).text(global.text)),
        ),
      ],
    ),
  );
}

changeIcon(id) {
  setFavList();
//adding or deleting place in fav list
  if (!global.favourites.contains(id.toString())) {
    global.favIcon = Icons.favorite_border;
    global.text = "add2favourite";
  } else {
    global.favIcon = Icons.favorite;
    global.text = "delfromfavourite";
  }
}

void getAlertAdding(context) {
  var alertDialog = AlertDialog(
    content: Text(global.title + (AppTranslations.of(context).text("added"))),
  );

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}

void getAlertRemoving(context) {
  var alertDialog = AlertDialog(
    content: Text(global.title + (AppTranslations.of(context).text("deleted"))),
  );
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return alertDialog;
      });
}

Future<void> routeMode(context) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
          title: new Text(AppTranslations.of(context).text("route_mode")),
          content: Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //auto = driving, fahrrad =bicycling, laufen= walking, öffentl. Verkehrsmittel = transit
              new IconButton(
                  icon: Icon(Icons.directions_bike, color: Colors.blue),
                  // alignment: Alignment.topLeft,
                  //padding: EdgeInsets.fromLTRB(0, 5.0, 50.0, 2.0),
                  onPressed: () {
                    global.mode = "bicycling";
                    Navigator.popUntil(context, ModalRoute.withName('/'));
                  }),
              new IconButton(
                icon: Icon(Icons.directions_walk, color: Colors.blue),
                //  alignment: Alignment.bottomCenter,
                onPressed: () {
                  global.mode = "walking";
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
              ),
              new IconButton(
                icon: Icon(Icons.directions_car, color: Colors.blue),
                //   alignment: Alignment.bottomRight,
                onPressed: () {
                  global.mode = "driving";
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                },
              )
            ],
          )));
    },
  );
}
