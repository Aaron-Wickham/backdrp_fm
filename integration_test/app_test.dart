import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

// Import all flow tests
import 'flows/authentication_flow_test.dart' as authentication_flow;
import 'flows/video_browsing_flow_test.dart' as video_browsing_flow;
import 'flows/profile_management_flow_test.dart' as profile_management_flow;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('BACKDRP.FM Integration Tests', () {
    group('Authentication Flows', () {
      authentication_flow.main();
    });

    group('Video Browsing Flows', () {
      video_browsing_flow.main();
    });

    group('Profile Management Flows', () {
      profile_management_flow.main();
    });
  });
}
