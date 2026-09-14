// ignore_for_file: avoid_web_libraries_in_flutter

import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:js' as js;

class RefreshDetector {
  Function()? onRefresh;

  // Constructor to accept a callback for the refresh event
  RefreshDetector({Function()? onRefresh}) {
    onRefresh = onRefresh;

    if (kIsWeb) {
      // Add the `beforeunload` event listener
      // js.context.callMethod('addEventListener', [
      //   'beforeunload',
      //   js.allowInterop((event) {
      //     print("Browser refresh detected!");
      //     // if (onRefresh != null) {
      //     //   onRefresh();
      //     // }
      //   }),
      // ]);
    } else {
      // Non-web platforms (e.g., mobile, desktop)
      print("This feature is only available on the web.");
    }
  }

  // Dispose method to clean up the event listener
  void dispose() {
    js.context.callMethod('removeEventListener', [
      'beforeunload',
      //js.allowInterop((_) {}),
    ]);
  }
}
