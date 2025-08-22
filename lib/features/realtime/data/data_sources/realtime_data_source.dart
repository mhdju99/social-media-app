import 'dart:async';

import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/databases/api/api_consumer.dart';
import 'package:social_media_app/features/realtime/data/models/chat_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract class RealtimeDataSource {
  Future<ChatModel> getChat(String targetUserId);
  Future<List<ChatModel>> getAllChats();

  Future<Map<String, dynamic>> isUserOnline(String targetUserId);
  Future<void> connect(String token);
  void sendMessage(String to, String content);

  Stream<Map<String, dynamic>> get messageStream;
  Stream<List<dynamic>> get initialNotifications;
  Stream<Map<String, dynamic>> get newNotification;

  // الجدد:
  Stream<String> get userOnline;
  Stream<Map<String, dynamic>> get userOffline;

  void disconnect();
}

class RealtimeDataSourceImpl implements RealtimeDataSource {
  late IO.Socket _socket;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();

  final _initialNotifController = StreamController<List<dynamic>>.broadcast();
  final _newNotifController =
      StreamController<Map<String, dynamic>>.broadcast();

  // الجدد:
  final _userOnlineController = StreamController<String>.broadcast();
  final _userOfflineController =
      StreamController<Map<String, dynamic>>.broadcast();

  bool _isConnected = false;

  final ApiConsumer api;
  RealtimeDataSourceImpl({
    required this.api,
  });

  @override
  Future<ChatModel> getChat(String targetUserId) async {
    final uri = '${EndPoints.baseUrl}/chats';
    final response =
        await api.get(uri, queryParameters: {"targetUserId": targetUserId});
    return ChatModel.fromJson(response.data['chat']);
  }

  @override
  Future<List<ChatModel>> getAllChats() async {
    final uri = await EndPoints.getAllChatsEndPoint;
    final response = await api.get(uri);
    final data = response.data['chats'] as List;
    print("💨$data");
    return data.map((json) => ChatModel.fromJson(json)).toList();
  }

  @override
  Future<Map<String, dynamic>> isUserOnline(String targetUserId) async {
    final uri = '${EndPoints.baseUrl}/chats/user-online';
    final response =
        await api.get(uri, queryParameters: {"targetUserId": targetUserId});
    return response.data;
  }

  @override
  Future<void> connect(String token) async {
    _socket = IO.io('${EndPoints.socketUrl}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    _socket.connect();

    _socket.onConnect((_) {
      _isConnected = true;
      print('✅ Connected to socket server $token');
      print("qqqqqqqqqqqqqqq");
      _socket.emit('connected', {'token': token});
    });

    _socket.on('message', (data) {
      _messageController.add(Map<String, dynamic>.from(data));
    });

    _socket.on("initial_notifications", (data) {
      _initialNotifController.add(List<dynamic>.from(data));
    });

    _socket.on("new_notification", (notif) {
      _newNotifController.add(Map<String, dynamic>.from(notif));
    });

    // 📌 الجدد:
    _socket.on("user_online", (data) {
      print(data);

      final userId = data["userId"];
      _userOnlineController.add(userId);
    });

    _socket.on("user_offline", (data) {
      print(data);

      final map = Map<String, dynamic>.from(data);
      _userOfflineController.add(map);
    });

    _socket.on('disconnect', (_) {
      _isConnected = false;
      print('🔌 Socket disconnected.');
    });

    _socket.on('error', (data) {
      print('❌ Socket error: $data');
    });
  }

  @override
  void sendMessage(String to, String content) {
    if (_isConnected) {
      _socket.emit('message', {
        'to': to,
        'content': content,
      });
    } else {
      print('⚠️ Cannot send message: Socket is not connected.');
    }
  }

  @override
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;

  @override
  Stream<List<dynamic>> get initialNotifications =>
      _initialNotifController.stream;

  @override
  Stream<Map<String, dynamic>> get newNotification =>
      _newNotifController.stream;

  @override
  Stream<String> get userOnline => _userOnlineController.stream;

  @override
  Stream<Map<String, dynamic>> get userOffline => _userOfflineController.stream;

  @override
  void disconnect() {
     _socket.disconnect();
      _socket.destroy();
      _socket.dispose();
  }
}
