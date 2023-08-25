import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/ad_mob/ad_mob_service.dart';
import 'package:listme/core/app_configs/config_model.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/core/styles/app_theme.dart';
import 'package:listme/crud/models/item.dart';
import 'package:listme/crud/models/folder.dart';
import 'package:listme/crud/models/lista.dart';

// init google ads
Future<void> initAdMob() async {
  // initializa
  await MobileAds.instance.initialize();
  // antes de publicar: cometar las siguientes 3 lineas (dispositivos de prueba):
  var devices = ["4C456C78BB5CAFE90286C23C5EA6A3CC"];
  RequestConfiguration requestConfiguration = RequestConfiguration(testDeviceIds: devices);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);
}

// Create examples and configs
void createExamples() {
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

void mainCommon(String envFileName) async {
  // here we can make some inicializations
  await dotenv.load(fileName: envFileName);
  WidgetsFlutterBinding.ensureInitialized();

  // HIVE
  await Hive.initFlutter();
  Hive.registerAdapter(ListaAdapter());
  Hive.registerAdapter(ItemAdapter());
  Hive.registerAdapter(FolderAdapter());
  Hive.registerAdapter(AppConfigAdapter());
  await Hive.openBox<Lista>(AppConstants.listasDb);
  await Hive.openBox<Folder>(AppConstants.foldersDb);
  await Hive.openBox<AppConfig>(AppConstants.configDb);

  // AD
  await initAdMob();

  // EXAMPLES
  createExamples();

  // prevent portrait orientation and then run app
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) => runApp(const App()),
  );
}

class App extends StatelessWidget {
  const App({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // material A para el banner siempre visible
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        bottomNavigationBar: const AdMobService(
          isProductionVersion: false,
        ),
        // material B para toda la app
        body: MaterialApp.router(
          routerConfig: AppRoutes.appRoutes,
          debugShowCheckedModeBanner: false,
          title: 'ListMe',
          theme: AppTheme().getTheme(),
        ),
      ),
    );

    // return MaterialApp(
    //   theme: AppTheme().getTheme(),
    //   home: ConfettiScreen(),
    // );
  }
}
