import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:listme/core/constants/constants.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/core/styles/app_theme.dart';
import 'package:listme/crud/models/item.dart';
import 'package:listme/crud/models/lista.dart';

void mainCommon(String envFileName) async {
  // here we can make some inicializations
  await dotenv.load(fileName: envFileName);
  WidgetsFlutterBinding.ensureInitialized();

  // HIVE
  await Hive.initFlutter();
  Hive.registerAdapter(ListaAdapter());
  Hive.registerAdapter(ItemAdapter());
  await Hive.openBox<Lista>(AppConstants.listsCollection);

  //var listsBox = Hive.box(AppConstants.listsCollection);
  //print('holis from main ${listsBox.keys}');

  // run the app
  runApp(const App());
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

    //  return MaterialApp(
    //   theme: AppTheme().getTheme(),
    //   home: const CounterScreen(),
    // );
  }
}
