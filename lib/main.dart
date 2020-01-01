import 'package:flutter/material.dart';
import 'package:sightseeing/Widgets/Helper/global_variables.dart';
import 'Widgets/snackbar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Widgets/translations_delegate.dart';
import 'Widgets/application.dart';
import 'package:shared_preferences/shared_preferences.dart';



Future<Null> main() async {
  runApp(new LocalisedApp());
}

class LocalisedApp extends StatefulWidget {
  @override
  LocalisedAppState createState() {
    return new LocalisedAppState();
  }
}

class LocalisedAppState extends State<LocalisedApp> {
  AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();
    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    _getLanguage();
    _getFavourites();
  }

// read favourite list
  _getFavourites() async {
    prefs = await SharedPreferences.getInstance();
    favourites = prefs.getStringList(keyFavourites) ?? [];
  }

  //shared prefs get keys; read language setting
  _getLanguage() async {
    prefs = await SharedPreferences.getInstance();
    prefLang = prefs.getString(keyLanguage) ?? '0';

    if (prefLang != '0') {
      if (prefLang == deutschPref) {
        selectedRadioTile = 0;
        flag = 1;
        description = 'description';
        onLocaleChange(Locale("de"));
      } else if (prefLang != deutschPref) {
        selectedRadioTile = 1;
        flag = 1;
        description = 'description_en';
        onLocaleChange(Locale("en"));
      }
    } else {
      onLocaleChange(Locale(myLocale.countryCode));
    }
    application.onLocaleChanged = onLocaleChange;
    _setLanguage();
    // prefs.remove(keyLanguage);
  }

  _setLanguage() async {
    await prefs.setString(keyLanguage, languageChanged);
  }

  void onLocaleChange(Locale locale) {
    languageChanged = locale.toString();
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      localeResolutionCallback: (deviceLocale, supportedLocale) {
        myLocale = deviceLocale;
      },
      localizationsDelegates: [
        _newLocaleDelegate,
        //provides localised strings
        GlobalMaterialLocalizations.delegate,
        //provides RTL support
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en", ""),
        const Locale("de", ""),
      ],
    );
  }
}
