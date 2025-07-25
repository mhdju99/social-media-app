import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:social_media_app/core/constants/UserActions%20.dart';
import 'package:social_media_app/core/utils/logger.dart';
import 'package:social_media_app/core/utils/post_helper.dart';
import 'package:social_media_app/features/user_tracking/LogEntry.dart';
import 'tracker_repository.dart';

part 'tracker_event.dart';
part 'tracker_state.dart';

class TrackerBloc extends Bloc<TrackerEvent, TrackerState> {
  final TrackerRepository repository;

  TrackerBloc({required this.repository}) : super(TrackerState.initial()) {
    debugPrint("TrackerBloc created ✅ ✅ ✅ ✅ ✅"); // ✅ هنا أضفنا الطباعة

    on<LogActionEvent>((event, emit) {
      final updatedLogs = Map<String, List<LogEntry>>.from(state.logs);

      // أنشئ LogEntry جديد
      final logEntry = LogEntry(
        action: event.action,
        timestamp: DateTime.now(),
      );

      updatedLogs.putIfAbsent(event.category, () => []).add(logEntry);
      print("❤❤❤❤❤❤❤❤");

      print(updatedLogs.toString());
      emit(state.copyWith(logs: updatedLogs));
    });

    on<ResetSessionEvent>((event, emit) async {
      await Logger.log("Start new session");
      print("❤❤❤Start new session");
      emit(TrackerState.initial());
    });

    on<SendLogsEvent>((event, emit) async {
      // إرسال بصيغة JSON أو بالشكل المناسب حسب repo
      emit(TrackerState.initial()); // تصفير بعد الإرسال
    });
      on<SendFeedbackEvent>((event, emit) async {
      // إرسال بصيغة JSON أو بالشكل المناسب حسب repo
      await repository.sendfeedback(cat: event.category,logs: state.logs['category ${event.category}']!,
      rating: event.rating);
      // print("💌${state.logs.toString()}");
    });
  }

      
    
 Map<String, dynamic> getlogs(){
    return toJsonLogs(state.logs);

  }
}
