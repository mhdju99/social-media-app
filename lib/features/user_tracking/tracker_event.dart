// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'tracker_bloc.dart';

@immutable
abstract class TrackerEvent {}

class LogActionEvent extends TrackerEvent {
  final String category;
  final String action;

  LogActionEvent({required this.category, required this.action});
}

class ResetSessionEvent extends TrackerEvent {}

class SendLogsEvent extends TrackerEvent {}
class SendFeedbackEvent extends TrackerEvent {
  final int category;
  final int rating;
  SendFeedbackEvent({
    required this.category,
    required this.rating,
  });
}
