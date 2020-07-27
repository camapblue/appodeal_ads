import 'dart:async';
import 'package:flutter/services.dart';

export 'native_ad_view.dart';
export 'banner_ad_view.dart';

enum AppodealAdType {
  AppodealAdTypeInterstitial,
  AppodealAdTypeSkippableVideo,
  AppodealAdTypeBanner,
  AppodealAdTypeNativeAd,
  AppodealAdTypeRewardedVideo,
  AppodealAdTypeMREC,
  AppodealAdTypeNonSkippableVideo,
}

enum RewardedVideoAdEvent {
  loaded,
  failedToLoad,
  present,
  willDismiss,
  finish,
}

typedef void RewardedVideoAdListener(RewardedVideoAdEvent event,
    {String rewardType, int rewardAmount});

class Appodeal {
  bool shouldCallListener;

  final MethodChannel _channel;

  /// Called when the status of the video ad changes.
  RewardedVideoAdListener videoListener;

  static const Map<String, RewardedVideoAdEvent> _methodToRewardedVideoAdEvent =
      const <String, RewardedVideoAdEvent>{
    'onRewardedVideoLoaded': RewardedVideoAdEvent.loaded,
    'onRewardedVideoFailedToLoad': RewardedVideoAdEvent.failedToLoad,
    'onRewardedVideoPresent': RewardedVideoAdEvent.present,
    'onRewardedVideoWillDismiss': RewardedVideoAdEvent.willDismiss,
    'onRewardedVideoFinished': RewardedVideoAdEvent.finish,
  };

  static final Appodeal _instance = new Appodeal.private(
    const MethodChannel('flutter_appodeal'),
  );

  Appodeal.private(MethodChannel channel) : _channel = channel {
    _channel.setMethodCallHandler(_handleMethod);
  }

  static Appodeal get instance => _instance;

  Future initialize({
    String appKey,
    List<AppodealAdType> types,
    String userId,
    int age,
    String gender,
  }) async {
    shouldCallListener = false;
    List<int> itypes = new List<int>();
    for (final type in types) {
      itypes.add(type.index);
    }
    print('Start initialize Appodeal with key = $appKey');
    _channel.invokeMethod('initialize', <String, dynamic>{
      'appKey': appKey,
      'types': itypes,
      'userId': userId,
      'age': age,
      'gender': gender
    });
  }

  /*
    Shows an Interstitial in the root view controller or main activity
   */
  Future<bool> showInterstitial() async {
    shouldCallListener = false;
    final result = await _channel.invokeMethod('showInterstitial');
    return result;
  }

  /*
    Shows an Rewarded Video in the root view controller or main activity
   */
  Future<bool> showRewardedVideo() async {
    shouldCallListener = true;
    final result = await _channel.invokeMethod('showRewardedVideo');
    return result;
  }

  Future<bool> isLoaded(AppodealAdType type) async {
    shouldCallListener = false;
    final bool result = await _channel
        .invokeMethod('isLoaded', <String, dynamic>{'type': type.index});
    return result;
  }

  Future<dynamic> _handleMethod(MethodCall call) {
    final Map<dynamic, dynamic> argumentsMap = call.arguments;
    final RewardedVideoAdEvent rewardedEvent =
        _methodToRewardedVideoAdEvent[call.method];
    if (rewardedEvent != null && shouldCallListener) {
      if (this.videoListener != null) {
        if (rewardedEvent == RewardedVideoAdEvent.finish &&
            argumentsMap != null) {
          this.videoListener(rewardedEvent,
              rewardType: argumentsMap['rewardType'],
              rewardAmount: argumentsMap['rewardAmount']);
        } else {
          this.videoListener(rewardedEvent);
        }
      }
    }

    return new Future<Null>(null);
  }
}
