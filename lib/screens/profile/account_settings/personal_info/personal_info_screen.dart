import 'package:flutter/material.dart';
import '../../../../models/user_model.dart';
import '../../../../services/auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final AuthService _authService = AuthService();
  final ImagePicker _picker = ImagePicker();
  UserModel? _user;
  bool _isLoading = true;
  
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _mailingAddressController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();
  
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _aptController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _provinceController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final user = await _authService.getProfile();
    if (mounted) {
      setState(() {
        _user = user;
        if (user != null) {
          final names = user.name.split(' ');
          _firstNameController.text = names.isNotEmpty ? names[0] : '';
          _lastNameController.text = names.length > 1 ? names.sublist(1).join(' ') : '';
          _emailController.text = user.email;
          _phoneController.text = user.phone ?? '';
          _mailingAddressController.text = user.mailingAddress ?? '';
          _emergencyContactController.text = user.emergencyContact ?? '';
          _streetController.text = user.location ?? '';
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _pickAndUploadID() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _isLoading = true);
      UserModel? updatedUser;
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        updatedUser = await _authService.uploadIDCard(bytes: bytes);
      } else {
        updatedUser = await _authService.uploadIDCard(path: image.path);
      }

      if (updatedUser != null && mounted) {
        setState(() {
          _user = updatedUser;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('ID Card uploaded successfully!')));
      } else {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to upload ID Card')));
      }
    }
  }

  Future<void> _saveAll() async {
    setState(() => _isLoading = true);
    final Map<String, dynamic> data = {
      'name': '${_firstNameController.text} ${_lastNameController.text}'.trim(),
      'email': _emailController.text,
      'phone': _phoneController.text,
      'mailingAddress': _mailingAddressController.text,
      'emergencyContact': _emergencyContactController.text,
      'location': _streetController.text,
    };

    final updatedUser = await _authService.updateProfile(data);
    if (updatedUser != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Personal info updated!'), behavior: SnackBarBehavior.floating));
      setState(() {
        _user = updatedUser;
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _mailingAddressController.dispose();
    _emergencyContactController.dispose();
    _streetController.dispose();
    _aptController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator(color: Colors.black)));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20), onPressed: () => Navigator.pop(context)),
        actions: [
          TextButton(onPressed: _saveAll, child: const Text('Save', style: TextStyle(color: Color(0xFFFF385C), fontWeight: FontWeight.bold, fontSize: 16))),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Personal info', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -1)),
            const SizedBox(height: 40),
            
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: const Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade200)),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(_user?.isIdentityVerified == true ? Icons.verified : Icons.verified_user_outlined, color: _user?.isIdentityVerified == true ? Colors.green : Colors.black45, size: 32),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Identity verification', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text(_user?.isIdentityVerified == true ? 'Your identity is verified.' : 'Verify your identity to build trust.', style: const TextStyle(color: Colors.black54, fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_user?.isIdentityVerified != true) ...[
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: _pickAndUploadID,
                        style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.black), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                        child: const Text('Add ID Card', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 40),

            _buildModernField('Legal name', 'First name', _firstNameController),
            const SizedBox(height: 16),
            _buildModernField(null, 'Last name', _lastNameController),
            
            const SizedBox(height: 32),
            _buildModernField('Email address', 'Email', _emailController),
            
            const SizedBox(height: 32),
            _buildModernField('Phone number', 'Phone', _phoneController),
            
            const SizedBox(height: 32),
            _buildModernField('Mailing address', 'Address', _mailingAddressController),
            
            const SizedBox(height: 32),
            _buildModernField('Emergency contact', 'Name & Phone', _emergencyContactController),
            
            const SizedBox(height: 32),
            const Text('Residential address', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildModernField(null, 'Street address', _streetController),
            const SizedBox(height: 16),
            _buildModernField(null, 'Apt, suite, etc.', _aptController),
            const SizedBox(height: 16),
            _buildModernField(null, 'City', _cityController),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildModernField(null, 'State', _provinceController)),
                const SizedBox(width: 16),
                Expanded(child: _buildModernField(null, 'Zip', _postalController)),
              ],
            ),
            
            const SizedBox(height: 64),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveAll,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 18), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                child: const Text('Save Changes', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 64),
          ],
        ),
      ),
    );
  }

  Widget _buildModernField(String? sectionTitle, String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sectionTitle != null) Padding(padding: const EdgeInsets.only(bottom: 12.0), child: Text(sectionTitle, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(12)),
          child: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: label, labelStyle: const TextStyle(color: Colors.black45), border: InputBorder.none, isDense: true),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
