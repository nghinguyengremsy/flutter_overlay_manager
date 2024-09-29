library flutter_overlay_manager;

import 'dart:async';
import 'package:flutter/material.dart';

import 'package:uuid/v4.dart';
import '../loader.dart';
import '../widget/overlay_widget.dart';
import '../widget/four_rotating_dots.dart';
part './core/overlay_data.dart';
part './core/overlay_position.dart';
part './core/overlay_manager.impl.dart';
part './core/overlay_manager.interface.dart';

class FlutterOverlayManager extends OverlayManager {
  static FlutterOverlayManager get I => _instance ??= FlutterOverlayManager._();
  static FlutterOverlayManager asNewInstance() => FlutterOverlayManager._();
  static FlutterOverlayManager? _instance;
  FlutterOverlayManager._();
  final OverlayManager _impl = _OverlayManagerImpl._();
  

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

  /// Set up your loading view.
  @override
  void registerLoadingView(WidgetBuilder builder) =>
      _impl.registerLoadingView(builder);

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

  @override
  void hide(String id) => _impl.hide(id);

  @override
  Future<Loader> showLoading({bool hasShadow = true}) => _impl.showLoading();

  /// Only call this function if we don't know where the loading is showing up.
  ///
  /// Should use loader.dismiss() instead.
  @override
  void forceHideLoading() => _impl.forceHideLoading();
}
