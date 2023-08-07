import 'dart:io';

String get getFormatLibrary {
  if (Platform.isAndroid || Platform.isLinux) {
    return "so";
  } else if (Platform.isIOS || Platform.isMacOS) {
    return "dylib";
  } else {
    return "dll";
  }
}
