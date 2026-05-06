import 'package:flutter/material.dart';
import '../../../../models/listing.dart';
import '../../../../services/host_service.dart';
import 'guest_requirements_screen.dart';
import 'airbnb_org_stays_screen.dart';
import 'languages_editor_screen.dart';
import 'local_laws_screen.dart';
import 'unlisting_reason_screen.dart';

class EditPreferencesScreen extends StatefulWidget {
  final Listing listing;
  const EditPreferencesScreen({super.key, required this.listing});

  @override
  State<EditPreferencesScreen> createState() => _EditPreferencesScreenState();
}

class _EditPreferencesScreenState extends State<EditPreferencesScreen> {
  late Listing _listing;
  bool _isUpdating = false;
  final HostService _hostService = HostService();

  @override
  void initState() {
    super.initState();
    _listing = widget.listing;
  }

  Future<void> _toggleStatus() async {
    setState(() => _isUpdating = true);
    try {
      final newStatus = (_listing.status == 'ACTIVE' || _listing.status == 'PUBLISHED') ? 'UNLISTED' : 'ACTIVE';
      final updated = await _hostService.updateBasics(_listing.id, {'status': newStatus});
      setState(() {
        _listing = updated;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Listing is now ${newStatus == 'ACTIVE' ? 'Listed' : 'Unlisted'}')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isUpdating = false);
    }
  }

  Future<void> _removeListing() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove listing?'),
        content: const Text('This will permanently remove your listing from Airbnb. This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel', style: TextStyle(color: Colors.black))),
          TextButton(
            onPressed: () => Navigator.pop(context, true), 
            child: const Text('Remove', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isUpdating = true);
      try {
        await _hostService.deleteListing(_listing.id);
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error removing listing: $e')),
          );
        }
      } finally {
        setState(() => _isUpdating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isListed = _listing.status == 'ACTIVE' || _listing.status == 'PUBLISHED';
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context, true), // Signal that changes might have occurred
        ),
        title: const Text(
          'Edit preferences',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            children: [
              const SizedBox(height: 24),
              _buildPreferenceItem(
                context,
                'Listing status',
                isListed ? '●  Listed' : '●  Unlisted',
                subtitleColor: isListed ? Colors.green : Colors.grey,
                onTap: _toggleStatus,
              ),
              _buildPreferenceItem(
                context,
                'Languages',
                'English',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LanguagesEditorScreen())),
              ),
              _buildPreferenceItem(
                context,
                'Guest requirements',
                'Profile photo not required',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GuestRequirementsScreen())),
              ),
              _buildPreferenceItem(
                context,
                'Local laws',
                'Review your local laws',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LocalLawsScreen())),
              ),
              _buildPreferenceItem(
                context,
                'Airbnb.org stays',
                'Learn how you can help',
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AirbnbOrgStaysScreen())),
              ),
              _buildPreferenceItem(
                context,
                'Remove listing',
                'Permanently remove your listing from Airbnb.',
                onTap: _removeListing,
              ),
            ],
          ),
          if (_isUpdating)
            Container(
              color: Colors.white.withOpacity(0.5),
              child: const Center(child: CircularProgressIndicator(color: Colors.black)),
            ),
        ],
      ),
    );
  }

  Widget _buildPreferenceItem(BuildContext context, String title, String subtitle, {required VoidCallback onTap, Color? subtitleColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: subtitleColor ?? Colors.black54),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black54),
          ],
        ),
      ),
    );
  }
}
