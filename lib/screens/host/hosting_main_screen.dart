import 'package:flutter/material.dart';
import 'tabs/hosting_today_tab.dart';
import 'tabs/hosting_placeholder_tab.dart';
import 'tabs/hosting_calendar_tab.dart';
import 'tabs/hosting_messages_tab.dart';
import 'tabs/hosting_listings_tab.dart';
import 'tabs/hosting_menu_tab.dart';

class HostingMainScreen extends StatefulWidget {
  const HostingMainScreen({super.key});

  @override
  State<HostingMainScreen> createState() => _HostingMainScreenState();
}

class _HostingMainScreenState extends State<HostingMainScreen> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const HostingTodayTab(),
    const HostingCalendarTab(),
    const HostingListingsTab(),
    const HostingMessagesTab(),
    const HostingMenuTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFE31C5F),
        unselectedItemColor: Colors.grey.shade600,
        showUnselectedLabels: true,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Icon(
                _currentIndex == 0 ? Icons.bookmark : Icons.bookmark_border,
                size: 28,
              ),
            ),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Icon(
                _currentIndex == 1 ? Icons.calendar_today : Icons.calendar_today_outlined,
                size: 28,
              ),
            ),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Icon(
                _currentIndex == 2 ? Icons.view_quilt : Icons.view_quilt_outlined,
                size: 28,
              ),
            ),
            label: 'Listings',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Icon(
                _currentIndex == 3 ? Icons.chat_bubble : Icons.chat_bubble_outline,
                size: 28,
              ),
            ),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: const Padding(
              padding: EdgeInsets.only(bottom: 4.0),
              child: Icon(Icons.menu, size: 28),
            ),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
