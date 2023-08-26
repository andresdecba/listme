import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listme/core/ad_mob/ad_mob_service.dart';
import 'package:listme/core/flavors/initializations.dart';
import 'package:listme/core/routes/routes.dart';
import 'package:listme/core/styles/app_theme.dart';

void mainCommon({String? flavor}) async {
  // initializations
  await AppInitializations.initHive();
  await AppInitializations.createExamples();

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
        bottomNavigationBar: const AdMobService(),
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
