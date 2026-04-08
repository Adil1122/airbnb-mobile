import 'package:flutter/material.dart';
import '../required_actions_screen.dart';

class HostingListingsTab extends StatelessWidget {
  const HostingListingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 120,
        title: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your listings',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
              Row(
                children: [
                  _buildHeaderIcon(Icons.search),
                  const SizedBox(width: 8),
                  _buildHeaderIcon(Icons.grid_view),
                  const SizedBox(width: 8),
                  _buildHeaderIcon(Icons.add),
                  const SizedBox(width: 8),
                  _buildHeaderIcon(Icons.edit_note_outlined),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildListingCard(
                  title: 'apartment in islamabad',
                  location: 'Home in Islamabad, Islamabad Capital Territory',
                  status: 'Action required',
                  statusColor: const Color(0xFFFF385C),
                  image: 'https://cdn-icons-png.flaticon.com/512/3222/3222687.png', // Custom property placeholder
                ),
                const SizedBox(height: 32),
                _buildListingCard(
                  title: 'Your House listing',
                  location: 'Home',
                  status: 'In progress',
                  statusColor: Colors.orange,
                  isPlaceholder: true,
                ),
                const SizedBox(height: 120), // Banner space
              ],
            ),
          ),
          
          // Bottom Banner
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RequiredActionsScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Confirm a few key details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Required to publish',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: Colors.grey.shade400),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Icon(icon, size: 20, color: Colors.black),
    );
  }

  Widget _buildListingCard({
    required String title,
    required String location,
    required String status,
    required Color statusColor,
    String? image,
    bool isPlaceholder = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: isPlaceholder ? const Color(0xFFEBEBEB) : const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  image: image != null
                      ? DecorationImage(
                          image: NetworkImage(image),
                          fit: BoxFit.cover,
                          opacity: 0.1, // Style for placeholder icons
                        )
                      : null,
                ),
                child: isPlaceholder 
                    ? const Center(child: Icon(Icons.camera_alt_outlined, color: Color(0xFFB0B0B0), size: 100))
                    : const Center(child: Icon(Icons.camera_alt_outlined, color: Colors.white24, size: 100)),
              ),
            ),
            // Floating Status Tag
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: statusColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      status,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          location,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
