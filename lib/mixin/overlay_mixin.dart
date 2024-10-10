import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import '../model/overlay_entry_data.dart';

mixin OverlayMixin {
  final _overlayKey = GlobalKey<OverlayState>();
  final _hashEntries = <String, OverlayEntryData>{};
  final _entries = <OverlayEntryData>[];
  GlobalKey<OverlayState> get overlayKey => _overlayKey;

  /// This values are used for managing where the loading is requested to be displayed.
  BuildContext get currentContext => _overlayKey.currentContext!;
  OverlayState get _currentState {
    assert(_overlayKey.currentState != null,
        'Must attach the Overlay to widget tree');
    return _overlayKey.currentState!;
  }

  bool hasEntry(String id) {
    return _hashEntries[id] != null;
  }

  OverlayEntryData? getOverlayEntryData(String? id) {
    return _hashEntries[id];
  }

  OverlayEntry? getEntry(String? id) {
    return _hashEntries[id]?.entry;
  }

  OverlayEntryData insert(
    String id,
    int zindex,
    OverlayEntry entry,
  ) {
    final overlayData = OverlayEntryData(id: id, zindex: zindex, entry: entry);
    _insert(overlayData);
    return overlayData;
  }

  void retake(
    OverlayEntryData data,
  ) {
    if (!hasEntry(data.id)) {
      _insert(data);
    }
  }

  void _insert(
    OverlayEntryData data,
  ) {
    final belowOverlayEntry = _getBelowOverlayEntry(data.zindex);
    _hashEntries[data.id] = data;
    // If the entries is empty, just add new entry to list.
    if (_entries.isEmpty) {
      _entries.add(data);
      _currentState.insert(data.entry);
    } else {
      // If there's an entry below the new entry, put it behide.
      if (belowOverlayEntry != null) {
        _entries.insert(data.zindex + 1, data);
        _currentState.insert(
          data.entry,
          above: belowOverlayEntry.entry,
        );
      } else {
        // There's no entry below the new entry, it should be at first in the list.
        final aboveOverlayEntry = _entries.first.entry;
        _entries.insert(0, data);
        _currentState.insert(
          data.entry,
          below: aboveOverlayEntry,
        );
      }
    }
  }

  void remove(String id) {
    final entry = _hashEntries[id];
    if (entry != null) {
      entry.entry.remove();
      _hashEntries.remove(id);
      _entries.remove(entry);
    }
  }

  void rearrangeByZIndex() {
    // final entries = _hashEntries.values.toList();
    // entries.sort((a, b) => a.zindex.compareTo(b.zindex));
    final convertedEntries = _entries.map((e) => e.entry);
    _currentState.rearrange(convertedEntries,
        below: convertedEntries.isNotEmpty ? convertedEntries.last : null);
  }

  OverlayEntryData? _getBelowOverlayEntry(int zindex) {
    final found = _entries.lastWhereOrNull((e) => zindex > e.zindex);
    return found;
  }
  // void rearrangeByPosition() {
  //   final entries = <OverlayEntry>[];
  //   for (final element in _hashEntries.entries) {
  //     final pos = _getOverlayPosition(element.key);
  //     if (pos == null || (pos.above == null && pos.below == null)) {
  //       entries.add(element.value.entry);
  //     }
  //     if (pos!.above != null) {
  //       final above = getEntry(pos.above)!;
  //       final aboveIndex = entries.indexOf(above);
  //       if (aboveIndex == -1) {
  //         entries.add(element.value.entry);
  //       } else {
  //         entries.insert(aboveIndex + 1, element.value.entry);
  //       }
  //     } else {
  //       final below = getEntry(pos.below)!;
  //       final belowIndex = entries.indexOf(below);
  //       if (belowIndex == -1) {
  //         entries.insert(0, element.value.entry);
  //       } else {
  //         entries.insert(belowIndex, element.value.entry);
  //       }
  //     }
  //   }
  //   _currentState.rearrange(entries,
  //       below: entries.isNotEmpty ? entries.last : null);
  // }
  // OverlayPosition? _getOverlayPosition(String id) {
  //   OverlayPosition? pos = _orderedEntries[id];

  //   /// The entry with [id] will be on top.
  //   if (pos == null || (pos.below == null && pos.above == null)) {
  //     return null;
  //   }
  //   while (pos != null && (pos.below != null || pos.above != null)) {
  //     final entry = getEntry(pos.below) ?? getEntry(pos.above);
  //     if (entry != null) {
  //       break;
  //     }
  //     pos = _orderedEntries[pos.below ?? pos.above];
  //   }
  //   return pos;
  // }
}
