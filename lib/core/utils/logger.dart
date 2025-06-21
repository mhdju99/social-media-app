import 'dart:io';

class Logger {
  static final File _logFile = File('test/logs/test_api_log.txt');

  static Future<void> log(String message) async {
    final now = DateTime.now();
    final formattedMessage = '[$now] $message\n';
    await _logFile.writeAsString(formattedMessage, mode: FileMode.append);
  }

  static Future<void> clear() async {
    if (await _logFile.exists()) {
      await _logFile.writeAsString(''); // Clear previous logs
    }
  }
}
