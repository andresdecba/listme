import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/app_configs/config_model.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/crud/models/folder.dart';
import 'package:listme/crud/models/item.dart';
import 'package:listme/crud/models/lista.dart';

class AppInitializations {
  // AppInitializations() {
  //   init();
  // }

  // void init() async {
  //   await initHive();
  //   await createExamples();
  // }

  // inicilizar hive ¡debe inicar antes [createExamples()] !
  static Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ListaAdapter());
    Hive.registerAdapter(ItemAdapter());
    Hive.registerAdapter(FolderAdapter());
    Hive.registerAdapter(AppConfigAdapter());
    await Hive.openBox<Lista>(AppConstants.listasDb);
    await Hive.openBox<Folder>(AppConstants.foldersDb);
    await Hive.openBox<AppConfig>(AppConstants.configDb);
  }

  // crear los ejemplos la promera vez que se intala la app
  static Future<void> createExamples() async {
    final Box<Lista> listaDb = Hive.box<Lista>(AppConstants.listasDb);
    final Box<Folder> folderDb = Hive.box<Folder>(AppConstants.foldersDb);
    final Box<AppConfig> configDb = Hive.box<AppConfig>(AppConstants.configDb);

    // configuarcion inicial
    AppConfig? initialConfig;
    if (configDb.containsKey(AppConstants.configKey)) {
      initialConfig = configDb.get(AppConstants.configKey); // buscar
    } else {
      configDb.put(AppConstants.configKey, InitialConfigs.initialConfigs); // crear
      initialConfig = configDb.get(AppConstants.configKey); // volver a buscar
    }

    // ejemplos
    if (initialConfig != null && !initialConfig.examplesDone) {
      if (listaDb.get(AppConstants.exampleList0Id) == null) {
        listaDb.put(AppConstants.exampleList0Id, InitialConfigs.exampleList0);
      }
      if (listaDb.get(AppConstants.exampleList1Id) == null) {
        listaDb.put(AppConstants.exampleList1Id, InitialConfigs.exampleList1);
      }
      if (folderDb.get(AppConstants.exampleFolder0Id) == null) {
        folderDb.put(AppConstants.exampleFolder0Id, InitialConfigs.exampleFolder0);
      }
    }
  }
}
