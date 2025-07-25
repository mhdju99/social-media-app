// lib/core/pages/set_ip_page.dart

import 'package:flutter/material.dart';
import 'package:social_media_app/core/databases/sh_helper.dart';

import '../../../../core/constants/end_points.dart';

class SetIpPage extends StatefulWidget {
  const SetIpPage({super.key});

  @override
  State<SetIpPage> createState() => _SetIpPageState();
}

class _SetIpPageState extends State<SetIpPage> {
  final TextEditingController _ipController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedIp();
  }

  Future<void> _loadSavedIp() async {
    final ip = await SharedPrefsHelper.getServerIp();
    if (ip != null) {
      _ipController.text = ip;
    }
  }

  Future<void> _saveIp() async {
    final ip = _ipController.text.trim();
    await SharedPrefsHelper.setServerIp(ip);
              await EndPoints.init();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('IP saved successfully')),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Server IP')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(
                labelText: 'Enter IP (e.g. 192.168.1.100)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveIp,
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
