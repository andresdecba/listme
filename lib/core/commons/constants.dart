import 'package:flutter/material.dart';
import 'package:listme/core/app_configs/config_model.dart';
import 'package:listme/crud/models/folder.dart';
import 'package:listme/crud/models/item.dart';
import 'package:listme/crud/models/lista.dart';

class AppConstants {
  // Databases names
  static const String listasDb = "listasDb";
  static const String foldersDb = "foldersDb";
  static const String configDb = "configDb";
  static const String configKey = "configKey";

  // TODO borrar :
  //static const String listasDb = "listas-DB-ALT";
  //static const String foldersDb = "folders-DB-ALT";

  // others consts
  static const Duration initialLoadingDuration = Duration(milliseconds: 400);

  // keys
  static final GlobalKey<ScaffoldState> crudScaffoldKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<ScaffoldState> homeScaffoldKey = GlobalKey<ScaffoldState>();

  // examples id
  static const String exampleList0Id = 'listaEx00';
  static const String exampleList1Id = 'listaEx01';
  static const String exampleFolder0Id = 'folderEx00';
}

class InitialConfigs {
  // configuracion inicial de la app //
  static final initialConfigs = AppConfig(
    examplesDone: false, // true: vistos y borrados x el usuario
    colorScheme: 'colorScheme',
  );

  // Listas y folders de ejemplo //
  static final exampleList0 = Lista(
    title: 'Holidays 2023 🏖️  (example)',
    creationDate: DateTime.now(),
    items: [
      Item(content: 'buy a tent  🏕️ ', isDone: false, id: 'itemEx00', isCategory: false),
      Item(content: 'chairs and table', isDone: false, id: 'itemEx02', isCategory: false),
      Item(content: 'To buy', isDone: false, id: 'itemEx03', isCategory: true),
      Item(content: 'groceries', isDone: true, id: 'itemEx04', isCategory: false),
    ],
    id: AppConstants.exampleList0Id,
    isCompleted: false,
  );

  static final exampleList1 = Lista(
    title: 'My birthday party to do (example)',
    creationDate: DateTime.now(),
    items: [
      Item(content: 'Buy a cake  🎂 ', isDone: false, id: 'itemEx05', isCategory: false),
      Item(content: 'Make a playlist', isDone: false, id: 'itemEx06', isCategory: true),
      Item(content: 'Send invitations', isDone: false, id: 'itemEx07', isCategory: false),
    ],
    id: AppConstants.exampleList1Id,
    isCompleted: false,
  );

  static Folder exampleFolder0 = Folder(
    name: 'Travels (example)',
    isExpanded: true,
    id: AppConstants.exampleFolder0Id,
    listasIds: ['listaEx00'],
    creationDate: DateTime.now(),
  );
}
