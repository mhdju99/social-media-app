import 'dart:async';

import 'package:social_media_app/core/constants/end_points.dart';
import 'package:social_media_app/core/databases/api/api_consumer.dart';
import 'package:social_media_app/features/realtime/data/models/chat_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

abstract class RealtimeDataSource {
    Future<ChatModel> getChat(String targetUserId);

  Future<bool> isUserOnline(String targetUserId);
  Future<void> connect(String token);
  void sendMessage(String to, String content);
  Stream<Map<String, dynamic>> get messageStream;
    Stream<List<dynamic>> get initialNotifications;
  Stream<Map<String, dynamic>> get newNotification;
  // void dispose();
  void disconnect();
}

/// RealtimeDataSourceImpl is the concrete implementation of the RealtimeDataSource
/// interface.
/// This class implements the methods defined in RealtimeDataSource to fetch
/// data from a remote API or other data sources.
class RealtimeDataSourceImpl implements RealtimeDataSource {
    late IO.Socket _socket;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();

  final _initialNotifController = StreamController<List<dynamic>>.broadcast();
  final _newNotifController =
      StreamController<Map<String, dynamic>>.broadcast();
  bool _isConnected = false;

    final ApiConsumer api;
RealtimeDataSourceImpl({
    required this.api,
    // required this.local,
  });

   @override


  Future<ChatModel> getChat(String targetUserId) async {
    final uri = '${EndPoints.baseUrl}/chats';
    final response = await api.get(uri,
    queryParameters: {
"targetUserId": targetUserId
    });
       return ChatModel.fromJson(response.data['chat']);
   
  }


  @override
  Future<bool> isUserOnline(String targetUserId) async {
    final uri =
        '${EndPoints.baseUrl}/chat/user-online';
    final response =
        await api.get(uri, queryParameters: {"targetUserId": targetUserId});
       return response.data['onlineFlag'] ?? false;

  }

  @override
  Future<void> connect(String token) async {
    _socket = IO.io('${EndPoints.socetUrl}', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });
    print("sSSSSSSSS");

    _socket.connect();

    _socket.onConnect((_) {
      _isConnected = true;
      print('✅ Connected to socket server');
      _socket.emit('connected', {'token': token});
    });

    _socket.on('message', (data) {
            print('✅ message resive $data');

      _messageController.add(Map<String, dynamic>.from(data));
    });
    _socket.on("initial_notifications", (data) {
      _initialNotifController.add(List<dynamic>.from(data));
    });

    _socket.on("new_notification", (notif) {
      _newNotifController.add(Map<String, dynamic>.from(notif));
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
      print('✅ message send');

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
  void disconnect() {
    if (_isConnected) {
      _socket.disconnect(); // يبقي socket قابل للإعادة لاحقًا
      print('🛑 Socket connection closed temporarily.');
    }
  }

  // @override
  // void dispose() {
  //   _socket.dispose(); // يمنع إعادة الاتصال
  //   _messageController.close();
  //   print('🧹 Socket and stream cleaned up.');
  // }
}
