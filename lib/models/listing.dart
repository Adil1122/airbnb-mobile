class Listing {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final double price;
  final String duration;
  final double rating;
  final bool isGuestFavorite;

  const Listing({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.duration,
    required this.rating,
    this.isGuestFavorite = false,
  });
}
