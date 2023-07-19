import 'package:easy_draggable/src/helpers/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NullableObjectUtils', () {
    test('let() should apply the mapper function if value is not null', () {
      const value = 10;
      final result = value.let((it) => it.toString());

      expect(result, '10');
    });
  });

  group('StateUtils', () {
    test('safeSetState() should call setState() if mounted', () {
      final state = TestState();
      state.mounted = true;

      var callbackCalled = false;
      state.safeSetState(() {
        callbackCalled = true;
      });

      expect(callbackCalled, true);
    });

    test('safeSetState() should call the callback directly if not mounted', () {
      final state = TestState();
      state.mounted = false;

      var callbackCalled = false;
      state.safeSetState(() {
        callbackCalled = true;
      });

      expect(callbackCalled, true);
    });
  });
}

class TestState extends State<StatefulWidget> {
  bool mounted = false;

  @override
  void setState(VoidCallback fn) {
    fn();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
