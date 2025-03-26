import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Optional: Set up a fallback handler for assets if needed
  TestWidgetsFlutterBinding.instance.defaultBinaryMessenger
      .setMockMessageHandler('flutter/assets', (message) async {
    // Allow test to proceed if asset is missing (e.g. localization)
    return null;
  });

  await testMain(); // Run all the tests
}
