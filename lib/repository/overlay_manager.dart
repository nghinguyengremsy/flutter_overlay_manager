import 'package:flutter/material.dart';
import '../controller/overlay_entry_control.dart';
import '../widget/overlay_widget.dart';

abstract class OverlayManager {
  String get loadingOverlayId;

  Widget builder(Widget Function(BuildContext context) builder);

  /// If the `id` exists, just keep the current entry respectively.
  /// The entry's inserted just below the entry whose zindex greater than the `zindex`.
  /// Return an OverlayEntryControl instance for controlling the entry if need.
  OverlayEntryControl show(
    Widget Function(BuildContext context) builder, {
    required String id,
    required int zindex,
    Color backgroundColor = Colors.transparent,
    OverlayLayoutTypeEnum type = OverlayLayoutTypeEnum.custom,
    bool dismissible = false,
  });

  /// Check whether the overlay is displayed
  bool isOverlayShowing(String overlayId);

  void setLoadingBackgroundColor(Color color);

  void setLoadingZIndex(int zindex);

  OverlayEntryControl showLoading(
      {Widget Function(BuildContext context)? builder, bool hasShadow = true});

  /// Close the entry with [id]
  /// Only call this function if we don't know where the entry is showing up that mean we dont have an OverlayEntryControl reference.
  void hide(String id);

  /// Re-arrange the entries based on their position.
  void rearrange();
}
