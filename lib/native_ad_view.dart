import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef void NativeAdViewCreatedCallback(NativeAdViewController controller);

class NativeAdView extends StatefulWidget {
  const NativeAdView({
    Key key,
    this.onNativeAdViewCreated,
  }) : super(key: key);

  final NativeAdViewCreatedCallback onNativeAdViewCreated;

  @override
  State<StatefulWidget> createState() => _NativeAdViewState();
}

class _NativeAdViewState extends State<NativeAdView> {
  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins.appodeal/nativeAd',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
    return UiKitView(
      key: UniqueKey(),
      viewType: 'plugins.appodeal/nativeAd',
      gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>[
        new Factory<OneSequenceGestureRecognizer>(
          () => new EagerGestureRecognizer(),
        ),
      ].toSet(),
      onPlatformViewCreated: _onPlatformViewCreated,
    );
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onNativeAdViewCreated == null) {
      return;
    }
    print('NAT VIEW ID = $id');
    widget.onNativeAdViewCreated(NativeAdViewController._(id));
  }
}

class NativeAdViewController {
  final int _id;
  NativeAdViewController._(int id)
      : _id = id,
      _channel = new MethodChannel('plugins.appodeal/nativeAd_$id');

  final MethodChannel _channel;

  int get getId => _id;

  Future<bool> loadAd() async {
    final result = await _channel.invokeMethod('loadAd');

    return result;
  }
}
