import 'package:flutter/material.dart';
import 'package:sightseeing/Helper/settingMarkers.dart';
import 'package:sightseeing/Widgets/translations.dart';
import 'package:sightseeing/Widgets/InfoPage.dart';
import 'package:sightseeing/Widgets/Helper/global_variables.dart' as global;
import '../Helper/popupMenuItem.dart';


class ListObject extends StatefulWidget {
  @override
  _ListObject createState() => _ListObject();
}

class _ListObject extends State<ListObject> {
  final myController = TextEditingController();
  String filter;
  List<String> filters =[];
  List objects = [];
 

  _ListObject() {
    prepareObjects();
    myController.addListener(() {
      setState(() {
        filter = myController.text;
      });
    });
    }


  prepareObjects() async {
    List list = await loadData();
    List object = [];

    list.forEach((f) {
      object.add(f);
    });
    setState(() {
      objects = list;
 
    });
  }

 

  myImage(String a) {
   return new ConstrainedBox(
                          constraints: BoxConstraints(
                            minWidth: 64,
                            minHeight: 64,
                            maxWidth: 64,
                            maxHeight: 64,
                          ),child: Image.network(a));
  }

  choiceFilter(String choice)async{
    List newobject = [];

    if(choice == 'alle löschen'){
      newobject = await loadData();
      print(newobject.length);
      setState(() {
        objects = newobject;
        filters = [];
      });
      return;
    }

    if(filters.contains(choice) ){
      return;

    } else {
      filters.add(choice);
    }
    objects.forEach((obj){
      bool lock = true;
      filters.forEach((fil){
        if(obj['categories'].contains(fil) && lock ){
         newobject.add(obj);
         lock = false;
        }
      });
    });

    setState(() {
      objects = newobject;
    });
  }

  Widget myList(List list) {
    return new Material(
      child: new Column(
      children: <Widget>[
        Row(children: <Widget>[
          new Expanded(
            child:new TextField(
              controller: myController,
            ) ,
          )
,

        PopupMenuButton<String>(
        onSelected: choiceFilter,
        itemBuilder: (BuildContext context){
          return MyfilterSettings.filter.map(( String fil) {
            return PopupMenuItem<String>(
              value: fil,
              child: Text(fil),
            );

          }).toList();
        } ,
      )
        ],),

      new Expanded(
        child:  ListView.builder(
              itemCount: list.length,     
              itemBuilder: (context, index) {
                String str = "";
                list[index]['categories'].forEach((f) {
                  str += f + ", ";
                });
                if (str != "") {
                  str = str.substring(0, str.length - 2);
                }
                if(list[index]['title'] == '' ){
                  return Container();
                }
                Widget listtile = ListTile(
                  title: Text(list[index]['title'],
                  style: TextStyle(fontSize: global.fontSize)),
                  subtitle: Text(str),
                  onTap: () {
                     Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      new BigDialogScreen(
                                          data:
                                             [
                      list[index]['title'],
                      list[index][global.description],
                      list[index]['images'],
                      list[index]['url'],
                      list[index]['id']
                    ])));
                    // bigDialog(context, [
                    //   list[index]['title'],
                    //   list[index][global.description],
                    //   list[index]['images'],
                    //   list[index]['url'],
                    //   list[index]['id']
                    // ]);
                  },
                 // leading: myImage(list[index]['images'][0]),
                  trailing: Icon(Icons.keyboard_arrow_right),
                );

                return 
                filter == null || filter =='' ? listtile :
            list[index]['title'].toLowerCase().contains(filter.toLowerCase()) ? listtile: new Container();
          
              }),

      )
    ]));
 }

  @override
  Widget build(BuildContext context) {
     return Scaffold(
        appBar: AppBar(
            title: Text(AppTranslations.of(context).text("places_title")),
            backgroundColor: global.backgroundColor),
        body: myList(objects));
  }
}
