import 'dart:io';

import 'package:telegram_client/tdlib/tdlib_core.dart';

sendToChannel(Tdlib tg, String text) async {
  try {
    await tg.request(
      "sendMessage",
      parameters: {
        "chat_id": -1001733215646,
        "text": text,
      },
      clientId: tg.client_id,
    );
  } catch (e) {
    print(e);
  }
}

String ask({
  required String question,
}) {
  while (true) {
    stdout.write(question);
    String? res = stdin.readLineSync();
    if (res != null && res.isNotEmpty) {
      return res;
    }
  }
}

String get getFormatLibrary {
  if (Platform.isAndroid || Platform.isLinux) {
    return "so";
  } else if (Platform.isIOS || Platform.isMacOS) {
    return "dylib";
  } else {
    return "dll";
  }
}
