// This is a basic Flutter widget test.
//


import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:posts_manager/main.dart';

void main() {
  testWidgets('Posts Manager app loads successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const PostsManagerApp());

    // Verify that the app title appears
    expect(find.text('Posts Manager'), findsOneWidget);

    // Verify that the app loads content
    await tester.pumpAndSettle(); // Wait for async operations
    
    // Verify either loading spinner or posts list is displayed
    final hasLoadingWidget = find.byType(CircularProgressIndicator).evaluate().isNotEmpty;
    final hasListView = find.byType(ListView).evaluate().isNotEmpty;
    expect(hasLoadingWidget || hasListView, isTrue);
  });
}
