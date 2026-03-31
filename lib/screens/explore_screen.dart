import 'package:flutter/material.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_tabs.dart';
import '../widgets/listing_carousel.dart';
import '../widgets/price_fees_toggle.dart';
import '../models/listing.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({Key? key}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedTabIndex = 0;

  // Homes images
  final List<String> _homeImages = [
    'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?w=500&q=80',
    'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=500&q=80',
    'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?w=500&q=80',
    'https://images.unsplash.com/photo-1515263487990-61b07816b324?w=500&q=80',
    'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=500&q=80',
    'https://images.unsplash.com/photo-1449844908441-8829872d2607?w=500&q=80',
    'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=500&q=80',
    'https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?w=500&q=80',
  ];

  // Experiences and Services images
  final List<String> _experienceImages = [
    'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=500&q=80',
    'https://images.unsplash.com/photo-1518780664697-55e3ad937233?w=500&q=80',
    'https://images.unsplash.com/photo-1583608205776-bfd35f0d9f83?w=500&q=80',
    'https://images.unsplash.com/photo-1570129477492-45c003edd2be?w=500&q=80',
    'https://images.unsplash.com/photo-1472224371017-08207f84aaae?w=500&q=80',
    'https://images.unsplash.com/photo-1480074568708-e7b720bb3f09?w=500&q=80',
  ];

  // Helper function to build lists
  List<Listing> _buildList(String idPrefix, String prefix, String suffix, List<String> imagesList, double basePrice) {
    return List.generate(6, (index) {
       return Listing(
          id: '${idPrefix}_$index',
          imageUrl: imagesList[index % imagesList.length],
          title: '$prefix ${index + 1} in $suffix',
          subtitle: 'Hosted by Host ${index + 1}',
          price: basePrice + (index * 15).toDouble(),
          duration: '${index + 1} nights',
          rating: 4.5 + (index % 5) * 0.1,
          isGuestFavorite: index % 2 == 0,
       );
    });
  }

  // --- Home Lists Context ---
  List<Listing> get _popularIslamabad => _buildList('h1', 'Apartment', 'Islamabad', _homeImages, 40.0);
  List<Listing> get _availableLahore => _buildList('h2', 'Condo', 'Lahore', _homeImages, 50.0);
  List<Listing> get _trendingKarachi => _buildList('h3', 'Villa', 'Karachi', _homeImages, 80.0);
  List<Listing> get _beachGwadar => _buildList('h4', 'Beachfront', 'Gwadar', _homeImages, 100.0);
  List<Listing> get _cabinsMurree => _buildList('h5', 'Cabin', 'Murree', _homeImages, 60.0);
  List<Listing> get _luxuryDHA => _buildList('h6', 'Mansion', 'DHA', _homeImages, 200.0);
  List<Listing> get _mountainGilgit => _buildList('h7', 'Chalet', 'Gilgit', _homeImages, 70.0);

  // --- Experience Lists Context ---
  List<Listing> get _expDubai => _buildList('e1', 'Desert Safari', 'Dubai', _experienceImages, 150.0);
  List<Listing> get _expCanada => _buildList('e2', 'Skiing', 'Canada', _experienceImages, 180.0);
  List<Listing> get _expTurkey => _buildList('e3', 'Hot Air Balloon', 'Turkey', _experienceImages, 250.0);
  List<Listing> get _expMaldives => _buildList('e4', 'Scuba Diving', 'Maldives', _experienceImages, 300.0);
  List<Listing> get _expLondon => _buildList('e5', 'City Tour', 'London', _experienceImages, 120.0);

  // --- Service Lists Context ---
  List<Listing> get _srvPhoto => _buildList('s1', 'Photo Shoot', 'Photography', _experienceImages, 200.0);
  List<Listing> get _srvCooking => _buildList('s2', 'Private Chef', 'Cooking', _homeImages, 150.0);
  List<Listing> get _srvCleaning => _buildList('s3', 'Deep Cleaning', 'Cleaning', _homeImages, 50.0);
  List<Listing> get _srvEvents => _buildList('s4', 'Wedding Setup', 'Events', _experienceImages, 500.0);
  List<Listing> get _srvBabysit => _buildList('s5', 'Nanny', 'Babysitting', _experienceImages, 60.0);

  Widget _buildContent() {
    if (_selectedTabIndex == 0) {
      return Column(
        children: [
          ListingCarousel(title: 'Popular homes in Islamabad', listings: _popularIslamabad),
          const SizedBox(height: 16),
          ListingCarousel(title: 'Available in Lahore this weekend', listings: _availableLahore),
          const SizedBox(height: 16),
          ListingCarousel(title: 'Trending homes in Karachi', listings: _trendingKarachi),
          const SizedBox(height: 16),
          ListingCarousel(title: 'Beach fronts in Gwadar', listings: _beachGwadar),
          const SizedBox(height: 16),
          ListingCarousel(title: 'Cozy cabins in Murree', listings: _cabinsMurree),
          const SizedBox(height: 16),
          ListingCarousel(title: 'Luxury stays in DHA', listings: _luxuryDHA),
          const SizedBox(height: 16),
          ListingCarousel(title: 'Mountain views in Gilgit', listings: _mountainGilgit),
        ],
      );
    } else if (_selectedTabIndex == 1) {
      return Column(
        children: [
          ListingCarousel(title: 'Experiences in Dubai', listings: _expDubai),
          const SizedBox(height: 16),
          ListingCarousel(title: 'Experiences in Canada', listings: _expCanada),
          const SizedBox(height: 16),
          ListingCarousel(title: 'Experiences in Turkey', listings: _expTurkey),
          const SizedBox(height: 16),
          ListingCarousel(title: 'Experiences in Maldives', listings: _expMaldives),
          const SizedBox(height: 16),
          ListingCarousel(title: 'Experiences in London', listings: _expLondon),
        ],
      );
    } else {
      return Column(
        children: [
          ListingCarousel(title: 'Photography', listings: _srvPhoto),
          const SizedBox(height: 16),
          ListingCarousel(title: 'Cooking services', listings: _srvCooking),
          const SizedBox(height: 16),
          ListingCarousel(title: 'Cleaning & Maintenance', listings: _srvCleaning),
          const SizedBox(height: 16),
          ListingCarousel(title: 'Event Planning', listings: _srvEvents),
          const SizedBox(height: 16),
          ListingCarousel(title: 'Babysitting', listings: _srvBabysit),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      const SearchBarWidget(),
                      CategoryTabs(
                        selectedIndex: _selectedTabIndex,
                        onTabSelected: (index) {
                          setState(() {
                            _selectedTabIndex = index;
                          });
                        },
                      ),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFF0F0F0)),
                      const SizedBox(height: 16),
                      _buildContent(),
                      const SizedBox(height: 100), // Padding for floating toggle
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Center(
              child: PriceFeesToggle(),
            ),
          ),
        ],
      ),
    );
  }
}
