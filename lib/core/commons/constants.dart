import 'package:flutter/material.dart';

class AppConstants {
  // Databases names
  static const String listsDoc = "lists";
  static const String listasDb = "listasDb";
  // others consts
  static const String user = "user_6";
  static const String categoriesDb = "categoriesDb";
  static const Duration initialLoadingDuration = Duration(milliseconds: 400);
  // keys
  static final GlobalKey<ScaffoldState> crudScaffoldKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();
}
