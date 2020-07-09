package com.studio85neighbors.appodeal_ads;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** AppodealAdsPlugin */
public class AppodealAdsPlugin implements FlutterPlugin, ActivityAware {
  @Nullable
  private MethodCallHandlerImpl methodCallHandler;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    methodCallHandler = new MethodCallHandlerImpl(null);
    methodCallHandler.startListening(binding.getBinaryMessenger());

    binding.getPlatformViewRegistry().registerViewFactory("plugins.appodeal/nativeAd",
        new NativeAdViewFactory(binding.getBinaryMessenger()));
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    if (methodCallHandler == null) {
      return;
    }

    methodCallHandler.stopListening();
    methodCallHandler = null;
  }

  /**
   * Plugin registration.
   */
  public static void registerWith(Registrar registrar) {
    MethodCallHandlerImpl handler = new MethodCallHandlerImpl(registrar.activity());
    handler.startListening(registrar.messenger());

    registrar.platformViewRegistry().registerViewFactory("plugins.appodeal/nativeAd",
        new NativeAdViewFactory(registrar.messenger()));
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    if (methodCallHandler == null) {
      return;
    }

    methodCallHandler.setActivity(binding.getActivity());
  }

  @Override
  public void onDetachedFromActivity() {
    if (methodCallHandler == null) {
      return;
    }

    methodCallHandler.setActivity(null);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }
}
