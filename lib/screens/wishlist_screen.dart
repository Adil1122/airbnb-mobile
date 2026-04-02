import 'package:flutter/material.dart';
import '../models/listing.dart';
import 'recently_viewed_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              const Text(
                'Wishlists',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 32),
              
              // Collection Card on Main Screen
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RecentlyViewedScreen(),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _CollageWidget(size: 160, borderRadius: 16),
                    const SizedBox(height: 16),
                    const Text(
                      'Recently viewed',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollageWidget extends StatelessWidget {
  final double size;
  final double borderRadius;

  const _CollageWidget({
    Key? key,
    required this.size,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Dynamic real-time imagery from the recently viewed manager
    final recentlyViewed = RecentlyViewedManager.recentlyViewed;
    
    // Default high-quality placeholders if no items are viewed yet
    final List<String> defaultImages = [
      'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=400&q=80',
      'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=400&q=80',
      'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=400&q=80',
      'https://images.unsplash.com/photo-1505691723518-36a5ac3be353?w=400&q=80',
    ];

    String getImageUrl(int index) {
      if (index < recentlyViewed.length) {
        return recentlyViewed[index].imageUrl;
      }
      return defaultImages[index % defaultImages.length];
    }

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Expanded(child: Image.network(getImageUrl(0), fit: BoxFit.cover)),
                const SizedBox(width: 2),
                Expanded(child: Image.network(getImageUrl(1), fit: BoxFit.cover)),
              ],
            ),
          ),
          const SizedBox(height: 2),
          Expanded(
            child: Row(
              children: [
                Expanded(child: Image.network(getImageUrl(2), fit: BoxFit.cover)),
                const SizedBox(width: 2),
                Expanded(child: Image.network(getImageUrl(3), fit: BoxFit.cover)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
