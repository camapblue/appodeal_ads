package com.studio85neighbors.appodeal_ads;

import android.content.Context;
import android.app.Activity;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class BannerAdViewFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;
    private FlutterBannerAdView flutterBannerAdView;
    private Activity activity;

    void setActivity(Activity activity) {
      this.activity = activity;
      if (this.flutterBannerAdView != null) {
        this.flutterBannerAdView.setActivity(activity);
      }
    }

    public BannerAdViewFactory(BinaryMessenger messenger, Activity activity) {
        super(StandardMessageCodec.INSTANCE);

        this.messenger = messenger;
        this.activity = activity;
    }

    @Override
    public PlatformView create(Context context, int id, Object o) {
        this.flutterBannerAdView = new FlutterBannerAdView(this.activity, messenger, id);
        return this.flutterBannerAdView;
    }
}