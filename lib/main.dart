import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
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

  final Badgeimge = [
    'fire_icon',
    'funny_icon',
    'heart_icon',
    'laugh_icon',
    'learn_icon',
  ];

  final buttonSize = 170.0;
  final buttonTextArray = [
    'You got this',
    'Champ!',
    'Now go conquer the world',
    'You are a superhero in training',
    'Put on your cape and fly through your tasks today.',
    'You can do it!',
    'Don nott give up, you are too awesome to quit!',
    'You are a ninja of productivity',
    'You are a rockstar',
    'You are a wizard of efficiency',
    'You are a puzzle master',
    'Keep calm and unicorn on',
  ];
  final Adventures = [
    'Going to the laundromat',
    'Obtaining a drivers license',
    'Any trip to a govt office',
    'Ask out the some you care about',
    'Learning a new language',
    'Returning a library book',
    'Go buy a cup of coffee',
    'Getting over social anxiety haha',
    'Spend the day making something',
    'Spend the day volunteering',
    'Choose a new skill and learn more about it',
    'Go on a hike to a new place',
    'Write a short story',
    'Take as many pictures as you can today',
    'Choose a type of food you have never tried before and try it.',
    'Do 10 kind deeds throughout the day',
    'Get a job at a carpet store',
    'Help carry a strangers groceries ',
    'Get a cat out of a tree',
    'Fill your palm with whipped cream and scare someone',
    'Annoy a family member ',
    'Quote as many funny clips as you can in one minute ',
    'Do some gardening ',
    'Catch a piece of cheese with your face',
    'Do your taxes',
    'Ask a person on a date ',
    'Sell everything you own and become a pirate ',
    'Throw a croissant like a boomerang and catch it on the way back ',
  ];

  var buttonTextArrayIndex = 0;
  var _buttonText = 'Poke Me';
  String Badge_adv = 'assets/main.webp';
  void changeButtonText() {
    setState(() {
      buttonTextArrayIndex < buttonTextArray.length - 1
          ? buttonTextArrayIndex++
          : buttonTextArrayIndex = 0;

      _buttonText = buttonTextArray[buttonTextArrayIndex];
    });
  }

  Random rnd = Random();
  int Badge_randomIndex = 0;
  int Text_randomIndex = 0;

  int lastIndex = 0;
  int text_lastIndex = 0;
  String positionText = "";

  void changeIndex() {
    setState(() {
      int bmax = Badgeimge.length;
      int amax = Adventures.length;

      Badge_randomIndex = rnd.nextInt(bmax);
      Text_randomIndex = rnd.nextInt(amax);

      while (Badge_randomIndex == lastIndex) {
        Badge_randomIndex = rnd.nextInt(bmax);
      }
      lastIndex = Badge_randomIndex;

      while (Text_randomIndex == text_lastIndex) {
        Text_randomIndex = rnd.nextInt(bmax);
      }
      text_lastIndex = Text_randomIndex;

      positionText = Adventures[Text_randomIndex];
      String bagetext = Badgeimge[Badge_randomIndex];
      String image_name = bagetext.replaceAll(' ', '_').toLowerCase();
      Badge_adv = "assets/$bagetext.webp";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Scaffold(
        bottomNavigationBar: _isBottomBannerAdLoaded
            ? Container(
                height: _bottomBannerAd.size.height.toDouble(),
                width: _bottomBannerAd.size.width.toDouble(),
                child: AdWidget(ad: _bottomBannerAd))
            : null,
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 122, 209),
          title: const Text(
            'Side Quest',
            style: TextStyle(
                fontFamily: 'Georgia',
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontStyle: FontStyle.italic),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue, Colors.black12],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ),
        body: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Text(
                positionText,
                style: const TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
              ),
            ),
            Center(
              child: Image(
                image: AssetImage(
                  Badge_adv,
                ),
                height: 250,
                width: 250,
                fit: BoxFit.cover,
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
