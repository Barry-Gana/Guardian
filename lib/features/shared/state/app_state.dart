import 'package:flutter/foundation.dart';
import 'package:guardian/features/shared/models/device_model.dart';
import 'package:guardian/features/shared/models/activity_log_model.dart';
import 'package:guardian/features/shared/models/chat_message_model.dart';
import 'package:guardian/features/shared/data/mock_data.dart';

extension StringExt on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

enum ConnectionMode { internet, bluetooth, localWiFi }

class AppState extends ChangeNotifier {
  late List<DeviceModel> _devices;
  late List<ActivityLogModel> _logs;
  late List<ChatMessageModel> _messages;
  ConnectionMode _connectionMode = ConnectionMode.internet;
  bool _preventUnlock = false;
  bool _isGuardianTyping = false;

  AppState() {
    _devices = List.from(MockData.devices);
    _logs = List.from(MockData.logs);
    _messages = List.from(MockData.messages);
  }

  // Getters (return unmodifiable views)
  List<DeviceModel> get devices => List.unmodifiable(_devices);
  List<ActivityLogModel> get logs => List.unmodifiable(_logs);
  List<ChatMessageModel> get messages => List.unmodifiable(_messages);
  ConnectionMode get connectionMode => _connectionMode;
  bool get preventUnlock => _preventUnlock;
  bool get isGuardianTyping => _isGuardianTyping;

  // Set connection mode
  void setConnectionMode(ConnectionMode mode) {
    if (_connectionMode == mode) return;
    _connectionMode = mode;
    notifyListeners();
  }

  // Toggle lock
  void toggleLock(String deviceId) {
    final idx = _devices.indexWhere((d) => d.id == deviceId);
    if (idx == -1) return;
    
    final d = _devices[idx];
    if (_preventUnlock && d.isLocked) return;

    _devices[idx] = d.copyWith(isLocked: !d.isLocked);
    final action = _devices[idx].isLocked ? 'locked' : 'unlocked';
    _addLog(
      ActivityLogModel(
        id: 'l${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        category: LogCategory.security,
        severity: LogSeverity.info,
        title: 'Lock ${action.capitalize()}',
        description: '${d.name} was $action.',
      ),
    );
    _addGuardianReply('${d.name} has been $action.', MessageType.status);
    notifyListeners();
  }





  // Add device
  void addDevice(DeviceType type, String connectionMode) {
    final names = {
      DeviceType.lock: 'New Lock',
    };
    final rooms = {
      DeviceType.lock: 'Entry',
    };
    _devices.add(
      DeviceModel(
        id: 'dev${DateTime.now().millisecondsSinceEpoch}',
        name: names[type]!,
        room: rooms[type]!,
        type: type,
      ),
    );
    _addLog(
      ActivityLogModel(
        id: 'l${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        category: LogCategory.system,
        severity: LogSeverity.info,
        title: 'Device Paired',
        description: '${names[type]} added via $connectionMode.',
      ),
    );
    notifyListeners();
  }

  // User sends a chat message (auto-triggers guardian reply)
  void addUserChat(String text) {
    if (text.trim().isEmpty) return;
    _messages.add(
      ChatMessageModel(
        id: 'm${DateTime.now().millisecondsSinceEpoch}',
        timestamp: DateTime.now(),
        sender: ChatSender.user,
        messageType: MessageType.status,
        text: text.trim(),
      ),
    );
    notifyListeners();

    final lower = text.toLowerCase();
    
    if (lower == 'dont allow any unlock attempt') {
      _preventUnlock = true;
      _addGuardianReply(
        'Got it. I have disabled all unlock attempts for the front door limit.',
        MessageType.status,
      );
      return;
    }

    if (lower == 'allow unlock attempts') {
      _preventUnlock = false;
      _addGuardianReply(
        'Got it. I have enabled all unlock attempts for the front door limit.',
        MessageType.status,
      );
      return;
    }

    if (lower == 'clean the chat') {
      _messages.clear();
      notifyListeners();
      return;
    }

    // Determine reply
    if (lower.contains('status')) {
      _addGuardianReply(
        'All systems nominal. ${_devices.length} devices online.',
        MessageType.status,
      );
    } else if (lower.contains('alert') || lower.contains('threat')) {
      _addGuardianReply(
        'Last alert: unauthorized access attempt at front door.',
        MessageType.alert,
      );
    } else if (lower.contains('secure') || lower.contains('lock')) {
      _addGuardianReply(
        'Perimeter secured. All locks engaged.',
        MessageType.status,
      );
    } else {
      _addGuardianReply(
        'Understood. Guardian is monitoring all zones.',
        MessageType.insight,
      );
    }
  }

  // Private helpers
  void _addLog(ActivityLogModel log) {
    _logs.insert(0, log);
  }

  void _addGuardianReply(String text, MessageType type) {
    _isGuardianTyping = true;
    notifyListeners();
    Future.delayed(const Duration(seconds: 3), () {
      _isGuardianTyping = false;
      _messages.add(
        ChatMessageModel(
          id: 'm${DateTime.now().millisecondsSinceEpoch}g',
          timestamp: DateTime.now(),
          sender: ChatSender.guardian,
          messageType: type,
          text: text,
        ),
      );
      notifyListeners();
    });
  }
}
