import 'dart:ui' as ui;

class platformViewRegistry {
  static registerViewFactory(String viewId, dynamic cb) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(viewId, cb);
  }
}
