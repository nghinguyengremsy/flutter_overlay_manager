A flutter package for managing overlays. It separate your main UI and the overlays. It also solves some problems encountered when using Navigator.

Using `showDialog<T>` in Flutter introduces several challenges:

1. Route Management and Lifecycle Events:
    - Showing a dialog with `showDialog<T>` creates a new route, causing the current page route to go to the background. This can interfere with lifecycle event handling, especially when the app relies on `ModalRoute.of(context).isCurrent` to determine the active route.

2. Asynchronous Nature and Synchronization:
    - `showDialog<T>` is asynchronous, making it difficult to detect when a dialog is actually displayed. This complicates synchronization, particularly when multiple dialogs need to be managed rapidly in succession.
    
3. Navigator Confusion:
    - Dialogs and app pages share the same navigator and cannot be individually named. Using `Navigator.of(context).pop()` to close a dialog or a page can lead to confusion, as the behavior depends on the current navigator context.

## Installation

Add the following to your pubspec.yaml file:

```yaml
dependencies:
  flutter_overlay_manager: ^<latest_version>
```

## Initialization

To use the overlay manager, initialize it as a singleton:
```dart
FlutterOverlayManager overlayManager = FlutterOverlayManager.I;
```
Alternatively, you can create a new instance:

```dart
FlutterOverlayManager overlayManager = FlutterOverlayManager.asNewInstance();
```

When integrating this in a Flutter app, you would typically call this method in the MaterialApp builder:

```dart
MaterialApp(
  builder: (context, child) {
        return FlutterOverlayManager.I.builder((context) => child!);
  },  // Wraps the app to manage overlays
  home: YourHomePage(),
);
```
## Display a Custom Overlay

You can display any widget as an overlay:

```dart
overlayManager.show(
  (context) => YourCustomWidget(),
  backgroundColor: Colors.black54,
  dismissible: true,
);
```
## Show a Loading Indicator

There is a built-in loading overlay, you can use it to prevent the user from interacting with UI when calling API or long-running async task.

The manager ensures that only one loading overlay is dislayed when you call showLoading() anywhere and anytime: 

```dart
Loader loader = await overlayManager.showLoading();
```
To hide the loader, call:
```dart
loader.dismiss();
```
Or if you don't have a loader reference, use:

```dart
overlayManager.forceHideLoading();
```
## Register a Custom Loading View

To register a custom loading view globally:
```dart
overlayManager.registerLoadingView(
  (context) => CircularProgressIndicator(),
);
```

## Set Position for the Overlay

You can control the position of the overlay relative to other UI elements:
```dart
overlayManager.setPosition(
      OverlayPosition(
        overlayId: 'your_overlay_id',
        below: 'your_another_overlay_id',
      ),
    );
```

## Hiding an Overlay

To hide a specific overlay by its ID:

```dart
overlayManager.hide('your_overlay_id');
```

Or if you have a loader reference, use:

```dart
loader.dismiss();
```

## Contributions

Contributions are welcome! Feel free to open issues or submit pull requests on the GitHub repository.