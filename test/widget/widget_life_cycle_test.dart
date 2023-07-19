import 'package:easy_draggable/src/helpers/widget_life_cycle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WidgetLifecycleListener', () {
    late VoidCallback onInitCallback;
    late VoidCallback onDisposeCallback;
    late Widget child;
    late WidgetLifecycleListener widget;

    setUp(() {
      onInitCallback = () {};
      onDisposeCallback = () {};
      child = Container();
    });

    testWidgets('should call onInit callback when initialized',
            (WidgetTester tester) async {
          bool onInitCalled = false;

          await tester.pumpWidget(
            WidgetLifecycleListener(
              onInit: () {
                onInitCalled = true;
              },
              onDispose: onDisposeCallback,
              child: child,
            ),
          );

          expect(onInitCalled, true);
        });

    testWidgets('should call onDispose callback when disposed',
            (WidgetTester tester) async {
          bool onDisposeCalled = false;

          await tester.pumpWidget(
            WidgetLifecycleListener(
              onInit: onInitCallback,
              onDispose: () {
                onDisposeCalled = true;
              },
              child: child,
            ),
          );

          await tester.pumpWidget(Container());

          expect(onDisposeCalled, true);
        });

    testWidgets('should return child widget when child is not null',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            WidgetLifecycleListener(
              onInit: onInitCallback,
              onDispose: onDisposeCallback,
              child: child,
            ),
          );

          final widgetFinder = find.byWidget(child);

          expect(widgetFinder, findsOneWidget);
        });

    testWidgets('should return SizedBox when child is null and isSliver is false',
            (WidgetTester tester) async {
          await tester.pumpWidget(
            WidgetLifecycleListener.custom(
              onInit: onInitCallback,
              onDispose: onDisposeCallback,
              child: null,
              isSliver: false,
            ),
          );

          final widgetFinder = find.byType(SizedBox);

          expect(widgetFinder, findsOneWidget);
        });
  });
}
