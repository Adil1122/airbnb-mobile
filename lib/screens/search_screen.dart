import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../services/property_service.dart';
import '../services/experience_service.dart';
import '../services/service_service.dart';
import '../services/destination_service.dart';

class SearchScreen extends StatefulWidget {
  final int initialCategoryIndex;
  const SearchScreen({super.key, this.initialCategoryIndex = 0});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late int _selectedCategoryIndex;
  int _activeStep = 0; // 0: Where, 1: When, 2: Who/What
  
  // Counters for Guests
  int _adults = 0;
  int _children = 0;
  int _infants = 0;
  int _pets = 0;

  final _locationController = TextEditingController();
  final _propertyService = PropertyService();
  final _experienceService = ExperienceService();
  final _serviceService = ServiceService();
  final _destinationService = DestinationService();
  
  bool _isSearching = false;
  List<Destination> _destinations = [];
  List<String> _serviceCategories = [];
  String? _selectedServiceCategory;

  // Date picker state
  DateTime? _startDate;
  DateTime? _endDate;
  late DateTime _viewDate;

  final List<String> _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December'
  ];

  @override
  void initState() {
    super.initState();
    _selectedCategoryIndex = widget.initialCategoryIndex;
    _loadDestinations();
    _loadServiceCategories();
    _viewDate = DateTime.now();
  }

  Future<void> _loadServiceCategories() async {
    final categories = await _serviceService.fetchServiceCategories();
    if (mounted) {
      setState(() {
        _serviceCategories = categories;
      });
    }
  }

  Future<void> _loadDestinations() async {
    final results = await _destinationService.fetchDestinations();
    if (mounted) {
      setState(() {
        _destinations = results;
      });
    }
  }

  final List<Map<String, dynamic>> _categories = [
    {'label': 'Homes', 'icon': Icons.home_filled},
    {'label': 'Experiences', 'icon': Icons.wb_sunny_rounded},
    {'label': 'Services', 'icon': Icons.notifications_active},
  ];

  @override
  Widget build(BuildContext context) {
    bool isExperience = _selectedCategoryIndex == 1;
    bool isService = _selectedCategoryIndex == 2;
    bool sharesAltWhen = isExperience || isService;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation & Close
            _buildTopNav(),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    
                    // Step 1: "Where?"
                    _activeStep == 0 
                      ? _buildExpandedWhere(isExperience, isService) 
                      : _buildCollapsedCard('Where', _locationController.text.isEmpty ? 'Search destinations' : _locationController.text, onTap: () => setState(() => _activeStep = 0)),
                    
                    const SizedBox(height: 12),
                    
                    // Step 2: "When?"
                    _activeStep == 1 
                      ? _buildExpandedWhen(sharesAltWhen) 
                      : _buildCollapsedCard('When', _formatDateRange(), onTap: () => setState(() => _activeStep = 1)),
                    
                    const SizedBox(height: 12),
                    
                    // Step 3: "Who?" or "What?"
                    _activeStep == 2 
                      ? (isService ? _buildExpandedWhat() : _buildExpandedWho(isExperience)) 
                      : _buildCollapsedCard(
                          isService ? 'What' : 'Who', 
                          isService ? 'Add service' : 'Add guests', 
                          onTap: () => setState(() => _activeStep = 2)
                        ),
                    
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
            
            // Bottom Action Bar
            _buildBottomBar(sharesAltWhen),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNav() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 44), 
          Row(
            children: List.generate(_categories.length, (index) {
              final isSelected = _selectedCategoryIndex == index;
              return GestureDetector(
                onTap: () => setState(() {
                  _selectedCategoryIndex = index;
                  // If switching to services and on who step, stay on step 2/3 but update content
                }),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 2.5,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _categories[index]['icon'],
                        size: 28,
                        color: isSelected ? Colors.black : Colors.grey.shade400,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _categories[index]['label'],
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? Colors.black : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black12),
              ),
              child: const Icon(Icons.close, size: 20, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedWhere(bool isExperience, bool isService) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Where?',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          ),
          const SizedBox(height: 20),
          // Search Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black45, width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.search, color: Colors.black, size: 22),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      hintText: 'Search destinations',
                      hintStyle: TextStyle(color: Colors.black54, fontSize: 16),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.cancel, color: Colors.black26, size: 20),
                  onPressed: () {
                    _locationController.clear();
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          if (!isService) ...[
            const SizedBox(height: 24),
            const Text(
              'Suggested destinations',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            ..._destinations.map((dest) => _buildSuggestionItemFromBackend(dest)),
          ] else
            const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSuggestionItemFromBackend(Destination dest) {
    IconData icon;
    Color iconColor;
    Color bgColor;

    switch (dest.type) {
      case 'nearby':
        icon = Icons.near_me;
        iconColor = Colors.blue;
        bgColor = const Color(0xFFF2F7FB);
        break;
      case 'trending':
        icon = Icons.trending_up;
        iconColor = Colors.redAccent;
        bgColor = const Color(0xFFFEF4F4);
        break;
      case 'popular':
        icon = Icons.location_city;
        iconColor = Colors.green;
        bgColor = const Color(0xFFF2F9F3);
        break;
      default:
        icon = Icons.location_on;
        iconColor = Colors.orange;
        bgColor = const Color(0xFFFFF7F0);
    }

    return _buildSuggestionItem(icon, dest.title, dest.subtitle, bgColor, iconColor);
  }

  Widget _buildSuggestionItem(IconData icon, String title, String subtitle, Color bgColor, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          _locationController.text = title;
          setState(() => _activeStep = 1);
        },
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedWhen(bool sharesAltWhen) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'When?',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          ),
          const SizedBox(height: 20),
          if (sharesAltWhen)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              child: Row(
                children: [
                  _buildQuickDateBtn('Today', DateTime.now()),
                  const SizedBox(width: 12),
                  _buildQuickDateBtn('Tomorrow', DateTime.now().add(const Duration(days: 1))),
                  const SizedBox(width: 12),
                  _buildQuickDateBtn('This weekend', _getThisWeekend()),
                ],
              ),
            )
          else ...[
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: const Text('Dates', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: const Text('Flexible', style: TextStyle(fontWeight: FontWeight.w500)),
                    ),
                  ),
                ],
              ),
            ),
          ],
          
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_monthNames[_viewDate.month - 1]} ${_viewDate.year}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => setState(() {
                      _viewDate = DateTime(_viewDate.year, _viewDate.month - 1);
                    }),
                    icon: const Icon(Icons.chevron_left),
                  ),
                  IconButton(
                    onPressed: () => setState(() {
                      _viewDate = DateTime(_viewDate.year, _viewDate.month + 1);
                    }),
                    icon: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Day initials
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa']
                .map((d) => Text(d, style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.bold)))
                .toList(),
          ),
          const SizedBox(height: 16),
          // Calendar Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
            ),
            itemCount: 42, // 6 weeks
            itemBuilder: (context, index) {
              final firstDayOfMonth = DateTime(_viewDate.year, _viewDate.month, 1);
              final firstDayOfWeek = firstDayOfMonth.weekday % 7; // 0 for Sunday
              final dayNum = index - firstDayOfWeek + 1;
              final totalDays = DateTime(_viewDate.year, _viewDate.month + 1, 0).day;

              if (dayNum < 1 || dayNum > totalDays) return const SizedBox();

              final date = DateTime(_viewDate.year, _viewDate.month, dayNum);
              final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));
              
              bool isSelected = false;
              bool isInRange = false;
              bool isStart = false;
              bool isEnd = false;

              if (_startDate != null && _endDate != null) {
                if (date.isAtSameMomentAs(_startDate!) || (date.isAfter(_startDate!) && date.isBefore(_endDate!)) || date.isAtSameMomentAs(_endDate!)) {
                  isSelected = true;
                  isInRange = true;
                }
                if (date.isAtSameMomentAs(_startDate!)) isStart = true;
                if (date.isAtSameMomentAs(_endDate!)) isEnd = true;
              } else if (_startDate != null && date.isAtSameMomentAs(_startDate!)) {
                isSelected = true;
                isStart = true;
              }

              return GestureDetector(
                onTap: isPast ? null : () => _onDateTap(date),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$dayNum',
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                      color: isSelected 
                          ? Colors.white 
                          : (isPast ? Colors.grey.shade300 : Colors.black),
                      decoration: isPast ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              );
            },
          ),
          if (!sharesAltWhen) ...[
            const SizedBox(height: 32),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSmallChip('Exact dates', isSelected: true),
                  const SizedBox(width: 8),
                  _buildSmallChip('± 1 day'),
                  const SizedBox(width: 8),
                  _buildSmallChip('± 2 days'),
                  const SizedBox(width: 8),
                  _buildSmallChip('± 3 days'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickDateBtn(String title, dynamic dateInfo) {
    String dateStr = '';
    if (dateInfo is DateTime) {
      dateStr = '${_monthNames[dateInfo.month - 1].substring(0, 3)} ${dateInfo.day}';
    } else if (dateInfo is Map<String, DateTime>) {
      final start = dateInfo['start']!;
      final end = dateInfo['end']!;
      dateStr = '${_monthNames[start.month - 1].substring(0, 3)} ${start.day}–${end.day}';
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          if (dateInfo is DateTime) {
            _startDate = dateInfo;
            _endDate = dateInfo.add(const Duration(days: 1));
          } else if (dateInfo is Map<String, DateTime>) {
            _startDate = dateInfo['start'];
            _endDate = dateInfo['end'];
          }
        });
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300, width: 1.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            const SizedBox(height: 4),
            Text(dateStr, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
          ],
        ),
      ),
    );
  }

  Map<String, DateTime> _getThisWeekend() {
    final now = DateTime.now();
    final friday = now.add(Duration(days: (5 - now.weekday + 7) % 7));
    final sunday = friday.add(const Duration(days: 2));
    return {'start': friday, 'end': sunday};
  }

  void _onDateTap(DateTime date) {
    setState(() {
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = date;
        _endDate = null;
      } else if (_startDate != null && date.isBefore(_startDate!)) {
        _startDate = date;
      } else if (_startDate != null && date.isAfter(_startDate!)) {
        _endDate = date;
      } else {
        _startDate = null;
        _endDate = null;
      }
    });
  }

  String _formatDateRange() {
    if (_startDate == null) return 'Add dates';
    final startStr = '${_monthNames[_startDate!.month - 1].substring(0, 3)} ${_startDate!.day}';
    if (_endDate == null) return startStr;
    final endStr = '${_monthNames[_endDate!.month - 1].substring(0, 3)} ${_endDate!.day}';
    return '$startStr – $endStr';
  }

  Widget _buildSmallChip(String label, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300, width: isSelected ? 2 : 1),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (label.contains('±')) Icon(Icons.add, size: 14, color: isSelected ? Colors.black : Colors.grey),
          if (label.contains('±')) const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? Colors.black : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedWho(bool isExperience) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Who?',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          ),
          const SizedBox(height: 24),
          _buildGuestRow('Adults', 'Ages 13 or above', _adults, (val) => setState(() => _adults = val)),
          _buildGuestRow('Children', 'Ages 2 – 12', _children, (val) => setState(() => _children = val)),
          _buildGuestRow('Infants', 'Under 2', _infants, (val) => setState(() => _infants = val), isLast: !isExperience),
          if (!isExperience)
            _buildGuestRow('Pets', 'Bringing a service animal?', _pets, (val) => setState(() => _pets = val), isLast: true),
        ],
      ),
    );
  }

  Widget _buildExpandedWhat() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Type of service',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          ),
          const SizedBox(height: 24),
          if (_serviceCategories.isEmpty)
             const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('No service types available', style: TextStyle(color: Colors.grey)))),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _serviceCategories.map((cat) => _buildServiceChip(_getServiceIcon(cat), cat)).toList(),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  IconData _getServiceIcon(String category) {
    switch (category.toLowerCase()) {
      case 'photography': return Icons.camera_alt_outlined;
      case 'chef': return Icons.restaurant_outlined;
      case 'massage': return Icons.airline_seat_flat_outlined;
      case 'prepared meals': return Icons.shopping_basket_outlined;
      case 'training': return Icons.timer_outlined;
      case 'makeup': return Icons.brush_outlined;
      case 'hair': return Icons.content_cut_outlined;
      case 'spa treatments': return Icons.spa_outlined;
      case 'catering': return Icons.flatware_outlined;
      case 'nails': return Icons.fingerprint_outlined;
      default: return Icons.home_repair_service_outlined;
    }
  }

  Widget _buildServiceChip(IconData icon, String label) {
    final isSelected = _selectedServiceCategory == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          if (_selectedServiceCategory == label) {
            _selectedServiceCategory = null;
          } else {
            _selectedServiceCategory = label;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade300, width: 1.2),
          borderRadius: BorderRadius.circular(32),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: isSelected ? Colors.white : Colors.black87),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isSelected ? Colors.white : Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestRow(String title, String subtitle, int value, Function(int) onChanged, {bool isLast = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                        decoration: title == 'Pets' ? TextDecoration.underline : null,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _buildCounterBtn(Icons.remove, value > 0, () => value > 0 ? onChanged(value - 1) : null),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text('$value', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  ),
                  _buildCounterBtn(Icons.add, true, () => onChanged(value + 1)),
                ],
              ),
            ],
          ),
          if (!isLast)
            const Padding(
              padding: EdgeInsets.only(top: 24.0),
              child: Divider(height: 1),
            ),
        ],
      ),
    );
  }

  Widget _buildCounterBtn(IconData icon, bool enabled, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: enabled ? Colors.black38 : Colors.black12),
        ),
        child: Icon(icon, size: 20, color: enabled ? Colors.black87 : Colors.black12),
      ),
    );
  }

  Widget _buildCollapsedCard(String title, String currentSelection, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            Text(
              currentSelection,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(bool sharesAltWhen) {
    bool isStep2 = _activeStep == 1;
    
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () {
              if (isStep2 && sharesAltWhen) {
                setState(() => _activeStep = 2);
              } else if (isStep2 && !sharesAltWhen) {
                // Reset
              } else {
                setState(() {
                  _adults = _children = _infants = _pets = 0;
                  _startDate = null;
                  _endDate = null;
                });
              }
            },
            child: Text(
              (isStep2 && sharesAltWhen) ? 'Skip' : (isStep2 ? 'Reset' : 'Clear all'),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          isStep2 
          ? SizedBox(
              width: 130,
              child: ElevatedButton(
                onPressed: () => setState(() => _activeStep = 2),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                child: const Text('Next', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            )
          : ElevatedButton(
              onPressed: _isSearching ? null : _performSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE31C5F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: _isSearching 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Row(
                children: [
                  Icon(Icons.search, size: 22),
                  SizedBox(width: 8),
                  Text(
                    'Search',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _performSearch() async {
    setState(() => _isSearching = true);
    
    try {
      List<Listing> results = [];
      String location = _locationController.text.trim();
      
      // Cleanup placeholders
      if (location == 'Search destinations') {
        location = '';
      }

      print('DEBUG: Performing search - category: $_selectedCategoryIndex, location: "$location", adults: $_adults, children: $_children, infants: $_infants, pets: $_pets');

      final startDateStr = _startDate?.toIso8601String().split('T')[0];
      final endDateStr = _endDate?.toIso8601String().split('T')[0];

      if (_selectedCategoryIndex == 0) {
        results = await _propertyService.searchProperties(
          location: location,
          adults: _adults > 0 ? _adults : null,
          children: _children > 0 ? _children : null,
          infants: _infants > 0 ? _infants : null,
          pets: _pets > 0 ? _pets : null,
          startDate: startDateStr,
          endDate: endDateStr,
        );
      } else if (_selectedCategoryIndex == 1) {
        results = await _experienceService.searchExperiences(
          location: location,
          adults: _adults > 0 ? _adults : null,
          children: _children > 0 ? _children : null,
          infants: _infants > 0 ? _infants : null,
          pets: _pets > 0 ? _pets : null,
          startDate: startDateStr,
          endDate: endDateStr,
        );
      } else {
        results = await _serviceService.searchServices(
          location: location,
          adults: _adults > 0 ? _adults : null,
          children: _children > 0 ? _children : null,
          infants: _infants > 0 ? _infants : null,
          pets: _pets > 0 ? _pets : null,
          startDate: startDateStr,
          endDate: endDateStr,
          category: _selectedServiceCategory,
        );
      }

      print('DEBUG: Search returned ${results.length} results');

      if (mounted) {
        Navigator.pop(context, {
          'results': results,
          'categoryIndex': _selectedCategoryIndex,
          'startDate': startDateStr,
          'endDate': endDateStr,
        });
      }
    } catch (e) {
      print('Search error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Search failed: ${e.toString().split(':').last.trim()}'),
            backgroundColor: const Color(0xFFE61E4D),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }
}
