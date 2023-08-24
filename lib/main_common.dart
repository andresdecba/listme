import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/ad_mob/ad_mob_service.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/core/styles/app_theme.dart';
import 'package:listme/crud/models/item.dart';
import 'package:listme/crud/models/folder.dart';
import 'package:listme/crud/models/lista.dart';

///// GOOGLE ADS /////
Future<void> initAdMob() async {
  // initializa
  await MobileAds.instance.initialize();
  // antes de publicar: cometar las siguientes 3 lineas (dispositivos de prueba):
  var devices = ["4C456C78BB5CAFE90286C23C5EA6A3CC"];
  RequestConfiguration requestConfiguration = RequestConfiguration(testDeviceIds: devices);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);
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
  await Hive.openBox<Lista>(AppConstants.listasDb);
  await Hive.openBox<Folder>(AppConstants.foldersDb);

  // AD
  await initAdMob();

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
