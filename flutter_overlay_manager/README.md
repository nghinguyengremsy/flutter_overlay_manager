A flutter package for managing overlays. It also solves some problems encountered when using Navigator.

Using `showDialog<T>` in Flutter introduces several challenges:

1. Route Management and Lifecycle Events:
    - Showing a dialog with `showDialog<T>` creates a new route, causing the current page route to go to the background. This can interfere with lifecycle event handling, especially when the app relies on `ModalRoute.of(context).isCurrent` to determine the active route.

2. Asynchronous Nature and Synchronization:
    - `showDialog<T>` is asynchronous, making it difficult to detect when a dialog is actually displayed. This complicates synchronization, particularly when multiple dialogs need to be managed rapidly in succession.
    
3. Navigator Confusion:
    - Dialogs and app pages share the same navigator and cannot be individually named. Using `Navigator.of(context).pop()` to close a dialog or a page can lead to confusion, as the behavior depends on the current navigator context.