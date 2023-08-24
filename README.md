# listme

ver: https://developers.google.com/admob/flutter/quick-start?hl=es-419

1- Crear la app y bloque de anuncios en AdMob
2- instalar el paquete: google_mobile_ads
3- en android/app/src/main/AndroidManifest.xml agregar
   <manifest>
    <application>
        <!-- Sample AdMob app ID: ca-app-pub-3940256099942544~3347511713 -->
        <meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/> 
    <application>
    <manifest>
4- en project/app/build.gradle agregar
    (https://stackoverflow.com/questions/55591958/flutter-firestore-causing-d8-cannot-fit-requested-classes-in-a-single-dex-file)
    defaultConfig {
        ...
        multiDexEnabled true
    }
5- pegar el archivo de adMob [AdMobService] y cambiar los key de prodccion apara android y iOs
6- ubicar el banner en la UI donde nos guste


/// PARA GENERAR NUEVOS ICONOS ///

1- paquete: https://pub.dev/packages/flutter_launcher_icons

2- 2- cambiar el/los .pngs en assets/icons

3- cambiar las config en: /flutter_launcher_icons-development.yaml (y las otras dos)

4- run:  flutter pub run flutter_launcher_icons -f flutter_launcher_icons*


/// PARA GENERAR NUEV PANTALLA SPLASH ///

1- paquete: https://pub.dev/packages/flutter_native_splash

2- cambiar el/los .pngs en assets/splash

3- cambiar la configuracion en pubspec.yaml:
flutter_native_splash:
  color: "#00BCD4"
  image: assets/splash/splash.png
  image_dark: assets/splash/splash.png
  android_12:
    image: assets/splash/splash.png
    icon_background_color: "#00BCD4"
    image_dark: assets/splash/splash.png
    icon_background_color_dark: "#00BCD4"
  web: false

4- run: dart run flutter_native_splash:create