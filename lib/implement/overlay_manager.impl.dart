import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/v4.dart';

import '../controller/overlay_entry_control.dart';
import '../mixin/overlay_mixin.dart';
import '../model/overlay_entry_data.dart';
import '../repository/overlay_manager.dart';
import '../widget/four_rotating_dots.dart';
import '../widget/overlay_widget.dart';

class OverlayManagerImpl with OverlayMixin implements OverlayManager {
  OverlayManagerImpl();
  final _hashRequester = <String, List<String>>{}; // Entry's ID - Requester ID

  ///*Loading
  late final _loadingId = "LOADING_${const UuidV4().generate()}";
  var _loadingZIndex = 0;
  var _loadingBackgroundColor = const Color.fromARGB(136, 158, 152, 152);

  @override
  String get loadingOverlayId => _loadingId;

  @override
  Widget builder(Widget Function(BuildContext context) builder) {
    final initialEntry = OverlayEntry(builder: (context) => builder(context));
    return Overlay(
      key: overlayKey,
      initialEntries: [initialEntry],
    );
  }

  /// Return an id of the entry in entries.
  @override
  OverlayEntryControl show(
    Widget Function(BuildContext context) builder, {
    required String id,
    required int zindex,
    Color backgroundColor = Colors.transparent,
    OverlayLayoutTypeEnum type = OverlayLayoutTypeEnum.custom,
    bool dismissible = false,
  }) {
    late OverlayEntryControl control;
    OverlayEntryData? currentData = getOverlayEntryData(id);
    final requesterId = const UuidV4().generate();

    _addOverlayRequester(id, requesterId);
    if (currentData != null) {
      control = OverlayEntryControl(
        currentData,
        this,
        () => retake(currentData),
        () => _removeOverlayRequester(id, requesterId),
      );
      return control;
    }
    final entry = OverlayEntry(
      builder: (context) {
        final widget = builder(context);
        return OverlayLayout(
          type: type,
          backgroundColor: backgroundColor,
          onTap: dismissible
              ? () async {
                  await control.dismiss();
                }
              : null,
          child: widget,
        );
      },
    );
    final data = insert(id, zindex, entry);

    control = OverlayEntryControl(
      data,
      this,
      () => retake(data),
      () => _removeOverlayRequester(id, requesterId),
    );

    return control;
  }

  @override
  bool isOverlayShowing(String overlayId) => hasEntry(overlayId);

  @override
  void setLoadingBackgroundColor(Color color) {
    _loadingBackgroundColor = color;
  }

  @override
  void setLoadingZIndex(int zindex) => _loadingZIndex = zindex;

  @override
  OverlayEntryControl showLoading(
          {Widget Function(BuildContext context)? builder,
          bool hasShadow = true}) =>
      show(
        builder ??
            (context) => const FourRotatingDots(color: Colors.blue, size: 40),
        id: _loadingId,
        zindex: _loadingZIndex,
        backgroundColor: _loadingBackgroundColor,
        type: OverlayLayoutTypeEnum.dialog,
      );

  ///
  /// Close the entry with [id]
  @override
  void hide(String id) {
    _hashRequester[id]?.clear();
    remove(id);
  }

  @override
  void rearrange() {
    rearrangeByZIndex();
  }

  void _addOverlayRequester(String overlayId, String requesterId) {
    final requester = _hashRequester[overlayId];
    if (requester == null || requester.isEmpty) {
      _hashRequester[overlayId] = [];
      _hashRequester[overlayId]!.add(requesterId);
    } else {
      _hashRequester[overlayId]!.add(requesterId);
    }
  }

  void _removeOverlayRequester(String overlayId, String requesterId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final requester = _hashRequester[overlayId];
    requester?.remove(requesterId);
    if (requester == null || requester.isEmpty) {
      hide(overlayId);
    }
  }
}
