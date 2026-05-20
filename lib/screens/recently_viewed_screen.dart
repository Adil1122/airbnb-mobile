import 'package:flutter/material.dart';
import '../services/recently_viewed_service.dart';
import '../models/listing.dart';
import 'property_details_screen.dart';

class RecentlyViewedScreen extends StatefulWidget {
  const RecentlyViewedScreen({super.key});

  @override
  State<RecentlyViewedScreen> createState() => _RecentlyViewedScreenState();
}

class _RecentlyViewedScreenState extends State<RecentlyViewedScreen> {
  List<dynamic> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final data = await RecentlyViewedService.getRecentlyViewed();
    if (mounted) setState(() { _items = data; _loading = false; });
  }

  Future<void> _clear() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear history?'),
        content: const Text('This will remove all recently viewed properties.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Clear', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed == true) {
      await RecentlyViewedService.clear();
      if (mounted) setState(() => _items = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () => Navigator.pop(context)),
        title: const Text('Recently Viewed', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          if (_items.isNotEmpty)
            TextButton(onPressed: _clear, child: const Text('Clear', style: TextStyle(color: Colors.black))),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? _EmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _items.length,
                  itemBuilder: (_, i) {
                    final item = _items[i];
                    final property = item['property'] as Map<String, dynamic>? ?? item;
                    final images = property['images'] as List? ?? [];
                    final imageUrl = images.isNotEmpty ? images.first['url'] ?? '' : '';

                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PropertyDetailsScreen(listing: Listing.fromJson(property)))),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                              child: imageUrl.isNotEmpty
                                  ? Image.network(imageUrl, width: 100, height: 80, fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => _PlaceholderImage())
                                  : _PlaceholderImage(),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(property['title'] ?? 'Property', style: const TextStyle(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                                  const SizedBox(height: 4),
                                  Text(property['city'] ?? property['address'] ?? '', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                                  const SizedBox(height: 4),
                                  Text('\$${property['price'] ?? '—'}/night', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 100, height: 80,
    color: Colors.grey.shade200,
    child: const Icon(Icons.home, color: Colors.grey),
  );
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.history, size: 64, color: Colors.grey.shade300),
        const SizedBox(height: 16),
        const Text('No recently viewed places', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Start exploring to see your history here.', style: TextStyle(color: Colors.grey.shade600)),
      ],
    ),
  );
}
