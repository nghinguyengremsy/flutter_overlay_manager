import 'package:flutter/material.dart';

class OverlayData<T> {
  final String id;
  final OverlayEntry entry;
  const OverlayData(
      {required this.id, required this.entry});
}
