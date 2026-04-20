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

  factory Review.fromJson(Map<String, dynamic> json) {
    try {
      // Backend uses a 'user' object relation
      final userData = json['user'] as Map<String, dynamic>?;
      
      return Review(
        userName: userData?['name']?.toString() ?? json['userName']?.toString() ?? 'Guest',
        userLocation: json['userLocation']?.toString() ?? 'Location verified',
        userImageUrl: userData?['avatar']?.toString() ?? json['userImageUrl']?.toString() ?? 'https://via.placeholder.com/150',
        rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
        date: json['reviewDate']?.toString() ?? json['date']?.toString() ?? 'Recent',
        comment: json['reviewText']?.toString() ?? json['comment']?.toString() ?? '',
      );
    } catch (e) {
      print('ERROR: Exception in Review.fromJson: $e for JSON: $json');
      return Review(
        userName: 'Guest',
        userLocation: 'Unknown',
        userImageUrl: 'https://via.placeholder.com/150',
        rating: 0.0,
        date: 'Recent',
        comment: 'Error parsing review',
      );
    }
  }
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

  factory Listing.fromJson(Map<String, dynamic> json) {
    try {
      final imagesList = (json['images'] as List? ?? []);
      final imageUrls = imagesList
          .map((img) => img is Map ? img['url']?.toString() : img.toString())
          .where((url) => url != null && url.isNotEmpty)
          .cast<String>()
          .toList();

      final mainImage = json['imageUrl']?.toString() ?? 
                       (imageUrls.isNotEmpty ? imageUrls.first : 'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=500&q=80');
      
      final rawReviews = json['reviews'];
      final bool isReviewsList = rawReviews is List;
      final int reviewsCountValue = int.tryParse(json['reviewCount']?.toString() ?? '0') ?? 
                                   (rawReviews is List ? rawReviews.length : 0);

      return Listing(
        id: (json['id'] ?? '0').toString(),
        imageUrl: mainImage,
        images: imageUrls,
        title: json['title']?.toString() ?? 'Untitled Property',
        subtitle: (json['location'] ?? json['subtitle'])?.toString() ?? 'Location unknown',
        price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
        duration: json['duration']?.toString() ?? 
                 (json['id'].toString().startsWith('e') ? 'per guest' : 
                 (json['id'].toString().startsWith('s') ? 'per service' : 'per night')),
        rating: double.tryParse(json['rating']?.toString() ?? '0') ?? 0.0,
        isGuestFavorite: (double.tryParse(json['rating']?.toString() ?? '0') ?? 0) >= 4.0,
        guests: int.tryParse(json['maxAdults']?.toString() ?? '2') ?? 2,
        bedrooms: int.tryParse(json['bedrooms']?.toString() ?? '1') ?? 1,
        beds: int.tryParse(json['beds']?.toString() ?? '1') ?? 1,
        baths: int.tryParse(json['bathrooms']?.toString() ?? '1') ?? 1,
        reviewsCount: reviewsCountValue,
        hostName: json['hostName']?.toString() ?? 'Host',
        hostDuration: 'Hosted since ${json['hostSince']?.toString() ?? 'recently'}',
        description: json['description']?.toString() ?? '',
        reviews: isReviewsList ? (rawReviews as List).map((rev) => Review.fromJson(rev)).toList() : [],
        mentions: [],
        amenities: (json['amenities'] as List? ?? []).map((a) {
          if (a is Map) return a['name'].toString();
          return a.toString();
        }).toList(),
        fullAddress: json['location']?.toString() ?? '',
        hostBio: json['hostBio']?.toString() ?? '',
        cancellationPolicy: json['cancellationPolicy']?.toString() ?? 'Flexible',
        checkInTime: json['checkInTime']?.toString() ?? '1:00 PM - 6:00 PM',
        checkOutTime: json['checkOutTime']?.toString() ?? '11:00 AM',
      );
    } catch (e) {
      print('ERROR: Exception in Listing.fromJson: $e for JSON: $json');
      rethrow;
    }
  }
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
