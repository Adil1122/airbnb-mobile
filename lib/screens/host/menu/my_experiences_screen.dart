import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../models/listing.dart';
import '../../../services/experience_service.dart';
import 'create_experience_screen.dart';
import 'edit_experience_screen.dart';

class MyExperiencesScreen extends StatefulWidget {
  const MyExperiencesScreen({super.key});

  @override
  State<MyExperiencesScreen> createState() => _MyExperiencesScreenState();
}

class _MyExperiencesScreenState extends State<MyExperiencesScreen> {
  final ExperienceService _service = ExperienceService();
  List<Listing> _experiences = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _isLoading = true);
    try {
      final data = await _service.getMyExperiences();
      if (mounted) setState(() { _experiences = data; _isLoading = false; });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _delete(Listing exp) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete experience?'),
        content: Text('Are you sure you want to delete "${exp.title}"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await _service.deleteExperience(exp.id);
      setState(() => _experiences.removeWhere((e) => e.id == exp.id));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Experience deleted'), behavior: SnackBarBehavior.floating),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete: $e'), behavior: SnackBarBehavior.floating),
        );
      }
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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('My Experiences', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.black))
          : RefreshIndicator(
              onRefresh: _load,
              color: Colors.black,
              child: _experiences.isEmpty ? _buildEmpty() : _buildList(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(context,
              MaterialPageRoute(builder: (_) => const CreateExperienceScreen()));
          if (result == true) _load();
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.explore_outlined, size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No experiences yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Tap + to create your first experience', style: TextStyle(color: Colors.grey.shade500)),
        ],
      ),
    );
  }

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: _experiences.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, i) => _buildCard(_experiences[i]),
    );
  }

  Widget _buildCard(Listing exp) {
    return GestureDetector(
      onTap: () async {
        final updated = await Navigator.push<Listing>(context,
            MaterialPageRoute(builder: (_) => EditExperienceScreen(experience: exp)));
        if (updated != null) {
          setState(() {
            final idx = _experiences.indexWhere((e) => e.id == updated.id);
            if (idx != -1) _experiences[idx] = updated;
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: exp.imageUrl,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(width: 110, height: 110, color: Colors.grey.shade100,
                    child: const Icon(Icons.image_outlined, color: Colors.grey)),
                errorWidget: (_, __, ___) => Container(width: 110, height: 110, color: Colors.grey.shade100,
                    child: const Icon(Icons.image_outlined, color: Colors.grey)),
              ),
            ),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(exp.category.isEmpty ? 'Experience' : exp.category,
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(exp.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(exp.subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('\$${exp.price.toStringAsFixed(0)}/guest',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            _iconBtn(Icons.edit_outlined, () async {
                              final updated = await Navigator.push<Listing>(context,
                                  MaterialPageRoute(builder: (_) => EditExperienceScreen(experience: exp)));
                              if (updated != null) {
                                setState(() {
                                  final idx = _experiences.indexWhere((e) => e.id == updated.id);
                                  if (idx != -1) _experiences[idx] = updated;
                                });
                              }
                            }),
                            const SizedBox(width: 4),
                            _iconBtn(Icons.delete_outline, () => _delete(exp), color: Colors.red.shade400),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap, {Color? color}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade100),
        child: Icon(icon, size: 18, color: color ?? Colors.black),
      ),
    );
  }
}
