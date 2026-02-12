import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:guardian/core/theme/app_colors.dart';
import 'package:guardian/core/theme/app_text.dart';
import 'package:guardian/core/theme/app_spacing.dart';
import 'package:guardian/core/theme/app_motion.dart';
import 'package:guardian/core/widgets/guardian_scaffold.dart';
import 'package:guardian/core/widgets/glass_card.dart';
import 'package:guardian/core/widgets/animated_glow.dart';
import 'package:guardian/features/shared/models/device_model.dart';
import 'package:guardian/features/shared/state/app_state.dart';

class AddDeviceScreen extends StatefulWidget {
  const AddDeviceScreen({super.key});

  @override
  State<AddDeviceScreen> createState() => _AddDeviceScreenState();
}

class _AddDeviceScreenState extends State<AddDeviceScreen> {
  int _step = 0;
  DeviceType? _selectedType;
  String? _selectedMode;
  int _pairIndex = 0;
  Timer? _pairTimer;

  final _pairSteps = [
    'Searching device...',
    'Device connected ✓',
    'Securing channel...',
    'Pairing complete ✓',
  ];

  void _startPairing() {
    _pairTimer = Timer.periodic(const Duration(milliseconds: 600), (t) {
      if (_pairIndex < _pairSteps.length - 1) {
        setState(() => _pairIndex++);
      } else {
        t.cancel();
        context.read<AppState>().addDevice(_selectedType!, _selectedMode!);
        Future.delayed(const Duration(milliseconds: 300), () {
          if (mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Device added (demo)'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pairTimer?.cancel();
    super.dispose();
  }

  Widget _buildStep({required Key key}) {
    return switch (_step) {
      0 => _StepChooseType(
          key: key,
          onTypeSelected: (type) {
            setState(() {
              _selectedType = type;
              _step = 1;
            });
          },
        ),
      1 => _StepChooseMode(
          key: key,
          onModeSelected: (mode) {
            setState(() {
              _selectedMode = mode;
              _step = 2;
            });
            _startPairing();
          },
        ),
      2 => _StepPairing(
          key: key,
          currentStep: _pairIndex,
          pairSteps: _pairSteps,
        ),
      _ => const SizedBox.shrink(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return GuardianScaffold(
      title: 'Add Device',
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              children: List.generate(
                3,
                (i) => Expanded(
                  child: AnimatedContainer(
                    duration: AppMotion.med,
                    height: 4,
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: i <= _step ? AppColors.neonBlue : AppColors.surface2,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          // Step body
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: AnimatedSwitcher(
                duration: AppMotion.med,
                child: _buildStep(key: ValueKey(_step)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepChooseType extends StatelessWidget {
  final Function(DeviceType) onTypeSelected;

  const _StepChooseType({
    required Key key,
    required this.onTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Select Device Type',
          style: AppText.headingMed,
        ),
        SizedBox(height: AppSpacing.lg),
        Row(
          children: [
            Expanded(
              child: GlassCard(
                onTap: () => onTypeSelected(DeviceType.lock),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock,
                      size: 40,
                      color: AppColors.neonBlue,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Lock',
                      style: AppText.bodyReg,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: GlassCard(
                onTap: () => onTypeSelected(DeviceType.light),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 40,
                      color: AppColors.neonBlue,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Light',
                      style: AppText.bodyReg,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: GlassCard(
                onTap: () => onTypeSelected(DeviceType.climate),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.thermostat,
                      size: 40,
                      color: AppColors.neonBlue,
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      'Climate',
                      style: AppText.bodyReg,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StepChooseMode extends StatelessWidget {
  final Function(String) onModeSelected;

  const _StepChooseMode({
    required Key key,
    required this.onModeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Connection Mode',
            style: AppText.headingMed,
          ),
          SizedBox(height: AppSpacing.lg),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: [
                SizedBox(
                  height: 170,
                  width: double.infinity,
                  child: GlassCard(
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bluetooth_connected,
                          size: 40,
                          color: AppColors.neonBlue,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'Bluetooth',
                          style: AppText.bodyReg,
                        ),
                        Text(
                          'Nearby device pairing',
                          style: AppText.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                SizedBox(
                  height: 170,
                  width: double.infinity,
                  child: GlassCard(
                    onTap: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          size: 40,
                          color: AppColors.neonBlue,
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Text(
                          'QR Code',
                          style: AppText.bodyReg,
                        ),
                        Text(
                          'Scan to add securely',
                          style: AppText.bodySmall,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepPairing extends StatelessWidget {
  final int currentStep;
  final List<String> pairSteps;

  const _StepPairing({
    required Key key,
    required this.currentStep,
    required this.pairSteps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedGlow(
            child: Icon(
              Icons.sensors,
              size: 64,
              color: AppColors.neonBlue,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          AnimatedSwitcher(
            duration: AppMotion.med,
            child: Text(
              pairSteps[currentStep],
              key: ValueKey(currentStep),
              style: AppText.headingMed,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Please wait...',
            style: AppText.bodySmall,
          ),
        ],
      ),
    );
  }
}
