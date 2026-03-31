import 'package:flutter/material.dart';
import '../models/listing.dart';
import 'listing_card.dart';

class ListingCarousel extends StatefulWidget {
  final String title;
  final List<Listing> listings;

  const ListingCarousel({
    Key? key,
    required this.title,
    required this.listings,
  }) : super(key: key);

  @override
  State<ListingCarousel> createState() => _ListingCarouselState();
}

class _ListingCarouselState extends State<ListingCarousel> {
  final ScrollController _scrollController = ScrollController();

  void _scrollRight() {
    if (_scrollController.hasClients) {
      final double currentPosition = _scrollController.position.pixels;
      final double maxScroll = _scrollController.position.maxScrollExtent;
      final double cardWidth = (MediaQuery.of(context).size.width - 56) / 2.5;
      // Scroll by roughly the width of two cards + spacing
      final double newPosition = (currentPosition + (cardWidth + 16) * 2).clamp(0.0, maxScroll);
      
      _scrollController.animateTo(
        newPosition,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    letterSpacing: -0.4,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _scrollRight,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(6),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: Colors.black87,
                  ),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          // dynamic height = cardWidth (for 1:1 image aspect) + extra height for text/rating
          height: (MediaQuery.of(context).size.width - 56) / 2.5 + 85,
          child: ListView.separated(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: widget.listings.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return ListingCard(listing: widget.listings[index]);
            },
          ),
        ),
      ],
    );
  }
}
