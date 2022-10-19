import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'pushable_button.dart';

import './data/ad_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {

  late BannerAd _bottomBannerAd;
  var _isBottomBannerAdLoaded = false;

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(onAdLoaded: (_) {
        setState(() {
          _isBottomBannerAdLoaded = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        ad.dispose();
      }),
    );
    _bottomBannerAd.load();
  }

  @override
  void initState() {
    super.initState();
    _createBottomBannerAd();
  }
  
  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
  }

  final buttonSize = 170.0;
  final buttonTextArray = [
    'Poke Me',
    'Stop I Like It',
    'Ooo That Tickled',
    'Harder',
    'Yas',
    'Yass',
    'YASSS',
    'I Called You An Uber',
  ];
  final sexPostions = [
    'Doggy',
    'Monster Mash',
    'Alone and Sad',
    'Twisting Tower'
  ];

  var buttonTextArrayIndex = 0;
  var _buttonText = 'Poke Me';
  void changeButtonText() {
    setState(() {
      buttonTextArrayIndex < buttonTextArray.length - 1
          ? buttonTextArrayIndex++
          : buttonTextArrayIndex = 0;

      _buttonText = buttonTextArray[buttonTextArrayIndex];
    });
  }

  Random rnd = Random();
  int randomIndex = 0;
  int lastIndex = 0;
  String positionText = "";

  void changeIndex() {
    setState(() {
      int max = sexPostions.length;

      randomIndex = rnd.nextInt(max);
      while (randomIndex == lastIndex) {
        randomIndex = rnd.nextInt(max);
      }
      lastIndex = randomIndex;

      positionText = sexPostions[randomIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        bottomNavigationBar: _isBottomBannerAdLoaded ? Container(
          height: _bottomBannerAd.size.height.toDouble(),
          width: _bottomBannerAd.size.width.toDouble(),
          child: AdWidget(ad: _bottomBannerAd)) : null,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 209, 14, 0),
          title: const Text(
            'Sex Position Generator',
            style: TextStyle(
                fontFamily: 'Georgia',
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontStyle: FontStyle.italic),
          ),
        ),
        body: Column(
          children: [
            Center(
              child: Text(
                positionText,
                style:
                    const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: SizedBox(
                width: buttonSize,
                child: PushableButton(
                  height: buttonSize,
                  elevation: 15,
                  hslColor: const HSLColor.fromAHSL(1, 1, 1.0, 0.435),
                  shadow: BoxShadow(
                    color: const Color.fromARGB(0, 0, 0, 0).withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: const Offset(0, 7),
                  ),
                  onPressed: () => {changeIndex(), changeButtonText()},
                  child: Center(
                    child: Text(
                      _buttonText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// final BannerAd myBanner = BannerAd(
//   adUnitId: '<ca-app-pub-3940256099942544/2934735716>',
//   size: AdSize.banner,
//   request: AdRequest(),
//   listener: BannerAdListener(),
// );
