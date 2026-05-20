import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../../../../models/user_model.dart';
import '../../../../services/auth_service.dart';
import '../../../../utils/api_config.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  UserModel? _user;
  bool _isLoading = true;
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();
  
  // Text Controllers for all fields
  final TextEditingController _workController = TextEditingController();
  final TextEditingController _dreamController = TextEditingController();
  final TextEditingController _funFactController = TextEditingController();
  final TextEditingController _petsController = TextEditingController();
  final TextEditingController _bornDecadeController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _timeSpenderController = TextEditingController();
  final TextEditingController _favSongController = TextEditingController();
  final TextEditingController _uselessSkillController = TextEditingController();
  final TextEditingController _bioTitleController = TextEditingController();
  final TextEditingController _languagesController = TextEditingController();
  final TextEditingController _obsessedWithController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  List<String> _interests = [];
  List<String> _travelStamps = [];
  bool _stampsEnabled = false;

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
    _bornDecadeController.dispose();
    _schoolController.dispose();
    _timeSpenderController.dispose();
    _favSongController.dispose();
    _uselessSkillController.dispose();
    _bioTitleController.dispose();
    _languagesController.dispose();
    _obsessedWithController.dispose();
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
          _bornDecadeController.text = user.bornDecade ?? '';
          _schoolController.text = user.school ?? '';
          _timeSpenderController.text = user.timeSpender ?? '';
          _favSongController.text = user.favSong ?? '';
          _uselessSkillController.text = user.uselessSkill ?? '';
          _bioTitleController.text = user.bioTitle ?? '';
          _obsessedWithController.text = user.obsessedWith ?? '';
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
      'bornDecade': _bornDecadeController.text,
      'school': _schoolController.text,
      'timeSpender': _timeSpenderController.text,
      'favSong': _favSongController.text,
      'uselessSkill': _uselessSkillController.text,
      'bioTitle': _bioTitleController.text,
      'obsessedWith': _obsessedWithController.text,
      'location': _locationController.text,
      'hostBio': _bioController.text,
      'showStamps': _stampsEnabled,
      'interests': _interests,
      'travelStamps': _travelStamps,
      'hostLanguages': _languagesController.text.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList(),
    };

    final updatedUser = await _authService.updateProfile(data);
    if (updatedUser != null && mounted) {
      Navigator.pop(context);
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
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
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.black)));
    }

    final avatarUrl = _user?.avatar != null ? '${ApiConfig.baseUrl}${_user!.avatar}' : null;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Edit profile', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
        leading: IconButton(icon: const Icon(Icons.close, color: Colors.black), onPressed: () => Navigator.pop(context)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
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
                    decoration: const BoxDecoration(color: Color(0xFF222222), shape: BoxShape.circle),
                    child: ClipOval(
                      child: avatarUrl != null 
                        ? Image.network(avatarUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => Center(child: Text(_user?.name.substring(0, 1).toUpperCase() ?? '?', style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold))))
                        : Center(
                            child: Text(
                              _user?.name.isNotEmpty == true ? _user!.name.substring(0, 1).toUpperCase() : '?',
                              style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.bold),
                            ),
                          ),
                    ),
                  ),
                  Positioned(
                    bottom: -16,
                    child: GestureDetector(
                      onTap: _pickAndUploadAvatar,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.camera_alt_outlined, size: 16),
                            SizedBox(width: 8),
                            Text('Add', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 64),
            const Text('My profile', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            const SizedBox(height: 12),
            const Text(
              'Hosts and guests can see your profile and it may appear across Airbnb to help us build trust in our community.',
              style: TextStyle(color: Colors.black54, fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 48),
            
            _buildDirectEditor(
              'What do you do for work?', 
              'Tell us what your profession is. If you don\'t have a traditional job, tell us your life\'s calling.', 
              'My work:', 
              _workController
            ),
            
            _buildDirectEditor(
              'Where you live', 
              'Share your current city or hometown.', 
              'Location:', 
              _locationController
            ),

            _buildDirectEditor(
              'What languages do you speak?', 
              'Share the languages you are fluent in (comma separated).', 
              'Languages:', 
              _languagesController
            ),

            _buildDirectEditor(
              'Where I\'ve always wanted to go', 
              'Is there a destination you\'re dreaming of visiting?', 
              'Dream destination:', 
              _dreamController
            ),

            _buildDirectEditor(
              'My fun fact', 
              'Share something surprising or unique about yourself.', 
              'Fun fact:', 
              _funFactController
            ),

            _buildDirectEditor(
              'Pets', 
              'Do you have any furry friends?', 
              'My pets:', 
              _petsController
            ),

            const SizedBox(height: 48),
            const Text('About me', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Tell us a little bit about yourself.', style: TextStyle(color: Colors.black54, fontSize: 15)),
            const SizedBox(height: 24),
            TextField(
              controller: _bioController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write something fun and punchy.',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width: 2)),
              ),
            ),
            
            const SizedBox(height: 120), // Extra space for bottom button
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        decoration: BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1))),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saveAll,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF222222), 
                foregroundColor: Colors.white, 
                padding: const EdgeInsets.symmetric(vertical: 16), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
              ),
              child: const Text('Save Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDirectEditor(String title, String subtitle, String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
          const SizedBox(height: 12),
          Text(subtitle, style: const TextStyle(color: Colors.black54, fontSize: 15, height: 1.4)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black87, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
                const SizedBox(height: 4),
                TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
