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