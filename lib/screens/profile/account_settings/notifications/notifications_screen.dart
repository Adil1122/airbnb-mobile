import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Text(
              'Notifications',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          
          // TabBar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelPadding: const EdgeInsets.only(right: 32),
              indicatorPadding: const EdgeInsets.only(right: 32),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.black,
              indicatorWeight: 2,
              tabs: const [
                Tab(text: 'Offers and updates'),
                Tab(text: 'Account'),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOffersAndUpdatesTab(),
                _buildAccountTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOffersAndUpdatesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          
          _buildNotificationSection(
            title: 'Hosting insights and rewards',
            description: 'Learn about best hosting practices, and get access to exclusive hosting perks.',
            items: [
              _buildNotificationItem(
                'Recognition and achievements',
                'Get recognized for reaching hosting milestones and Superhost status.',
              ),
              _buildNotificationItem(
                'Insights and tips',
                'Learn about best hosting practices and get access to exclusive hosting perks.',
              ),
              _buildNotificationItem(
                'Pricing trends and suggestions',
                'Optimize your price with data-backed tips and insights.',
              ),
              _buildNotificationItem(
                'Hosting perks',
                'Take advantage of Airbnb perks like discounts on partner products and special promotions.',
              ),
            ],
          ),
          
          _buildNotificationSection(
            title: 'Hosting updates',
            description: 'Get updates about programs, features, and regulations.',
            items: [
              _buildNotificationItem(
                'News and updates',
                'Be first to know about new tools and changes to the app and our service.',
              ),
              _buildNotificationItem(
                'Local laws and regulations',
                'Stay up to date on laws and regulations in your area.',
              ),
            ],
          ),
          
          _buildNotificationSection(
            title: 'Travel tips and offers',
            description: 'Inspire your next trip with personalized recommendations and special offers.',
            items: [
              _buildNotificationItem(
                'Inspiration and offers',
                'Get personalized recommendations and special offers.',
              ),
              _buildNotificationItem(
                'Trip planning',
                'Get tips and suggestions for planning your next trip.',
              ),
            ],
          ),
          
          _buildNotificationSection(
            title: 'Airbnb updates',
            description: 'Stay up to date on the latest news from Airbnb, and let us know how we can improve.',
            items: [
              _buildNotificationItem(
                'News and programs',
                'Stay up to date on the latest news from Airbnb.',
              ),
              _buildNotificationItem(
                'Feedback',
                'Help us improve by providing feedback on your experience.',
              ),
              _buildNotificationItem(
                'Travel regulations',
                'Stay up to date on travel regulations.',
              ),
            ],
          ),
          
          _buildNotificationSection(
            title: 'Unsubscribe from all offers and updates',
            description: 'You\'ll continue to get notifications about your account activity.',
            items: [
              _buildNotificationItem(
                'All offers and updates',
                'Unsubscribe from all non-transactional emails and notifications.',
                isUnsubscribe: true,
              ),
            ],
            isLast: true,
          ),
          
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildAccountTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          
          _buildNotificationSection(
            title: 'Account activity and policies',
            description: 'Confirm your booking and account activity, and learn about important Airbnb policies.',
            items: [
              _buildNotificationItem(
                'Account activity',
                'Get updates on your account activity and security.',
              ),
              _buildNotificationItem(
                'Listing activity',
                'Get updates on your listing activity.',
                status: 'On: Email, Push, and SMS',
              ),
              _buildNotificationItem(
                'Guest policies',
                'Keep up to date on important info about using Airbnb.',
              ),
              _buildNotificationItem(
                'Host policies',
                'Keep up to date on important info about hosting on Airbnb.',
              ),
            ],
          ),
          
          _buildNotificationSection(
            title: 'Reminders',
            description: 'Get important reminders about your reservations, listings, and account activity.',
            items: [
              _buildNotificationItem(
                'Reminders',
                'Get important reminders about your reservations, listings, and account activity.',
              ),
            ],
          ),
          
          _buildNotificationSection(
            title: 'Guest and Host messages',
            description: 'Keep in touch with hosts and guests before, during, and after your reservation.',
            items: [
              _buildNotificationItem(
                'Messages',
                'Never miss important messages from your Hosts or guests.',
                channels: ['Email', 'Push notifications', 'SMS'],
              ),
            ],
            isLast: true,
          ),
          
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildNotificationSection({
    required String title, 
    required String description, 
    required List<Widget> items,
    bool isLast = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        Text(
          description,
          style: const TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
        ),
        const SizedBox(height: 32),
        ...items,
        if (!isLast) const Divider(height: 64, thickness: 1, color: Color(0xFFF0F0F0)),
      ],
    );
  }

  Widget _buildNotificationItem(String title, String description, {String status = 'On: Email and Push', bool isUnsubscribe = false, List<String>? channels}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
                const SizedBox(height: 4),
                Text(status, style: const TextStyle(fontSize: 15, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: () {
              if (isUnsubscribe) {
                _showUnsubscribeModal(context);
              } else {
                _showEditNotificationModal(context, title, description, channels: channels);
              }
            },
            child: const Text(
              'Edit',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showUnsubscribeModal(BuildContext context) {
    bool email = true;
    bool push = false;
    bool sms = false;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'We’d love to stay in touch',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'But you\'re in control. Choose the notifications you\'d like to keep, or unsubscribe completely.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              _buildCheckboxRow('Email', 'All on', email, (val) => setModalState(() => email = val)),
              const SizedBox(height: 32),
              _buildCheckboxRow('Push notifications', 'All on', push, (val) => setModalState(() => push = val)),
              const SizedBox(height: 32),
              _buildCheckboxRow('SMS', 'All off', sms, (val) => setModalState(() => sms = val)),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCheckboxRow(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 18, color: Colors.black87)),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.black54)),
          ],
        ),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: value ? Colors.black : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: value ? Colors.black : Colors.black12, width: 2),
            ),
            child: value ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
          ),
        ),
      ],
    );
  }

  void _showEditNotificationModal(BuildContext context, String title, String description, {List<String>? channels}) {
    final List<String> channelList = channels ?? ['Email', 'Push notifications', 'SMS', 'Phone calls'];
    
    // Initial states
    final Map<String, bool> preferenceStates = {
      'Email': true,
      'Push notifications': true,
      'SMS': false,
      'Phone calls': false,
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 32),
              ...channelList.map((channel) => Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: _buildPreferenceRow(
                  channel, 
                  preferenceStates[channel] ?? false, 
                  (val) => setModalState(() => preferenceStates[channel] = val),
                  isDisabled: title == 'Guest policies' && channel == 'Email',
                ),
              )),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPreferenceRow(String title, bool value, ValueChanged<bool> onChanged, {bool isDisabled = false}) {
    return Opacity(
      opacity: isDisabled ? 0.3 : 1.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 18, color: Colors.black87)),
          _buildAirbnbSwitch(isDisabled ? true : value, (val) {
            if (!isDisabled) onChanged(val);
          }),
        ],
      ),
    );
  }

  Widget _buildAirbnbSwitch(bool value, ValueChanged<bool> onChanged) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 50,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: value ? Colors.black : const Color(0xFFB0B0B0),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              left: value ? 20 : 2,
              child: Container(
                width: 28,
                height: 28,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: value 
                  ? const Icon(Icons.check, size: 16, color: Colors.black)
                  : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
