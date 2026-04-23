import 'package:flutter/material.dart';
import '../../models/listing.dart';
import '../../services/host_service.dart';
import '../property_details_screen.dart';

class ListingPreviewScreen extends StatefulWidget {
  final Listing listing;
  const ListingPreviewScreen({super.key, required this.listing});

  @override
  State<ListingPreviewScreen> createState() => _ListingPreviewScreenState();
}

class _ListingPreviewScreenState extends State<ListingPreviewScreen> {
  bool _isPublishing = false;
  final HostService _hostService = HostService();

  Future<void> _publish() async {
    setState(() => _isPublishing = true);
    try {
      await _hostService.publishListing(widget.listing.id);
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Listing published successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error publishing: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isPublishing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Preview',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Use the existing details screen UI
          PropertyDetailsScreen(listing: widget.listing, hideAppBar: true),
          
          // Custom overlay for preview
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            '\$${widget.listing.price.toInt()}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(' weekday', style: TextStyle(fontSize: 12, color: Colors.black54)),
                          if (widget.listing.weekendPrice != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              '\$${widget.listing.weekendPrice!.toInt()}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(' weekend', style: TextStyle(fontSize: 12, color: Colors.black54)),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ready to publish?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  _isPublishing
                      ? const CircularProgressIndicator(color: Color(0xFFE61E4D))
                      : ElevatedButton(
                          onPressed: _publish,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE61E4D),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Publish',
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
        ],
      ),
    );
  }
}
