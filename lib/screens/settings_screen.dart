import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import '../utils/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _highRiskController;
  late TextEditingController _mediumRiskController;
  late Box _settingsBox;

  @override
  void initState() {
    super.initState();
    _settingsBox = Hive.box('settings');
    // Load the saved thresholds from Hive.
    // Use the default values (60 and 30) if nothing has been saved yet.
    _highRiskController = TextEditingController(
      text: _settingsBox.get('highRiskThreshold', defaultValue: 60).toString(),
    );
    _mediumRiskController = TextEditingController(
      text: _settingsBox.get('mediumRiskThreshold', defaultValue: 30).toString(),
    );
  }

  @override
  void dispose() {
    _highRiskController.dispose();
    _mediumRiskController.dispose();
    super.dispose();
  }

  void _saveSettings() {
    if (_formKey.currentState!.validate()) {
      // Parse the text input into numbers.
      final highRisk = int.tryParse(_highRiskController.text) ?? 60;
      final mediumRisk = int.tryParse(_mediumRiskController.text) ?? 30;

      // Basic validation to ensure high is greater than medium.
      if (highRisk <= mediumRisk) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)
                .text('highRiskThresholdValidation')),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Save the new values to the Hive settings box.
      _settingsBox.put('highRiskThreshold', highRisk);
      _settingsBox.put('mediumRiskThreshold', mediumRisk);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).text('settingsSaved')),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.text('settings')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.text('riskThresholds'),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                localizations.text('riskThresholdsDescription'),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              // High Risk Threshold Input
              TextFormField(
                controller: _highRiskController,
                decoration: InputDecoration(
                  labelText: localizations.text('highRiskThresholdLabel'),
                  hintText: 'e.g., 60',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.text('valueRequired');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Medium Risk Threshold Input
              TextFormField(
                controller: _mediumRiskController,
                decoration: InputDecoration(
                  labelText: localizations.text('mediumRiskThresholdLabel'),
                  hintText: 'e.g., 30',
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return localizations.text('valueRequired');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveSettings,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // full width
                ),
                child: Text(localizations.text('save')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

