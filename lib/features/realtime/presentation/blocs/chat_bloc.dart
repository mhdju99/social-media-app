import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_media_app/features/realtime/domain/usecases/connect_to_socket.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_chat_usecase.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_message_stream.dart';
import 'package:social_media_app/features/realtime/domain/usecases/get_user_online_status_usecase.dart';
import 'package:social_media_app/features/realtime/domain/usecases/send_message.dart';
import 'chat_event.dart';
import 'chat_state.dart';
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ConnectToSocketUseCase connectToSocket;
  final SendMessageUseCase sendMessage;
  final GetMessageStreamUseCase getMessageStream;
  final GetChatUseCase getChatUseCase;
  final GetUserOnlineStatusUseCase getUserOnlineStatusUseCase;

  StreamSubscription? _messageSubscription;

  ChatBloc({
    required this.getChatUseCase,
    required this.getUserOnlineStatusUseCase,
    required this.connectToSocket,
    required this.sendMessage,
    required this.getMessageStream,
  }) : super(ChatInitial()) {
    on<ConnectToSocketEvent>(_onConnectToSocket);
    on<SendMessageEvent>(_onSendMessage);
    on<MessageReceivedEvent>(_onMessageReceived);
    on<GetChatEvent>((event, emit) async {
      emit(ChatLoading());
      final result = await getChatUseCase(event.targetUserId);

      result.fold(
        (l) => emit(ChatError(l.errMessage)),
        (chat) => emit(ChatLoaded(chat)),
      );
    });
    on<GetUserOnlineStatusEvent>((event, emit) async {
      final result = await getUserOnlineStatusUseCase(event.targetUserId);

      result.fold(
        (l) => emit(ChatError(l.errMessage)),
        (isOnline) => emit(UserOnlineStatusLoaded(isOnline)),
      );
    });

    // ✅ احفظ الاشتراك لتجنب خطأ LateInitialization
    _messageSubscription = getMessageStream().listen((message) {
      add(MessageReceivedEvent(message));
    });
  }

  Future<void> _onConnectToSocket(
      ConnectToSocketEvent event, Emitter<ChatState> emit) async {
    await connectToSocket(event.token);
    emit(ChatConnected());
  }

  Future<void> _onSendMessage(
      SendMessageEvent event, Emitter<ChatState> emit) async {
    await sendMessage(event.to, event.content);
  }

  void _onMessageReceived(MessageReceivedEvent event, Emitter<ChatState> emit) {
    emit(ChatMessageReceived(event.message));
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel(); // ✅ إلغاء الاشتراك قبل إغلاق bloc
    return super.close();
  }
}
