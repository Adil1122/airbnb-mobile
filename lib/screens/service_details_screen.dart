import 'package:flutter/material.dart';
import '../models/listing.dart';
import '../services/service_service.dart';
import 'service_reservation_screen.dart';

class ServiceDetailsScreen extends StatefulWidget {
  final Listing listing;

  const ServiceDetailsScreen({super.key, required this.listing});

  @override
  State<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends State<ServiceDetailsScreen> {
  late Listing _currentListing;
  bool _isLoading = true;
  final _serviceService = ServiceService();

  @override
  void initState() {
    super.initState();
    _currentListing = widget.listing;
    _loadDetails();
  }

  Future<void> _loadDetails() async {
    final details = await _serviceService.fetchServiceDetails(_currentListing.id);
    if (details != null && mounted) {
      setState(() {
        _currentListing = details;
        _isLoading = false;
      });
    } else {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFFE31C5F)),
        ),
      );
    }

    final listing = _currentListing;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F4),
      body: Stack(
        children: [
          // Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 380,
            child: Image.network(
              listing.imageUrl,
              fit: BoxFit.cover,
            ),
          ),

          // Scrollable Content
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 280), // Transparent space for the header image
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 40),
                      padding: const EdgeInsets.only(top: 64, bottom: 40),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              listing.title,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Text(
                              listing.description.isEmpty ? "Premium service provided by a verified professional in ${listing.subtitle}." : listing.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24.0),
                            child: Wrap(
                              alignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 6,
                              children: [
                                const Icon(Icons.star, size: 16, color: Colors.black),
                                Text(
                                  '${listing.rating}',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const Text('·'),
                                Text(
                                  '${listing.reviewsCount} reviews',
                                  style: const TextStyle(decoration: TextDecoration.underline),
                                ),
                                const Text('·'),
                                Text(
                                  listing.hostName, 
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('Provided on location', style: TextStyle(color: Colors.black54)),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.translate, size: 16, color: Colors.grey.shade500),
                              const SizedBox(width: 8),
                              Text('Automatically translated', style: TextStyle(color: Colors.grey.shade500)),
                            ],
                          ),
                          const SizedBox(height: 32),
                          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                          const SizedBox(height: 32),
                          
                          // Service Packages List
                          _buildServicePackages(),
                          
                          // Reviews Section
                          _buildReviewsSection(),
                          
                          // Qualifications Section
                          _buildQualificationsSection(),
                          
                          // Host Profile Section
                          _buildHostProfileSection(),
                          
                          // Portfolio Section
                          _buildPortfolioSection(),
                          
                          // Location Section
                          _buildLocationSection(),
                          
                          // Things to Know Section
                          _buildThingsToKnowSection(),
                        ],
                      ),
                    ),
                    
                    // Floating Avatar
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&q=80'), // Placeholder avatar
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Vetted designers area replaces the simple SizedBox
                _buildVettedPhotographersSection(),
              ],
            ),
          ),
          
          // Header Floating Buttons
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildFloatingButton(Icons.arrow_back, () => Navigator.pop(context)),
                    Row(
                      children: [
                        _buildFloatingButton(Icons.share_outlined, () {}),
                        const SizedBox(width: 12),
                        _buildFloatingButton(Icons.favorite_border, () {}),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Sticky Bottom Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.grey.shade200)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, -2),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                        RichText(
                          text: TextSpan(
                            style: const TextStyle(color: Colors.black, fontSize: 16),
                            children: [
                              const TextSpan(
                                text: 'From ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '\$${listing.price.toInt()}',
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const TextSpan(text: ' / group'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Free cancellation',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                      ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServiceReservationScreen(listing: _currentListing),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE31C5F),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Show dates',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8),
          ],
        ),
        child: Icon(icon, size: 20, color: Colors.black87),
      ),
    );
  }

  Widget _buildServicePackages() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          _buildPackageCard(
            'https://images.unsplash.com/photo-1606791422814-b32c705e3e2f?w=200&q=80',
            'Standard Package',
            '• 1 hour duration\n• Basic consultation included\n• Full equipment provided',
            '\$${_currentListing.price.toInt()} / session · 1 hr',
          ),
          const SizedBox(height: 32),
          Text(
            'You can message ${_currentListing.hostName} to customize or make changes',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildPackageCard(String imgUrl, String title, String bullets, String price) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imgUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 16, right: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bullets,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 14, color: Colors.black),
                      children: [
                        TextSpan(
                          text: price.split(' /')[0],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                          text: ' /${price.split(' /')[1]}',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQualificationsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 32),
          const Text(
            'Professional qualifications',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          _buildQualificationItem(
            Icons.verified_user_outlined,
            'Verified Expert',
            'Full identity and skills verification completed by Airbnb community.',
          ),
          const SizedBox(height: 24),
          _buildQualificationItem(
            Icons.history_outlined,
            'Years of experience',
            'Over 5 years of professional practice in the field.',
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildQualificationItem(IconData icon, String title, String subtitle) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 28, color: Colors.black87),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
        ),
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Icon(Icons.star, size: 24, color: Colors.black),
              SizedBox(width: 8),
              Text(
                '${_currentListing.rating} · ${_currentListing.reviewsCount} reviews',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Center(child: Text("Service reviews coming soon", style: TextStyle(color: Colors.grey))),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildHostProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&q=80'),
                ),
                const SizedBox(height: 16),
                Text(
                  _currentListing.hostName,
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                ),
                const SizedBox(height: 4),
                Text(
                  'Professional Provider',
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF3F3F3),
                foregroundColor: Colors.black,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Message ${_currentListing.hostName}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPortfolioSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Service portfolio',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              _currentListing.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildLocationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 32),
          const Text(
            'Service coverage',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _currentListing.subtitle,
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildThingsToKnowSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
          const SizedBox(height: 32),
          const Text(
            'Things to know',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          _buildKnowItem('Cancellation policy', 'Free cancellation for 48 hours. Cancel before the start time for a full refund.'),
          const SizedBox(height: 24),
          _buildKnowItem('Communication', 'Always communicate through the app to protect your safety and payment.'),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildKnowItem(String title, String desc) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(desc, style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.4)),
      ],
    );
  }

  Widget _buildVettedPhotographersSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      color: const Color(0xFFF7F7F4),
      child: Column(
        children: [
          const Icon(Icons.verified_outlined, size: 48, color: Colors.blue),
          const SizedBox(height: 16),
          const Text(
            'Vetted Professionals',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Every professional is interviewed and their portfolio reviewed by our experts.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
