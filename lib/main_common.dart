import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/commons/constants.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/core/styles/app_theme.dart';
import 'package:listme/crud/models/item.dart';
import 'package:listme/crud/models/folder.dart';
import 'package:listme/crud/models/lista.dart';

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
    return MaterialApp.router(
      routerConfig: AppRoutes.appRoutes,
      debugShowCheckedModeBanner: false,
      title: 'ListMe',
      theme: AppTheme().getTheme(),
    );

    // return MaterialApp(
    //   theme: AppTheme().getTheme(),
    //   home: ConfettiScreen(),
    // );
  }
}
