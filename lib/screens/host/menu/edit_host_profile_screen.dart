import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart';
import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';
import '../../../utils/api_config.dart';

class EditHostProfileScreen extends StatefulWidget {
  const EditHostProfileScreen({super.key});

  @override
  State<EditHostProfileScreen> createState() => _EditHostProfileScreenState();
}

class _EditHostProfileScreenState extends State<EditHostProfileScreen> {
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

  final Color _airbnbRose = const Color(0xFFFF385C);
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
        SnackBar(content: const Text('Host profile saved!'), backgroundColor: Colors.black, behavior: SnackBarBehavior.floating, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))
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

    final avatarUrl = _user?.avatar != null ? '${ApiConfig.baseUrl}${_user!.avatar}' : null;

    return Scaffold(
      backgroundColor: _softBg,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                pinned: true,
                backgroundColor: Colors.white.withOpacity(0.9),
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  title: const Text('Host profile', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                  centerTitle: true,
                ),
                leading: IconButton(icon: const Icon(Icons.close, color: Colors.black), onPressed: () => Navigator.pop(context)),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: TextButton(onPressed: _saveAll, child: Text('Save', style: TextStyle(color: _airbnbRose, fontWeight: FontWeight.bold, fontSize: 16))),
                  ),
                ],
              ),
              
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)]),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: _pickAndUploadAvatar,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  Container(
                                    width: 120, height: 120,
                                    decoration: BoxDecoration(color: const Color(0xFF222222), shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 4), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)]),
                                    child: ClipOval(
                                      child: avatarUrl != null 
                                        ? Image.network(avatarUrl, fit: BoxFit.cover, errorBuilder: (c, e, s) => Center(child: Text(_user?.name.substring(0, 1).toUpperCase() ?? '?', style: const TextStyle(color: Colors.white, fontSize: 48))))
                                        : Center(child: Text(_user?.name.substring(0, 1).toUpperCase() ?? '?', style: const TextStyle(color: Colors.white, fontSize: 48))),
                                    ),
                                  ),
                                  Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: _airbnbRose, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)), child: const Icon(Icons.camera_alt, size: 18, color: Colors.white)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(_user?.name ?? 'Host', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 4),
                            const Text('Superhost Member', style: TextStyle(fontSize: 14, color: Colors.black45, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 48),
                      const Text('Profile Details', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 32),
                      
                      _buildModernEditor('Work', 'What do you do for work?', _workController, Icons.work_outline),
                      _buildModernEditor('Location', 'Where you live', _locationController, Icons.location_on_outlined),
                      _buildModernEditor('Languages', 'Languages you speak', _languagesController, Icons.translate_outlined),
                      
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Where I\'ve been', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          Switch(value: _stampsEnabled, onChanged: (v) => setState(() => _stampsEnabled = v), activeColor: _airbnbRose),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildModernStamp(Icons.public, 'World Traveler', _stampsEnabled),
                            const SizedBox(width: 16),
                            _buildModernStamp(Icons.wb_sunny_outlined, 'Beach Lover', _stampsEnabled),
                          ],
                        ),
                      ),

                      const SizedBox(height: 48),
                      _buildModernEditor('Dream Destination', 'Where have you always wanted to go?', _dreamController, Icons.explore_outlined),
                      _buildModernEditor('Fun Fact', 'Something unique about you.', _funFactController, Icons.lightbulb_outline),
                      _buildModernEditor('Pets', 'Do you have furry friends?', _petsController, Icons.pets_outlined),
                      
                      const SizedBox(height: 48),
                      const Text('My interests', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      if (_interests.isNotEmpty)
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: _interests.map((i) => Chip(label: Text(i, style: const TextStyle(fontWeight: FontWeight.w600)), onDeleted: () => setState(() => _interests.remove(i)), backgroundColor: Colors.white, side: BorderSide(color: Colors.grey.shade200))).toList(),
                        ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(onPressed: () => _showInterestsModal(context), style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Text('Add interests', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
                      ),

                      const SizedBox(height: 48),
                      const Text('About me', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)]),
                        child: TextField(
                          controller: _bioController,
                          maxLines: 5,
                          decoration: InputDecoration(hintText: 'Share a bit about yourself...', contentPadding: const EdgeInsets.all(20), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none)),
                        ),
                      ),
                      
                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: Container(
              height: 60,
              decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)]),
              child: InkWell(
                onTap: _saveAll,
                borderRadius: BorderRadius.circular(16),
                child: const Center(child: Text('Save Host Profile', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold))),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernEditor(String label, String hint, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [Icon(icon, size: 18, color: Colors.black45), const SizedBox(width: 8), Text(label, style: const TextStyle(fontSize: 14, color: Colors.black45, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100, width: 1.5)),
            child: TextField(controller: controller, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600), decoration: InputDecoration(hintText: hint, border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero)),
          ),
        ],
      ),
    );
  }

  Widget _buildModernStamp(IconData icon, String label, bool isActive) {
    return Opacity(
      opacity: isActive ? 1.0 : 0.5,
      child: Container(
        width: 140, height: 110,
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(20), 
          border: Border.all(color: isActive ? _airbnbRose : Colors.grey.shade200, width: 2)
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Icon(icon, size: 36, color: isActive ? _airbnbRose : Colors.black45), 
            const SizedBox(height: 8), 
            Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isActive ? Colors.black : Colors.black45))
          ]
        ),
      ),
    );
  }

  void _showInterestsModal(BuildContext context) {
    List<String> temp = List<String>.from(_interests);
    final list = ['Food scenes', 'Outdoors', 'Movies', 'Photography', 'Live music', 'Coffee', 'Shopping', 'Reading', 'Cooking'];
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 500, padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Interests', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Expanded(child: Wrap(spacing: 8, runSpacing: 8, children: list.map((i) {
            final sel = temp.contains(i);
            return FilterChip(label: Text(i), selected: sel, onSelected: (v) => setState(() => v ? temp.add(i) : temp.remove(i)));
          }).toList())),
          const SizedBox(height: 16),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { setState(() => _interests = temp); Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 16)), child: const Text('Save', style: TextStyle(color: Colors.white)))),
        ]),
      ),
    );
  }
}
