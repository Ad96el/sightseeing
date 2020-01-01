//language
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sightseeing/Widgets/application.dart';
import 'package:sightseeing/Widgets/translations.dart';
import 'package:sightseeing/Widgets/Helper/global_variables.dart' as global;

class LanguageScreen extends StatefulWidget {
  @override
  _LanguageWidgetState createState() => _LanguageWidgetState();
}

class _LanguageWidgetState extends State<LanguageScreen> {
  //String label = languagesList[1];

  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Locale deutsch = Locale("de", "DE");
    String noPrefLang = '0';

// first time using the app -> no pref language available
    if (global.prefLang == noPrefLang && global.flag != 1) {
      if (global.myLocale == deutsch) {
        global.selectedRadioTile = 0;
        global.flag = 1;
        onLocaleChange(Locale("de"));
      } else if (global.myLocale != deutsch) {
        global.selectedRadioTile = 1;
        global.flag = 1;
        onLocaleChange(Locale("en"));
      }
    }
    super.initState();
    application.onLocaleChanged = onLocaleChange;
    _setLanguage();
  }

  _setLanguage() async {
    await global.prefs.setString(global.keyLanguage, global.languageChanged);
  }

  void onLocaleChange(Locale locale) async {
    global.languageChanged = locale.toString();
    setState(() {
      AppTranslations.load(locale);
    });
  }

  //save pref language
  Future<bool> setPrefLanguage(String value) async {
    global.prefs = await SharedPreferences.getInstance();
    return global.prefs.setString(global.keyLanguage, value);
  }

  setSelectedRadioTile(int val) {
    setState(() {
      global.selectedRadioTile = val;
      if (global.selectedRadioTile == 1) {
        global.description = 'description_en';
        onLocaleChange(Locale("en"));
        _setLanguage();
      } else {
        global.description = 'description';
        onLocaleChange(Locale("de"));
        _setLanguage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(AppTranslations.of(context).text("language_title")),
            backgroundColor: global.backgroundColor),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              RadioListTile(
                value: 0,
                groupValue: global.selectedRadioTile,
                title: Text(AppTranslations.of(context).text("lang_de"),
                    style: TextStyle(fontSize: global.fontSize)),
                activeColor: Colors.black,
                onChanged: (val) {
                  setSelectedRadioTile(val);
                },
              ),
              RadioListTile(
                value: 1,
                groupValue: global.selectedRadioTile,
                title: Text(AppTranslations.of(context).text("lang_en"),
                    style: TextStyle(fontSize: global.fontSize)),
                activeColor: Colors.black,
                onChanged: (val) {
                  setSelectedRadioTile(val);
                },
              )
            ]));
  }
}


