package com.studio85neighbors.appodeal_ads;

import android.content.Context;
import android.view.View;
import android.app.Activity;

import com.appodeal.ads.Appodeal;
import com.appodeal.ads.BannerView;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import static io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import static io.flutter.plugin.common.MethodChannel.Result;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;

public class FlutterBannerAdView implements PlatformView, MethodCallHandler {
  private final MethodChannel methodChannel;

  private BannerView bannerAdView;
  private Activity _activity;

  FlutterBannerAdView(Activity activity, BinaryMessenger messenger, int id) {
    _activity = activity;
    if (_activity != null) {
      bannerAdView = Appodeal.getBannerView(_activity);
      if (bannerAdView != null) {
        bannerAdView.setVisibility(View.INVISIBLE);
      }
    }
    methodChannel = new MethodChannel(messenger, "plugins.appodeal/bannerAd_" + id);
    methodChannel.setMethodCallHandler(this);
  }

  void setActivity(Activity activity) {
    _activity = activity;

    bannerAdView = Appodeal.getBannerView(_activity);
    if (bannerAdView != null) {
      bannerAdView.setVisibility(View.INVISIBLE);
    }
  }

  @Override
  public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
    switch (methodCall.method) {
      case "loadAd":
        if (bannerAdView == null) {
          bannerAdView = Appodeal.getBannerView(_activity);
          if (bannerAdView != null) {
            bannerAdView.setVisibility(View.INVISIBLE);
          }
        }
        boolean isShow = loadAd();
        result.success(isShow);
        break;
      default:
        result.notImplemented();
    }

  }

  private boolean loadAd() {
    if (bannerAdView == null) {
      return false;
    }
    Appodeal.show(_activity, Appodeal.BANNER_VIEW);
    bannerAdView.setVisibility(View.VISIBLE);

    return true;
  }

  @Override
  public View getView() {
    return bannerAdView;
  }

  @Override
  public void dispose() {}
}