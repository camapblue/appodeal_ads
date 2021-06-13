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
      types.add(AppodealAdType.AppodealAdTypeBanner);
      Appodeal.instance.videoListener =
          (RewardedVideoAdEvent event, {String rewardType, int rewardAmount}) {
        print("RewardedVideoAd event $event");
        setState(() {
          videoState = "State $event";
        });
      };
      // You should use here your APP Key from Appodeal
      await Appodeal.instance.initialize(
          appKey: Platform.isIOS
              ? 'dc412003b20f5933ad99eb19ea0c79eebd388949601d32e4'
              : '6c6731495cb337820b3e04081b288aa965426cdda76fc625',
          types: types,
          userId: 'anonymous',
          age: 25,
          gender: 'male');
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
                  child: _isFinishedInitialize
                      ? FlatButton(
                          onPressed: () {
                            this.loadRewarded();
                          },
                          child: Text('Show Rewarded'),
                        )
                      : Text('Ads Not Ready'),
                ),
                Container(
                  height: 100.0,
                  color: Colors.blue,
                  child: _isFinishedInitialize
                      ? FlatButton(
                          onPressed: () {
                            this.loadInterstital();
                          },
                          child: Text('Show Interstitial'),
                        )
                      : Text('Ads Not Ready'),
                ),
                Container(
                  height: 100.0,
                  color: Colors.red,
                  child: _isFinishedInitialize
                      ? FlatButton(
                          onPressed: () async {
                            final isLoaded = await this.isNativeAdsLoaded();
                            if (isLoaded && _nativeAdViewController != null) {
                              _nativeAdViewController.loadAd();
                            }
                          },
                          child: new Text('Load Native Ads'),
                        )
                      : Text('Ads Not Ready'),
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
                        : const SizedBox(),
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
                              print(
                                  'Load Native Ad with ID = ${controller.getId}');
                              final result = await controller.loadAd();

                              print('Load Ad SUCCESS = $result');
                            },
                          )
                        : const SizedBox(),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                AspectRatio(
                  aspectRatio: 414 / 144,
                  child: Container(
                    color: Colors.orange[700],
                    child: _isFinishedInitialize
                        ? BannerAdView(
                            onBannerAdViewCreated: (controller) async {
                              print(
                                  'Load Banner Ad with ID = ${controller.getId}');
                              final isLoaded = await this.isBannerAdLoaded();
                              print('Is Loaded Banner Ad = $isLoaded');

                              if (isLoaded) {
                                final result = await controller.loadAd();

                                print('Load Banner Ad SUCCESS = $result');
                              }
                            },
                          )
                        : Text('Ads Not Ready'),
                  ),
                ),
                SizedBox(
                  height: 32,
                ),
                AspectRatio(
                  aspectRatio: 414 / 144,
                  child: Container(
                    color: Colors.orange[700],
                    child: _isFinishedInitialize
                        ? BannerAdView(
                            onBannerAdViewCreated: (controller) async {
                              print(
                                  'Load Banner Ad with ID = ${controller.getId}');
                              final isLoaded = await this.isBannerAdLoaded();
                              print('Is Loaded Banner Ad = $isLoaded');

                              if (isLoaded) {
                                final result = await controller.loadAd();

                                print('Load Banner Ad SUCCESS = $result');
                              }
                            },
                          )
                        : Text('Ads Not Ready'),
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
      final isShow = await Appodeal.instance.showInterstitial();
      print('SHOW INTERSTITIAL >> $isShow');
    } else {
      print("No se ha cargado un Interstitial");
    }
  }

  void loadRewarded() async {
    bool loaded = await Appodeal.instance
        .isLoaded(AppodealAdType.AppodealAdTypeRewardedVideo);
    if (loaded) {
      final isShow = await Appodeal.instance.showRewardedVideo();
      print('SHOW REWARD AD >> $isShow');
    } else {
      print("No se ha cargado un Rewarded Video");
    }
  }

  Future<bool> isNativeAdsLoaded() async {
    return Appodeal.instance.isLoaded(AppodealAdType.AppodealAdTypeNativeAd);
  }

  Future<bool> isBannerAdLoaded() async {
    return Appodeal.instance.isLoaded(AppodealAdType.AppodealAdTypeBanner);
  }
}
