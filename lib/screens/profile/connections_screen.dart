import 'package:flutter/material.dart';
import '../../services/connections_service.dart';

class ConnectionsScreen extends StatefulWidget {
  const ConnectionsScreen({super.key});

  @override
  State<ConnectionsScreen> createState() => _ConnectionsScreenState();
}

class _ConnectionsScreenState extends State<ConnectionsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<dynamic> _connections = [];
  List<dynamic> _pending = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final results = await Future.wait([
      ConnectionsService.getConnections(),
      ConnectionsService.getPendingRequests(),
    ]);
    if (mounted) {
      setState(() {
        _connections = results[0];
        _pending = results[1];
        _loading = false;
      });
    }
  }

  Future<void> _respond(int connectionId, bool accept) async {
    await ConnectionsService.respond(connectionId, accept);
    await _load();
  }

  Future<void> _remove(int connectionId) async {
    await ConnectionsService.remove(connectionId);
    setState(() => _connections.removeWhere((c) => c['id'] == connectionId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        title: const Text('Connections', style: TextStyle(fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.black,
          tabs: [
            Tab(text: 'Friends (${_connections.length})'),
            Tab(text: 'Requests (${_pending.length})'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _ConnectionsList(connections: _connections, onRemove: _remove),
                _PendingList(pending: _pending, onRespond: _respond),
              ],
            ),
    );
  }
}

class _ConnectionsList extends StatelessWidget {
  final List<dynamic> connections;
  final Future<void> Function(int) onRemove;
  const _ConnectionsList({required this.connections, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    if (connections.isEmpty) {
      return const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.people_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No connections yet', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Connect with other Airbnb users', style: TextStyle(color: Colors.grey)),
        ]),
      );
    }
    return ListView.builder(
      itemCount: connections.length,
      itemBuilder: (_, i) {
        final c = connections[i];
        final user = c['requester'] ?? c['receiver'] ?? {};
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: user['avatar'] != null ? NetworkImage(user['avatar']) : null,
            child: user['avatar'] == null ? const Icon(Icons.person) : null,
          ),
          title: Text(user['name'] ?? 'User'),
          subtitle: Text(user['email'] ?? ''),
          trailing: PopupMenuButton(
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'remove', child: Text('Remove connection')),
            ],
            onSelected: (val) { if (val == 'remove') onRemove(c['id']); },
          ),
        );
      },
    );
  }
}

class _PendingList extends StatelessWidget {
  final List<dynamic> pending;
  final Future<void> Function(int, bool) onRespond;
  const _PendingList({required this.pending, required this.onRespond});

  @override
  Widget build(BuildContext context) {
    if (pending.isEmpty) {
      return const Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.check_circle_outline, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No pending requests', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ]),
      );
    }
    return ListView.builder(
      itemCount: pending.length,
      itemBuilder: (_, i) {
        final c = pending[i];
        final requester = c['requester'] ?? {};
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: requester['avatar'] != null ? NetworkImage(requester['avatar']) : null,
            child: requester['avatar'] == null ? const Icon(Icons.person) : null,
          ),
          title: Text(requester['name'] ?? 'User'),
          subtitle: const Text('wants to connect'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(
                onPressed: () => onRespond(c['id'], true),
                child: const Text('Accept', style: TextStyle(color: Color(0xFFE61E4D))),
              ),
              TextButton(
                onPressed: () => onRespond(c['id'], false),
                child: const Text('Decline', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        );
      },
    );
  }
}
