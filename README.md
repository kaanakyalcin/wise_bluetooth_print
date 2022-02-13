# wise_bluetooth_print

A new flutter plugin project to get print out from bluetooth printers for Android.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android.

## How to use it?

At the start, you need to get your already paired devices.
The plugin will return paired devices list with the device name, device mac address, and device UUID.

And then you need to call the print method with your printing text and target device UUID.

If you use ZPL, CPCL, or something like these languages, you have to set your design text to print text parameters.
If you use line feed, you just need to send your text.

# Sample

Please check the example project.

<code>
List<PairedDevice> devices = await WiseBluetoothPrint.getPairedDevices();
  </code>
  <br/><br/>
  Here is the model of the PairedDevice
  <br/><br/>
  <code>
    class PairedDevice {
  String name;
  String hardwareAddress;
  String socketId;
  }
  </code><br/><br/>

![A new flutter plugin project to get print out from bluetooth printers for Android.](https://github.com/kaanakyalcin/wise_bluetooth_print/blob/master/blob/output1.png?raw=true)

# Licence
  
  wise_bluetooth_print is free and open source software licensed under MIT License. You can use it in private and commercial projects.
