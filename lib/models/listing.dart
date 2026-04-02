class Review {
  final String userName;
  final String userLocation;
  final String userImageUrl;
  final double rating;
  final String date;
  final String comment;

  const Review({
    required this.userName,
    required this.userLocation,
    required this.userImageUrl,
    required this.rating,
    required this.date,
    required this.comment,
  });
}

class ReviewMention {
  final String label;
  final String iconImageUrl; // For emojis/icons in the screenshot

  const ReviewMention({required this.label, required this.iconImageUrl});
}

class Listing {
  final String id;
  final String imageUrl;
  final List<String> images;
  final String title;
  final String subtitle;
  final double price;
  final String duration;
  final double rating;
  final bool isGuestFavorite;
  final int guests;
  final int bedrooms;
  final int beds;
  final int baths;
  final int reviewsCount;
  final String hostName;
  final String hostDuration;
  final String description;
  final List<Review> reviews;
  final List<ReviewMention> mentions;
  final List<String> amenities;
  final String fullAddress;
  
  // Host detail fields
  final String hostSchool;
  final String hostWork;
  final String hostBio;
  final String hostResponseRate;
  final String hostResponseTime;

  // New Policy & Rule fields
  final String cancellationPolicy;
  final String checkInTime;
  final String checkOutTime;
  final List<String> safetyInfo;

  const Listing({
    required this.id,
    required this.imageUrl,
    this.images = const [],
    required this.title,
    required this.subtitle,
    required this.price,
    required this.duration,
    required this.rating,
    this.isGuestFavorite = false,
    this.guests = 2,
    this.bedrooms = 1,
    this.beds = 1,
    this.baths = 1,
    this.reviewsCount = 0,
    this.hostName = 'Host',
    this.hostDuration = '1 month',
    this.description = 'Welcome to our home!',
    this.reviews = const [],
    this.mentions = const [],
    this.amenities = const [],
    this.fullAddress = 'Lahore, Pakistan',
    this.hostSchool = '',
    this.hostWork = '',
    this.hostBio = '',
    this.hostResponseRate = '100%',
    this.hostResponseTime = 'within an hour',
    this.cancellationPolicy = 'Flexible',
    this.checkInTime = '1:00 PM - 6:00 PM',
    this.checkOutTime = '11:00 AM',
    this.safetyInfo = const ['Smoke alarm', 'Carbon monoxide alarm'],
  });
}

class RecentlyViewedManager {
  static final List<Listing> _recentlyViewed = [];

  static List<Listing> get recentlyViewed => List.unmodifiable(_recentlyViewed);

  static void addView(Listing listing) {
    // Remove if already exists (to move to top)
    _recentlyViewed.removeWhere((item) => item.id == listing.id);
    
    // Add to the beginning of the list
    _recentlyViewed.insert(0, listing);
    
    // Limit to last 50 items
    if (_recentlyViewed.length > 50) {
      _recentlyViewed.removeLast();
    }
  }
}
