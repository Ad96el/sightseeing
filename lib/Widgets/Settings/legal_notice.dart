//LegalNotice
import 'package:flutter/material.dart';
import 'package:sightseeing/Widgets/translations.dart';
import 'package:sightseeing/Widgets/Helper/global_variables.dart' as global;

class LegalNoticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppTranslations.of(context).text("imprint_title")),
            backgroundColor: global.backgroundColor),
        body: Text.rich(
          TextSpan(
            text: 'Berlin Sightseeing\n',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                height: 3.0), // default text style
            children: <TextSpan>[
              TextSpan(
                  text: 'Adresse \nNamen',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 18,
                      height: 2.0)),
            ],
          ),
        ));
  }
}