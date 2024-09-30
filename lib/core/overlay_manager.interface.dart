part of flutter_overlay_manager;

abstract class OverlayManager {
  String get loadingOverlayId;

  Widget builder(Widget Function(BuildContext context) builder);

  /// Return an id of the entry in entries.
  Loader show(
    Widget Function(BuildContext context) builder, {
    String? id,
    Color backgroundColor = Colors.transparent,
    OverlayLayoutTypeEnum type = OverlayLayoutTypeEnum.custom,
    bool dismissible = false,
  });

  /// Check whether the overlay is displayed
  bool isOverlayShowing(String overlayId);

  /// If `below` is non-null, the entries are inserted just below `below`.
  /// If `above` is non-null, the entries are inserted just above `above`.
  /// Otherwise, the entries are inserted on top.
  ///
  /// It is an error to specify both `above` and `below`.
  void setPosition(OverlayPosition position);

  /// Set up your loading view.
  void registerLoadingView(WidgetBuilder builder);

  void setLoadingBackgroundColor(Color color);

  Future<Loader> showLoading({bool hasShadow = true});

  /// Only call this function if we don't know where the loading is showing up.
  /// Should use loader.dismiss() instead.
  void forceHideLoading();

  /// Close the entry with [id]
  void hide(String id);
}

enum _LoadingRequestType {
  hide,
  show,
}

class _LoadingRequestPayload {
  final _LoadingRequestType type;
  final String id;
  final bool hasShadow;
  const _LoadingRequestPayload(
      {required this.type, required this.id, this.hasShadow = true});
}
