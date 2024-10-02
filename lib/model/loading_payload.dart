import 'package:flutter/material.dart';

enum LoadingRequestType {
  hide,
  show,
}

class LoadingRequestPayload {
  final LoadingRequestType type;
  final String id;
  final bool hasShadow;
  final Widget Function(BuildContext context)? builder;
  const LoadingRequestPayload({
    required this.type,
    required this.id,
    this.hasShadow = true,
    this.builder,
  });
}
