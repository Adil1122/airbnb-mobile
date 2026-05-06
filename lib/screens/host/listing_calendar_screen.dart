import 'package:flutter/material.dart';
import '../../models/listing.dart';
import 'calendar_settings_screen.dart';
import '../../services/host_service.dart';
import 'package:intl/intl.dart';

class ListingCalendarScreen extends StatefulWidget {
  final Listing listing;
  const ListingCalendarScreen({super.key, required this.listing});

  @override
  State<ListingCalendarScreen> createState() => _ListingCalendarScreenState();
}

class _ListingCalendarScreenState extends State<ListingCalendarScreen> {
  final HostService _hostService = HostService();
  bool _isSaving = false;
  DateTime? _selectedDate;
  bool _isPanelVisible = false;
  bool _isBlocked = false;
  String _selectedPolicy = 'Flexible (Default)';
  int _minNights = 1;

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.listing.title,
          style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
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
                MaterialPageRoute(builder: (context) => CalendarSettingsScreen()),
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
            itemCount: _months.length + 1,
            itemBuilder: (context, index) {
              if (index == _months.length) {
                return const SizedBox(height: 350);
              }
              
              final monthDate = _months[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: _buildMonthSection(monthDate),
              );
            },
          ),

          if (!_isPanelVisible)
            Positioned(
              right: 24,
              bottom: 40,
              child: _buildTodayButton(),
            ),

          if (_selectedDate != null) ...[
            _buildSelectionBubble(),
            _buildBottomPanel(),
          ],
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
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
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
            // Mock logic: block some dates for demonstration
            _isBlocked = date.day % 5 == 0; 
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
                color: isSelected ? Colors.white : (isToday ? const Color(0xFFFF385C) : Colors.transparent),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$dayNumber',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.black : (isToday ? Colors.white : Colors.black),
                    decoration: date.day % 5 == 0 ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Text(
              '\$${widget.listing.price.toInt()}',
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              '$monthName ${_selectedDate!.day}',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => setState(() {
              _selectedDate = null;
              _isPanelVisible = false;
            }),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.close, size: 24, color: Colors.white),
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
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.black12)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _buildPanelCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _isBlocked ? 'Blocked by you' : 'Available',
                              style: const TextStyle(color: Colors.white, fontSize: 13),
                            ),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: _isBlocked ? Colors.red : Colors.greenAccent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ),
                        if (_isBlocked) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Add a note',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFF333333),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() => _isSaving = true);
                                    try {
                                      await _hostService.updateCalendar(widget.listing.id.toString(), {
                                        'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
                                        'isAvailable': false,
                                      });
                                      setState(() {
                                        _isBlocked = true;
                                        _isSaving = false;
                                      });
                                    } catch (e) {
                                      setState(() => _isSaving = false);
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: _isBlocked ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.close,
                                        color: _isBlocked ? Colors.black : Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () async {
                                    setState(() => _isSaving = true);
                                    try {
                                      await _hostService.updateCalendar(widget.listing.id.toString(), {
                                        'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
                                        'isAvailable': true,
                                      });
                                      setState(() {
                                        _isBlocked = false;
                                        _isSaving = false;
                                      });
                                    } catch (e) {
                                      setState(() => _isSaving = false);
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: !_isBlocked ? Colors.white : Colors.transparent,
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Center(
                                      child: Icon(
                                        Icons.check,
                                        color: !_isBlocked ? Colors.black : Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
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
                  child: GestureDetector(
                    onTap: () => _showPriceEditorSheet(context),
                    child: _buildPanelCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Last-minute price',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '\$${(widget.listing.price * 0.97).toInt()}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '\$${widget.listing.price.toInt()}',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 16,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          const SizedBox(height: 48), // Spacer to match height
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () => _showCustomSettingsSheet(context),
              child: _buildPanelCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Custom setting',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    if (true) ...[ // Show override summary always if we want '1' to be visible
                      const SizedBox(height: 4),
                      Text(
                        '$_minNights-night min${_selectedPolicy != 'Flexible (Default)' ? ', ${_selectedPolicy.replaceAll(' (Default)', '')} cancellation' : ''}',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ],
                ),
                fullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomSettingsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 380,
              decoration: const BoxDecoration(
                color: Color(0xFF121212),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Custom settings',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 24),
                  // Minimum nights
                  _buildCustomSettingItem(
                    title: 'Minimum nights',
                    value: '$_minNights ${_minNights == 1 ? 'night' : 'nights'}',
                    onTap: () async {
                      await _showMinNightsSheet(context);
                      setModalState(() {}); // Rebuild to show new night count
                    },
                  ),
                  const SizedBox(height: 12),
                  // Cancellation policy
                  _buildCustomSettingItem(
                    title: 'Cancellation policy',
                    // Show '+' if it's the default Flexible policy, to match screenshot
                    value: _selectedPolicy == 'Flexible (Default)' ? null : _selectedPolicy.split(' ').first,
                    onTap: () async {
                      await _showCancellationPolicySheet(context);
                      setModalState(() {}); // Rebuild to show new policy name
                    },
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCustomSettingItem({required String title, String? value, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (value != null)
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.w500,
                ),
              )
            else
              const Icon(Icons.add, color: Colors.white, size: 24),
          ],
        ),
      ),
    );
  }

  Future<void> _showMinNightsSheet(BuildContext context) async {
    await showModalBottomSheet(
// ...
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: 400,
              decoration: const BoxDecoration(
                color: Color(0xFF121212),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Minimum nights',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'This will override your global minimum of 1 night for this date only.',
                    style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.4),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Minus Button
                      GestureDetector(
                        onTap: _minNights > 1 ? () => setModalState(() => _minNights--) : null,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: _minNights > 1 ? Colors.white : Colors.white12),
                          ),
                          child: Icon(Icons.remove, color: _minNights > 1 ? Colors.white : Colors.white12, size: 28),
                        ),
                      ),
                      const SizedBox(width: 48),
                      // Number
                      Text(
                        '$_minNights',
                        style: const TextStyle(color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 48),
                      // Plus Button
                      GestureDetector(
                        onTap: () => setModalState(() => _minNights++),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white),
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 28),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel', style: TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.underline)),
                      ),
                      ElevatedButton(
                        onPressed: _isSaving ? null : () async {
                          setState(() => _isSaving = true);
                          try {
                            await _hostService.updateCalendar(widget.listing.id.toString(), {
                              'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
                              'minNights': _minNights,
                            });
                            setState(() => _isSaving = false);
                            Navigator.pop(context);
                          } catch (e) {
                            setState(() => _isSaving = false);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        child: _isSaving 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                          : const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showCancellationPolicySheet(BuildContext context) async {
    await showModalBottomSheet(
// ...
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.7,
              decoration: const BoxDecoration(
                color: Color(0xFF1E1E1E),
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cancellation policy',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(color: Colors.white70, fontSize: 15, height: 1.4),
                              children: [
                                const TextSpan(text: 'This policy applies to reservations that begin on any of the selected dates. '),
                                TextSpan(
                                  text: 'Learn more',
                                  style: const TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildPolicyOption(
                            'Flexible (Default)',
                            '· Full refund at least 1 day before check-in\n· Partial refund within 1 day of check-in',
                            setModalState,
                          ),
                          const SizedBox(height: 12),
                          _buildPolicyOption(
                            'Moderate',
                            '· Full refund at least 5 days before check-in\n· Partial refund within 5 days of check-in',
                            setModalState,
                          ),
                          const SizedBox(height: 12),
                          _buildPolicyOption(
                            'Limited',
                            '· Full refund at least 14 days before check-in\n· Partial refund 7-14 days before check-in',
                            setModalState,
                          ),
                          const SizedBox(height: 12),
                          _buildPolicyOption(
                            'Firm',
                            '· Full refund at least 30 days before check-in\n· Partial refund 7-30 days before check-in',
                            setModalState,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel', style: TextStyle(color: Colors.white, fontSize: 16, decoration: TextDecoration.underline)),
                      ),
                      ElevatedButton(
                        onPressed: _isSaving ? null : () async {
                          setState(() => _isSaving = true);
                          try {
                            await _hostService.updateCalendar(widget.listing.id.toString(), {
                              'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
                              'cancellationPolicy': _selectedPolicy,
                            });
                            setState(() => _isSaving = false);
                            Navigator.pop(context);
                          } catch (e) {
                            setState(() => _isSaving = false);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          elevation: 0,
                        ),
                        child: _isSaving 
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                          : const Text('Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPolicyOption(String title, String? description, StateSetter setModalState) {
    bool isSelected = _selectedPolicy == title;
    return GestureDetector(
      onTap: () {
        setModalState(() => _selectedPolicy = title);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white12,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (description != null && isSelected) ...[
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(color: Colors.white70, fontSize: 13, height: 1.4),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPriceEditorSheet(BuildContext context) {
    final double basePrice = widget.listing.price;
    final int discountedPrice = (basePrice * 0.97).toInt();
    final TextEditingController priceController = TextEditingController(text: basePrice.toInt().toString());
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final String monthName = _monthNames[_selectedDate!.month - 1].substring(0, 3);
        return Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Color(0xFF121212),
          ),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.help_outline, color: Colors.white, size: 28),
                    Column(
                      children: [
                        Text(
                          '$monthName ${_selectedDate!.day}',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Guest total \$${(discountedPrice * 1.1).toInt()}', // Mock total calculation
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 28),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              // Price Input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: priceController,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  cursorColor: Colors.white,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: const InputDecoration(
                    prefixText: '\$',
                    prefixStyle: TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.bold),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '\$$discountedPrice after 3% last-minute discount',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const Spacer(flex: 2),
// ...
              // Save Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : () async {
                      final price = double.tryParse(priceController.text);
                      if (price == null) return;
                      
                      setState(() => _isSaving = true);
                      try {
                        await _hostService.updateCalendar(widget.listing.id.toString(), {
                          'date': DateFormat('yyyy-MM-dd').format(_selectedDate!),
                          'priceOverride': price,
                        });
                        setState(() => _isSaving = false);
                        Navigator.pop(context);
                      } catch (e) {
                        setState(() => _isSaving = false);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: _isSaving 
                      ? const CircularProgressIndicator(color: Colors.black)
                      : const Text(
                          'Save',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
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

  Widget _buildPanelCard({String? title, required Widget child, bool fullWidth = false}) {
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
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
            const SizedBox(height: 4),
          ],
          child,
        ],
      ),
    );
  }
}
