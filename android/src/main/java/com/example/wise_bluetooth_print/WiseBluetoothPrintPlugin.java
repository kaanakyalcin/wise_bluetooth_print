package com.example.wise_bluetooth_print;

import android.bluetooth.BluetoothAdapter;
import android.bluetooth.BluetoothDevice;
import android.bluetooth.BluetoothSocket;
import android.os.Handler;
import android.os.ParcelUuid;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Set;
import java.util.UUID;

/** WiseBluetoothPrintPlugin */
public class WiseBluetoothPrintPlugin implements FlutterPlugin, MethodCallHandler {
  private MethodChannel channel;

  private OutputStream outputStream;
  private InputStream inStream;
  String tempText = "0";

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "wise_bluetooth_print");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("getPlatformVersion")) {
      result.success("Android " + android.os.Build.VERSION.RELEASE);
    } else if(call.method.equals("getPairedDevices")) {
      ArrayList<String> deviceInfoList = new ArrayList<String>();
      BluetoothAdapter bluetooth = BluetoothAdapter.getDefaultAdapter();
      if (bluetooth != null) {
        if (bluetooth.isEnabled()) {
          Set<BluetoothDevice> pairedDevices = bluetooth.getBondedDevices();
          
          if (pairedDevices.size() > 0) {
            for (BluetoothDevice device : pairedDevices) {
              String deviceName = device.getName();
              String deviceHardwareAddress = device.getAddress();
              ParcelUuid[] uuids = device.getUuids();
              UUID socket = uuids[0].getUuid();

              deviceInfoList.add(deviceName);
              deviceInfoList.add(deviceHardwareAddress);
              deviceInfoList.add(socket.toString());
            }
          }
        }
      }
      bluetooth.cancelDiscovery();
      result.success(deviceInfoList);
    } else if(call.method.equals("print")) {
      String printStr = call.argument("printText");
      String uuid = call.argument("deviceUUID");

      BluetoothAdapter bluetooth = BluetoothAdapter.getDefaultAdapter();
      
      Set<BluetoothDevice> pairedDevices = bluetooth.getBondedDevices();
      for (BluetoothDevice pairedDevice : pairedDevices) {
        ParcelUuid[] uuids = pairedDevice.getUuids();
        UUID s = uuids[0].getUuid();
        if (s.toString().equals(uuid)) {
          bluetooth.cancelDiscovery();

          try {
            final BluetoothSocket socket = pairedDevice.createRfcommSocketToServiceRecord(UUID.fromString(uuid));

            socket.connect();
            outputStream = socket.getOutputStream();
            inStream = socket.getInputStream();

            write(printStr);

            final Handler handler = new Handler();
            handler.postDelayed(new Runnable() {
              @Override
              public void run() {
                try 
                {
                  socket.close();
                } 
                catch (IOException e) { 
                  tempText = "1";
                  result.success(false);
                }
              }
            }, 100);
          } catch (IOException e){
            tempText = "1";
            result.success(false);
          }
        } else {
          tempText = "1";
          result.success(false);
        }
      }
      if(tempText != "1") {
        result.success(true);
      }
    } else {
      result.notImplemented();
    }
  }

  public void write(String s) throws IOException {
    outputStream.write(s.getBytes());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
