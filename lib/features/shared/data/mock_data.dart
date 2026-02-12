import 'package:guardian/features/shared/models/device_model.dart';
import 'package:guardian/features/shared/models/activity_log_model.dart';
import 'package:guardian/features/shared/models/chat_message_model.dart';

abstract class MockData {
  static List<DeviceModel> get devices => [
    DeviceModel(
      id: 'd1',
      name: 'Front Door',
      room: 'Entrance',
      type: DeviceType.lock,
      isLocked: true,
    ),
    DeviceModel(
      id: 'd2',
      name: 'Living Room',
      room: 'Living',
      type: DeviceType.light,
      isOn: true,
    ),
    DeviceModel(
      id: 'd3',
      name: 'Office Lamp',
      room: 'Office',
      type: DeviceType.light,
      isOn: false,
    ),
    DeviceModel(
      id: 'd4',
      name: 'Main HVAC',
      room: 'Central',
      type: DeviceType.climate,
      temperature: 21.4,
      humidity: 58.0,
    ),
  ];

  static List<ActivityLogModel> get logs => [
    ActivityLogModel(
      id: 'l1',
      timestamp: DateTime.now().subtract(Duration(minutes: 5)),
      category: LogCategory.security,
      severity: LogSeverity.critical,
      title: 'Unauthorized Access Attempt',
      description: 'Front door handle triggered without credential.',
    ),
    ActivityLogModel(
      id: 'l2',
      timestamp: DateTime.now().subtract(Duration(minutes: 22)),
      category: LogCategory.security,
      severity: LogSeverity.warning,
      title: 'Lock Disengaged',
      description: 'Front door unlocked at 02:14. Unusual hour.',
    ),
    ActivityLogModel(
      id: 'l3',
      timestamp: DateTime.now().subtract(Duration(hours: 1)),
      category: LogCategory.system,
      severity: LogSeverity.info,
      title: 'System Boot Complete',
      description: 'All subsystems nominal.',
    ),
    ActivityLogModel(
      id: 'l4',
      timestamp: DateTime.now().subtract(Duration(hours: 2)),
      category: LogCategory.environment,
      severity: LogSeverity.info,
      title: 'Temperature Within Range',
      description: 'HVAC zone reporting 21.4°C / 58% RH.',
    ),
    ActivityLogModel(
      id: 'l5',
      timestamp: DateTime.now().subtract(Duration(hours: 3)),
      category: LogCategory.system,
      severity: LogSeverity.info,
      title: 'AI Guardian Online',
      description: 'Neural inference module loaded successfully.',
    ),
  ];

  static List<ChatMessageModel> get messages => [
    ChatMessageModel(
      id: 'm1',
      timestamp: DateTime.now().subtract(Duration(minutes: 30)),
      sender: ChatSender.guardian,
      messageType: MessageType.status,
      text: 'All systems secure. Local execution is enabled.',
    ),
    ChatMessageModel(
      id: 'm2',
      timestamp: DateTime.now().subtract(Duration(minutes: 20)),
      sender: ChatSender.guardian,
      messageType: MessageType.alert,
      text: 'Front door unlocked outside typical usage window. Monitoring.',
    ),
    ChatMessageModel(
      id: 'm3',
      timestamp: DateTime.now().subtract(Duration(minutes: 10)),
      sender: ChatSender.guardian,
      messageType: MessageType.insight,
      text: 'Climate stable. No anomalies detected.',
    ),
  ];
}
