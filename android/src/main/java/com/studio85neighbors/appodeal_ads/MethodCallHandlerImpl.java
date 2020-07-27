package com.studio85neighbors.appodeal_ads;

import androidx.annotation.Nullable;
import androidx.annotation.NonNull;
import android.app.Activity;

import com.appodeal.ads.Appodeal;
import com.appodeal.ads.Native;
import com.appodeal.ads.RewardedVideoCallbacks;
import com.appodeal.ads.InterstitialCallbacks;
import com.appodeal.ads.utils.Log;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.util.Map;

/**
 * Translates incoming UrlLauncher MethodCalls into well formed Java function calls for {@link
 * UrlLauncher}.
 */
final class MethodCallHandlerImpl implements MethodCallHandler, RewardedVideoCallbacks, InterstitialCallbacks {
  private Activity activity;
  @Nullable private MethodChannel channel;

  /** Forwards all incoming MethodChannel calls to the given {@code urlLauncher}. */
  MethodCallHandlerImpl(Activity activity) {
    this.activity = activity;
  }

  void setActivity(Activity activity) {
    this.activity = activity;
  }

  /**
   * Registers this instance as a method call handler on the given {@code messenger}.
   *
   * <p>Stops any previously started and unstopped calls.
   *
   * <p>This should be cleaned with {@link #stopListening} once the messenger is disposed of.
   */
  void startListening(BinaryMessenger messenger) {
    if (channel != null) {
      System.out.print("Setting a method call handler before the last was disposed.");
      stopListening();
    }

    Appodeal.setRewardedVideoCallbacks(this);
    Appodeal.setInterstitialCallbacks(this);

    channel = new MethodChannel(messenger, "flutter_appodeal");
    channel.setMethodCallHandler(this);
  }

  /**
   * Clears this instance from listening to method calls.
   *
   * <p>Does nothing if {@link #startListening} hasn't been called, or if we're already stopped.
   */
  void stopListening() {
    if (channel == null) {
      System.out.print("Tried to stop listening when no MethodChannel had been initialized.");
      return;
    }

    Appodeal.setRewardedVideoCallbacks(null);

    channel.setMethodCallHandler(null);
    channel = null;
  }


  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (this.activity == null) {
      result.error("no_activity", "flutler_appodeal plugin requires a foreground activity", null);
      return;
    }
    if (call.method.equals("initialize")) {
      String appKey = call.argument("appKey");
      List<Integer> types = call.argument("types");
      String userId = call.argument("userId");
      int age = call.argument("age");
      String gender = call.argument("gender");

      int type = Appodeal.NONE;
      for (int type2 : types) {
        type = type | this.appodealAdType(type2);
      }
      Appodeal.setUserId(userId);
      Appodeal.setAge(age);
      Appodeal.setUserGender(gender.equals("male") ? UserSettings.Gender.MALE : UserSettings.Gender.FEMALE);

      Appodeal.setRequiredNativeMediaAssetType(Native.MediaAssetType.ICON);
      Appodeal.initialize(activity, appKey, type);
      Appodeal.setLogLevel(Log.LogLevel.verbose);
      result.success(Boolean.TRUE);
    } else if (call.method.equals("showInterstitial")) {
      boolean isShow = Appodeal.show(activity, Appodeal.INTERSTITIAL);
      result.success(isShow);
    } else if (call.method.equals("showRewardedVideo")) {
      boolean isShow = Appodeal.show(activity, Appodeal.REWARDED_VIDEO);
      result.success(isShow);
    } else if (call.method.equals("isLoaded")) {
      int type = call.argument("type");
      int adType = this.appodealAdType(type);
      Boolean isLoaded = Appodeal.isLoaded(adType);
      result.success(isLoaded);
    } else {
      result.notImplemented();
    }
  }

  private int appodealAdType(int innerType) {
    switch (innerType) {
      case 0:
        return Appodeal.INTERSTITIAL;
      case 1:
        return Appodeal.NON_SKIPPABLE_VIDEO;
      case 2:
        return Appodeal.BANNER;
      case 3:
        return Appodeal.NATIVE;
      case 4:
        return Appodeal.REWARDED_VIDEO;
      case 5:
        return Appodeal.MREC;
      case 6:
        return Appodeal.NON_SKIPPABLE_VIDEO;
    }
    return Appodeal.INTERSTITIAL;
  }

  private Map<String, Object> argumentsMap(Object... args) {
    Map<String, Object> arguments = new HashMap<>();
    for (int i = 0; i < args.length; i += 2)
      arguments.put(args[i].toString(), args[i + 1]);
    return arguments;
  }

  // Appodeal Rewarded Video Callbacks
  @Override
  public void onRewardedVideoLoaded(boolean isPrecache) {
    channel.invokeMethod("onRewardedVideoLoaded", argumentsMap());
  }

  @Override
  public void onRewardedVideoFailedToLoad() {
    channel.invokeMethod("onRewardedVideoFailedToLoad", argumentsMap());
  }

  @Override
  public void onRewardedVideoShown() {
    channel.invokeMethod("onRewardedVideoPresent", argumentsMap());
  }

  @Override
  public void onRewardedVideoShowFailed() {
    // Called when rewarded video show failed
  }

  @Override
  public void onRewardedVideoFinished(double i, String s) {
    channel.invokeMethod("onRewardedVideoFinished", argumentsMap());
  }

  @Override
  public void onRewardedVideoClicked() {
    channel.invokeMethod("onRewardedVideoClicked", argumentsMap());
  }

  @Override
  public void onRewardedVideoClosed(boolean b) {
    channel.invokeMethod("onRewardedVideoWillDismiss", argumentsMap());
  }

  @Override
  public void onRewardedVideoExpired() {
    // Called when rewarded video is expired
  }

  // Interstitial Ad
  @Override
  public void onInterstitialLoaded(boolean isPrecache) {
    // Called when interstitial is loaded
    System.out.print("INTERSTITIAL AD LOADED");
  }
  @Override
  public void onInterstitialFailedToLoad() {
    // Called when interstitial failed to load
    System.out.print("INTERSTITIAL AD FAIL TO LOAD");
  }
  @Override
  public void onInterstitialShown() {
    // Called when interstitial is shown
  }
  @Override
  public void onInterstitialShowFailed() {
    // Called when interstitial show failed 
  }
  @Override
  public void onInterstitialClicked() {
    // Called when interstitial is clicked
  }
  @Override
  public void onInterstitialClosed() {
    // Called when interstitial is closed
  }
  @Override
  public void onInterstitialExpired()  {
    // Called when interstitial is expired
  }
}
