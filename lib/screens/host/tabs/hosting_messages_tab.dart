import 'package:flutter/material.dart';

class HostingMessagesTab extends StatefulWidget {
  const HostingMessagesTab({super.key});

  @override
  State<HostingMessagesTab> createState() => _HostingMessagesTabState();
}

class _HostingMessagesTabState extends State<HostingMessagesTab> {
  String _activeFilter = 'All';
  bool _isSearching = false;
  final List<String> _filters = ['All', 'Hosting', 'Traveling', 'Support'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: _isSearching ? 80 : 120,
        title: Padding(
          padding: EdgeInsets.only(top: _isSearching ? 0.0 : 20.0),
          child: _isSearching 
            ? _buildSearchBar()
            : _buildDefaultHeader(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          // Filter Chips
          _buildFilterChips(),
          const SizedBox(height: 48),
          
          // Empty State
          Expanded(
            child: _buildEmptyState(),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Messages',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            letterSpacing: -0.8,
          ),
        ),
        Row(
          children: [
            _buildHeaderIcon(
              Icons.search,
              onTap: () => setState(() => _isSearching = true),
            ),
            const SizedBox(width: 12),
            _buildHeaderIcon(
              Icons.settings_outlined,
              onTap: () => _showSettingsModal(context),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.black, width: 1.5),
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search all messages',
                hintStyle: TextStyle(fontSize: 16, color: Colors.grey),
                prefixIcon: Icon(Icons.search, color: Colors.black, size: 24),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 10),
              ),
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        GestureDetector(
          onTap: () {
            setState(() {
              _isSearching = false;
              _searchController.clear();
            });
          },
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 44,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final label = _filters[index];
          final isActive = _activeFilter == label;
          return GestureDetector(
            onTap: () => setState(() => _activeFilter = label),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: isActive ? Colors.black : const Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isActive ? Colors.transparent : Colors.grey.shade200,
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isActive ? Colors.white : Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.chat_bubble_outline, size: 48, color: Colors.black.withOpacity(0.85)),
            Positioned(
              left: 10,
              top: 8,
              child: Icon(Icons.chat_bubble_outline, size: 48, color: Colors.black.withOpacity(0.85)),
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Text(
          "You don't have any messages",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          "When you receive a new message, it will appear here.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 120), // Balance the bottom layout
      ],
    );
  }

  Widget _buildHeaderIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(icon, size: 22, color: Colors.black),
      ),
    );
  }

  void _showSettingsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Messaging settings',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildModalItem(Icons.chat_bubble_outline, 'Manage quick replies'),
              _buildModalItem(Icons.auto_awesome_outlined, 'Suggested replies'),
              _buildModalItem(Icons.archive_outlined, 'Archived'),
              _buildModalItem(Icons.send_outlined, 'Give feedback'),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModalItem(IconData icon, String label) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8),
      leading: Icon(icon, color: Colors.black, size: 28),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, color: Colors.black),
      ),
      onTap: () => Navigator.pop(context),
    );
  }
}
