import 'package:flutter/material.dart';

class AppConstants {
  // Databases names
  static const String listasDb = "listasDb";
  static const String foldersDb = "foldersDb";

  // TODO borrar:
  // static const String listasDb = "listasDb2";
  // static const String foldersDb = "foldersDb2";

  // others consts
  static const String user = "user_6";
  static const Duration initialLoadingDuration = Duration(milliseconds: 400);
  // keys
  static final GlobalKey<ScaffoldState> crudScaffoldKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();
}
