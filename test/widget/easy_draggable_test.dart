import 'package:easy_draggable/src/easy_draggable_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EasyDraggableWidget', () {
    testWidgets('EasyDraggableWidget renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: EasyDraggableWidget(
            padding: EdgeInsets.zero,
            floatingBuilder:
                (BuildContext context, BoxConstraints constraints) {
              return Container(
                width: 100,
                height: 100,
                color: Colors.blue,
              );
            },
          ),
        ),
      );

      // Verify that the EasyDraggableWidget is rendered
      expect(find.byType(EasyDraggableWidget), findsOneWidget);
    });

    test('should create a widget', () {
      final widget = EasyDraggableWidget(
        floatingBuilder: (context, _) => Container(),
      );
      expect(widget, isA<EasyDraggableWidget>());
    });

    test('should set the speed property', () {
      final widget = EasyDraggableWidget(
        floatingBuilder: (context, _) => Container(),
        speed: 100.0,
      );
      expect(widget.speed, 100.0);
    });

    test('should set the hasBounce property', () {
      final widget = EasyDraggableWidget(
        floatingBuilder: (context, _) => Container(),
        hasBounce: true,
      );
      expect(widget.hasBounce, true);
    });

    test('should set the autoAlign property', () {
      final widget = EasyDraggableWidget(
        floatingBuilder: (context, _) => Container(),
        autoAlign: true,
      );
      expect(widget.autoAlign, true);
    });
  });
}
