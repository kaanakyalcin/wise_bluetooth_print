class PairedDevice {
  String name;
  String hardwareAddress;
  String socketId;

  PairedDevice(
      {required this.name,
      required this.hardwareAddress,
      required this.socketId});

  static PairedDevice empty =
      PairedDevice(name: '', hardwareAddress: '', socketId: '');

  factory PairedDevice.fromJson(Map<String, dynamic> json) {
    return PairedDevice(
        name: json['name'],
        hardwareAddress: json['hardwareAddress'],
        socketId: json['socketId']);
  }

  static List<PairedDevice> fromJsonToList(List<dynamic> json) {
    List<PairedDevice> devices = <PairedDevice>[];
    for (int i = 0; i < json.length; i++) {
      devices.add(PairedDevice(
          name: json[i]['name'],
          hardwareAddress: json[i]['hardwareAddress'],
          socketId: json[i]['socketId']));
    }
    return devices;
  }
}
