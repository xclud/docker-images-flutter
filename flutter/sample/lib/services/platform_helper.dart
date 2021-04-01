export 'src/io.dart' if (dart.library.html) 'src/html.dart';
export 'src/barcode_io.dart' if (dart.library.html) 'src/barcode_html.dart';
export 'src/browser_io.dart' if (dart.library.html) 'src/browser_html.dart';

enum PlatformType { unknown, web, android, fuchsia, iOS, macOS, linux, windows }


enum BrowserAgent {
  UnKnown,
  Chrome,
  Safari,
  Firefox,
  Explorer,
  Edge,
  EdgeChromium,
}
