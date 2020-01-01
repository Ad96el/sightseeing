//privacy
import 'package:flutter/material.dart';
import 'package:sightseeing/Widgets/translations.dart';
import 'package:sightseeing/Widgets/Helper/global_variables.dart' as global;

class PrivacyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(AppTranslations.of(context).text("privacy_title")),
          backgroundColor: global.backgroundColor),
    );
  }
}