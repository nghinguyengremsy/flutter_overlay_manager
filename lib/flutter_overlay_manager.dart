library flutter_overlay_manager;

import 'package:flutter/material.dart';
import 'controller/overlay_entry_control.dart';
import 'implement/overlay_manager.impl.dart';
import 'repository/overlay_manager.dart';
import 'widget/overlay_widget.dart';
export 'widget/overlay_widget.dart';

class FlutterOverlayManager extends OverlayManager {
  static FlutterOverlayManager get I => _instance ??= FlutterOverlayManager._();
  static FlutterOverlayManager asNewInstance() => FlutterOverlayManager._();
  static FlutterOverlayManager? _instance;
  FlutterOverlayManager._();
  final OverlayManager _impl = OverlayManagerImpl();

  @override
  String get loadingOverlayId => _impl.loadingOverlayId;

  /// Attach the manager to your app.
  @override
  Widget builder(Widget Function(BuildContext context) builder) =>
      _impl.builder(builder);

  @override
  void setLoadingBackgroundColor(Color color) =>
      _impl.setLoadingBackgroundColor(color);

  @override
  void setLoadingZIndex(int zindex) => _impl.setLoadingZIndex(zindex);

  /// If the `id` exists, just keep the current entry respectively.
  /// The entry's inserted just below the entry whose zindex greater than the `zindex`.
  /// Return an OverlayEntryControl instance for controlling the entry if need.
  @override
  OverlayEntryControl show(Widget Function(BuildContext context) builder,
          {required String id,
          required int zindex,
          Color backgroundColor = Colors.transparent,
          OverlayLayoutTypeEnum type = OverlayLayoutTypeEnum.custom,
          bool dismissible = false}) =>
      _impl.show(
        builder,
        id: id,
        zindex: zindex,
        backgroundColor: backgroundColor,
        type: type,
        dismissible: dismissible,
      );

  /// Check whether the overlay is displayed
  @override
  bool isOverlayShowing(String overlayId) => _impl.isOverlayShowing(overlayId);

  /// Close the entry with [id]
  /// Only call this function if we don't know where the entry is showing up that mean we dont have an OverlayEntryControl reference.
  @override
  void hide(String id) => _impl.hide(id);

  @override
  OverlayEntryControl showLoading(
          {Widget Function(BuildContext context)? builder,
          bool hasShadow = true}) =>
      _impl.showLoading(
        builder: builder,
        hasShadow: hasShadow,
      );

  /// Re-arrange the entries based on their position.
  @override
  void rearrange() => _impl.rearrange();
}
