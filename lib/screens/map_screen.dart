import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/api_config.dart';
import '../models/listing.dart';
import 'property_details_screen.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  final Set<Marker> _markers = {};
  List<dynamic> _properties = [];
  bool _loading = true;
  LatLng _initialPosition = const LatLng(37.7749, -122.4194); // Default SF

  @override
  void initState() {
    super.initState();
    _initLocation();
    _loadProperties();
  }

  Future<void> _initLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        await Geolocator.requestPermission();
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.low),
      );
      if (mounted) {
        setState(() => _initialPosition = LatLng(pos.latitude, pos.longitude));
        _mapController?.animateCamera(CameraUpdate.newLatLng(_initialPosition));
      }
    } catch (_) {}
  }

  Future<void> _loadProperties() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? '';
      final res = await http.get(
        Uri.parse(ApiConfig.propertiesUrl),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = data is List ? data : (data['properties'] ?? data['data'] ?? []);
        if (mounted) {
          setState(() {
            _properties = list as List;
            _loading = false;
          });
          _buildMarkers();
        }
      }
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _buildMarkers() {
    final markers = <Marker>{};
    for (final property in _properties) {
      final lat = double.tryParse(property['latitude']?.toString() ?? '');
      final lng = double.tryParse(property['longitude']?.toString() ?? '');
      if (lat == null || lng == null) continue;

      final price = property['price']?.toString() ?? '';
      markers.add(Marker(
        markerId: MarkerId(property['id'].toString()),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: property['title'] ?? '',
          snippet: price.isNotEmpty ? '\$$price / night' : '',
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PropertyDetailsScreen(listing: Listing.fromJson(property)),
            ),
          ),
        ),
      ));
    }
    setState(() => _markers.addAll(markers));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Map'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _initialPosition, zoom: 12),
            onMapCreated: (c) => _mapController = c,
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
          ),
          if (_loading)
            const Center(child: CircularProgressIndicator()),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
              ),
              child: Text(
                '${_properties.length} places found — tap a pin to view',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
