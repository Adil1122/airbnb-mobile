import 'package:flutter/material.dart';

class CalendarSettingsScreen extends StatefulWidget {
  const CalendarSettingsScreen({super.key});

  @override
  State<CalendarSettingsScreen> createState() => _CalendarSettingsScreenState();
}

class _CalendarSettingsScreenState extends State<CalendarSettingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _smartPricing = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Settings',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                const Text(
                  'These settings apply to all nights, unless you customize them by date.',
                  style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
          
          // Custom TabBar
          Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.black,
              indicatorWeight: 3,
              labelPadding: const EdgeInsets.symmetric(vertical: 12),
              tabs: const [
                Text('Pricing', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Availability', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPricingTab(),
                _buildAvailabilityTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildSectionHeader('Base price', rightAction: 'USD'),
        const SizedBox(height: 16),
        _buildSettingCard(
          title: 'Per night',
          value: '\$22',
          isLargeValue: true,
        ),
        const SizedBox(height: 12),
        _buildSettingCard(
          title: 'Custom weekend price',
          value: '\$38',
          isLargeValue: true,
          rightAction: 'Remove',
        ),
        const SizedBox(height: 12),
        _buildSettingCard(
          title: 'Smart Pricing',
          child: Switch(
            value: _smartPricing,
            onChanged: (v) => setState(() => _smartPricing = v),
            activeColor: Colors.black,
          ),
        ),
        const SizedBox(height: 48),

        _buildSectionHeader('Discounts'),
        const Text(
          'Adjust your pricing to attract more guests.',
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
        const SizedBox(height: 16),
        _buildSettingCard(
          title: 'Weekly',
          subtitle: 'For 7 nights or more',
          value: '10%',
          description: 'Weekly average is \$167',
          isLargeValue: true,
        ),
        const SizedBox(height: 12),
        _buildSettingCard(
          title: 'Monthly',
          subtitle: 'For 28 nights or more',
          value: '20%',
          description: 'Monthly average is \$630',
          isLargeValue: true,
        ),
        const SizedBox(height: 12),
        _buildNavCard('Set up discounts', subtitle: 'Early bird, last-minute'),
        const SizedBox(height: 48),

        _buildSectionHeader('Promotions'),
        const Text(
          'Set short-term discounts to get new bookings.',
          style: TextStyle(color: Colors.black54, fontSize: 14),
        ),
        const SizedBox(height: 16),
        _buildNavCard('Add new listing promotion', subtitle: 'Get your first guests in the door'),
        const SizedBox(height: 48),

        _buildSectionHeader('Additional charges'),
        const SizedBox(height: 16),
        _buildNavCard('Fees', subtitle: 'Cleaning, pets, extra guests'),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildAvailabilityTab() {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        _buildSectionHeader('Trip length'),
        const SizedBox(height: 16),
        _buildSettingCard(
          child: Column(
            children: [
              _buildSimpleRow('Minimum nights', '1'),
              const Divider(height: 32),
              _buildSimpleRow('Maximum nights', '365'),
            ],
          ),
        ),
        const SizedBox(height: 48),

        _buildSectionHeader('Availability'),
        const SizedBox(height: 16),
        _buildNavCard('Advance notice', subtitle: 'Same day'),
        const SizedBox(height: 12),
        _buildNavCard('Same day advance notice', subtitle: '12:00 AM'),
        const SizedBox(height: 12),
        _buildNavCard('Preparation time', subtitle: 'None'),
        const SizedBox(height: 12),
        _buildNavCard('Availability window', subtitle: '12 months in advance'),
        const SizedBox(height: 12),
        _buildNavCard('More availability settings', subtitle: 'Restrict check-in and checkout days'),
        const SizedBox(height: 48),

        _buildSectionHeader('Connect calendars'),
        const Text(
          'Sync all of your hosting calendars so they automatically stay up to date.',
          style: TextStyle(color: Colors.black54, fontSize: 14, height: 1.4),
        ),
        const SizedBox(height: 16),
        _buildNavCard('Connect to another website', icon: Icons.link),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {String? rightAction}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          if (rightAction != null)
            Text(
              rightAction,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
            ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({String? title, String? subtitle, String? value, String? description, String? rightAction, bool isLargeValue = false, Widget? child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: child ?? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null) Text(title, style: const TextStyle(fontSize: 16)),
                  if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54)),
                ],
              ),
              if (rightAction != null)
                Text(
                  rightAction,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                ),
            ],
          ),
          if (value != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: TextStyle(fontSize: isLargeValue ? 32 : 18, fontWeight: FontWeight.bold),
                ),
                if (description != null)
                  Text(description, style: const TextStyle(fontSize: 13, color: Colors.black54)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNavCard(String title, {String? subtitle, IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: Colors.black),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16)),
                if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildSimpleRow(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16)),
        Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
