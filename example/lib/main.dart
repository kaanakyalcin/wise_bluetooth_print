import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:wise_bluetooth_print/classes/paired_device.dart';
import 'package:wise_bluetooth_print/wise_bluetooth_print.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<PairedDevice> _devices;

  @override
  void initState() {
    super.initState();
    _devices = <PairedDevice>[];
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    List<PairedDevice> devices = <PairedDevice>[];

    try {
      devices = await WiseBluetoothPrint.getPairedDevices();
    } on PlatformException {
      devices = <PairedDevice>[];
    }

    if (!mounted) return;

    setState(() {
      _devices = devices;
    });
  }

  void initPrint(BuildContext context, String deviceUUID) {
    // You can add more language options other than ZPL and BZPL/ZPL II for printers
    // that don't support them.
    String printTextZPL = "^XA"
        "^LH55,30"
        "^FO20,10^CFD,27,13^FDCompany Name^FS"
        "^FO20,60^AD^FD<DESCRIPTION >^FS"
        "^FO40,160^BY2,2.0^BCN,100,Y,N,N,N^FD<PART,-1>^FS"
        "^XZ";

    String printTextBZPL = "^XA"
        "^FO50,50^ADN,18,10,^FDCompany Name^FS"
        "^FO50,80^ADN,18,10,^FDCompany Address^FS"
        "^FO50,135^ADN,18,10,^FDExample text^FS"
        "^FO50,165^ADN,18,10,^FDMore example text^FS"
        "^FO50,220^ADN,18,10,^FD2022-09-01T16:36:35Z^FS"
        "^XZ";

    showDialog(
      context: context,
      builder: (builder) => AlertDialog(
        title: const Text("Select supported printer language"),
        content: const Text(
            "WARNING: On some printers, selecting an unsupported language first and then "
            "a supported one would cause the printer not to print at all, in which case "
            "you might have to restart your printer and try again."),
        actions: [
          TextButton(
            onPressed: () async {
              await WiseBluetoothPrint.print(deviceUUID, printTextZPL);
              Navigator.of(context).pop();
            },
            child: const Text("ZPL"),
          ),
          TextButton(
            onPressed: () async {
              await WiseBluetoothPrint.print(deviceUUID, printTextBZPL);
              Navigator.of(context).pop();
            },
            child: const Text("B-ZPL/ZPL II"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text("Wise Bluetooth Print Plugin example"),
      ),
      body: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => initPrint(context, _devices[index].socketId),
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                            title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_devices[index].name),
                                  Text(_devices[index].hardwareAddress)
                                ]),
                            subtitle: Text(_devices[index].socketId))
                      ],
                    ),
                  ),
                );
              })),
    ));
  }
}
