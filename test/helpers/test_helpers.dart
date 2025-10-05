import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:backdrp_fm/theme/app_theme.dart';

/// Helper function to wrap widgets with MaterialApp for testing
Widget createTestableWidget(Widget child) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: Scaffold(
      body: child,
    ),
  );
}

/// Helper function to wrap widgets with BlocProvider for testing
Widget createBlocTestableWidget<B extends StateStreamableSource<Object?>>(
  B bloc,
  Widget child,
) {
  return BlocProvider<B>.value(
    value: bloc,
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

/// Helper function to create a widget with multiple BLoC providers
Widget createMultiBlocTestableWidget({
  required List<BlocProvider> providers,
  required Widget child,
}) {
  return MultiBlocProvider(
    providers: providers,
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

/// Helper to wait for animations to complete
Future<void> pumpAndWait(WidgetTester tester, {Duration? duration}) async {
  await tester.pump(duration ?? const Duration(milliseconds: 100));
  await tester.pumpAndSettle();
}

/// Helper to find widgets by text (case insensitive)
Finder findTextContaining(String text) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Text &&
        widget.data != null &&
        widget.data!.toLowerCase().contains(text.toLowerCase()),
  );
}

/// Helper to verify if a widget exists
void expectWidgetExists(Finder finder) {
  expect(finder, findsOneWidget);
}

/// Helper to verify if a widget doesn't exist
void expectWidgetNotExists(Finder finder) {
  expect(finder, findsNothing);
}

/// Helper to verify multiple widgets exist
void expectWidgetsExist(Finder finder, int count) {
  expect(finder, findsNWidgets(count));
}

/// Helper for debugging - prints widget tree
void printWidgetTree(WidgetTester tester) {
  debugPrint(tester.allWidgets.map((w) => w.runtimeType.toString()).join('\n'));
}
