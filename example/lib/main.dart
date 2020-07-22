import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:appodeal_ads/appodeal_ads.dart';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String videoState;
  NativeAdViewController _nativeAdViewController;
  bool _isFinishedInitialize = false;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  initPlatformState() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      List<AppodealAdType> types = new List<AppodealAdType>();
      types.add(AppodealAdType.AppodealAdTypeInterstitial);
      types.add(AppodealAdType.AppodealAdTypeRewardedVideo);
      types.add(AppodealAdType.AppodealAdTypeNativeAd);
      Appodeal.instance.videoListener =
          (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
        print("RewardedVideoAd event $event");
        setState(() {
          videoState = "State $event";
        });
      };
      // You should use here your APP Key from Appodeal
      await Appodeal.instance.initialize(
          Platform.isIOS
              ? 'IOS_KEY'
              : 'ANDROID_KEY',
          types);
    } on PlatformException {}

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _isFinishedInitialize = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('$videoState'),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 40.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  height: 100.0,
                  color: Colors.green,
                  child: FlatButton(
                    onPressed: () {
                      this.loadRewarded();
                    },
                    child: new Text('Show Rewarded'),
                  ),
                ),
                Container(
                  height: 100.0,
                  color: Colors.blue,
                  child: new FlatButton(
                    onPressed: () {
                      this.loadInterstital();
                    },
                    child: new Text('Show Interstitial'),
                  ),
                ),
                Container(
                  height: 100.0,
                  color: Colors.red,
                  child: FlatButton(
                    onPressed: () async {
                      final isLoaded = await this.isNativeAdsLoaded();
                      if (isLoaded && _nativeAdViewController != null) {
                        _nativeAdViewController.loadAd();
                      }
                    },
                    child: new Text('Load Native Ads'),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                AspectRatio(
                  aspectRatio: 414 / 144,
                  child: Container(
                    color: Colors.green[700],
                    child: _isFinishedInitialize
                        ? NativeAdView(
                            onNativeAdViewCreated: (controller) {
                              _nativeAdViewController = controller;
                            },
                          )
                        : Opacity(opacity: 0.0),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                AspectRatio(
                  aspectRatio: 414 / 144,
                  child: Container(
                    color: Colors.green[700],
                    child: _isFinishedInitialize
                        ? NativeAdView(
                            onNativeAdViewCreated: (controller) async {
                              print('Load Ad with ID = ${controller.getId}');
                              final result = await controller.loadAd();

                              print('Load Ad SUCCESS = $result');
                            },
                          )
                        : Opacity(opacity: 0.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void loadInterstital() async {
    bool loaded = await Appodeal.instance
        .isLoaded(AppodealAdType.AppodealAdTypeInterstitial);
    if (loaded) {
      Appodeal.instance.showInterstitial();
    } else {
      print("No se ha cargado un Interstitial");
    }
  }

  void loadRewarded() async {
    bool loaded = await Appodeal.instance
        .isLoaded(AppodealAdType.AppodealAdTypeRewardedVideo);
    if (loaded) {
      Appodeal.instance.showRewardedVideo();
    } else {
      print("No se ha cargado un Rewarded Video");
    }
  }

  Future<bool> isNativeAdsLoaded() async {
    return Appodeal.instance.isLoaded(AppodealAdType.AppodealAdTypeNativeAd);
  }
}
