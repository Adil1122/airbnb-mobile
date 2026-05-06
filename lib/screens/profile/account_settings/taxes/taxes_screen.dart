import 'package:flutter/material.dart';
import '../../../../services/user_settings_service.dart';
import '../../../../models/user_settings_model.dart';

class TaxesScreen extends StatefulWidget {
  const TaxesScreen({super.key});

  @override
  State<TaxesScreen> createState() => _TaxesScreenState();
}

class _TaxesScreenState extends State<TaxesScreen> {
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

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Taxes',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 16),
                  TabBar(
                    isScrollable: true,
                    labelPadding: EdgeInsets.only(right: 32),
                    indicatorPadding: EdgeInsets.zero,
                    indicatorColor: Colors.black,
                    indicatorWeight: 2,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black54,
                    labelStyle: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    tabs: [
                      Tab(text: 'Taxpayers'),
                      Tab(text: 'Tax documents'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            TaxpayersTab(settings: _settings, onUpdate: _updateSetting),
            const TaxDocumentsTab(),
          ],
        ),
      ),
    );
  }
}

class TaxpayersTab extends StatelessWidget {
  final UserSettingsModel? settings;
  final Function(String, dynamic) onUpdate;

  const TaxpayersTab({super.key, this.settings, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Taxpayer information',
            settings?.taxId != null 
              ? 'Tax ID: ${settings?.taxId}\nCountry: ${settings?.taxCountry}'
              : 'Tax info is required for most countries/regions.',
            'Learn more',
            settings?.taxId != null ? 'Edit tax info' : 'Add tax info',
            onPressed: () => _showEditModal(context, 'Taxpayer information', 'taxId', 'taxCountry'),
          ),
          const SizedBox(height: 48),
          _buildSection(
            'Value Added Tax (VAT)',
            settings?.vatNumber != null
              ? 'VAT ID: ${settings?.vatNumber}'
              : 'If you are VAT-registered, please add your VAT ID.',
            'Learn more',
            settings?.vatNumber != null ? 'Edit VAT ID' : 'Add VAT ID Number',
            onPressed: () => _showEditModal(context, 'VAT ID', 'vatNumber', null),
          ),
          const SizedBox(height: 48),
          const _NeedHelpSection(),
        ],
      ),
    );
  }

  void _showEditModal(BuildContext context, String title, String key1, String? key2) {
    final controller1 = TextEditingController(text: settings?.toJson()[key1] ?? '');
    final controller2 = key2 != null ? TextEditingController(text: settings?.toJson()[key2] ?? '') : null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 24, right: 24, top: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              controller: controller1,
              decoration: InputDecoration(
                labelText: key1.contains('taxId') ? 'Tax ID' : 'VAT Number',
                border: const OutlineInputBorder(),
              ),
            ),
            if (key2 != null) ...[
              const SizedBox(height: 16),
              TextField(
                controller: controller2,
                decoration: const InputDecoration(
                  labelText: 'Country/Region',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  onUpdate(key1, controller1.text);
                  if (key2 != null) onUpdate(key2, controller2!.text);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                child: const Text('Save', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String description, String linkText, String actionText, {required VoidCallback onPressed}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
            children: [
              TextSpan(text: '$description '),
              TextSpan(
                text: linkText,
                style: const TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF222222),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
          child: Text(actionText, style: const TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

}

class TaxDocumentsTab extends StatelessWidget {
  const TaxDocumentsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tax documents required for filing taxes are available to review and download here.',
            style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
          ),
          const SizedBox(height: 24),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
              children: [
                TextSpan(text: 'You can also file taxes using detailed earnings info, available in the '),
                TextSpan(
                  text: 'earnings summary.',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 32),
          
          _buildYearlySection('2025'),
          _buildYearlySection('2024'),
          _buildYearlySection('2023'),
          _buildYearlySection('2022'),
          
          const SizedBox(height: 24),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.4),
              children: [
                TextSpan(text: 'For tax documents issued prior to 2022, '),
                TextSpan(
                  text: 'contact us.',
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          const _NeedHelpSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildYearlySection(String year) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(year, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        const Text(
          'No tax document issued',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        const SizedBox(height: 32),
        const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _NeedHelpSection extends StatelessWidget {
  const _NeedHelpSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Need help?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
            children: [
              TextSpan(text: 'Get answers to questions about taxes in our '),
              TextSpan(
                text: 'Help Center.',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
