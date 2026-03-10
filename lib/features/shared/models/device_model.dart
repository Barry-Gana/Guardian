enum DeviceType { lock }

class DeviceModel {
  final String id;
  final String name;
  final String room;
  final DeviceType type;
  final bool isOn;
  final bool isLocked;
  final double temperature;
  final double humidity;

  DeviceModel({
    required this.id,
    required this.name,
    required this.room,
    required this.type,
    this.isOn = false,
    this.isLocked = true,
    this.temperature = 20.0,
    this.humidity = 50.0,
  });

  DeviceModel copyWith({
    String? id,
    String? name,
    String? room,
    DeviceType? type,
    bool? isOn,
    bool? isLocked,
    double? temperature,
    double? humidity,
  }) {
    return DeviceModel(
      id: id ?? this.id,
      name: name ?? this.name,
      room: room ?? this.room,
      type: type ?? this.type,
      isOn: isOn ?? this.isOn,
      isLocked: isLocked ?? this.isLocked,
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
    );
  }
}
