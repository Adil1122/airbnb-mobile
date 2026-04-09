import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int _selectedCategoryIndex = 0;
  int _activeStep = 0; // 0: Where, 1: When, 2: Who/What
  
  // Counters for Guests
  int _adults = 0;
  int _children = 0;
  int _infants = 0;
  int _pets = 0;

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
                      : _buildCollapsedCard('Where', 'Peshawar', onTap: () => setState(() => _activeStep = 0)),
                    
                    const SizedBox(height: 12),
                    
                    // Step 2: "When?"
                    _activeStep == 1 
                      ? _buildExpandedWhen(sharesAltWhen) 
                      : _buildCollapsedCard('When', 'Add dates', onTap: () => setState(() => _activeStep = 1)),
                    
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
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Peshawar, Khyber Pakhtunkhwa',
                      hintStyle: TextStyle(color: Colors.black, fontSize: 16),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.cancel, color: Colors.black26, size: 20),
                  onPressed: () {},
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
            if (isExperience) ...[
              _buildSuggestionItem(Icons.architecture, 'New York', 'For its stunning architecture', const Color(0xFFF2F7FB), Colors.brown),
              _buildSuggestionItem(Icons.temple_buddhist, 'Bangkok, Thailand', 'For its top-notch dining', const Color(0xFFF2F9F3), Colors.green),
              _buildSuggestionItem(Icons.nightlife, 'Istanbul, Türkiye', 'For its bustling nightlife', const Color(0xFFFEF4F4), Colors.blueGrey),
              _buildSuggestionItem(Icons.public, 'Mississauga, Canada', 'For a trip abroad', const Color(0xFFF2F7FB), Colors.blue),
            ] else ...[
              _buildSuggestionItem(Icons.near_me, 'Nearby', 'Find what\'s around you', const Color(0xFFF2F7FB), Colors.blue),
              _buildSuggestionItem(Icons.house_siding, 'Nathia Gali, Khyber Pakhtunkhwa', 'Near you', const Color(0xFFFEF4F4), Colors.redAccent),
              _buildSuggestionItem(Icons.location_city, 'Lahore, Punjab', 'Popular with travelers near you', const Color(0xFFF2F9F3), Colors.green),
              _buildSuggestionItem(Icons.waves, 'Peshawar, Khyber Pakhtunkhwa', 'A hidden gem', const Color(0xFFF2F7FB), Colors.lightBlue),
            ],
          ] else
            const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSuggestionItem(IconData icon, String title, String subtitle, Color bgColor, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => setState(() => _activeStep = 1),
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
                  _buildQuickDateBtn('Today', 'Apr 9'),
                  const SizedBox(width: 12),
                  _buildQuickDateBtn('Tomorrow', 'Apr 10'),
                  const SizedBox(width: 12),
                  _buildQuickDateBtn('This weekend', 'Apr 10–12'),
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
          const Text(
            'April 2026',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          // Calendar Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: 35, 
            itemBuilder: (context, index) {
              int day = index - 2; 
              if (day < 1 || day > 30) return const SizedBox();
              bool isSelected = day == 15;
              return Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$day',
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                      color: isSelected ? Colors.white : (day < 6 ? Colors.grey.shade400 : Colors.black),
                      decoration: day < 6 ? TextDecoration.lineThrough : null,
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

  Widget _buildQuickDateBtn(String title, String date) {
    return Container(
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
          Text(date, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        ],
      ),
    );
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
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildServiceChip(Icons.camera_alt_outlined, 'Photography'),
              _buildServiceChip(Icons.restaurant_outlined, 'Chefs'),
              _buildServiceChip(Icons.airline_seat_flat_outlined, 'Massage'),
              _buildServiceChip(Icons.shopping_basket_outlined, 'Prepared meals'),
              _buildServiceChip(Icons.timer_outlined, 'Training'),
              _buildServiceChip(Icons.brush_outlined, 'Makeup'),
              _buildServiceChip(Icons.content_cut_outlined, 'Hair'),
              _buildServiceChip(Icons.spa_outlined, 'Spa treatments'),
              _buildServiceChip(Icons.flatware_outlined, 'Catering'),
              _buildServiceChip(Icons.fingerprint_outlined, 'Nails'),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildServiceChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Colors.black87),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87),
          ),
        ],
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE31C5F),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: const Row(
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
}
