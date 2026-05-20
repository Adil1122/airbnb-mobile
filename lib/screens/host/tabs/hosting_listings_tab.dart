import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../required_actions_screen.dart';
import '../menu/create_listing_screen.dart';
import '../menu/create_experience_screen.dart';
import '../menu/create_service_screen.dart';
import '../menu/edit_experience_screen.dart';
import '../menu/edit_service_screen.dart';
import '../edit_listings_screen.dart';
import '../listing_editor_screen.dart';
import '../editor/your_space/property_type_editor_screen.dart';
import '../identity_verification_screen.dart';
import '../../../services/host_service.dart';
import '../../../services/property_service.dart';
import '../../../services/auth_service.dart';
import '../../../services/experience_service.dart';
import '../../../services/service_service.dart';
import '../../../models/listing.dart';
import '../../../models/user_model.dart';

class HostingListingsTab extends StatefulWidget {
  const HostingListingsTab({super.key});

  @override
  State<HostingListingsTab> createState() => _HostingListingsTabState();
}

class _HostingListingsTabState extends State<HostingListingsTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Properties state
  bool _isGrid = false;
  bool _isSearching = false;
  bool _isEditing = false;
  final Set<String> _selectedIds = {};
  final TextEditingController _searchController = TextEditingController();
  final HostService _hostService = HostService();
  final AuthService _authService = AuthService();
  List<Listing> _listings = [];
  UserModel? _user;
  bool _isLoadingProps = true;
  String? _errorMessage;

  // Experiences state
  final ExperienceService _expService = ExperienceService();
  List<Listing> _experiences = [];
  bool _isLoadingExp = true;

  // Services state
  final ServiceService _svcService = ServiceService();
  List<Listing> _services = [];
  bool _isLoadingSvc = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
    _fetchAll();
  }

  Future<void> _fetchAll() {
    return Future.wait([_fetchListings(), _fetchExperiences(), _fetchServices()]);
  }

  Future<void> _fetchListings() async {
    setState(() { _isLoadingProps = true; _errorMessage = null; });
    try {
      final listingData = await _hostService.getListings();
      final userData = await _authService.getProfile();
      if (mounted) setState(() { _listings = listingData; _user = userData; _isLoadingProps = false; });
    } catch (e) {
      if (mounted) setState(() { _errorMessage = e.toString(); _isLoadingProps = false; });
    }
  }

  Future<void> _fetchExperiences() async {
    setState(() => _isLoadingExp = true);
    try {
      final data = await _expService.getMyExperiences();
      if (mounted) setState(() { _experiences = data; _isLoadingExp = false; });
    } catch (e) {
      if (mounted) setState(() => _isLoadingExp = false);
    }
  }

  Future<void> _fetchServices() async {
    setState(() => _isLoadingSvc = true);
    try {
      final data = await _svcService.getMyServices();
      if (mounted) setState(() { _services = data; _isLoadingSvc = false; });
    } catch (e) {
      if (mounted) setState(() => _isLoadingSvc = false);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  int get _tab => _tabController.index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPropertiesTab(),
          _buildExperiencesTab(),
          _buildServicesTab(),
        ],
      ),
      floatingActionButton: _tab == 0 ? null : FloatingActionButton(
        onPressed: () async {
          if (_tab == 1) {
            final result = await Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CreateExperienceScreen()));
            if (result == true) _fetchExperiences();
          } else {
            final result = await Navigator.push(context,
                MaterialPageRoute(builder: (_) => const CreateServiceScreen()));
            if (result == true) _fetchServices();
          }
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: _tab != 0
          ? null
          : _isEditing
              ? _buildEditBar()
              : ((_user?.isIdentityVerified ?? false) && (_user?.isPhoneVerified ?? false))
                  ? null
                  : _buildActionBanner(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      toolbarHeight: _isSearching ? 80 : 100,
      title: Padding(
        padding: EdgeInsets.only(top: _isSearching ? 0.0 : 10.0),
        child: _isSearching
            ? Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: 'Search listings by name or location',
                          hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                          prefixIcon: Icon(Icons.search, color: Colors.black),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () => setState(() { _isSearching = false; _searchController.clear(); }),
                    child: const Text('Cancel',
                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Listings',
                      style: TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold)),
                  Row(children: _buildAppBarActions()),
                ],
              ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
            indicatorColor: Colors.black,
            indicatorWeight: 2,
            tabs: const [
              Tab(text: 'Properties'),
              Tab(text: 'Experiences'),
              Tab(text: 'Services'),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_tab == 0) {
      return [
        _buildHeaderIcon(Icons.search, onTap: () => setState(() => _isSearching = true)),
        const SizedBox(width: 12),
        _buildHeaderIcon(Icons.add, onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => const CreateListingScreen()))),
        const SizedBox(width: 12),
        _buildHeaderIcon(
          _isGrid ? Icons.format_list_bulleted : Icons.grid_view_outlined,
          onTap: () => setState(() => _isGrid = !_isGrid),
        ),
        const SizedBox(width: 12),
        _buildHeaderIcon(
          _isEditing ? Icons.close : Icons.edit_outlined,
          isActive: _isEditing,
          onTap: () => setState(() {
            _isEditing = !_isEditing;
            if (!_isEditing) _selectedIds.clear();
          }),
        ),
      ];
    }
    return [];
  }

  // ─── Properties Tab ───────────────────────────────────────────────────────

  Widget _buildPropertiesTab() {
    if (_isLoadingProps) return const Center(child: CircularProgressIndicator(color: Colors.black));
    if (_errorMessage != null) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('Error: $_errorMessage'),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: _fetchListings, child: const Text('Retry')),
        ]),
      );
    }

    final filtered = _listings.where((l) {
      final q = _searchController.text.toLowerCase();
      return l.title.toLowerCase().contains(q) || l.subtitle.toLowerCase().contains(q);
    }).toList();

    final drafts = filtered.where((l) => l.status == 'DRAFT' || l.title.isEmpty || l.title == 'Untitiled Listing').toList();
    final active = filtered.where((l) => !drafts.contains(l)).toList();

    return RefreshIndicator(
      onRefresh: _fetchListings,
      color: Colors.black,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(height: 16),
          if (active.isNotEmpty) ...[
            _buildSectionHeader('${active.length} active listing${active.length == 1 ? '' : 's'}'),
            const SizedBox(height: 16),
            _isGrid ? _buildGridView(active) : _buildListView(active),
            const SizedBox(height: 32),
          ],
          if (drafts.isNotEmpty) ...[
            _buildSectionHeader('${drafts.length} draft listing${drafts.length == 1 ? '' : 's'}'),
            const SizedBox(height: 16),
            _isGrid ? _buildGridView(drafts) : _buildListView(drafts),
            const SizedBox(height: 32),
          ],
          if (filtered.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(top: 80.0),
                child: Text('No listings found', style: TextStyle(color: Colors.grey)),
              ),
            ),
        ]),
      ),
    );
  }

  // ─── Experiences Tab ──────────────────────────────────────────────────────

  Widget _buildExperiencesTab() {
    if (_isLoadingExp) return const Center(child: CircularProgressIndicator(color: Colors.black));
    if (_experiences.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.explore_outlined, size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No experiences yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Tap + to create your first experience', style: TextStyle(color: Colors.grey.shade500)),
        ]),
      );
    }
    return RefreshIndicator(
      onRefresh: _fetchExperiences,
      color: Colors.black,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: _experiences.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _buildExpSvcCard(
          item: _experiences[i],
          onEdit: () async {
            final updated = await Navigator.push<Listing>(context,
                MaterialPageRoute(builder: (_) => EditExperienceScreen(experience: _experiences[i])));
            if (updated != null) {
              setState(() {
                final idx = _experiences.indexWhere((e) => e.id == updated.id);
                if (idx != -1) _experiences[idx] = updated;
              });
            }
          },
          onDelete: () => _deleteExperience(_experiences[i]),
        ),
      ),
    );
  }

  Future<void> _deleteExperience(Listing exp) async {
    final confirmed = await _confirmDelete(exp.title);
    if (confirmed != true) return;
    try {
      await _expService.deleteExperience(exp.id);
      setState(() => _experiences.removeWhere((e) => e.id == exp.id));
      if (mounted) _snack('Experience deleted');
    } catch (e) {
      if (mounted) _snack('Failed to delete: $e');
    }
  }

  // ─── Services Tab ─────────────────────────────────────────────────────────

  Widget _buildServicesTab() {
    if (_isLoadingSvc) return const Center(child: CircularProgressIndicator(color: Colors.black));
    if (_services.isEmpty) {
      return Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.handyman_outlined, size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text('No services yet', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Tap + to create your first service', style: TextStyle(color: Colors.grey.shade500)),
        ]),
      );
    }
    return RefreshIndicator(
      onRefresh: _fetchServices,
      color: Colors.black,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: _services.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _buildExpSvcCard(
          item: _services[i],
          onEdit: () async {
            final updated = await Navigator.push<Listing>(context,
                MaterialPageRoute(builder: (_) => EditServiceScreen(service: _services[i])));
            if (updated != null) {
              setState(() {
                final idx = _services.indexWhere((e) => e.id == updated.id);
                if (idx != -1) _services[idx] = updated;
              });
            }
          },
          onDelete: () => _deleteService(_services[i]),
        ),
      ),
    );
  }

  Future<void> _deleteService(Listing svc) async {
    final confirmed = await _confirmDelete(svc.title);
    if (confirmed != true) return;
    try {
      await _svcService.deleteService(svc.id);
      setState(() => _services.removeWhere((e) => e.id == svc.id));
      if (mounted) _snack('Service deleted');
    } catch (e) {
      if (mounted) _snack('Failed to delete: $e');
    }
  }

  // ─── Shared Experience/Service Card ──────────────────────────────────────

  Widget _buildExpSvcCard({
    required Listing item,
    required VoidCallback onEdit,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      onTap: onEdit,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(width: 110, height: 110, color: Colors.grey.shade100,
                    child: const Icon(Icons.image_outlined, color: Colors.grey)),
                errorWidget: (_, __, ___) => Container(width: 110, height: 110, color: Colors.grey.shade100,
                    child: const Icon(Icons.image_outlined, color: Colors.grey)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade100, borderRadius: BorderRadius.circular(6)),
                    child: Text(item.category.isEmpty ? 'Listing' : item.category,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500)),
                  ),
                  const SizedBox(height: 6),
                  Text(item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(item.subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${item.price.toStringAsFixed(0)}/guest',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                      Row(children: [
                        _iconBtn(Icons.edit_outlined, onEdit),
                        const SizedBox(width: 4),
                        _iconBtn(Icons.delete_outline, onDelete, color: Colors.red.shade400),
                      ]),
                    ],
                  ),
                ]),
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

  Future<bool?> _confirmDelete(String title) => showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Delete?'),
          content: Text('Delete "$title"? This cannot be undone.'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Delete', style: TextStyle(color: Colors.red))),
          ],
        ),
      );

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating));
  }

  // ─── Existing Property helpers (unchanged) ────────────────────────────────

  Widget _buildSectionHeader(String title) {
    return Text(title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black));
  }

  Widget _buildActionBanner() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => RequiredActionsScreen(
              propertyTitle: _listings.isNotEmpty ? _listings.first.title : null))),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24), topRight: Radius.circular(24)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, -4))],
          border: Border(top: BorderSide(color: Colors.grey.shade100)),
        ),
        child: SafeArea(
          top: false,
          child: Row(children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.camera_alt_outlined, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
                Text('Confirm a few key details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Required to publish', style: TextStyle(fontSize: 14, color: Colors.grey)),
              ]),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ]),
        ),
      ),
    );
  }

  Widget _buildEditBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4))],
      ),
      child: SafeArea(
        top: false,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(
            onTap: () => setState(() { _isEditing = false; _selectedIds.clear(); }),
            child: const Text('Cancel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline)),
          ),
          ElevatedButton(
            onPressed: _selectedIds.isEmpty
                ? null
                : () => showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => EditListingsScreen(selectedCount: _selectedIds.length),
                    ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              disabledBackgroundColor: Colors.grey.shade300,
            ),
            child: Text('Edit ${_selectedIds.length} listing${_selectedIds.length == 1 ? '' : 's'}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
        ]),
      ),
    );
  }

  Widget _buildGridView(List<Listing> listings) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 24, childAspectRatio: 0.65,
      ),
      itemCount: listings.length,
      itemBuilder: (_, i) => _buildListingCard(listing: listings[i]),
    );
  }

  Widget _buildListView(List<Listing> listings) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: listings
          .map((l) => Padding(padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildListRow(listing: l)))
          .toList(),
    );
  }

  Widget _buildListRow({required Listing listing}) {
    final isSelected = _selectedIds.contains(listing.id);
    final isPlaceholder = listing.imageUrl.contains('placeholder') || listing.imageUrl.isEmpty;
    return GestureDetector(
      onTap: _isEditing
          ? () => setState(() => isSelected ? _selectedIds.remove(listing.id) : _selectedIds.add(listing.id))
          : isPlaceholder
              ? () => _showInProgressBottomSheet(context, listing)
              : () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ListingEditorScreen(listing: listing))),
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Row(children: [
          if (_isEditing) ...[
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                color: isSelected ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade400, width: 1.5),
              ),
              child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
            ),
            const SizedBox(width: 16),
          ],
          Stack(children: [
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(
                color: isPlaceholder ? const Color(0xFFF2F2F2) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                image: listing.imageUrl.isNotEmpty
                    ? DecorationImage(image: NetworkImage(listing.imageUrl), fit: BoxFit.cover)
                    : null,
              ),
              child: listing.imageUrl.isEmpty
                  ? const Center(child: Icon(Icons.camera_alt_outlined, color: Color(0xFFB0B0B0), size: 32))
                  : null,
            ),
            Positioned(
              top: 4, left: 4,
              child: Container(
                width: 12, height: 12,
                decoration: BoxDecoration(
                    color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
              ),
            ),
          ]),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(listing.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(listing.subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey)),
          ])),
        ]),
      ),
    );
  }

  Widget _buildListingCard({required Listing listing}) {
    final isSelected = _selectedIds.contains(listing.id);
    final isPlaceholder = listing.imageUrl.contains('placeholder') || listing.imageUrl.isEmpty;
    return GestureDetector(
      onTap: _isEditing
          ? () => setState(() => isSelected ? _selectedIds.remove(listing.id) : _selectedIds.add(listing.id))
          : isPlaceholder
              ? () => _showInProgressBottomSheet(context, listing)
              : () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => ListingEditorScreen(listing: listing))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: isPlaceholder ? const Color(0xFFEBEBEB) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
                image: listing.imageUrl.isNotEmpty
                    ? DecorationImage(image: NetworkImage(listing.imageUrl), fit: BoxFit.cover)
                    : null,
              ),
              child: listing.imageUrl.isEmpty
                  ? const Center(child: Icon(Icons.camera_alt_outlined, color: Color(0xFFB0B0B0), size: 100))
                  : null,
            ),
          ),
          if (!_isEditing)
            Positioned(
              top: 16, left: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4)],
                ),
                child: const Row(mainAxisSize: MainAxisSize.min, children: [
                  CircleAvatar(radius: 4, backgroundColor: Colors.green),
                  SizedBox(width: 8),
                  Text('Published', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                ]),
              ),
            ),
          if (_isEditing)
            Positioned(
              top: 12, right: 12,
              child: Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: isSelected ? Colors.black : Colors.grey.shade400, width: 1.5),
                ),
                child: isSelected ? const Icon(Icons.check, color: Colors.white, size: 20) : null,
              ),
            ),
        ]),
        const SizedBox(height: 12),
        Text(listing.title,
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(listing.subtitle,
            maxLines: 2, overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
      ]),
    );
  }

  void _showInProgressBottomSheet(BuildContext context, Listing listing) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
          ]),
          const SizedBox(height: 8),
          Container(
            width: 160, height: 160,
            decoration: BoxDecoration(color: const Color(0xFFEBEBEB), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.camera_alt_outlined, color: Color(0xFFB0B0B0), size: 64),
          ),
          const SizedBox(height: 24),
          Text(listing.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Text(listing.subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey), textAlign: TextAlign.center),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity, height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const PropertyTypeEditorScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0,
              ),
              child: const Text('Edit listing', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Remove listing?'),
                  content: const Text('This will permanently delete your listing. This action cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                        _removeListing(listing.id);
                      },
                      child: const Text('Remove', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              );
            },
            child: const Text('Remove listing',
                style: TextStyle(color: Colors.black, fontSize: 14,
                    fontWeight: FontWeight.bold, decoration: TextDecoration.underline)),
          ),
          const SizedBox(height: 16),
        ]),
      ),
    );
  }

  void _removeListing(String id) async {
    try {
      await _hostService.deleteListing(id);
      if (mounted) {
        setState(() => _listings.removeWhere((l) => l.id == id));
        PropertyService.triggerRefresh();
        _snack('Listing removed permanently');
      }
    } catch (e) {
      if (mounted) _snack('Error removing listing: $e');
    }
  }

  Widget _buildHeaderIcon(IconData icon, {VoidCallback? onTap, bool isActive = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Icon(icon, color: isActive ? Colors.white : Colors.black, size: 20),
      ),
    );
  }
}
