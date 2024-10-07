import 'package:flutter/material.dart';

import '../model/overlay_data.dart';
import '../model/overlay_position.dart';

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
  final _orderedEntries = <String, OverlayPosition>{};

  bool hasEntry(String id) {
    return _entries[id] != null;
  }

  OverlayEntry? getEntry(String? id) {
    return _entries[id]?.entry;
  }

  void insert(
    String id,
    OverlayEntry entry,
  ) {
    final overlayPositon = getOverlayPosition(id);
    _entries[id] = OverlayData(id: id, entry: entry);
    _currentState.insert(
      entry,
      below: getEntry(overlayPositon?.below ?? ''),
      above: getEntry(overlayPositon?.above ?? ''),
    );
  }

  void remove(String id) {
    final entry = _entries[id];
    if (entry != null) {
      entry.entry.remove();
      _entries.remove(id);
    }
  }

  void rearrangeByPosition() {
    final entries = <OverlayEntry>[];
    for (final element in _entries.entries) {
      final pos = getOverlayPosition(element.key);
      if (pos == null || (pos.above == null && pos.below == null)) {
        entries.add(element.value.entry);
      }
      if (pos!.above != null) {
        final above = getEntry(pos.above)!;
        final aboveIndex = entries.indexOf(above);
        if (aboveIndex == -1) {
          entries.add(element.value.entry);
        } else {
          entries.insert(aboveIndex + 1, element.value.entry);
        }
      } else {
        final below = getEntry(pos.below)!;
        final belowIndex = entries.indexOf(below);
        if (belowIndex == -1) {
          entries.insert(0, element.value.entry);
        } else {
          entries.insert(belowIndex, element.value.entry);
        }
      }
    }
    _currentState.rearrange(entries, below: entries.lastOrNull);
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
