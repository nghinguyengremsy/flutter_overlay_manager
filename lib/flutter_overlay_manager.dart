library flutter_overlay_manager;

import 'dart:async';
import 'package:flutter/material.dart';

import 'implement/overlay_manager.impl.dart';
import 'model/loader.dart';
import 'model/overlay_position.dart';
import 'repository/overlay_manager.dart';
import 'widget/overlay_widget.dart';
export 'model/overlay_position.dart';
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

  /// If `below` is non-null, the entries are inserted just below `below`.
  /// If `above` is non-null, the entries are inserted just above `above`.
  /// Otherwise, the entries are inserted on top.
  ///
  /// It is an error to specify both `above` and `below`.
  @override
  void setPosition(OverlayPosition position) => _impl.setPosition(position);

  @override
  void setLoadingBackgroundColor(Color color) =>
      _impl.setLoadingBackgroundColor(color);

  @override
  Loader show(Widget Function(BuildContext context) builder,
          {String? id,
          Color backgroundColor = Colors.transparent,
          OverlayLayoutTypeEnum type = OverlayLayoutTypeEnum.custom,
          bool dismissible = false}) =>
      _impl.show(
        builder,
        id: id,
        backgroundColor: backgroundColor,
        type: type,
        dismissible: dismissible,
      );

  /// Check whether the overlay is displayed
  @override
  bool isOverlayShowing(String overlayId) => _impl.isOverlayShowing(overlayId);

  @override
  void hide(String id) => _impl.hide(id);

  @override
  Future<Loader> showLoading(
          {Widget Function(BuildContext context)? builder,
          bool hasShadow = true}) =>
      _impl.showLoading(
        builder: builder,
        hasShadow: hasShadow,
      );

  /// Only call this function if we don't know where the loading is showing up.
  ///
  /// Should use loader.dismiss() instead.
  @override
  void forceHideLoading() => _impl.forceHideLoading();

  /// Re-arrange the entries based on their position.
  @override
  void rearrange() => _impl.rearrange();
}
