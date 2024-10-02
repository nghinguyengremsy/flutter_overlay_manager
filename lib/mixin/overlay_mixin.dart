import 'package:flutter/material.dart';

import '../model/overlay_data.dart';
import '../model/overlay_position.dart';
import '../widget/overlay_widget.dart';

mixin OverlayMixin {
  final _overlayKey = GlobalKey<OverlayState>();
  final _entries = <String, OverlayData<OverlayEntry>>{};

  GlobalKey<OverlayState> get overlayKey => _overlayKey;

  /// This values are used for managing where the loading is requested to be displayed.
  BuildContext get currentContext => _overlayKey.currentContext!;
  OverlayState get _currentState {
    assert(_overlayKey.currentState != null,
        'Must attach the Overlay to widget tree');
    return _overlayKey.currentState!;
  }

  ///
  late final _orderedEntries = <String, OverlayPosition>{};

  bool hasEntry(String id) {
    return _entries[id] != null;
  }

  OverlayEntry? getEntry(String? id) {
    return _entries[id]?.data;
  }

  void insert(
    String id,
    OverlayEntry entry,
    GlobalKey<OverlayLayoutState> layoutKey,
  ) {
    final overlayPositon = getOverlayPosition(id);
    _entries[id] = OverlayData(id: id, data: entry, layoutKey: layoutKey);
    _currentState.insert(
      entry,
      below: getEntry(overlayPositon?.below ?? ''),
      above: getEntry(overlayPositon?.above ?? ''),
    );
  }

  void remove(String id) {
    final entry = _entries[id];
    if (entry != null) {
      entry.data.remove();
      _entries.remove(id);
    }
  }

  void setOverlayPosition(OverlayPosition position) {
    _orderedEntries[position.id] = position;
  }

  OverlayPosition? getOverlayPosition(String id) {
    OverlayPosition? pos = _orderedEntries[id];

    /// The entry with [id] will be on top.
    if (pos == null || (pos.below == null && pos.above == null)) {
      return null;
    }
    while (pos != null && (pos.below != null || pos.above != null)) {
      final entry = getEntry(pos.below) ?? getEntry(pos.above);
      if (entry != null) {
        break;
      }
      pos = _orderedEntries[pos.below ?? pos.above];
    }
    return pos;
  }
}
