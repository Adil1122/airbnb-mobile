import 'package:flutter/material.dart';
import '../required_actions_screen.dart';
import '../calendar_settings_screen.dart';
import '../editor/settings/edit_preferences_screen.dart';

class HostingCalendarTab extends StatefulWidget {
  const HostingCalendarTab({super.key});

  @override
  State<HostingCalendarTab> createState() => _HostingCalendarTabState();
}

class _HostingCalendarTabState extends State<HostingCalendarTab> {
  DateTime? _selectedDate;
  bool _isPanelVisible = false;
  
  final List<DateTime> _months = List.generate(12, (index) {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month + index, 1);
  });

  final List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined, color: Colors.black, size: 24),
            onPressed: () => _showCalendarViewSelector(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black, size: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditPreferencesScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            itemCount: _months.length + 1, // +1 for the bottom padding
            itemBuilder: (context, index) {
              if (index == _months.length) {
                return const SizedBox(height: 320); // Space for bottom panel & banner
              }
              
              final monthDate = _months[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: _buildMonthSection(monthDate),
              );
            },
          ),

          // Floating Today Button
          if (!_isPanelVisible)
            Positioned(
              right: 24,
              bottom: 120,
              child: _buildTodayButton(),
            ),

          // Selection Bubble and Panel
          if (_selectedDate != null) ...[
            _buildSelectionBubble(),
            _buildBottomPanel(),
          ],

          // Shared Bottom Banner (Only show if panel is closed)
          if (!_isPanelVisible)
            _buildSharedBottomBanner(),
        ],
      ),
    );
  }

  Widget _buildMonthSection(DateTime monthDate) {
    final String monthName = _monthNames[monthDate.month - 1];
    final int daysInMonth = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    final int startEmptyDays = monthDate.weekday % 7;
    
    final now = DateTime.now();
    final bool isCurrentMonth = monthDate.year == now.year && monthDate.month == now.month;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          monthName,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        // Weekday header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) => Expanded(
            child: Center(
              child: Text(
                day,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          )).toList(),
        ),
        const SizedBox(height: 12),
        // Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.55,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: daysInMonth + startEmptyDays,
          itemBuilder: (context, index) {
            if (index < startEmptyDays) return const SizedBox.shrink();
            
            int dayNumber = index - startEmptyDays + 1;
            bool isToday = isCurrentMonth && dayNumber == now.day;
            DateTime date = DateTime(monthDate.year, monthDate.month, dayNumber);
            bool isSelected = _selectedDate != null && 
                             _selectedDate!.day == dayNumber && 
                             _selectedDate!.month == monthDate.month &&
                             _selectedDate!.year == monthDate.year;

            return _buildDayTile(dayNumber, isToday, isSelected, date);
          },
        ),
      ],
    );
  }

  Widget _buildDayTile(int dayNumber, bool isToday, bool isSelected, DateTime date) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedDate = null;
            _isPanelVisible = false;
          } else {
            _selectedDate = date;
            _isPanelVisible = true;
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey.shade200,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 8),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isToday && !isSelected ? const Color(0xFFFF385C) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$dayNumber',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected || (isToday && !isSelected) ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              '\$21', // Mock price
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.arrow_upward, size: 18, color: Colors.black),
          SizedBox(width: 8),
          Text(
            'Today',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectionBubble() {
    final String monthName = _monthNames[_selectedDate!.month - 1].substring(0, 3);
    return Positioned(
      right: 24,
      bottom: 340,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              '$monthName ${_selectedDate!.day}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() {
              _selectedDate = null;
              _isPanelVisible = false;
            }),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(Icons.close, size: 20, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPanel() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: 320,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildPanelCard(
                    title: 'Available',
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Container(
                          width: 80,
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F7F7),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Stack(
                            children: [
                              AnimatedPositioned(
                                duration: const Duration(milliseconds: 200),
                                right: 4,
                                top: 4,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                                  ),
                                  child: const Icon(Icons.check, size: 20, color: Colors.black),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildPanelCard(
                    title: 'Last-minute price',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              '\$21',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '\$22',
                              style: TextStyle(
                                fontSize: 16, 
                                color: Colors.grey, 
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildPanelCard(
              title: 'Custom settings',
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.add, size: 24, color: Colors.black),
                ],
              ),
              fullWidth: true,
            ),
          ],
        ),
      ),
    );
  }

  void _showCalendarViewSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Calendar view', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              _buildViewOption('Year', false),
              _buildViewOption('Month', true),
              _buildViewOption('List', false),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF222222),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _buildViewOption(String label, bool isSelected) {
    return Container(
      color: isSelected ? const Color(0xFFF7F7F7) : Colors.transparent,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        title: Text(label, style: const TextStyle(fontSize: 16)),
        trailing: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: isSelected ? Colors.black : Colors.grey, width: isSelected ? 8 : 1),
            color: Colors.white,
          ),
        ),
        onTap: () {},
      ),
    );
  }

  Widget _buildPanelCard({required String title, required Widget child, bool fullWidth = false}) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }

  Widget _buildSharedBottomBanner() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RequiredActionsScreen()),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, -4),
              ),
            ],
            border: Border(top: BorderSide(color: Colors.grey.shade100)),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Confirm a few key details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Required to publish', style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
