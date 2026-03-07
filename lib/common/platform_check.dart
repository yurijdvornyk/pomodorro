import 'dart:io';

enum PomPlatform { android, ios, macos, windows, linux, web }

const bool _isWeb = bool.fromEnvironment('dart.library.html');

PomPlatform get getCurrentPlatform {
  if (_isWeb) {
    return PomPlatform.web;
  } else if (Platform.isAndroid) {
    return PomPlatform.android;
  } else if (Platform.isIOS) {
    return PomPlatform.ios;
  } else if (Platform.isMacOS) {
    return PomPlatform.macos;
  } else if (Platform.isWindows) {
    return PomPlatform.windows;
  } else if (Platform.isLinux) {
    return PomPlatform.linux;
  } else {
    throw UnsupportedError('Unsupported platform');
  }
}
