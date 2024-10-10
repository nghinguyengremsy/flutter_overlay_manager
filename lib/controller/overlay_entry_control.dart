import 'dart:async';

import '../model/overlay_entry_data.dart';
import '../repository/overlay_manager.dart';

class OverlayEntryControl {
  final OverlayEntryData _data;
  final OverlayManager _manager;
  final void Function()? _retakeFnc;
  final FutureOr<void> Function()? _dismissFnc;

  OverlayEntryControl(
      this._data, this._manager, this._retakeFnc, this._dismissFnc);

  /// Show the entry again.
  void retake() {
    _retakeFnc?.call();
  }

  Future<void> dismiss() async {
    await _dismissFnc?.call();
  }

  void setZIndex(int zindex) {
    _data.setZIndex(zindex);
    _manager.rearrange();
  }
}
