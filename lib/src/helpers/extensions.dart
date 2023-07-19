import 'package:flutter/cupertino.dart';

extension NullableObjectUtils<T> on T? {
  /// Apply the [mapper] to the value if it's not null,
  /// then return the result of the mapping operation.
  S? let<S>(S? Function(T it) mapper) {
    if (this is T) {
      return mapper(this as T);
    }
    return null;
  }
}
extension StateUtils<W extends StatefulWidget> on State<W> {
  @protected
  void safeSetState(VoidCallback callback) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      setState(callback);
    } else {
      callback();
    }
  }
}
