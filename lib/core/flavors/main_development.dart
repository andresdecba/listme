import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:listme/main_common.dart';

void main() async {
  // flavor
  const String flavor = 'env/development.env';
  await dotenv.load(fileName: flavor);
  // initializations //
  WidgetsFlutterBinding.ensureInitialized();
  await initAdMob();

  // main
  mainCommon(flavor: flavor);
}

Future<void> initAdMob() async {
  await MobileAds.instance.initialize();
  var devices = ["4C456C78BB5CAFE90286C23C5EA6A3CC"];
  RequestConfiguration requestConfiguration = RequestConfiguration(testDeviceIds: devices);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);
}
