// ignore_for_file: public_member_api_docs, sort_constructors_first
class LogEntry {
  final String action;
  final DateTime timestamp;

  LogEntry({required this.action, required this.timestamp});

  factory LogEntry.fromList(List<String> list) {
    return LogEntry(
      action: list[0],
      timestamp: DateTime.parse(list[1]),
    );
  }

  List<String> toList() => [action, timestamp.toIso8601String()];

  @override
  String toString() => 'LogEntry(action: $action, timestamp: $timestamp)';
}
