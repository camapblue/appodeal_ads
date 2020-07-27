import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void BannerAdViewCreatedCallback(BannerAdViewController controller);

class BannerAdView extends StatefulWidget {
  const BannerAdView({
    Key key,
    this.onBannerAdViewCreated,
  }) : super(key: key);

  final BannerAdViewCreatedCallback onBannerAdViewCreated;

  @override
  State<StatefulWidget> createState() => _BannerAdViewState();
}

class _BannerAdViewState extends State<BannerAdView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins.appodeal/bannerAd',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return UiKitView(
      key: UniqueKey(),
      viewType: 'plugins.appodeal/bannerAd',
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        new Factory<OneSequenceGestureRecognizer>(
          () => new EagerGestureRecognizer(),
        ),
      ].toSet(),
      onPlatformViewCreated: _onPlatformViewCreated,
    );
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onBannerAdViewCreated == null) {
      return;
    }
    print('BANNER VIEW ID = $id');
    widget.onBannerAdViewCreated(BannerAdViewController._(id));
  }
}

class BannerAdViewController {
  final int _id;
  BannerAdViewController._(int id)
      : _id = id,
      _channel = new MethodChannel('plugins.appodeal/bannerAd_$id');

  final MethodChannel _channel;

  int get getId => _id;

  Future<bool> loadAd() async {
    final result = await _channel.invokeMethod('loadAd');

    return result;
  }
}
