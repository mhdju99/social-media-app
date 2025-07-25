part of 'tracker_bloc.dart';
class TrackerState {
  final Map<String, List<LogEntry>> logs;
  final DateTime startedAt;

  TrackerState({required this.logs, required this.startedAt});

  factory TrackerState.initial() {
    
    return TrackerState(
      logs:  {
        "category 0": [
         LogEntry(action: UserActions.connected, timestamp: DateTime.now())
        ],
        "category 1": [
          LogEntry(action: UserActions.connected, timestamp: DateTime.now())
        ],
        "category 2": [
          LogEntry(action: UserActions.connected, timestamp: DateTime.now())
        ],
        "category 3": [
          LogEntry(action: UserActions.connected, timestamp: DateTime.now())
        ],
        "category 4": [
          LogEntry(action: UserActions.connected, timestamp: DateTime.now())
        ],
        "category 5": [
          LogEntry(action: UserActions.connected, timestamp: DateTime.now())
        ],
      },
      startedAt: DateTime.now(),
    );
  }

  TrackerState copyWith({
    Map<String, List<LogEntry>>? logs,
    DateTime? startedAt,
  }) {
    return TrackerState(
      logs: logs ?? this.logs,
      startedAt: startedAt ?? this.startedAt,
    );
  }

  Map<String, List<List<String>>> toJson() {
    final map = <String, List<List<String>>>{};
    logs.forEach((key, entries) {
      map[key] = entries.map((e) => e.toList()).toList();
    });
    return map;
  }
}
