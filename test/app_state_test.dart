import 'package:flutter_test/flutter_test.dart';
import 'package:guardian/features/shared/state/app_state.dart';

void main() {
  group('AppState Connection Mode Tests', () {
    test('Default connection mode should be internet', () {
      final appState = AppState();
      expect(appState.connectionMode, ConnectionMode.internet);
    });

    test('Setting connection mode should update state and notify listeners', () {
      final appState = AppState();
      var notifyCount = 0;
      appState.addListener(() => notifyCount++);

      appState.setConnectionMode(ConnectionMode.bluetooth);
      expect(appState.connectionMode, ConnectionMode.bluetooth);
      expect(notifyCount, 1);

      appState.setConnectionMode(ConnectionMode.localWiFi);
      expect(appState.connectionMode, ConnectionMode.localWiFi);
      expect(notifyCount, 2);
    });

    test('Setting the same connection mode should not notify listeners', () {
      final appState = AppState();
      var notifyCount = 0;
      appState.addListener(() => notifyCount++);

      appState.setConnectionMode(ConnectionMode.internet);
      expect(notifyCount, 0);
    });
  });
}
