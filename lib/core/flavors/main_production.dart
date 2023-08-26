import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:listme/main_common.dart';

void main() async {
  // flavor
  const String flavor = 'env/production.env';
  await dotenv.load(fileName: flavor);
  // initializations //
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();

  // main
  mainCommon(flavor: flavor);
}
