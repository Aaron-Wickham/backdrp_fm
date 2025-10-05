import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart';

const _topic = 'releases';
const webVapidKey =
    'BKxp-8NTct808Rjvl1-3LNgLRDsqZA6etvjnHVIbRGfN5Bhhke5v8Sn-jpQ4Aom6MwewhRJyLvsdDlMhQ2MOiPY'; // from Console → Project settings → Cloud Messaging → Web configuration
const _region = 'us-central1';

class TestPushPage extends StatefulWidget {
  const TestPushPage({super.key});
  @override
  State<TestPushPage> createState() => _TestPushPageState();
}

class _TestPushPageState extends State<TestPushPage> {
  String? _token;
  String _lastMsg = '(none)';
  bool _subscribed = false;
  bool _busy = false;

  FirebaseFunctions get _functions =>
      FirebaseFunctions.instanceFor(region: _region);

  @override
  void initState() {
    super.initState();
    _bootstrap();
    FirebaseMessaging.onMessage.listen((m) {
      final title = m.notification?.title ?? '';
      final body = m.notification?.body ?? '';
      setState(() => _lastMsg = '$title\n$body');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Foreground push: $title — $body')),
        );
      }
    });
  }

  Future<void> _bootstrap() async {
    setState(() => _busy = true);
    try {
      await FirebaseMessaging.instance.requestPermission();
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      _token = await FirebaseMessaging.instance.getToken(
        vapidKey: kIsWeb ? webVapidKey : null,
      );
      setState(() {});
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _subscribe() async {
    setState(() => _busy = true);
    try {
      if (kIsWeb) {
        if (_token == null) return;
        await _functions.httpsCallable('subscribeTokenToTopic').call({
          'token': _token,
          'topic': _topic,
        });
      } else {
        await FirebaseMessaging.instance.subscribeToTopic(_topic);
      }
      setState(() => _subscribed = true);
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _unsubscribe() async {
    setState(() => _busy = true);
    try {
      if (kIsWeb) {
        if (_token == null) return;
        await _functions.httpsCallable('unsubscribeTokenFromTopic').call({
          'token': _token,
          'topic': _topic,
        });
      } else {
        await FirebaseMessaging.instance.unsubscribeFromTopic(_topic);
      }
      setState(() => _subscribed = false);
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _sendTestToTopic() async {
    setState(() => _busy = true);
    try {
      await _functions.httpsCallable('sendTestToTopic').call({'topic': _topic});
    } finally {
      setState(() => _busy = false);
    }
  }

  Future<void> _sendTestToToken() async {
    if (_token == null) return;
    setState(() => _busy = true);
    try {
      await _functions.httpsCallable('sendTestToToken').call({'token': _token});
    } finally {
      setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokenShort = _token == null
        ? '(no token yet)'
        : '${_token!.substring(0, 12)}…${_token!.substring(_token!.length - 6)}';
    return Scaffold(
      appBar: AppBar(title: const Text('BACKDRP.FM — Push Tester')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Platform: ${kIsWeb ? "Web" : "Android/iOS"}'),
            const SizedBox(height: 8),
            Text('Token: $tokenShort'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                ElevatedButton(
                  onPressed: _busy ? null : _bootstrap,
                  child: const Text('Refresh token'),
                ),
                ElevatedButton(
                  onPressed: _busy ? null : _subscribe,
                  child: const Text('Subscribe to releases'),
                ),
                ElevatedButton(
                  onPressed: _busy ? null : _unsubscribe,
                  child: const Text('Unsubscribe'),
                ),
                ElevatedButton(
                  onPressed: _busy ? null : _sendTestToTopic,
                  child: const Text('Send TEST to TOPIC'),
                ),
                ElevatedButton(
                  onPressed: _busy ? null : _sendTestToToken,
                  child: const Text('Send TEST to THIS DEVICE'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Subscribed? '),
                Chip(label: Text(_subscribed ? 'YES' : 'NO')),
              ],
            ),
            const Divider(),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Last foreground message:'),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(_lastMsg),
            ),
          ],
        ),
      ),
    );
  }
}
