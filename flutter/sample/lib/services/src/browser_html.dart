import 'dart:html';

import 'package:novinpay/services/platform_helper.dart';

class Browser {
  /// Browser initialization
  Browser() {
    _detectBrowser();
  }

  BrowserAgent get browserAgent =>
      _detected?.browserAgent ?? BrowserAgent.UnKnown;

  String get browser => _browserIdentifiers[browserAgent];

  String get version => _version;

  static const Map<BrowserAgent, String> _browserIdentifiers =
      <BrowserAgent, String>{
    BrowserAgent.UnKnown: 'Unknown browser',
    BrowserAgent.Chrome: 'Chrome',
    BrowserAgent.Safari: 'Safari',
    BrowserAgent.Firefox: 'Firefox',
    BrowserAgent.Explorer: 'Internet Explorer',
    BrowserAgent.Edge: 'Edge',
    BrowserAgent.EdgeChromium: 'Chromium Edge',
  };

  _BrowserDetection _detected;
  String _version;

  /// Detect current browser if it is known
  void _detectBrowser() {
    final List<_BrowserDetection> detections = <_BrowserDetection>[
      _BrowserDetection(
        browserAgent: BrowserAgent.EdgeChromium,
        string: window.navigator.userAgent,
        subString: 'Edg',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.Chrome,
        string: window.navigator.userAgent,
        subString: 'Chrome',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.Safari,
        string: window.navigator.vendor,
        subString: 'Apple',
        versionSearch: 'Version',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.Firefox,
        string: window.navigator.userAgent,
        subString: 'Firefox',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.Explorer,
        string: window.navigator.userAgent,
        subString: 'MSIE',
        versionSearch: 'MSIE',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.Explorer,
        string: window.navigator.userAgent,
        subString: 'Trident',
        versionSearch: 'rv',
      ),
      _BrowserDetection(
        browserAgent: BrowserAgent.Edge,
        string: window.navigator.userAgent,
        subString: 'Edge',
      ),
    ];

    for (_BrowserDetection detection in detections) {
      if (detection.string.contains(detection.subString)) {
        _detected = detection;

        final String versionSearchString =
            detection.versionSearch ?? detection.subString;
        String versionFromString = window.navigator.userAgent;
        int index = versionFromString.indexOf(versionSearchString);
        if (index == -1) {
          versionFromString = window.navigator.appVersion;
          index = versionFromString.indexOf(versionSearchString);
        }

        if (index == -1) {
          _version = 'Unknown version';
        } else {
          _version = versionFromString
              .substring(index + versionSearchString.length + 1);

          if (_version.split(' ').length > 1) {
            _version = _version.split(' ').first;
          }
        }

        break;
      }
    }
  }
}

class _BrowserDetection {
  /// BrowserDetection initialization
  _BrowserDetection({
    this.browserAgent,
    this.string,
    this.subString,
    this.versionSearch,
  });

  final BrowserAgent browserAgent;
  final String string;
  final String subString;
  final String versionSearch;
}
