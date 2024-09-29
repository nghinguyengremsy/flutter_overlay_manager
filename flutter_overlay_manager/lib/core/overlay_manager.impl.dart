part of flutter_overlay_manager;

class _OverlayManagerImpl implements OverlayManager {
  _OverlayManagerImpl._() {
    _init();
  }
  final _overlayKey = GlobalKey<OverlayState>();
  final _entries = <String, OverlayData<OverlayEntry>>{};

  ///*Loading
  final _$loadingRequest = StreamController<_LoadingRequestPayload>();
  final _LOADING_ID_PREFIX = "LOADING";
  late final _LOADING_ID = "${_LOADING_ID_PREFIX}_${const UuidV4().generate()}";
  var _loadingBackgroundColor = const Color.fromARGB(136, 158, 152, 152);
  final _LOADING_REQUESTER_IDs = <String>{};
  WidgetBuilder _loadingBuilder =
      (context) => const FourRotatingDots(color: Colors.blue, size: 40);

  ///
  late final _orderedEntries = <String, OverlayPosition>{
    _LOADING_ID: OverlayPosition(id: _LOADING_ID),
  };

  /// This values are used for managing where the loading is requested to be displayed.
  BuildContext get currentContext => _overlayKey.currentContext!;
  OverlayState get _currentState {
    assert(_overlayKey.currentState != null,
        'Must attach the Overlay to widget tree by calling builder()');
    return _overlayKey.currentState!;
  }

  bool get _hasLoading => _hasEntry(_LOADING_ID);
  bool get _hasLoadingRequester => _LOADING_REQUESTER_IDs.isNotEmpty;
  void _init() {
    /// Loading
    _$loadingRequest.stream.listen((payload) {
      if (payload.type == _LoadingRequestType.hide) {
        _hideLoadingHandler(payload: payload);
      } else if (payload.type == _LoadingRequestType.show) {
        _showLoadingHandler(payload: payload);
      }
    });
  }

  @override
  Widget builder(Widget Function(BuildContext context) builder) {
    final initialEntry = OverlayEntry(builder: (context) => builder(context));
    return Overlay(
      key: _overlayKey,
      initialEntries: [initialEntry],
    );
  }

  @override
  void setPosition(OverlayPosition position) {
    _orderedEntries[position.id] = position;
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
    final overlayPositon = _getOverlayPosition(_id);
    _entries[_id] = OverlayData(id: _id, data: entry, layoutKey: layoutKey);
    _currentState.insert(
      entry,
      below: _getEntry(overlayPositon?.below ?? ''),
      above: _getEntry(overlayPositon?.above ?? ''),
    );

    return loader;
  }

  @override
  void registerLoadingView(WidgetBuilder builder) {
    _loadingBuilder = builder;
  }

  @override
  void setLoadingBackgroundColor(Color color) {
    _loadingBackgroundColor = color;
  }

  ///* Loading
  void _requestLoading({required _LoadingRequestPayload payload}) async {
    if (payload.type == _LoadingRequestType.hide) {
      //wait 100ms for avoid loading flashing when many API call sequentially
      await Future.delayed(const Duration(milliseconds: 100));
    }
    _$loadingRequest.add(payload);
  }

  @override
  Future<Loader> showLoading({bool hasShadow = true}) async {
    final id = _generateLoadingID();
    _requestLoading(
      payload: _LoadingRequestPayload(
        id: id,
        type: _LoadingRequestType.show,
        hasShadow: hasShadow,
      ),
    );
    await Future.delayed(const Duration(milliseconds: 50));
    return Loader(
        overlayId: id,
        dismiss: () async {
          _requestLoading(
            payload: _LoadingRequestPayload(
              id: id,
              type: _LoadingRequestType.hide,
            ),
          );
        });
  }

  @override

  /// Only call this function if we don't know where the loading is showing up.
  void forceHideLoading() {
    _LOADING_REQUESTER_IDs.clear();
    hide(_LOADING_ID);
  }

  void _hideLoadingHandler({required _LoadingRequestPayload payload}) {
    _LOADING_REQUESTER_IDs.remove(payload.id);

    if (!_hasLoadingRequester) {
      hide(_LOADING_ID);
    }
  }

  void _showLoadingHandler({required _LoadingRequestPayload payload}) {
    if (!_hasLoading) {
      show(
        _loadingBuilder,
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
    final entry = _entries[id];
    if (entry != null) {
      entry.data.remove();
      _entries.remove(id);
    }
  }

  bool _hasEntry(String id) {
    return _entries[id] != null;
  }

  OverlayEntry? _getEntry(String id) {
    return _entries[id]?.data;
  }

  OverlayPosition? _getOverlayPosition(String id) {
    OverlayPosition? pos = _orderedEntries[id];

    /// The entry with [id] will be on top.
    if (pos == null || (pos.below == null && pos.above == null)) {
      return null;
    }
    while (pos != null && (pos.below != null || pos.above != null)) {
      final entry = _getEntry(pos.below!) ?? _getEntry(pos.above!);
      if (entry != null) {
        break;
      }
      pos = _orderedEntries[pos.below ?? pos.above];
    }
    return pos;
  }

  String _generateLoadingID() {
    return "${_LOADING_ID_PREFIX}_${const UuidV4().generate()}";
  }
}
