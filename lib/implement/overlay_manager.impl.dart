import 'dart:async';

import 'package:flutter/material.dart';
import 'package:uuid/v4.dart';

import '../mixin/overlay_mixin.dart';
import '../model/loader.dart';
import '../model/loading_payload.dart';
import '../model/overlay_position.dart';
import '../repository/overlay_manager.dart';
import '../widget/four_rotating_dots.dart';
import '../widget/overlay_widget.dart';

class OverlayManagerImpl with OverlayMixin implements OverlayManager {
  OverlayManagerImpl() {
    _init();
  }

  ///*Loading
  final _$loadingRequest = StreamController<LoadingRequestPayload>();
  final _LOADING_ID_PREFIX = "LOADING";
  late final _LOADING_ID = "${_LOADING_ID_PREFIX}_${const UuidV4().generate()}";
  var _loadingBackgroundColor = const Color.fromARGB(136, 158, 152, 152);
  final _LOADING_REQUESTER_IDs = <String>{};
  ///

  bool get _hasLoading => hasEntry(_LOADING_ID);
  bool get _hasLoadingRequester => _LOADING_REQUESTER_IDs.isNotEmpty;

  @override
  String get loadingOverlayId => _LOADING_ID;

  void _init() {
    /// Loading
    _$loadingRequest.stream.listen((payload) {
      if (payload.type == LoadingRequestType.hide) {
        _hideLoadingHandler(payload: payload);
      } else if (payload.type == LoadingRequestType.show) {
        _showLoadingHandler(payload: payload);
      }
    });
  }

  @override
  Widget builder(Widget Function(BuildContext context) builder) {
    final initialEntry = OverlayEntry(builder: (context) => builder(context));
    return Overlay(
      key: overlayKey,
      initialEntries: [initialEntry],
    );
  }

  @override
  void setPosition(OverlayPosition position) {
    setOverlayPosition(position);
  }

  /// Return an id of the entry in entries.
  @override
  Loader show(
    Widget Function(BuildContext context) builder, {
    String? id,
    Color backgroundColor = Colors.transparent,
    OverlayLayoutTypeEnum type = OverlayLayoutTypeEnum.custom,
    bool dismissible = false,
  }) {
    final _id = id ?? const UuidV4().generate();
    final layoutKey = GlobalKey<OverlayLayoutState>();
    final loader = Loader(
      overlayId: _id,
      dismiss: () {
        hide(_id);
      },
    );
    final entry = OverlayEntry(
      builder: (context) {
        final widget = builder(context);
        return OverlayLayout(
          key: layoutKey,
          type: type,
          backgroundColor: backgroundColor,
          onTap: dismissible
              ? () async {
                  await loader.dismiss.call();
                }
              : null,
          child: widget,
        );
      },
    );
    insert(_id, entry, layoutKey);
    return loader;
  }

  @override
  bool isOverlayShowing(String overlayId) => hasEntry(overlayId);

  @override
  void setLoadingBackgroundColor(Color color) {
    _loadingBackgroundColor = color;
  }

  ///* Loading
  void _requestLoading({required LoadingRequestPayload payload}) async {
    if (payload.type == LoadingRequestType.hide) {
      //wait 100ms for avoid loading flashing when many APIs call sequentially
      await Future.delayed(const Duration(milliseconds: 100));
    }
    _$loadingRequest.add(payload);
  }

  @override
  Future<Loader> showLoading(
      {Widget Function(BuildContext context)? builder,
      bool hasShadow = true}) async {
    final id = _generateLoadingID();
    _requestLoading(
      payload: LoadingRequestPayload(
        id: id,
        type: LoadingRequestType.show,
        hasShadow: hasShadow,
        builder: builder,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 50));
    return Loader(
        overlayId: id,
        dismiss: () async {
          _requestLoading(
            payload: LoadingRequestPayload(
              id: id,
              type: LoadingRequestType.hide,
            ),
          );
        });
  }

  /// Only call this function if we don't know where the loading is showing up.
  @override
  void forceHideLoading() {
    _LOADING_REQUESTER_IDs.clear();
    hide(_LOADING_ID);
  }

  void _hideLoadingHandler({required LoadingRequestPayload payload}) {
    _LOADING_REQUESTER_IDs.remove(payload.id);

    if (!_hasLoadingRequester) {
      hide(_LOADING_ID);
    }
  }

  void _showLoadingHandler({required LoadingRequestPayload payload}) {
    if (!_hasLoading) {
      show(
        payload.builder ??
            (context) => const FourRotatingDots(color: Colors.blue, size: 40),
        id: _LOADING_ID,
        type: OverlayLayoutTypeEnum.dialog,
        backgroundColor: _loadingBackgroundColor,
      );
    }
  }

  ///
  /// Close the entry with [id]
  @override
  void hide(String id) {
    remove(id);
  }

  String _generateLoadingID() {
    return "${_LOADING_ID_PREFIX}_${const UuidV4().generate()}";
  }
}
