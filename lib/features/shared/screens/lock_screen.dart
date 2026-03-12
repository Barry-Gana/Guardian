import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:guardian/core/theme/app_colors.dart';
import 'package:guardian/core/theme/app_text.dart';
import 'package:guardian/core/theme/app_spacing.dart';
import 'package:guardian/core/theme/app_motion.dart';
import 'package:guardian/core/widgets/guardian_scaffold.dart';
import 'package:guardian/core/widgets/neon_button.dart';
import 'package:guardian/core/constants/firebase_constants.dart';
import 'package:guardian/features/shared/state/app_state.dart';
import 'package:guardian/core/services/lock_firebase_service.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({super.key});

  @override
  State<LockScreen> createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  static const Duration _presenceTimeout = Duration(milliseconds: 10000);
  static const Duration _presenceRefreshInterval = Duration(seconds: 1);
  static const int _epochMillisecondsFloor = 1000000000000;

  final LockFirebaseService _lockService = LockFirebaseService();
  String _lastSentCommandId = '';
  Timer? _presenceRefreshTimer;
  int? _lastObservedLastSeen;
  DateTime? _lastObservedLastSeenAt;

  @override
  void initState() {
    super.initState();
    _presenceRefreshTimer = Timer.periodic(_presenceRefreshInterval, (_) {
      if (!mounted) return;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _presenceRefreshTimer?.cancel();
    super.dispose();
  }

  bool _looksLikeEpochMilliseconds(int value) {
    return value >= _epochMillisecondsFloor;
  }

  // The ESP32 currently writes lastSeen as a heartbeat value, so the app
  // records when it last observed that value change and expires it locally.
  void _recordLastSeenHeartbeat(int? lastSeen) {
    if (lastSeen == null || lastSeen <= 0) return;
    if (_looksLikeEpochMilliseconds(lastSeen)) return;
    if (_lastObservedLastSeen == lastSeen) return;

    _lastObservedLastSeen = lastSeen;
    _lastObservedLastSeenAt = DateTime.now();
  }

  bool _isLastSeenFresh(int? lastSeen) {
    if (lastSeen == null || lastSeen <= 0) return false;

    final now = DateTime.now();
    if (_looksLikeEpochMilliseconds(lastSeen)) {
      final lastSeenAt = DateTime.fromMillisecondsSinceEpoch(lastSeen);
      return now.difference(lastSeenAt) <= _presenceTimeout;
    }

    final observedAt = _lastObservedLastSeenAt;
    if (_lastObservedLastSeen != lastSeen || observedAt == null) {
      return false;
    }

    return now.difference(observedAt) <= _presenceTimeout;
  }

  String _connectionModeLabel(ConnectionMode mode) {
    return switch (mode) {
      ConnectionMode.internet => 'internet',
      ConnectionMode.bluetooth => 'bluetooth',
      ConnectionMode.localWiFi => 'local_wifi',
    };
  }

  IconData _getConnectionIcon(String mode) {
    return switch (mode) {
      'internet' => LucideIcons.wifi,
      'bluetooth' => LucideIcons.bluetooth,
      'local_wifi' => LucideIcons.houseWifi,
      _ => LucideIcons.wifi,
    };
  }

  @override
  Widget build(BuildContext context) {
    final deviceId = ModalRoute.of(context)!.settings.arguments as String;

    return Consumer<AppState>(
      builder: (context, appState, _) {
        final device = appState.devices.firstWhere((d) => d.id == deviceId);

        return StreamBuilder<DatabaseEvent>(
          stream: _lockService.listenToLockState(),
          builder: (context, snapshot) {
            bool isLocked = true;
            bool isOnline = false;
            bool isPresenceFresh = false;
            int? firebaseLastSeen;
            bool firebaseUnlockBlocked = false;
            String firebaseConnectionMode = 'internet';
            String firebaseLastCommandId = '';
            String firebaseLastResult = '';
            bool firebaseOnlineFlag = false;

            if (snapshot.hasError) {
              debugPrint(
                '[LockScreen] Firebase stream error at ${LockFirebaseConstants.lockPath}: ${snapshot.error}',
              );
            }

            if (snapshot.hasData && snapshot.data?.snapshot.value != null) {
              final raw = snapshot.data!.snapshot.value;
              debugPrint(
                '[LockScreen] Snapshot received from ${LockFirebaseConstants.lockPath}: $raw',
              );

              if (raw is Map) {
                final data = Map<String, dynamic>.from(raw);
                final firebaseStatus =
                    data[LockFirebaseConstants.status]?.toString();
                if (firebaseStatus == 'locked' || firebaseStatus == 'unlocked') {
                  isLocked = firebaseStatus == 'locked';
                }
                firebaseConnectionMode =
                    data[LockFirebaseConstants.connectionMode]?.toString() ??
                        'internet';
                firebaseOnlineFlag =
                    data[LockFirebaseConstants.online] == true;
                firebaseLastSeen = int.tryParse(
                  data[LockFirebaseConstants.lastSeen]?.toString() ?? '',
                );
                _recordLastSeenHeartbeat(firebaseLastSeen);
                isPresenceFresh = _isLastSeenFresh(firebaseLastSeen);
                isOnline = firebaseConnectionMode == 'internet' &&
                    isPresenceFresh;
                firebaseUnlockBlocked =
                    data[LockFirebaseConstants.unlockBlocked] == true;
                firebaseLastCommandId =
                    data[LockFirebaseConstants.lastCommandId]?.toString() ?? '';
                firebaseLastResult =
                    data[LockFirebaseConstants.lastActionResult]?.toString() ??
                        '';

                debugPrint(
                  '[LockScreen] Parsed state status=${isLocked ? 'locked' : 'unlocked'} '
                  'onlineFlag=$firebaseOnlineFlag online=$isOnline presenceFresh=$isPresenceFresh '
                  'lastSeen=$firebaseLastSeen unlockBlocked=$firebaseUnlockBlocked '
                  'connectionMode=$firebaseConnectionMode lastCommandId=$firebaseLastCommandId '
                  'lastActionResult=$firebaseLastResult',
                );
              }
            }

            // Determine if we should show a confirmation for the command we just sent
            final bool showConfirmation =
                _lastSentCommandId.isNotEmpty &&
                _lastSentCommandId == firebaseLastCommandId;
            bool isCommandSuccess = firebaseLastResult == 'success';

            return GuardianScaffold(
              title: device.name,
              actions: [
                IconButton(
                  icon: const Icon(LucideIcons.trash2),
                  color: AppColors.textPrimary,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(_getConnectionIcon(firebaseConnectionMode)),
                  color: AppColors.textPrimary,
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
              ],
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: device.id,
                      child: AnimatedContainer(
                        duration: AppMotion.med,
                        curve: AppMotion.smooth,
                        width: 220,
                        height: 220,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isLocked
                                ? AppColors.success
                                : AppColors.danger,
                            width: 4,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: (isLocked
                                      ? AppColors.success
                                      : AppColors.danger)
                                  .withValues(alpha: 0.4),
                              blurRadius: isLocked ? 32 : 12,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            isLocked
                                ? LucideIcons.doorClosed
                                : LucideIcons.doorOpen,
                            size: 100,
                            color: isLocked
                                ? AppColors.success
                                : AppColors.danger,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppSpacing.lg),
                    Text(
                      isLocked ? 'LOCKED' : 'UNLOCKED',
                      style: AppText.labelMono.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isOnline ? 'ONLINE' : 'OFFLINE',
                      style: AppText.labelMono.copyWith(
                        fontSize: 14,
                        color: isOnline ? AppColors.success : AppColors.danger,
                      ),
                    ),
                    if (showConfirmation) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isCommandSuccess
                              ? AppColors.success.withValues(alpha: 0.1)
                              : AppColors.danger.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isCommandSuccess
                                ? AppColors.success.withValues(alpha: 0.5)
                                : AppColors.danger.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isCommandSuccess
                                  ? LucideIcons.circleCheck
                                  : LucideIcons.circleAlert,
                              color: isCommandSuccess
                                  ? AppColors.success
                                  : AppColors.danger,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              isCommandSuccess
                                  ? 'Command Executed'
                                  : 'Unlock Blocked',
                              style: AppText.labelSmall.copyWith(
                                color: isCommandSuccess
                                    ? AppColors.success
                                    : AppColors.danger,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    SizedBox(height: AppSpacing.lg),
                    NeonButton(
                      label: isLocked ? 'UNLOCK' : 'LOCK',
                      onPressed: () async {
                        final selectedMode =
                            _connectionModeLabel(appState.connectionMode);
                        final currentStatus = isLocked ? 'locked' : 'unlocked';
                        final nextCommand = isLocked ? 'unlock' : 'lock';

                        debugPrint(
                          '[LockScreen] Front Door button pressed.',
                        );
                        debugPrint(
                          '[LockScreen] Resolved current lock status before sending command: $currentStatus',
                        );
                        debugPrint(
                          '[LockScreen] Resolved current selected connection mode: $selectedMode',
                        );

                        if (appState.connectionMode !=
                            ConnectionMode.internet) {
                          debugPrint(
                            '[LockScreen] Command blocked because selected mode is not internet.',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Internet control disabled. Enable Wi-Fi connection mode in Settings.'),
                              duration: Duration(seconds: 3),
                            ),
                          );
                          return;
                        }

                        // Generate an ID for the UI to track
                        final newCommandId = DateTime.now()
                            .microsecondsSinceEpoch
                            .toString();
                        setState(() {
                          _lastSentCommandId = newCommandId;
                        });

                        final payload = {
                          LockFirebaseConstants.command: nextCommand,
                          LockFirebaseConstants.commandId: newCommandId,
                          LockFirebaseConstants.connectionMode: 'internet',
                        };

                        debugPrint(
                          '[LockScreen] Command write attempt to ${LockFirebaseConstants.lockPath}',
                        );
                        debugPrint(
                          '[LockScreen] Payload being written: $payload',
                        );

                        try {
                          await _lockService.sendCommand(
                            command: nextCommand,
                            commandId: newCommandId,
                          );
                        } catch (e) {
                          debugPrint('[LockScreen] Command write failed: $e');
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Failed to send command to Firebase.',
                              ),
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
