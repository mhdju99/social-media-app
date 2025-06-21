import 'dart:io';

void main() async {
  final file = File('test/logs/test_api_log.txt');

  if (!await file.parent.exists()) {
    await file.parent.create(recursive: true);
    print('Created folder: ${file.parent.path}');
  }

  await file.writeAsString('Test log entry\n', mode: FileMode.append);

  print('Wrote to file: ${file.path}');
}
