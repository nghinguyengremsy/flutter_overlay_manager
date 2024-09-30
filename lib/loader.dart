import 'dart:async';

class Loader {
  final String overlayId;
  final FutureOr<void> Function() dismiss;
  const Loader({required this.dismiss, required this.overlayId});
}
