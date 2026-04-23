import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/search_bar_widget.dart';
import '../widgets/category_tabs.dart';
import '../widgets/listing_carousel.dart';
import '../widgets/price_fees_toggle.dart';
import '../models/listing.dart';
import '../services/property_service.dart';
import '../services/experience_service.dart';
import '../services/service_service.dart';
import '../utils/api_config.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  int _selectedTabIndex = 0;
  bool _isLoading = true;
  bool _hasActiveSearch = false;
  String? _errorMessage;

  final _propertyService = PropertyService();
  final _experienceService = ExperienceService();
  final _serviceService = ServiceService();

  List<Listing> _allProperties = [];
  List<Listing> _allExperiences = [];
  List<Listing> _allServices = [];

  late final StreamSubscription<void> _refreshSubscription;

  @override
  void initState() {
    super.initState();
    _loadAllData();
    _refreshSubscription = PropertyService.refreshStream.listen((_) {
      _loadAllData();
    });
  }

  @override
  void dispose() {
    _refreshSubscription.cancel();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _hasActiveSearch = false;
    });

    try {
      print('DEBUG: Starting data load from ${ApiConfig.baseUrl}');
      final results = await Future.wait([
        _propertyService.fetchProperties(),
        _experienceService.fetchExperiences(),
        _serviceService.fetchServices(),
      ]);

      if (mounted) {
        setState(() {
          _allProperties = results[0] as List<Listing>;
          _allExperiences = results[1] as List<Listing>;
          _allServices = results[2] as List<Listing>;
          _isLoading = false;
        });
        print(
            'DEBUG: Data loaded. Properties: ${_allProperties.length}, Experiences: ${_allExperiences.length}, Services: ${_allServices.length}');
      }
    } catch (e) {
      print('DEBUG: Error in _loadAllData: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = e.toString().contains('SocketException')
              ? 'Could not connect to backend at ${ApiConfig.hostIp}. Please check your network and ensure the backend is running.'
              : 'Failed to load data. Ensure your backend is running! Details: ${e.toString().split(':').last}';
        });
      }
    }
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 80.0),
          child: CircularProgressIndicator(color: Color(0xFFE61E4D)),
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 60, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _loadAllData,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE61E4D),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final bool isEmpty = (_selectedTabIndex == 0 && _allProperties.isEmpty) ||
        (_selectedTabIndex == 1 && _allExperiences.isEmpty) ||
        (_selectedTabIndex == 2 && _allServices.isEmpty);

    if (isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 80.0, horizontal: 40.0),
          child: Column(
            children: [
              const Icon(Icons.search_off, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text(
                'No listings found',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Try adjusting your filters or searching for a different location.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: _loadAllData,
                child: const Text(
                  'Clear all filters',
                  style: TextStyle(
                      color: Colors.black, decoration: TextDecoration.underline),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_selectedTabIndex == 0) {
      return Column(
        children: [
          ListingCarousel(
            title: _hasActiveSearch ? 'Search results' : 'Available now', 
            listings: _allProperties
          ),
          if (!_hasActiveSearch && _allProperties.length > 3) ...[
            const SizedBox(height: 16),
            ListingCarousel(
                title: 'Top rated gems',
                listings: _allProperties.reversed.toList()),
          ],
        ],
      );
    } else if (_selectedTabIndex == 1) {
      return Column(
        children: [
          ListingCarousel(
              title: _hasActiveSearch ? 'Search results' : 'Real World Experiences', 
              listings: _allExperiences
          ),
        ],
      );
    } else {
      return Column(
        children: [
          ListingCarousel(
              title: _hasActiveSearch ? 'Search results' : 'Verified Services', 
              listings: _allServices
          ),
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
            child: RefreshIndicator(
              onRefresh: _loadAllData,
              color: const Color(0xFFE61E4D),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SearchBarWidget(
                          initialCategoryIndex: _selectedTabIndex,
                          onSearchResults: (results, categoryIndex) {
                            setState(() {
                              _selectedTabIndex = categoryIndex;
                              _hasActiveSearch = true;
                              if (categoryIndex == 1) {
                                _allExperiences = results;
                              } else if (categoryIndex == 2) {
                                _allServices = results;
                              } else {
                                _allProperties = results;
                              }
                            });
                          },
                        ),
                        // Homes / Experiences / Services tab switcher
                        CategoryTabs(
                          selectedIndex: _selectedTabIndex,
                          onTabSelected: (index) {
                            setState(() {
                              _selectedTabIndex = index;
                            });
                          },
                        ),
                        const Divider(
                            height: 1,
                            thickness: 1,
                            color: Color(0xFFF0F0F0)),
                        const SizedBox(height: 16),
                        _buildContent(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
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
