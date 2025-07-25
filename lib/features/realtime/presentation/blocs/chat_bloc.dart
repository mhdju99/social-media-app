import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/authentication/domain/usecases/GetUserIdUseCase.dart';
import 'package:social_media_app/features/authentication/domain/usecases/check_auth_status_usecase.dart';
import 'package:social_media_app/features/realtime/domain/usecases/connect_to_socket.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_All_chat_usecase.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_chat_usecase.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_message_stream.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_user_online_status_usecase.dart';
import 'package:social_media_app/features/realtime/domain/usecases/send_message.dart';
import 'package:social_media_app/features/realtime/domain/usecases/stream_user_offline_usecase.dart';
import 'package:social_media_app/features/realtime/domain/usecases/stream_user_online_usecase.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ConnectToSocketUseCase connectToSocket;
  final SendMessageUseCase sendMessage;
  final GetMessageStreamUseCase getMessageStream;
  final GetChatUseCase getChatUseCase;
  final GetAllChatUsecase getAllChatUsecase;
  final GetUserOnlineStatusUseCase getUserOnlineStatusUseCase;
  final GetUserIdUseCase getUserIdUseCase;
  final StreamUserOnlineUseCase userOnlineStream;
  final StreamUserOfflineUseCase userOfflineStream;
  final CheckAuthStatusUseCase checkLoginStatusUseCase;

  StreamSubscription? _messageSubscription;
  StreamSubscription? _userOnlineSubscription; // جديد
  StreamSubscription? _userOfflineSubscription; // جديد

  ChatBloc({
    required this.userOnlineStream,
    required this.userOfflineStream,
    required this.getUserIdUseCase,
    required this.getChatUseCase,
    required this.getUserOnlineStatusUseCase,
    required this.connectToSocket,
    required this.sendMessage,
    required this.getMessageStream,
    required this.getAllChatUsecase,
    required this.checkLoginStatusUseCase,
  }) : super(ChatInitial()) {
    on<ConnectToSocketEvent>(_onConnectToSocket);
    on<SendMessageEvent>(_onSendMessage);
    on<MessageReceivedEvent>(_onMessageReceived);
    on<GetChatEvent>(_onGetChat);
    on<GetUserOnlineStatusEvent>(_onGetUserOnlineStatus);
    on<GetAllChatEvent>(_onGetAllChats);

    // الأحداث الجديدة:
    on<UserBecameOnlineEvent>(_onUserBecameOnline);
    on<UserBecameOfflineEvent>(_onUserBecameOffline);

    // الاشتراكات:
    _messageSubscription = getMessageStream().listen((message) {
      add(MessageReceivedEvent(message));
    });

    // استمع لحالة المستخدمين online
    _userOnlineSubscription = userOnlineStream().listen((userId) {
      add(UserBecameOnlineEvent(userId));
    });

    // استمع لحالة المستخدمين offline
    _userOfflineSubscription = userOfflineStream().listen((data) {
      final userId = data['userId'] as String;
      final lastSeenAt = data['lastSeenAt'].toString();
      add(UserBecameOfflineEvent(userId, lastSeenAt));
    });
  }

  Future<void> _onConnectToSocket(
      // TODO: التعامل مع الأخطاء بشكل أفضل هنا

      ConnectToSocketEvent event,
      Emitter<ChatState> emit) async {
    final result = await checkLoginStatusUseCase();

    await connectToSocket(result['token']);
    emit(ChatConnected());
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    await sendMessage(event.to, event.content);
  }

  void _onMessageReceived(MessageReceivedEvent event, Emitter<ChatState> emit) {
    emit(ChatMessageReceived(event.message));
  }

  Future<void> _onGetChat(GetChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final result = await getChatUseCase(event.targetUserId);
    result.fold(
      (failure) => emit(ChatError(failure.errMessage)),
      (chat) => emit(ChatLoaded(chat)),
    );
  }

  Future<void> _onGetUserOnlineStatus(
      GetUserOnlineStatusEvent event, Emitter<ChatState> emit) async {
    final result = await getUserOnlineStatusUseCase(event.targetUserId);
    result.fold(
      (failure) => emit(ChatError(failure.errMessage)),
      (isOnline) => emit(UserOnlineStatusLoaded(isOnline)),
    );
  }

  Future<void> _onGetAllChats(
      GetAllChatEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    final userId = await getUserIdUseCase();

    final result = await getAllChatUsecase();
    result.fold((failure) => emit(ChatError(failure.errMessage)), (chats) {
      final updatedChats = chats.map((chat) {
        final updatedUsers = chat.users.where((u) => u != userId).toList();
        return chat.copyWith(users: updatedUsers);
      }).toList();
      emit(ChatListLoaded(updatedChats));
    });
  }

  void _onUserBecameOnline(
      UserBecameOnlineEvent event, Emitter<ChatState> emit) {
    emit(UserBecameOnlineState(event.userId));
  }

  void _onUserBecameOffline(
      UserBecameOfflineEvent event, Emitter<ChatState> emit) {
    emit(UserBecameOfflineState(event.userId, event.lastSeenAt));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _userOnlineSubscription?.cancel();
    _userOfflineSubscription?.cancel();
    return super.close();
  }
}
