package com.studio85neighbors.appodeal_ads;

import android.content.Context;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.RatingBar;
import android.widget.TextView;
import java.util.List;

import com.appodeal.ads.Appodeal;
import com.appodeal.ads.NativeAd;
import com.appodeal.ads.NativeAdView;
import com.appodeal.ads.NativeIconView;
import com.appodeal.ads.NativeMediaView;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import static io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import static io.flutter.plugin.common.MethodChannel.Result;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.platform.PlatformView;

public class FlutterNativeAdView implements PlatformView, MethodCallHandler {
  private final MethodChannel methodChannel;

  private final NativeAdView nativeAdView;
  private final Context _context;

  FlutterNativeAdView(Context context, BinaryMessenger messenger, int id) {
    _context = context;
    nativeAdView = (NativeAdView) LayoutInflater.from(context).inflate(R.layout.native_ads_view, null);

    nativeAdView.setVisibility(View.INVISIBLE);

    methodChannel = new MethodChannel(messenger, "plugins.appodeal/nativeAd_" + id);
    methodChannel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
    switch (methodCall.method) {
      case "loadAd":
        loadAd(result);
        break;
      default:
        result.notImplemented();
    }

  }

  private void loadAd(Result result) {
    System.out.print("START LOAD ADS");
    List<NativeAd> ads = Appodeal.getNativeAds(1);
    System.out.print("NUMBER ADS = " + ads.size());

    NativeAd nativeAd = ads.get(0);

    TextView tvTitle = (TextView) nativeAdView.findViewById(R.id.tv_title);
    tvTitle.setText(nativeAd.getTitle());
    nativeAdView.setTitleView(tvTitle);

    TextView tvDescription = (TextView) nativeAdView.findViewById(R.id.tv_description);
    tvDescription.setText(nativeAd.getDescription());
    nativeAdView.setDescriptionView(tvDescription);

    RatingBar ratingBar = (RatingBar) nativeAdView.findViewById(R.id.rb_rating);
    if (nativeAd.getRating() == 0) {
        ratingBar.setVisibility(View.INVISIBLE);
    } else {
        ratingBar.setVisibility(View.VISIBLE);
        ratingBar.setRating(nativeAd.getRating());
        ratingBar.setStepSize(0.1f);
    }
    nativeAdView.setRatingView(ratingBar);

    Button ctaButton = (Button) nativeAdView.findViewById(R.id.b_cta);
    ctaButton.setText(nativeAd.getCallToAction());
    nativeAdView.setCallToActionView(ctaButton);

    View providerView = nativeAd.getProviderView(_context);
    if (providerView != null) {
        if (providerView.getParent() != null && providerView.getParent() instanceof ViewGroup) {
            ((ViewGroup) providerView.getParent()).removeView(providerView);
        }
        FrameLayout providerViewContainer = (FrameLayout) nativeAdView.findViewById(R.id.provider_view);
        ViewGroup.LayoutParams layoutParams = new ViewGroup.LayoutParams(ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
        providerViewContainer.addView(providerView, layoutParams);
    }
    nativeAdView.setProviderView(providerView);

    TextView tvAgeRestrictions = (TextView) nativeAdView.findViewById(R.id.tv_age_restriction);
    if (nativeAd.getAgeRestrictions() != null) {
        tvAgeRestrictions.setText(nativeAd.getAgeRestrictions());
        tvAgeRestrictions.setVisibility(View.VISIBLE);
    } else {
        tvAgeRestrictions.setVisibility(View.GONE);
    }

    NativeIconView nativeIconView = nativeAdView.findViewById(R.id.icon);
    nativeAdView.setNativeIconView(nativeIconView);

    NativeMediaView nativeMediaView = (NativeMediaView) nativeAdView.findViewById(R.id.appodeal_media_view_content);
    nativeAdView.setNativeMediaView(nativeMediaView);

    nativeAdView.registerView(nativeAd);
    nativeAdView.setVisibility(View.VISIBLE);

    result.success(null);
  }

  @Override
  public View getView() {
    return nativeAdView;
  }

  @Override
  public void dispose() {}
}