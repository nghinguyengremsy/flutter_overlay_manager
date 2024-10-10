import 'package:flutter/material.dart';

class OverlayEntryData {
  final String id;
  late int _zindex;
  final OverlayEntry entry;
  OverlayEntryData(
      {required this.id, required int zindex, required this.entry}) {
    _zindex = zindex;
  }
  
  int get zindex => _zindex;

  void setZIndex(int zindex) {
    _zindex = zindex;
  }
}
