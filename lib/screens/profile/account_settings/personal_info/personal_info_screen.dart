import 'package:flutter/material.dart';
import 'add_emergency_contact_screen.dart';
import 'identity_verification_screen.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  bool _isEditingLegalName = false;
  bool _isEditingPreferredName = false;
  bool _isEditingEmail = false;
  bool _isEditingResidentialAddress = false;
  bool _isEditingMailingAddress = false;
  
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _preferredNameController;
  late final TextEditingController _emailController;
  
  // Residental Address Controllers
  late final TextEditingController _streetController;
  late final TextEditingController _aptController;
  late final TextEditingController _cityController;
  late final TextEditingController _provinceController;
  late final TextEditingController _postalController;

  // Mailing Address Controllers
  late final TextEditingController _mailingStreetController;
  late final TextEditingController _mailingAptController;
  late final TextEditingController _mailingCityController;
  late final TextEditingController _mailingStateController;
  late final TextEditingController _mailingZipController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: 'Ahmad');
    _lastNameController = TextEditingController(text: 'Farooq');
    _preferredNameController = TextEditingController();
    _emailController = TextEditingController(text: 'a***1@gmail.com');
    
    _streetController = TextEditingController();
    _aptController = TextEditingController();
    _cityController = TextEditingController();
    _provinceController = TextEditingController();
    _postalController = TextEditingController();

    _mailingStreetController = TextEditingController();
    _mailingAptController = TextEditingController();
    _mailingCityController = TextEditingController();
    _mailingStateController = TextEditingController();
    _mailingZipController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _preferredNameController.dispose();
    _emailController.dispose();
    
    _streetController.dispose();
    _aptController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _postalController.dispose();

    _mailingStreetController.dispose();
    _mailingAptController.dispose();
    _mailingCityController.dispose();
    _mailingStateController.dispose();
    _mailingZipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isAnyEditing = _isEditingLegalName || 
                        _isEditingPreferredName || 
                        _isEditingEmail || 
                        _isEditingResidentialAddress ||
                        _isEditingMailingAddress;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personal info',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 32),
            
            // Legal Name Section
            Opacity(
              opacity: (isAnyEditing && !_isEditingLegalName) ? 0.3 : 1.0,
              child: IgnorePointer(
                ignoring: (isAnyEditing && !_isEditingLegalName),
                child: _isEditingLegalName
                  ? _buildLegalNameEditForm()
                  : _buildInfoSection(
                      'Legal name', 
                      '${_firstNameController.text} ${_lastNameController.text}', 
                      'Edit',
                      onAction: () => setState(() => _isEditingLegalName = true),
                    ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
            
            // Preferred Name Section
            if (_isEditingPreferredName)
              _buildPreferredNameEditForm()
            else
              Opacity(
                opacity: (isAnyEditing && !_isEditingPreferredName) ? 0.3 : 1.0,
                child: IgnorePointer(
                  ignoring: (isAnyEditing && !_isEditingPreferredName),
                  child: _buildInfoSection(
                    'Preferred first name', 
                    _preferredNameController.text.isEmpty ? 'Not provided' : _preferredNameController.text, 
                    _preferredNameController.text.isEmpty ? 'Add' : 'Edit',
                    onAction: () => setState(() => _isEditingPreferredName = true),
                  ),
                ),
              ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
            
            // Phone Number Section (Dimmed when any editing is active)
            Opacity(
              opacity: isAnyEditing ? 0.3 : 1.0,
              child: IgnorePointer(
                ignoring: isAnyEditing,
                child: _buildInfoSection(
                  'Phone number', 
                  '+92 *** ***6857',
                  'Edit',
                  description: 'Contact number (for confirmed guests and Airbnb to get in touch). You can add other numbers and choose how they’re used.',
                  onAction: () => _showAddPhoneModal(context),
                ),
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
            
            // Email Section
            if (_isEditingEmail)
              _buildEmailEditForm()
            else
              Opacity(
                opacity: (isAnyEditing && !_isEditingEmail) ? 0.3 : 1.0,
                child: IgnorePointer(
                  ignoring: (isAnyEditing && !_isEditingEmail),
                  child: _buildInfoSection(
                    'Email', 
                    _emailController.text, 
                    'Edit',
                    onAction: () => setState(() => _isEditingEmail = true),
                  ),
                ),
              ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
            
            // Residential Address
            if (_isEditingResidentialAddress)
              _buildResidentialAddressEditForm()
            else
              Opacity(
                opacity: (isAnyEditing && !_isEditingResidentialAddress) ? 0.3 : 1.0,
                child: IgnorePointer(
                  ignoring: (isAnyEditing && !_isEditingResidentialAddress),
                  child: _buildInfoSection(
                  'Residential address', 
                  'Provided', 
                  'Edit',
                  onAction: () => setState(() => _isEditingResidentialAddress = true),
                ),
                ),
              ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),

            // Mailing Address
            if (_isEditingMailingAddress)
              _buildMailingAddressEditForm()
            else
              Opacity(
                opacity: (isAnyEditing && !_isEditingMailingAddress) ? 0.3 : 1.0,
                child: IgnorePointer(
                  ignoring: (isAnyEditing && !_isEditingMailingAddress),
                  child: _buildInfoSection(
                    'Mailing address', 
                    'Not provided', 
                    'Add',
                    onAction: () => setState(() => _isEditingMailingAddress = true),
                  ),
                ),
              ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
            
            // Other Missing Sections (Dimmed when any editing is active)
            Opacity(
              opacity: isAnyEditing ? 0.3 : 1.0,
              child: IgnorePointer(
                ignoring: isAnyEditing,
                child: Column(
                  children: [
                    _buildInfoSection(
                      'Emergency contact', 
                      'Not provided', 
                      'Add',
                      onAction: () => _showEmergencyContactModal(context),
                    ),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                    
                    _buildInfoSection(
                      'Identity verification', 
                      'Not started', 
                      'Start',
                      onAction: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const IdentityVerificationScreen(),
                        ),
                      ),
                    ),
                    const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  void _showEmergencyContactModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: EdgeInsets.only(
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ),
              ),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      const Text(
                        'Add at least one emergency contact',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'An emergency contact gives us another possible way to help out if you\'re ever in an urgent situation. We suggest you add at least one contact before you start a trip. We\'ll never share the info with other people who use Airbnb.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 64),
                      const Center(
                        child: Icon(
                          Icons.contact_phone_outlined,
                          size: 120,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 64),
                    ],
                  ),
                ),
              ),
              
              // Footer
              const Divider(height: 1, thickness: 1),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Learn more',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the modal
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddEmergencyContactScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF222222),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Add now',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMailingAddressEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Mailing address',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            InkWell(
              onTap: () => setState(() => _isEditingMailingAddress = false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Region Selector
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black45, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Address/region', style: TextStyle(fontSize: 12, color: Colors.black54)),
                  Text('United States', style: TextStyle(fontSize: 16, color: Colors.black)),
                ],
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.black87),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        _buildCustomTextField('Street', _mailingStreetController),
        const SizedBox(height: 16),
        _buildCustomTextField('Apt, suite (optional)', _mailingAptController),
        const SizedBox(height: 16),
        _buildCustomTextField('City', _mailingCityController),
        const SizedBox(height: 16),
        _buildCustomTextField('State', _mailingStateController),
        const SizedBox(height: 16),
        _buildCustomTextField('ZIP code', _mailingZipController),
        
        const SizedBox(height: 24),
        SizedBox(
          width: 140,
          child: ElevatedButton(
            onPressed: () {
              setState(() => _isEditingMailingAddress = false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF2F2F2),
              foregroundColor: Colors.black38,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildResidentialAddressEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Residential address',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            InkWell(
              onTap: () => setState(() => _isEditingResidentialAddress = false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Country Dropdown
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black87, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Country / region', style: TextStyle(fontSize: 12, color: Colors.black54)),
                  Text('Pakistan', style: TextStyle(fontSize: 16, color: Colors.black)),
                ],
              ),
              Icon(Icons.keyboard_arrow_down, color: Colors.black87),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Composite Address Fields
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black45, width: 1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _buildAddressInput('Street address', _streetController, isError: true),
              const Divider(height: 1, thickness: 1, color: Colors.black26),
              _buildAddressInput('Apt, floor, bldg (if applicable)', _aptController),
              const Divider(height: 1, thickness: 1, color: Colors.black26),
              _buildAddressInput('City / town / village', _cityController, isError: true),
              const Divider(height: 1, thickness: 1, color: Colors.black26),
              _buildAddressInput('Province / state / territory (if applicable)', _provinceController),
              const Divider(height: 1, thickness: 1, color: Colors.black26),
              _buildAddressInput('Postal code (if applicable)', _postalController, isLast: true),
            ],
          ),
        ),
        
        const SizedBox(height: 12),
        const Row(
          children: [
            Icon(Icons.error, size: 16, color: Color(0xFFC13511)),
            SizedBox(width: 8),
            Text(
              'Please enter all of the required fields.',
              style: TextStyle(fontSize: 13, color: Color(0xFFC13511)),
            ),
          ],
        ),
        
        const SizedBox(height: 24),
        SizedBox(
          width: 140,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF2F2F2),
              foregroundColor: Colors.black38,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildAddressInput(String label, TextEditingController controller, {bool isError = false, bool isLast = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isError ? const Color(0xFFFFF8F7) : Colors.white,
        borderRadius: isLast ? const BorderRadius.vertical(bottom: Radius.circular(12)) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(
            fontSize: 14, 
            color: isError ? const Color(0xFFC13511) : Colors.black54
          )),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildEmailEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Email',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            InkWell(
              onTap: () => setState(() => _isEditingEmail = false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Use an address you\'ll always have access to.',
          style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
        ),
        const SizedBox(height: 32),
        
        _buildCustomTextField('Email', _emailController),
        
        const SizedBox(height: 24),
        SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: () {
              setState(() => _isEditingEmail = false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF0F0F0),
              foregroundColor: Colors.black45,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  void _showAddPhoneModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          'Add phone number',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24), // Balance the close button
                  ],
                ),
              ),
              const Divider(height: 1, thickness: 1),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add a number so confirmed guests and Airbnb can get in touch. You can add other numbers and choose how they\'re used.',
                        style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.4),
                      ),
                      const SizedBox(height: 32),
                      
                      // Composite Input Box
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black45, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            // Country/Region Selector
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Country/Region',
                                        style: TextStyle(fontSize: 12, color: Colors.black54),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'United States ( +1 )',
                                        style: TextStyle(fontSize: 16, color: Colors.black87),
                                      ),
                                    ],
                                  ),
                                  const Icon(Icons.keyboard_arrow_down, color: Colors.black87),
                                ],
                              ),
                            ),
                            const Divider(height: 1, thickness: 1, color: Colors.black26),
                            // Phone Number Input
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Phone number',
                                    style: TextStyle(fontSize: 12, color: Colors.black54),
                                  ),
                                  const SizedBox(height: 4),
                                  TextFormField(
                                    initialValue: '+1',
                                    keyboardType: TextInputType.phone,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.zero,
                                    ),
                                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      const Text(
                        'We\'ll text you a code to verify your number. Standard message and data rates apply.',
                        style: TextStyle(fontSize: 13, color: Colors.black54, height: 1.4),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Sticky Footer
              const Divider(height: 1, thickness: 1),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE0E0E0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Verify',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPreferredNameEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Preferred first name',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            InkWell(
              onTap: () => setState(() => _isEditingPreferredName = false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
            children: [
              TextSpan(text: 'This is how your first name will appear to hosts and guests. '),
              TextSpan(
                text: 'Learn more',
                style: TextStyle(decoration: TextDecoration.underline, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        
        _buildCustomTextField('Preferred first name (optional)', _preferredNameController),
        
        const SizedBox(height: 24),
        SizedBox(
          width: 100,
          child: ElevatedButton(
            onPressed: () {
              setState(() => _isEditingPreferredName = false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF0F0F0),
              foregroundColor: Colors.black45,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text('Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildLegalNameEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Legal name',
              style: TextStyle(fontSize: 18, color: Colors.black),
            ),
            InkWell(
              onTap: () => setState(() => _isEditingLegalName = false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Your calendar may be blocked for up to an hour while we verify your new legal name.',
          style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
        ),
        const SizedBox(height: 32),
        
        _buildCustomTextField('First name on ID', _firstNameController),
        const SizedBox(height: 16),
        _buildCustomTextField('Last name on ID', _lastNameController),
        
        const SizedBox(height: 24),
        SizedBox(
          width: 180,
          child: ElevatedButton(
            onPressed: () {
              setState(() => _isEditingLegalName = false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF222222),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
            child: const Text('Save and continue', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildCustomTextField(String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black45, width: 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, String actionText, {String? description, VoidCallback? onAction}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
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
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 16,
                    color: content == 'Not provided' || content == 'Not started' 
                        ? Colors.black54 
                        : Colors.black87,
                    height: 1.4,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 16),
          InkWell(
            onTap: onAction,
            child: Text(
              actionText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
