part of flutter_overlay_manager;

class OverlayData<T> {
  final String id;
  final T data;
  final GlobalKey<OverlayLayoutState> layoutKey;
  const OverlayData(
      {required this.id, required this.data, required this.layoutKey});
}
