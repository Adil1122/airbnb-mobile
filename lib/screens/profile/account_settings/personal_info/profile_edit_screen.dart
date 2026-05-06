import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../../../../models/user_model.dart';
import '../../../../services/auth_service.dart';

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  UserModel? _user;
  bool _isLoading = true;
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();

  // Text Controllers
  final TextEditingController _workController = TextEditingController();
  final TextEditingController _dreamController = TextEditingController();
  final TextEditingController _funFactController = TextEditingController();
  final TextEditingController _petsController = TextEditingController();
  final TextEditingController _languagesController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  List<String> _interests = [];
  List<String> _travelStamps = [];
  bool _stampsEnabled = false;

  final Color _airbnbRed = const Color(0xFFFF385C);
  final Color _softBg = const Color(0xFFF7F7F7);

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _workController.dispose();
    _dreamController.dispose();
    _funFactController.dispose();
    _petsController.dispose();
    _languagesController.dispose();
    _locationController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final user = await _authService.getProfile();
    if (mounted) {
      setState(() {
        _user = user;
        if (user != null) {
          _workController.text = user.work ?? '';
          _dreamController.text = user.dreamDestination ?? '';
          _funFactController.text = user.funFact ?? '';
          _petsController.text = user.pets ?? '';
          _locationController.text = user.location ?? '';
          _bioController.text = user.hostBio ?? '';
          _interests = user.interests ?? [];
          _travelStamps = user.travelStamps ?? [];
          _stampsEnabled = user.showStamps;
          _languagesController.text = user.hostLanguages?.join(', ') ?? '';
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _saveAll() async {
    setState(() => _isLoading = true);
    final Map<String, dynamic> data = {
      'work': _workController.text,
      'dreamDestination': _dreamController.text,
      'funFact': _funFactController.text,
      'pets': _petsController.text,
      'location': _locationController.text,
      'hostBio': _bioController.text,
      'interests': _interests,
      'travelStamps': _travelStamps,
      'showStamps': _stampsEnabled,
      'hostLanguages': _languagesController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
    };

    final updatedUser = await _authService.updateProfile(data);
    if (updatedUser != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Profile saved successfully'),
          backgroundColor: Colors.black87,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        )
      );
      setState(() {
        _user = updatedUser;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _pickAndUploadAvatar() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _isLoading = true);
      UserModel? updatedUser;
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        updatedUser = await _authService.uploadAvatar(bytes: bytes);
      } else {
        updatedUser = await _authService.uploadAvatar(path: image.path);
      }

      if (updatedUser != null && mounted) {
        setState(() {
          _user = updatedUser;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(backgroundColor: _softBg, body: const Center(child: CircularProgressIndicator(color: Colors.black)));
    }

    String getBaseUrl() {
      if (kIsWeb) return 'http://localhost:3001';
      return 'http://192.168.1.12:3001';
    }

    final avatarUrl = _user?.avatar != null ? '${getBaseUrl()}${_user!.avatar}' : null;

    return Scaffold(
      backgroundColor: _softBg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Modern Glassmorphic AppBar
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: Colors.white.withOpacity(0.8),
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text('Edit profile', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                  centerTitle: true,
                ),
                leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20), onPressed: () => Navigator.pop(context)),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(
                      onPressed: _saveAll,
                      child: Text('Save', style: TextStyle(color: _airbnbRed, fontWeight: FontWeight.w800, fontSize: 16)),
                    ),
                  ),
                ],
              ),
              
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Identity Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 12)),
                          ],
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _pickAndUploadAvatar,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    width: 110,
                                    height: 110,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF222222),
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 4),
                                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12)],
                                    ),
                                    child: ClipOval(
                                      child: avatarUrl != null 
                                        ? Image.network(avatarUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => Center(child: Text(_user?.name.substring(0, 1).toUpperCase() ?? '?', style: const TextStyle(color: Colors.white, fontSize: 40))))
                                        : Center(child: Text(_user?.name.substring(0, 1).toUpperCase() ?? '?', style: const TextStyle(color: Colors.white, fontSize: 40))),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(color: _airbnbRed, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                                    child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(_user?.name ?? 'Guest', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: -1)),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              decoration: BoxDecoration(color: _softBg, borderRadius: BorderRadius.circular(20)),
                              child: const Text('Host Member', style: TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w600)),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      const Text('Personal Info', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.8)),
                      const SizedBox(height: 8),
                      const Text('Information that builds trust with your community.', style: TextStyle(color: Colors.black45, fontSize: 15)),
                      const SizedBox(height: 32),
                      
                      _buildModernEditor('Work', 'What do you do for work?', _workController, Icons.work_outline),
                      _buildModernEditor('Location', 'Where you live', _locationController, Icons.location_on_outlined),
                      _buildModernEditor('Languages', 'Languages you speak', _languagesController, Icons.translate_outlined),
                      _buildModernEditor('Dreams', 'Where I\'ve always wanted to go', _dreamController, Icons.explore_outlined),
                      
                      // Modern Stamps Section
                      const SizedBox(height: 24),
                      _buildSectionHeader('Where I\'ve been', trailing: Switch(
                        value: _stampsEnabled, 
                        onChanged: (v) => setState(() => _stampsEnabled = v), 
                        activeColor: _airbnbRed,
                      )),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        clipBehavior: Clip.none,
                        child: Row(
                          children: [
                            _buildModernStamp(Icons.public, 'World Traveler', _stampsEnabled),
                            const SizedBox(width: 16),
                            _buildModernStamp(Icons.beach_access_outlined, 'Beach Lover', _stampsEnabled),
                            const SizedBox(width: 16),
                            _buildModernStamp(Icons.terrain_outlined, 'Mountain Fan', _stampsEnabled),
                          ],
                        ),
                      ),

                      const SizedBox(height: 48),
                      _buildModernEditor('Fun Fact', 'My fun fact', _funFactController, Icons.lightbulb_outline),
                      _buildModernEditor('Pets', 'Do you have furry friends?', _petsController, Icons.pets_outlined),
                      
                      // Interests Section
                      const SizedBox(height: 48),
                      _buildSectionHeader('My interests'),
                      const SizedBox(height: 16),
                      if (_interests.isNotEmpty)
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: _interests.map((i) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.grey.shade200)),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(i, style: const TextStyle(fontWeight: FontWeight.w600)),
                                const SizedBox(width: 8),
                                GestureDetector(onTap: () => setState(() => _interests.remove(i)), child: const Icon(Icons.close, size: 14, color: Colors.black45)),
                              ],
                            ),
                          )).toList(),
                        ),
                      const SizedBox(height: 16),
                      InkWell(
                        onTap: () => _showInterestsModal(context),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(border: Border.all(color: Colors.black12, style: BorderStyle.solid), borderRadius: BorderRadius.circular(16)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add, size: 20),
                              SizedBox(width: 8),
                              Text('Add Interests', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),
                      _buildSectionHeader('About me'),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
                        ),
                        child: TextField(
                          controller: _bioController,
                          maxLines: 5,
                          style: const TextStyle(fontSize: 16, height: 1.5),
                          decoration: InputDecoration(
                            hintText: 'Share a bit about yourself...',
                            hintStyle: const TextStyle(color: Colors.black26),
                            contentPadding: const EdgeInsets.all(20),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Modern Floating Action Button for Saving
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _saveAll,
                  borderRadius: BorderRadius.circular(20),
                  child: const Center(
                    child: Text('Update Profile', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {Widget? trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.8)),
        if (trailing != null) trailing,
      ],
    );
  }

  Widget _buildModernEditor(String label, String title, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: Colors.black45),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(fontSize: 14, color: Colors.black45, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.shade100, width: 1.5),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4))],
            ),
            child: TextField(
              controller: controller,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: title,
                hintStyle: const TextStyle(color: Colors.black12, fontWeight: FontWeight.normal),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernStamp(IconData icon, String label, bool isActive) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isActive ? 1.0 : 0.4,
      child: Container(
        width: 140, height: 110,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isActive ? _airbnbRed.withOpacity(0.5) : Colors.grey.shade200, width: 2),
          boxShadow: [if (isActive) BoxShadow(color: _airbnbRed.withOpacity(0.1), blurRadius: 10)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: isActive ? _airbnbRed : Colors.black45),
            const SizedBox(height: 12),
            Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isActive ? Colors.black : Colors.black45)),
          ],
        ),
      ),
    );
  }

  void _showInterestsModal(BuildContext context) {
    List<String> temp = List<String>.from(_interests);
    final list = ['Food scenes', 'Outdoors', 'Movies', 'Photography', 'Live music', 'Coffee', 'Shopping', 'Reading', 'Cooking', 'Art', 'Sports', 'Gaming'];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(builder: (context, setS) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('What are you into?', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: -1)),
            const SizedBox(height: 8),
            const Text('Pick some things you love.', style: TextStyle(color: Colors.black45, fontSize: 16)),
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 12, runSpacing: 12, 
                  children: list.map((i) {
                    final sel = temp.contains(i);
                    return ChoiceChip(
                      label: Text(i), 
                      selected: sel, 
                      onSelected: (v) => setS(() => v ? temp.add(i) : temp.remove(i)),
                      selectedColor: Colors.black,
                      labelStyle: TextStyle(color: sel ? Colors.white : Colors.black, fontWeight: FontWeight.w600),
                      backgroundColor: _softBg,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () { setState(() => _interests = temp); Navigator.pop(context); }, 
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                child: const Text('Confirm', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
