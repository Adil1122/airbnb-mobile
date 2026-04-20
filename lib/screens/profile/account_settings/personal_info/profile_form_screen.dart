import 'package:flutter/material.dart';
import 'dart:ui';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  bool _stampsEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 48), // Spacer to balance the close button
                    const Text(
                      'Edit profile',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 120), // Bottom padding for sticky bar
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar Section
                        Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.bottomCenter,
                            children: [
                              Container(
                                width: 140,
                                height: 140,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF222222),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Text(
                                    'A',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: -16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.camera_alt_outlined, size: 16),
                                      SizedBox(width: 8),
                                      Text(
                                        'Add',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        const SizedBox(height: 64),
                        
                        // My profile section
                        const Text(
                          'My profile',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 12),
                        RichText(
                          text: const TextSpan(
                            style: TextStyle(color: Colors.black54, fontSize: 16, height: 1.4),
                            children: [
                              TextSpan(
                                text: 'Hosts and guests can see your profile and it may appear across Airbnb to help us build trust in our community. ',
                              ),
                              TextSpan(
                                text: 'Learn more',
                                style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        
                        // Form Items
                        // Form Items
                        _buildFormRow(Icons.work_outline, 'My work', onTap: () => _showTextInputModal(context, 'What do you do for work?', "Tell us what your profession is. If you don't have a traditional job, tell us your life's calling.", 'My work:', 20)),
                        _buildFormRow(Icons.public, "Where I've always wanted to go", onTap: () => _showTextInputModal(context, 'Dream destination?', 'Share the place you have always wanted to visit.', 'Destination:', 40)),
                        _buildFormRow(Icons.lightbulb_outline, 'My fun fact', onTap: () => _showTextInputModal(context, 'What is your fun fact?', 'Share something unique or interesting about yourself.', 'Fun fact:', 50)),
                        _buildFormRow(Icons.pets_outlined, 'Pets', onTap: () => _showTextInputModal(context, 'Do you have any pets?', 'Tell us about the furry friends in your life.', 'Pets:', 30)),
                        _buildFormRow(Icons.cake_outlined, 'Decade I was born', onTap: () => _showTextInputModal(context, 'Which decade were you born?', 'Share the decade you were born in.', 'Decade:', 4)),
                        _buildFormRow(Icons.school_outlined, 'Where I went to school', onTap: () => _showTextInputModal(context, 'Where did you go to school?', 'Share your educational background.', 'School or University:', 40)),
                        _buildFormRow(Icons.access_time, 'I spend too much time', onTap: () => _showTextInputModal(context, 'What takes up your time?', 'Share what you spend too much time doing.', 'Activity:', 40)),
                        _buildFormRow(Icons.music_note_outlined, 'My favorite song in high school', onTap: () => _showTextInputModal(context, 'Favorite song in high school?', 'Share a song that takes you back.', 'Song title:', 40)),
                        _buildFormRow(Icons.auto_fix_high_outlined, 'My most useless skill', onTap: () => _showTextInputModal(context, 'What is your most useless skill?', 'Share a funny or quirky skill you have.', 'Useless skill:', 40)),
                        _buildFormRow(Icons.menu_book_outlined, 'My biography title would be', onTap: () => _showTextInputModal(context, 'Biography title?', 'If someone wrote a book about you, what would the title be?', 'Title:', 40)),
                        _buildFormRow(Icons.g_translate_outlined, 'Languages I speak', onTap: () => _showTextInputModal(context, 'What languages do you speak?', 'Share the languages you are fluent in.', 'Languages:', 50)),
                        _buildFormRow(Icons.favorite_border, "I'm obsessed with", showDivider: false, onTap: () => _showTextInputModal(context, 'What are you obsessed with?', 'Share your current obsessions or hobbies.', 'Obsession:', 40)),
                        _buildFormRow(Icons.public, 'Where I live', showDivider: true, onTap: () => _showLocationModal(context)),
                        
                        const SizedBox(height: 32),
                        const Text('About me', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                        const SizedBox(height: 16),
                        
                        // Dashed Container
                        CustomPaint(
                          painter: DashedRectPainter(color: Colors.grey.shade400, strokeWidth: 1.5, gap: 6.0),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Write something fun and punchy.', style: TextStyle(color: Colors.black54, fontSize: 14)),
                                const SizedBox(height: 16),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () => _showTextInputModal(context, 'About you', 'Tell us a little bit about yourself, so your future hosts or guests can get to know you.', null, 500, maxLines: 4),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey.shade100,
                                      foregroundColor: Colors.black,
                                      elevation: 0,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    ),
                                    child: const Text('Add intro', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 48),
                        
                        // Where I've been
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Where I\'ve been', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                            Switch(
                              value: _stampsEnabled,
                              onChanged: (val) {
                                setState(() {
                                  _stampsEnabled = val;
                                });
                              },
                              activeThumbColor: Colors.black,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Pick the stamps you want other people to see on your profile.',
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        const SizedBox(height: 24),
                        
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          clipBehavior: Clip.none,
                          child: Row(
                            children: [
                              _buildStampCard(Icons.public, 'Next destination', -0.02, isActive: _stampsEnabled),
                              const SizedBox(width: 16),
                              _buildStampCard(Icons.wb_sunny_outlined, 'Next destination', 0.02, isRounder: true, isActive: _stampsEnabled),
                            ],
                          ),
                        ),
                        
                        if (_stampsEnabled)
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _showTravelStampsModal(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey.shade100,
                                  foregroundColor: Colors.black,
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                                child: const Text('Edit travel stamps', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        
                        const SizedBox(height: 48),
                        const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                        const SizedBox(height: 32),

                        const Text('My interests', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                        const SizedBox(height: 12),
                        const Text(
                          'Find common ground with other guests and hosts by adding interests to your profile.',
                          style: TextStyle(color: Colors.black54, fontSize: 14),
                        ),
                        const SizedBox(height: 16),
                        
                        // Dashed Pills
                        Row(
                          children: [
                            _buildDashedPill(onTap: () => _showInterestsModal(context)),
                            const SizedBox(width: 8),
                            _buildDashedPill(onTap: () => _showInterestsModal(context)),
                            const SizedBox(width: 8),
                            _buildDashedPill(onTap: () => _showInterestsModal(context)),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // Add Interests Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _showInterestsModal(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade100,
                              foregroundColor: Colors.black,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text('Add interests', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF222222),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Done',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showInterestsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, size: 24, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'What are you into?',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Pick some interests you enjoy that you want to show on your profile.',
                        style: TextStyle(color: Colors.black54, fontSize: 15, height: 1.4),
                      ),
                      const SizedBox(height: 32),
                      
                      const Text(
                        'Interests',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          _buildInterestChip(Icons.ramen_dining, 'Food scenes'),
                          _buildInterestChip(Icons.terrain, 'Outdoors'),
                          _buildInterestChip(Icons.movie_outlined, 'Movies'),
                          _buildInterestChip(Icons.camera_alt_outlined, 'Photography'),
                          _buildInterestChip(Icons.music_note_outlined, 'Live music'),
                          _buildInterestChip(Icons.local_cafe_outlined, 'Coffee'),
                          _buildInterestChip(Icons.shopping_bag_outlined, 'Shopping'),
                          _buildInterestChip(Icons.menu_book_outlined, 'Reading'),
                          _buildInterestChip(Icons.restaurant_outlined, 'Cooking'),
                          _buildInterestChip(Icons.directions_walk, 'Walking'),
                          _buildInterestChip(Icons.directions_car_outlined, 'Cars'),
                          _buildInterestChip(Icons.public, 'History'),
                          _buildInterestChip(Icons.architecture, 'Architecture'),
                          _buildInterestChip(Icons.pets_outlined, 'Animals'),
                        ],
                      ),
                      
                      const SizedBox(height: 32),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Show all',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
              
              // Bottom Save Bar
              Container(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade100, width: 1),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '0/20 selected',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        width: 140,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF222222),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInterestChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: Colors.black87),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormRow(IconData icon, String hint, {bool showDivider = true, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            children: [
              Icon(icon, size: 28, color: Colors.black87),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  hint,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(height: 1, thickness: 1, color: Colors.grey.shade200),
        ],
      ),
    );
  }

  void _showTextInputModal(BuildContext context, String title, String subtitle, String? fieldLabel, int maxLength, {int maxLines = 1}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom, // Avoid keyboard
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Close Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, size: 24, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black54, fontSize: 15, height: 1.4),
                          children: [
                            TextSpan(text: '$subtitle '),
                            const TextSpan(
                              text: 'Where is this shown?',
                              style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      // TextField
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black87, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (fieldLabel != null && fieldLabel.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  fieldLabel,
                                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                                ),
                              ),
                            TextField(
                              autofocus: true,
                              maxLines: maxLines,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                              style: TextStyle(fontSize: 16, color: Colors.black),
                              cursorColor: Colors.black,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Character count
                      Align(
                        alignment: Alignment.centerRight,
                        child: Text(
                          '0/$maxLength characters',
                          style: const TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
                
                // Bottom Save Button
                const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Normally would save state here
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLocationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Close Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, size: 24, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Where you live',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      
                      // Search TextField
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400, width: 1.5),
                          borderRadius: BorderRadius.circular(32),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: Colors.black54, size: 20),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Search for your city',
                                  hintStyle: TextStyle(color: Colors.black54, fontSize: 14),
                                  border: InputBorder.none,
                                  isDense: true,
                                ),
                                style: TextStyle(fontSize: 16, color: Colors.black),
                                cursorColor: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Bottom Save Button
                const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showTravelStampsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Close button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.close, size: 24, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
                
                // Title & subtitle
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Where I've been",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Pick the stamps you want other people to see on your profile.',
                        style: TextStyle(color: Colors.black54, fontSize: 15, height: 1.4),
                      ),
                    ],
                  ),
                ),
                
                const Spacer(),
                
                // Disabled grey Save button
                const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: Colors.grey.shade300,
                        disabledForegroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Save', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStampCard(IconData icon, String subtitle, double rotation, {bool isRounder = false, bool isActive = false}) {
    final borderColor = isActive ? const Color(0xFF4B84C1) : Colors.black45;
    return Column(
      children: [
        Transform.rotate(
          angle: rotation,
          child: Container(
            width: 140,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderColor, width: isActive ? 2.5 : 1.5),
              borderRadius: isRounder 
                  ? BorderRadius.circular(32) 
                  : const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(16),
                    ),
            ),
            child: Center(
              child: Icon(icon, size: 56, color: borderColor),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildDashedPill({VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: CustomPaint(
        painter: DashedRectPainter(
          color: Colors.grey.shade400, 
          strokeWidth: 1.5, 
          gap: 6.0, 
          borderRadius: const Radius.circular(100),
        ),
        child: Container(
          height: 48,
          width: 80,
          alignment: Alignment.center,
          child: const Icon(Icons.add, color: Colors.black54, size: 24),
        ),
      ),
    );
  }
}

class DashedRectPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;
  final Radius borderRadius;
  
  DashedRectPainter({
    required this.color, 
    this.strokeWidth = 1.0, 
    this.gap = 5.0,
    this.borderRadius = const Radius.circular(16),
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    Path path = Path()..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), borderRadius));
    
    PathMetrics pathMetrics = path.computeMetrics();
    Path dashedPath = Path();
    for (PathMetric pathMetric in pathMetrics) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        dashedPath.addPath(
          pathMetric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
    }
    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
