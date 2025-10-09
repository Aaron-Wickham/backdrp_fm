// lib/notifications.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'firebase_options.dart';

const _topic = 'releases';

@pragma('vm:entry-point')
Future<void> _bg(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
}

Future<void> initFirebaseAndNotifications({required String webVapidKey}) async {
  // 1) Core + messaging bootstrap
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
  FirebaseMessaging.onBackgroundMessage(_bg);

  // 2) Ask for notification permission (Web + Android 13+ use same API)
  await FirebaseMessaging.instance.requestPermission();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  // 3) Get the token (Web requires VAPID)
  final token = await FirebaseMessaging.instance.getToken(
    vapidKey: kIsWeb ? webVapidKey : null,
  );

  // 4) Join the topic
  if (kIsWeb) {
    // Call your Gen-2 callable in us-central1
    if (token != null) {
      final functions = FirebaseFunctions.instanceFor(region: 'us-central1');
      final subscribe = functions.httpsCallable('subscribeTokenToTopic');
      await subscribe.call({'token': token, 'topic': _topic});
    }
  } else {
    // Android/iOS support client-side topics
    await FirebaseMessaging.instance.subscribeToTopic(_topic);
  }
}

// Optional toggles you can bind to a UI switch:
Future<void> subscribeToReleases({required String webVapidKey}) async {
  final token = await FirebaseMessaging.instance.getToken(
    vapidKey: kIsWeb ? webVapidKey : null,
  );
  if (kIsWeb) {
    if (token != null) {
      final functions = FirebaseFunctions.instanceFor(region: 'us-central1');
      await functions.httpsCallable('subscribeTokenToTopic').call({
        'token': token,
        'topic': _topic,
      });
    }
  } else {
    await FirebaseMessaging.instance.subscribeToTopic(_topic);
  }
}

Future<void> unsubscribeFromReleases({required String webVapidKey}) async {
  final token = await FirebaseMessaging.instance.getToken(
    vapidKey: kIsWeb ? webVapidKey : null,
  );
  if (kIsWeb) {
    if (token != null) {
      final functions = FirebaseFunctions.instanceFor(region: 'us-central1');
      await functions.httpsCallable('unsubscribeTokenFromTopic').call({
        'token': token,
        'topic': _topic,
      });
    }
  } else {
    await FirebaseMessaging.instance.unsubscribeFromTopic(_topic);
  }
}
