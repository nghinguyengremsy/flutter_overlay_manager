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
  final _loadingIdPrefix = "LOADING";
  late final _loadingId = "${_loadingIdPrefix}_${const UuidV4().generate()}";
  var _loadingBackgroundColor = const Color.fromARGB(136, 158, 152, 152);
  final _loadingRequesterIds = <String>{};

  ///

  bool get _hasLoading => hasEntry(_loadingId);
  bool get _hasLoadingRequester => _loadingRequesterIds.isNotEmpty;

  @override
  String get loadingOverlayId => _loadingId;

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
    insert(_id, entry);
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
    _loadingRequesterIds.clear();
    hide(_loadingId);
  }

  void _hideLoadingHandler({required LoadingRequestPayload payload}) {
    _loadingRequesterIds.remove(payload.id);

    if (!_hasLoadingRequester) {
      hide(_loadingId);
    }
  }

  void _showLoadingHandler({required LoadingRequestPayload payload}) {
    if (!_hasLoading) {
      show(
        payload.builder ??
            (context) => const FourRotatingDots(color: Colors.blue, size: 40),
        id: _loadingId,
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

  @override
  void rearrange() {
    rearrangeByPosition();
  }

  String _generateLoadingID() {
    return "${_loadingIdPrefix}_${const UuidV4().generate()}";
  }
}
