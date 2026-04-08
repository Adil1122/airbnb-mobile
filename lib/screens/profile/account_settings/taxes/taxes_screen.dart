import 'package:flutter/material.dart';

class TaxesScreen extends StatelessWidget {
  const TaxesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    unselectedLabelStyle: TextStyle(
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
        body: const TabBarView(
          children: [
            TaxpayersTab(),
            TaxDocumentsTab(),
          ],
        ),
      ),
    );
  }
}

class TaxpayersTab extends StatelessWidget {
  const TaxpayersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSection(
            'Taxpayer information',
            'Tax info is required for most countries/regions.',
            'Learn more',
            'Add tax info',
          ),
          const SizedBox(height: 48),
          _buildSection(
            'Value Added Tax (VAT)',
            'If you are VAT-registered, please add your VAT ID.',
            'Learn more',
            'Add VAT ID Number',
          ),
          const SizedBox(height: 48),
          _buildNeedHelpSection(),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String description, String linkText, String actionText) {
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
          onPressed: () {},
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

  Widget _buildNeedHelpSection() {
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
          const TaxpayersTab()._buildNeedHelpSection(),
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
