import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';

// --- Screen 1: Intro ---

class HostStep3IntroScreen extends StatelessWidget {
  const HostStep3IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 24.0, top: 8.0),
            child: OutlinedButton(
              onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Save & exit',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  // Illustration
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: kIsWeb
                          ? Container(
                              height: 300,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.home_work_outlined, size: 64, color: Colors.black26),
                            )
                          : Image.file(
                              File('C:/Users/Computer Arena/.gemini/antigravity/brain/7d4a128d-57c1-4474-a7df-7a99dd1c5a54/airbnb_host_step3_house_illustration_1775467357876.png'),
                              height: 300,
                              fit: BoxFit.contain,
                            ),
                    ),
                  ),
                  const SizedBox(height: 60),
                  
                  // Text Content
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Step 3',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Finish up and publish',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -1.0,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Finally, you’ll choose booking settings, set up pricing, and publish your listing.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
          
          // Progress Bar and Bottom Nav
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade100, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.14, // Step 3, Screen 1/7
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const BookingSettingsScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Screen 2: Booking Settings ---

class BookingSettingsScreen extends StatefulWidget {
  const BookingSettingsScreen({super.key});

  @override
  State<BookingSettingsScreen> createState() => _BookingSettingsScreenState();
}

class _BookingSettingsScreenState extends State<BookingSettingsScreen> {
  String _selectedSetting = 'approve';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 12.0),
          child: OutlinedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Save & exit',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 12.0),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Questions?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Pick your booking settings',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'You can change this at any time. Learn more',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Option 1: Approve
                  _buildOptionCard(
                    id: 'approve',
                    title: 'Approve your first 3 bookings',
                    description: 'Start by reviewing reservation requests, then switch to Instant Book, so guests can book automatically.',
                    icon: Icons.calendar_today_outlined,
                    isRecommended: true,
                  ),
                  const SizedBox(height: 16),
                  
                  // Option 2: Instant Book
                  _buildOptionCard(
                    id: 'instant',
                    title: 'Use Instant Book',
                    description: 'Let guests book automatically.',
                    icon: Icons.bolt,
                  ),
                ],
              ),
            ),
          ),
          
          // Progress Bar and Bottom Nav
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade100, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.28, // Step 3, Screen 2/7
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WeekdayPricingScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required String id,
    required String title,
    required String description,
    required IconData icon,
    bool isRecommended = false,
  }) {
    final isSelected = _selectedSetting == id;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedSetting = id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.black : Colors.black12,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? const Color(0xFFF7F7F7) : Colors.white,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (isRecommended) ...[
                    const SizedBox(height: 4),
                    const Text(
                      'Recommended',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF008A05),
                      ),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              icon,
              size: 32,
              color: isSelected ? Colors.black : Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}

// --- Screen 3: Weekday Pricing ---

class WeekdayPricingScreen extends StatefulWidget {
  const WeekdayPricingScreen({super.key});

  @override
  State<WeekdayPricingScreen> createState() => _WeekdayPricingScreenState();
}

class _WeekdayPricingScreenState extends State<WeekdayPricingScreen> {
  final int _basePrice = 22;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 12.0),
          child: OutlinedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Save & exit',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 12.0),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Questions?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Now, set a weekday base price',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tip: \$22. You’ll set a weekend price next.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 60),
                  
                  // Price Display
                  Center(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '\$$_basePrice',
                              style: const TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.black12),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.edit_outlined, size: 24),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Guest price before taxes \$25',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey.shade600),
                          ],
                        ),
                        const SizedBox(height: 48),
                        
                        // Similar Listings Button
                        OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.location_on, color: Color(0xFFFF385C), size: 18),
                          label: const Text(
                            'View similar listings',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.black12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          'Learn more about pricing',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Progress Bar and Bottom Nav
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade100, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.42, // Step 3, Screen 3/7
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const WeekendPricingScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Screen 4: Weekend Pricing ---

class WeekendPricingScreen extends StatefulWidget {
  const WeekendPricingScreen({super.key});

  @override
  State<WeekendPricingScreen> createState() => _WeekendPricingScreenState();
}

class _WeekendPricingScreenState extends State<WeekendPricingScreen> {
  final double _baseWeekdayPrice = 22.0;
  double _premiumPercentage = 72.0;

  @override
  Widget build(BuildContext context) {
    // Weekend price calculation
    final int weekendPrice = (_baseWeekdayPrice * (1 + _premiumPercentage / 100)).round();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 12.0),
          child: OutlinedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Save & exit',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 12.0),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Questions?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Set a weekend price',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Add a premium for Fridays and Saturdays.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 60),
                  
                  // Price Calculated
                  Center(
                    child: Column(
                      children: [
                        Text(
                          '\$$weekendPrice',
                          style: const TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Guest price before taxes \$26',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 64),
                        
                        // Premium Slider Area
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Weekend premium',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Tip: Try 3%',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black87),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '${_premiumPercentage.round()}%',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.black,
                            inactiveTrackColor: Colors.grey.shade200,
                            thumbColor: const Color(0xFF222222),
                            overlayColor: Colors.black12,
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 18),
                          ),
                          child: Slider(
                            value: _premiumPercentage,
                            max: 99,
                            min: 0,
                            onChanged: (val) {
                              setState(() {
                                _premiumPercentage = val;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('0%', style: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.bold)),
                              Text('99%', style: TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Progress Bar and Bottom Nav
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade100, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.57, // Step 3, Screen 4/7
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const DiscountsScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Screen 5: Discounts ---

class DiscountsScreen extends StatefulWidget {
  const DiscountsScreen({super.key});

  @override
  State<DiscountsScreen> createState() => _DiscountsScreenState();
}

class _DiscountsScreenState extends State<DiscountsScreen> {
  final List<Map<String, dynamic>> _discounts = [
    {
      'id': 'new',
      'percentage': 20,
      'title': 'New listing promotion',
      'description': 'Offer 20% off your first 3 bookings',
      'isSelected': true,
    },
    {
      'id': 'last',
      'percentage': 4,
      'title': 'Last-minute discount',
      'description': 'For stays booked 14 days or less before arrival',
      'isSelected': true,
    },
    {
      'id': 'weekly',
      'percentage': 10,
      'title': 'Weekly discount',
      'description': 'For stays of 7 nights or more',
      'isSelected': true,
    },
    {
      'id': 'monthly',
      'percentage': 20,
      'title': 'Monthly discount',
      'description': 'For stays of 28 nights or more',
      'isSelected': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 12.0),
          child: OutlinedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Save & exit',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 12.0),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Questions?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Add discounts',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Help your place stand out to get booked faster and earn your first reviews.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 48),
                  
                  // Discounts List
                  ..._discounts.map((discount) => _buildDiscountCard(discount)),
                  
                  const SizedBox(height: 24),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                        children: [
                          TextSpan(text: 'Only one discount will be applied per stay. '),
                          TextSpan(
                            text: 'Learn more',
                            style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Progress Bar and Bottom Nav
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade100, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.71, // Step 3, Screen 5/7
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const SafetyDetailsScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountCard(Map<String, dynamic> discount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.black87),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${discount['percentage']}%',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  discount['title'],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  discount['description'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Checkbox(
            value: discount['isSelected'],
            activeColor: Colors.black,
            onChanged: (bool? val) {
              setState(() {
                discount['isSelected'] = val;
              });
            },
          ),
        ],
      ),
    );
  }
}

// --- Screen 6: Safety Details ---

class SafetyDetailsScreen extends StatefulWidget {
  const SafetyDetailsScreen({super.key});

  @override
  State<SafetyDetailsScreen> createState() => _SafetyDetailsScreenState();
}

class _SafetyDetailsScreenState extends State<SafetyDetailsScreen> {
  bool _cameraPresent = false;
  bool _noiseMonitorPresent = false;
  bool _weaponsPresent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 12.0),
          child: OutlinedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Save & exit',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 12.0),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Questions?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Share safety details',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Does your place have any of these?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      Icon(Icons.info_outline, size: 20, color: Colors.grey.shade600),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Checkbox Items
                  _buildCheckboxItem(
                    label: 'Exterior security camera present',
                    value: _cameraPresent,
                    onChanged: (val) => setState(() => _cameraPresent = val!),
                  ),
                  _buildCheckboxItem(
                    label: 'Noise decibel monitor present',
                    value: _noiseMonitorPresent,
                    onChanged: (val) => setState(() => _noiseMonitorPresent = val!),
                  ),
                  _buildCheckboxItem(
                    label: 'Weapon(s) on the property',
                    value: _weaponsPresent,
                    onChanged: (val) => setState(() => _weaponsPresent = val!),
                  ),
                  
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Important things to know',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Security cameras that monitor indoor spaces are not allowed even if they\'re turned off. All exterior security cameras must be disclosed.',
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4, fontFamily: 'Circular'),
                      children: [
                        TextSpan(text: 'Be sure to comply with your '),
                        TextSpan(
                          text: 'local laws',
                          style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        ),
                        TextSpan(text: ' and review Airbnb\'s '),
                        TextSpan(
                          text: 'anti-discrimination policy',
                          style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        ),
                        TextSpan(text: ' and '),
                        TextSpan(
                          text: 'guest and Host fees',
                          style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        ),
                        TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Progress Bar and Bottom Nav
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade100, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Stack(
                        children: [
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          FractionallySizedBox(
                            widthFactor: 0.85, // Step 3, Screen 6/7
                            child: Container(
                              height: 6,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LegalDetailsScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem({
    required String label,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: CheckboxListTile(
        title: Text(
          label,
          style: const TextStyle(fontSize: 17, color: Colors.black),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: Colors.black,
        controlAffinity: ListTileControlAffinity.trailing,
        contentPadding: EdgeInsets.zero,
        checkboxShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }
}

// --- Screen 7: Legal Details ---

class LegalDetailsScreen extends StatefulWidget {
  const LegalDetailsScreen({super.key});

  @override
  State<LegalDetailsScreen> createState() => _LegalDetailsScreenState();
}

class _LegalDetailsScreenState extends State<LegalDetailsScreen> {
  bool _isBusiness = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leadingWidth: 120,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0, top: 12.0),
          child: OutlinedButton(
            onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.black12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            child: const Text(
              'Save & exit',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0, top: 12.0),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.black12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text(
                'Questions?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'What\'s your residential address?',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -1.0,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Guests won\'t see this information.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  // Address Form Box
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildInputField('Country / region', 'Pakistan', isDropdown: true),
                        const Divider(height: 1, color: Colors.black),
                        _buildInputField('Street address', 'Islamabad - Murree Expressway', isDropdown: true),
                        const Divider(height: 1, color: Colors.black),
                        _buildInputField('Apt, floor, bldg (if applicable)', 'ilamabad'),
                        const Divider(height: 1, color: Colors.black),
                        _buildInputField('City / town / village', 'Lower Topa'),
                        const Divider(height: 1, color: Colors.black),
                        _buildInputField('Province / state / territory (if applicable)', 'Punjab'),
                        const Divider(height: 1, color: Colors.black),
                        _buildInputField('Postal code (if applicable)', ''),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  const Text(
                    'Are you hosting as a business?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: const TextSpan(
                      style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4, fontFamily: 'Circular'),
                      children: [
                        TextSpan(text: 'This means your business is most likely registered with your state or government. '),
                        TextSpan(
                          text: 'Get details',
                          style: TextStyle(fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => _isBusiness = true),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: _isBusiness ? const Color(0xFFF7F7F7) : Colors.white,
                            side: BorderSide(color: _isBusiness ? Colors.black : Colors.black12, width: _isBusiness ? 2 : 1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          child: const Text('Yes', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => _isBusiness = false),
                          style: OutlinedButton.styleFrom(
                            backgroundColor: !_isBusiness ? const Color(0xFFF7F7F7) : Colors.white,
                            side: BorderSide(color: !_isBusiness ? Colors.black : Colors.black12, width: !_isBusiness ? 2 : 1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          child: const Text('No', style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          
          // Progress Bar and Bottom Nav
          Container(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey.shade100, width: 1),
              ),
            ),
            child: Column(
              children: [
                // Progress Bar
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.black, // Step 3 Finished
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Back',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // FINAL STEP: Redirect to home
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Create listing',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, String value, {bool isDropdown = false}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value.isEmpty ? ' ' : value,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              if (isDropdown)
                const Icon(Icons.keyboard_arrow_down, size: 24, color: Colors.black),
            ],
          ),
        ],
      ),
    );
  }
}
