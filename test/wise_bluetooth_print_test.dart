import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wise_bluetooth_print/wise_bluetooth_print.dart';

void main() {
  const MethodChannel channel = MethodChannel('wise_bluetooth_print');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await WiseBluetoothPrint.platformVersion, '42');
  });
}
