import 'package:flutter/material.dart';
import 'package:usuarios/src/pages/api_pages.dart';

Map<String, WidgetBuilder> obtenerRutas() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => ApiPage(),
  };
}
