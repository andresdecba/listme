import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/*
TUTORIAL: https://developers.google.com/admob/flutter/banner/inline-adaptive?hl=es
importante: hay ejemplos de otros tipos de banner, ver !
*/

// UNITS KEYS
final String _androidAdKey = dotenv.env['ANDROID_AD_KEY']!;
final String _iOsAdKey = dotenv.env['IOS_AD_KEY']!;

// OTHERS
const _padding = 5.0;
const _radius = 5.0;

class AdMobService extends StatefulWidget {
  const AdMobService({
    super.key,
  });

  @override
  State<AdMobService> createState() => _AdMobServiceState();
}

class _AdMobServiceState extends State<AdMobService> {
  BannerAd? _anchoredAdaptiveAd;
  LoadAdError? _loadError;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  Future<void> _loadAd() async {
    // Get an AnchoredAdaptiveBannerAdSize before loading the ad.
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(MediaQuery.of(context).size.width.truncate() - (_padding.toInt() * 2));

    if (size == null) {
      print('Unable to get height of anchored banner.');
      return;
    }

    _anchoredAdaptiveAd = BannerAd(
      adUnitId: Platform.isAndroid ? _androidAdKey : _iOsAdKey,
      size: size,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          setState(() {
            // When the ad is loaded, get the ad size and use it to set
            // the height of the ad container.
            _anchoredAdaptiveAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          setState(() {
            _loadError = error;
            _isLoaded = true;
            ad.dispose();
          });
        },
      ),
    );
    return _anchoredAdaptiveAd!.load();
  }

  @override
  Widget build(BuildContext context) {
    /// LOADING ///
    if (!_isLoaded) {
      return const _BuildAd(
        child: Align(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        ),
      );
    }

    /// ERROR ///
    if (_loadError != null && _isLoaded) {
      return const _BuildAd(
        child: Text(
          "Error while connecting to ad server.",
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    /// AD LOADED ///
    if (_anchoredAdaptiveAd != null && _isLoaded) {
      return _BuildAd(
        height: _anchoredAdaptiveAd!.size.height.toDouble(),
        width: _anchoredAdaptiveAd!.size.width.toDouble(),
        child: AdWidget(ad: _anchoredAdaptiveAd!),
      );
    }
    return Container();
  }

  @override
  void dispose() {
    super.dispose();
    _anchoredAdaptiveAd?.dispose();
  }
}

class _BuildAd extends StatelessWidget {
  const _BuildAd({
    required this.child,
    this.height,
    this.width,
  });

  final Widget child;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: _padding),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: const BorderRadius.all(Radius.circular(_radius)),
          border: Border.all(
            color: Colors.grey[800]!,
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(horizontal: _padding),
        width: width ?? double.infinity,
        height: height ?? 60,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_radius),
          child: child,
        ),
      ),
    );
  }
}
