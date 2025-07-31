// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dio/dio.dart';
import 'package:social_media_app/core/constants/end_points.dart';

import 'package:social_media_app/core/databases/api/api_consumer.dart';
import 'package:social_media_app/core/databases/api/dio_consumer.dart';
import 'package:social_media_app/features/user_tracking/LogEntry.dart';

class TrackerRepository {
  final ApiConsumer api;
  TrackerRepository({
    required this.api,
  });
  Map<String, dynamic> toJsonLogs(Map<String, List<LogEntry>> logs) {
    return {
      "logs": logs.map((category, entries) {
        return MapEntry(
          category,
          entries
              .map((e) => [e.action, e.timestamp.toIso8601String()])
              .toList(),
        );
      }),
    };
  }

  Future<void> sendLogs(Map<String, List<LogEntry>> logs) async {
    final payload = toJsonLogs(logs);
    (payload['logs'] as Map<String, dynamic>).entries.forEach((entry) {
      print('📁 ${entry.key}:');
      for (var log in entry.value) {
        print('  👉 $log');
      }
    });
    try {
      await api.post(await EndPoints.recommendEndPoint, data: payload);
      print("🈹✅ Logs sent");
    } catch (e) {
      print("🈹❌ Error sending logs: $e");
    }
  }

  Future<void> sendfeedback(
      {required List<LogEntry> logs,
      required int rating,
      required int cat}) async {
    print({
      "category": cat,
      "rating": rating,
      "logs": {
        "category $cat":
            logs.map((e) => [e.action, e.timestamp.toIso8601String()]).toList(),
      }
    });
    try {
      await api.post(await EndPoints.feedbackEndPoint, data: {
        "category": cat,
        "rating": rating,
        "logs": {
          "category $cat": logs
              .map((e) => [e.action, e.timestamp.toIso8601String()])
              .toList(),
        }
      });
      print("🈹✅ feedbCK sent");
    } catch (e) {
      print("🈹❌ Error sending logs: $e");
    }
  }
}
