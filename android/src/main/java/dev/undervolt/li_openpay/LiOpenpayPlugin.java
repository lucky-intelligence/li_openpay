package dev.undervolt.li_openpay;

import android.app.Activity;

import androidx.annotation.NonNull;

import dev.undervolt.li_openpay.op.OpenpayWrapper;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;
import mx.openpay.android.OperationCallBack;
import mx.openpay.android.OperationResult;
import mx.openpay.android.exceptions.OpenpayServiceException;
import mx.openpay.android.exceptions.ServiceUnavailableException;
import mx.openpay.android.model.Token;

public class LiOpenpayPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private OpenpayWrapper openpay;
  private static Activity currentActivity;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getFlutterEngine().getDartExecutor(), "li_openpay");
    channel.setMethodCallHandler(this);
  }

  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "li_openpay");
    LiOpenpayPlugin.currentActivity = registrar.activity();
    channel.setMethodCallHandler(new LiOpenpayPlugin());
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
    switch (call.method){
      case "getPlatformVersion": {
        result.success("Android " + android.os.Build.VERSION.RELEASE);
        break;
      }
      case "instance": {
        String merchantId = call.argument("merchantId");
        String apiKey = call.argument("apiKey");
        boolean production = call.argument("production");
        this.openpay = new OpenpayWrapper(merchantId, apiKey, production);
        result.success("");
        System.out.println("INFO: Instanced Native Openpay Wrapper");
        break;
      }
      case "deviceSessionId": {
        result.success(this.openpay.getDeviceSessionID(this.currentActivity));
        break;
      }
      case "createCard": {
        String name = call.argument("name");
        String card = call.argument("card");
        int month = call.argument("month");
        int year = call.argument("year");
        String cvv = call.argument("cvv");

        this.openpay.createCard(name, card, month, year, cvv, new OperationCallBack<Token>() {
          @Override
          public void onError(OpenpayServiceException e) {
            result.error(String.valueOf(e.getErrorCode()), "OpenPay Error", e.getDescription());
          }

          @Override
          public void onCommunicationError(ServiceUnavailableException e) {
            result.error("-1", "OpenPay Error", "Service unavailable");
          }

          @Override
          public void onSuccess(OperationResult<Token> operationResult) {
            result.success(operationResult.getResult().getId());
          }
        });
        break;
      }
      default:
        result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    LiOpenpayPlugin.currentActivity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {

  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
    LiOpenpayPlugin.currentActivity = binding.getActivity();
  }

  @Override
  public void onDetachedFromActivity() {

  }
}
