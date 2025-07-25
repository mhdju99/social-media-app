import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Logger {
  static File? _logFile;

  static Future<File> _getLogFile() async {
    if (_logFile != null) return _logFile!;

    final directory =
        await getApplicationDocumentsDirectory(); // يشتغل على أندرويد و iOS
    final path = '${directory.path}/test_api_log.txt';
    debugPrint(" ✅✅✅✅✅Logging to: $path"); // هنا نطبع مسار الملف للتأكد

    _logFile = File(path);
    if (!await _logFile!.exists()) {
      await _logFile!.create(recursive: true);
    }

    return _logFile!;
  }
static void testReadLogs() async {
    final file = await Logger._getLogFile();
    final content = await file.readAsString();
    debugPrint("📄 Log content:\n$content");
  }
  static Future<void> log(String message) async {
    final file = await _getLogFile();
    final now = DateTime.now();
    final formattedMessage = '[$now] $message\n';
    await file.writeAsString(formattedMessage, mode: FileMode.append);
  }

  static Future<void> clear() async {
    final file = await _getLogFile();
    await file.writeAsString('');
  }
}
