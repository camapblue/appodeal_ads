import 'package:flutter/foundation.dart';
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
    return Text(
        '$defaultTargetPlatform is not yet supported by the Native Ad View plugin');
  }

  void _onPlatformViewCreated(int id) {
    if (widget.onNativeAdViewCreated == null) {
      return;
    }
    widget.onNativeAdViewCreated(NativeAdViewController._(id));
  }
}

class NativeAdViewController {
  NativeAdViewController._(int id)
      : _channel = new MethodChannel('plugins.appodeal/nativeAd_$id');

  final MethodChannel _channel;

  Future<void> loadAd() async {
    return _channel.invokeMethod('loadAd');
  }
}
