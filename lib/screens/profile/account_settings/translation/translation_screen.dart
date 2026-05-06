import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../../services/user_settings_service.dart';
import '../../../../models/user_settings_model.dart';

class TranslationScreen extends StatefulWidget {
  const TranslationScreen({super.key});

  @override
  State<TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<TranslationScreen> {
  final UserSettingsService _settingsService = UserSettingsService();
  UserSettingsModel? _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await _settingsService.getSettings();
    if (mounted) {
      setState(() {
        _settings = settings ?? UserSettingsModel();
        _isLoading = false;
      });
    }
  }

  Future<void> _updateSetting(String key, dynamic value) async {
    if (_settings == null) return;
    
    setState(() {
      final json = _settings!.toJson();
      json[key] = value;
      _settings = UserSettingsModel.fromJson(json);
    });

    await _settingsService.updateSettings({key: value});
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.black)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Translation',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Automatically translate the reviews, descriptions, and messages written by guests and Hosts to English. Turn this feature off if you\'d like to show the original language.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Automatic translation',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Translate reviews, descriptions, and messages into English.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                CupertinoSwitch(
                  value: _settings?.autoTranslate ?? true,
                  activeTrackColor: Colors.black,
                  onChanged: (bool value) => _updateSetting('autoTranslate', value),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
