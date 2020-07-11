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
    return UiKitView(
      key: UniqueKey(),
      creationParams: <String, dynamic>{
        "width": MediaQuery.of(context).size.width,
        "height": 128,
      },
      viewType: 'plugins.appodeal/nativeAd',
      creationParamsCodec: const StandardMessageCodec(),
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
  NativeAdViewController._(int id)
      : _channel = new MethodChannel('plugins.appodeal/nativeAd_$id');

  final MethodChannel _channel;

  Future<void> loadAd() async {
    return _channel.invokeMethod('loadAd');
  }
}
