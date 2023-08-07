import "dart:convert";
import "dart:io";
import "package:dio/dio.dart";
import "package:shamsi_date/shamsi_date.dart";
import "package:telegram_userbot_tdlib_template/telegram_userbot_tdlib_template.dart";
import "package:telegram_client/telegram_client.dart";
import "package:path/path.dart" as path;

import "utils.dart";
import "values.dart";

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

sendToChannel(Tdlib tg, String text) async {
  await tg.request(
    "sendMessage",
    parameters: {
      "chat_id": -1001701888085,
      "text": text,
    },
    clientId: tg.client_id,
  );
}

void main(List<String> arguments) async {
  var _dio =
      Dio(BaseOptions(baseUrl: 'https://pb.bezanbere.sbs/api/collections'));
  var headers = {'Content-Type': 'application/json'};
  LineSplitter ls = LineSplitter();
  //

  Directory directory_current = Directory.current;
  Directory telegram_directory =
      Directory(path.join(directory_current.path, "tg_database"));

  List<String> name_clients = ["azka"];

  /// telegram database
  int api_id = 23662616;
  String api_hash = 'b7537d62c81b5c46dd0f20f2df297061';
  int owner_chat_id =
      int.tryParse(Platform.environment["owner_chat_id"] ?? "0") ?? 0;
  Tdlib tg = Tdlib(
    pathTdl: "tdjson.$getFormatLibrary",
    clientOption: {
      'api_id': api_id,
      'api_hash': api_hash,
    },
    invokeTimeOut: Duration(minutes: 10),
    delayInvoke: Duration(milliseconds: 10),
  );

  TelegramUserbotTdlibTemplate telegram_userbot_tdlib_template =
      TelegramUserbotTdlibTemplate(
    tg: tg,
    telegram_directory: telegram_directory,
    owner_chat_id: owner_chat_id,
    name_clients: name_clients,
  );

  await telegram_userbot_tdlib_template.userbot(
    onAuthState: (int client_id, String name_client,
        AuthorizationStateType authorizationStateType) async {
      ///
      if (authorizationStateType == AuthorizationStateType.phone_number) {
        String phone_number = ask(question: "Phone Number: ");
        phone_number = phone_number.replaceAll(
            RegExp(r"(\+|([ ]+))", caseSensitive: false), "");
        await tg.request(
          "setAuthenticationPhoneNumber",
          parameters: {
            "phone_number": phone_number,
          },
          clientId: client_id, // add this if your project more one client
        );
      }

      if (authorizationStateType == AuthorizationStateType.code) {
        String code = ask(question: "Code: ");
        await tg.request(
          "checkAuthenticationCode",
          parameters: {
            "code": code,
          },
          clientId: client_id, // add this if your project more one client
        );
      }
      if (authorizationStateType == AuthorizationStateType.password) {
        String password = ask(question: "Password: ");
        await tg.request(
          "checkAuthenticationPassword",
          parameters: {
            "password": password,
          },
          clientId: client_id, // add this if your project more one client
        );
      }
    },
  );

  tg.on("update", (UpdateTd update) async {
    print(update.update['message']['chat_id']);
    print(update.update['message']['content']['text']['text']);
    var now = Jalali.now();
    var datetime =
        '${now.year}/${now.month}/${now.day} , ${now.hour}:${now.minute}';

    if (update.type == 'updateNewMessage') {
      //
      //
      //دلار
      for (var i = 0; i < dolarchannelID.length; i++) {
        if (update.update['message']['chat_id'] == dolarchannelID[i]) {
          //
          var msgtext =
              update.update['message']['content']['text']['text'].toString();
          var manba = dolarchannelUsername[i];
          //
          RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
          String Function(Match) mathFunc = (Match match) => '${match[1]},';
          for (var element in dolarklidText) {
            String extratext = '';
            if (element == dolarklidText[0]) {
              extratext = 'فروشنده';
            }
            if (element == dolarklidText[1]) {
              extratext = 'فروش';
            }
            if (element == dolarklidText[2]) {
              extratext = 'فروش';
            }
            if (msgtext.contains(element) && msgtext.contains(extratext)) {
              var text =
                  '''قیمت دلار : ${ls.convert(msgtext.substring(msgtext.indexOf(element))).first.replaceAll(RegExp(r'[^0-9]'), '')}
منبع : $manba
هشتگ : #Dollar
''';

              await sendToChannel(tg, text.replaceAllMapped(reg, mathFunc));
              String body = json.encode({
                "content":
                    "${ls.convert(msgtext.substring(msgtext.indexOf(element))).first.replaceAll(RegExp(r'[^0-9]'), '').replaceAllMapped(reg, mathFunc)}",
                "channellink": "$manba",
                "datetime": "$datetime",
                "field": "Dollar",
              });
              var resault = await _dio
                  .post(
                    '/${dolarcollections[i]}/records',
                    options: Options(headers: headers),
                    data: body,
                  )
                  .onError((error, stackTrace) async =>
                      await sendToChannel(tg, "*⛔️*"));

              if (resault.statusCode == 200) {
                await sendToChannel(tg, "*✅*");
              }
            }
          }
        }
      }
      //
      //
      //گرم طلا
      for (var i = 0; i < channelID.length; i++) {
        if (update.update['message']['chat_id'] == channelID[i]) {
          //
          var msgtext =
              update.update['message']['content']['text']['text'].toString();
          var manba = channelUsername[i];
          //
          RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
          String Function(Match) mathFunc = (Match match) => '${match[1]},';

          for (var element in klidText) {
            String extratext = '';
            if (element == klidText[0]) {
              extratext = 'فروش';
            }

            if (msgtext.contains(element) && msgtext.contains(extratext)) {
              var text =
                  '''قیمت طلا : ${ls.convert(msgtext.substring(msgtext.indexOf(element))).first.replaceAll(RegExp(r'[^0-9]'), '')}
منبع : $manba
هشتگ : #Talla
''';

              await sendToChannel(tg, text.replaceAllMapped(reg, mathFunc));
              String body = json.encode({
                "content":
                    "${ls.convert(msgtext.substring(msgtext.indexOf(element))).first.replaceAll(RegExp(r'[^0-9]'), '').replaceAllMapped(reg, mathFunc)}",
                "channellink": "$manba",
                "datetime": "$datetime",
                "field": "Talla",
              });
              var resault = await _dio
                  .post(
                    '/${collections[i]}/records',
                    options: Options(headers: headers),
                    data: body,
                  )
                  .onError((error, stackTrace) async =>
                      await sendToChannel(tg, "*⛔️*"));
              ;
              if (resault.statusCode == 200) {
                await sendToChannel(tg, "*✅*");
              }
            }
          }
        }
      }
      //
      //
      //
      //انس طلا
      for (var i = 0; i < onschannelID.length; i++) {
        if (update.update['message']['chat_id'] == onschannelID[i]) {
          //
          var msgtext =
              update.update['message']['content']['text']['text'].toString();
          var manba = onschannelUsername[i];
          //

          for (var element in onsklidText) {
            String extratext = '';
            if (element == onsklidText[0]) {
              extratext = 'فروش';
            }

            if (msgtext.contains(element) && msgtext.contains(extratext)) {
              var text =
                  '''انس طلا : ${ls.convert(msgtext.substring(msgtext.indexOf(element))).first.replaceAll(RegExp(r'[^0-9&.]'), '')}
منبع : $manba
هشتگ : #Ons
''';

              await sendToChannel(tg, text);
              String body = json.encode({
                "content":
                    "${ls.convert(msgtext.substring(msgtext.indexOf(element))).first.replaceAll(RegExp(r'[^0-9&.]'), '')}",
                "channellink": "$manba",
                "datetime": "$datetime",
                "field": "Ons",
              });
              var resault = await _dio
                  .post(
                    '/${onscollections[i]}/records',
                    options: Options(headers: headers),
                    data: body,
                  )
                  .onError((error, stackTrace) async =>
                      await sendToChannel(tg, "*⛔️*"));
              ;
              if (resault.statusCode == 200) {
                await sendToChannel(tg, "*✅*");
              }
            }
          }
        }
      }
    }
  });
}
