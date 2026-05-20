import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/api_config.dart';

class SocketService {
  static SocketService? _instance;
  WebSocketChannel? _channel;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _notifController = StreamController<Map<String, dynamic>>.broadcast();
  bool _connected = false;
  Timer? _reconnectTimer;

  static SocketService get instance {
    _instance ??= SocketService._();
    return _instance!;
  }

  SocketService._();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<Map<String, dynamic>> get notificationStream => _notifController.stream;
  bool get isConnected => _connected;

  Future<void> connect() async {
    if (_connected) return;
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) return;

    final wsUrl = ApiConfig.wsBaseUrl;
    try {
      _channel = WebSocketChannel.connect(
        Uri.parse('$wsUrl/chat?token=$token'),
      );

      _channel!.stream.listen(
        (data) {
          final decoded = jsonDecode(data as String) as Map<String, dynamic>;
          final event = decoded['event'] as String?;
          if (event == 'new_message') {
            _messageController.add(decoded['data'] ?? decoded);
          } else if (event == 'notification') {
            _notifController.add(decoded['data'] ?? decoded);
          }
        },
        onDone: _onDisconnected,
        onError: (_) => _onDisconnected(),
      );

      _connected = true;
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void joinConversation(int conversationId) {
    _send({'event': 'join_conversation', 'data': {'conversationId': conversationId}});
  }

  void leaveConversation(int conversationId) {
    _send({'event': 'leave_conversation', 'data': {'conversationId': conversationId}});
  }

  void sendTyping(int conversationId, bool isTyping) {
    _send({'event': 'typing', 'data': {'conversationId': conversationId, 'isTyping': isTyping}});
  }

  void _send(Map<String, dynamic> data) {
    if (_connected && _channel != null) {
      _channel!.sink.add(jsonEncode(data));
    }
  }

  void _onDisconnected() {
    _connected = false;
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), connect);
  }

  void disconnect() {
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _connected = false;
  }

  void dispose() {
    disconnect();
    _messageController.close();
    _notifController.close();
  }
}
