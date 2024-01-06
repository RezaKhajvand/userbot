import "dart:async";
import "dart:convert";
import "dart:io";
import "package:dio/dio.dart";
import "package:main/qizilchibot.dart";
import "package:shamsi_date/shamsi_date.dart";
import "package:telegram_client/telegram_client.dart";
import "package:path/path.dart" as path;
import "functions.dart";
import "values.dart";

//نسخه نهایی
void main(List<String> arguments) async {
  Directory directoryCurrent = Directory.current;
  Directory telegramDirectory =
      Directory(path.join(directoryCurrent.path, "tg_database"));

  /// telegram database
  int apiId = 25552855;
  String apiHash = 'a15203bee9a571182fcc4d66cd93d0a3';
  int ownerChatId = 6120077709;
  List<String> nameClients = ["qizilchi"];

  Tdlib tg = Tdlib(
    pathTdl: "libtdjson.$getFormatLibrary",
    clientOption: {
      'api_id': apiId,
      'api_hash': apiHash,
    },
    invokeTimeOut: Duration(minutes: 10),
    delayInvoke: Duration(milliseconds: 10),
  );

  QizilchiBot qizilchiBot = QizilchiBot(
    tg: tg,
    telegram_directory: telegramDirectory,
    owner_chat_id: ownerChatId,
    name_clients: nameClients,
  );

  await qizilchiBot.userbot(
    onAuthState: (int clientId, String nameClient,
        AuthorizationStateType authorizationStateType) async {
      ///
      if (authorizationStateType == AuthorizationStateType.phone_number) {
        String phoneNumber = ask(question: "Phone Number: ");
        phoneNumber = phoneNumber.replaceAll(
            RegExp(r"(\+|([ ]+))", caseSensitive: false), "");
        await tg.request(
          "setAuthenticationPhoneNumber",
          parameters: {
            "phone_number": phoneNumber,
          },
          clientId: clientId,
        );
      }

      if (authorizationStateType == AuthorizationStateType.code) {
        String code = ask(question: "Code: ");
        await tg.request(
          "checkAuthenticationCode",
          parameters: {
            "code": code,
          },
          clientId: clientId, // add this if your project more one client
        );
      }
      if (authorizationStateType == AuthorizationStateType.password) {
        String password = ask(question: "Password: ");
        await tg.request(
          "checkAuthenticationPassword",
          parameters: {
            "password": password,
          },
          clientId: clientId, // add this if your project more one client
        );
      }
    },
  );
  LineSplitter ls = LineSplitter();
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  final dio = Dio(BaseOptions(baseUrl: 'https://j85.ir/api/'));
  late String pocketbasetoken;
  late Map<String, String> headers;
  const int tokenduration = 345600;
  await Future(() async {
    headers = {'Content-Type': 'application/json'};
    var data = json.encode(
        {"identity": "userbot@gmail.com", "password": "n9@Yx54Gp7dsslt*q*&7"});

    var response = await dio.request(
      'admins/auth-with-password',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );

    if (response.statusCode == 200) {
      pocketbasetoken = response.data['token'];
      headers = {'Authorization': 'Bearer $pocketbasetoken'};
      sendToChannel(tg, '✅ ریجیستر با موفقیت انجام شد');
    } else {
      sendToChannel(tg, '⛔️ عملیات ریجیستر ناموفق بود');
    }
  });
  Timer.periodic(Duration(seconds: tokenduration - 120), (timer) async {
    try {
      var response = await dio.request(
        'admins/auth-refresh',
        options: Options(
          method: 'POST',
          headers: headers,
        ),
      );

      if (response.statusCode == 200) {
        pocketbasetoken = response.data['token'];
        headers = {'Authorization': 'Bearer $pocketbasetoken'};
        sendToChannel(tg, '✅ توکن با موفقیت رفرش شد');
      } else {
        sendToChannel(tg, '⛔️ عملیات رفرش توکن ناموفق بود');
      }
    } catch (e) {
      print(e.toString());
      sendToChannel(tg, '⛔️ عملیات رفرش توکن ناموفق بود');
    }
  });

  tg.on("update", (UpdateTd update) async {
    var now = Jalali.now();
    var datetime =
        '${now.year}/${now.month}/${now.day} , ${now.hour}:${now.minute}';
    if (update.type == 'updateNewMessage') {
      //دلار
      for (var elemento in datamap["Dollar"]!.values.toList()) {
        if (update.update['message']['chat_id'] ==
            int.parse(elemento["channelID"]!)) {
          //
          var msgtext =
              update.update['message']['content']['text']['text'].toString();
          var manba = elemento["channelUsername"];
          var collection = elemento["collections"];
          mathFunc(Match match) => '${match[1]},';
          for (var element in klidMap["Dollar"]!.toList()) {
            bool saleCheck;
            if (collection == "qheimat_Abshode" || collection == "Telegram") {
              saleCheck = true;
            } else {
              saleCheck = klidMap["Sale"]!.any((el) => el.contains(msgtext));
            }
            if (msgtext.contains(element) && saleCheck) {
              var text =
                  '''قیمت دلار : ${ls.convert(msgtext.substring(msgtext.indexOf(element))).first.replaceAll(RegExp(r'[^0-9]'), '')}
منبع : $manba
هشتگ : #Dollar
''';
              await sendToChannel(tg, text.replaceAllMapped(reg, mathFunc));
              String body = json.encode({
                "content": ls
                    .convert(msgtext.substring(msgtext.indexOf(element)))
                    .first
                    .replaceAll(RegExp(r'[^0-9]'), '')
                    .replaceAllMapped(reg, mathFunc),
                "channellink": manba,
                "datetime": datetime,
                "field": "Dollar",
              });
              await dio
                  .post(
                    'collections/$collection/records',
                    options: Options(headers: headers),
                    data: body,
                  )
                  .onError((error, stackTrace) async =>
                      await sendToChannel(tg, "*⛔️*"));
            }
          }
        }
      }
      //
      //
      //گرم طلا
      for (var elemento in datamap["Talla"]!.values.toList()) {
        if (update.update['message']['chat_id'] ==
            int.parse(elemento["channelID"]!)) {
          //
          var msgtext =
              update.update['message']['content']['text']['text'].toString();
          var manba = elemento["channelUsername"];
          var collection = elemento["collections"];
          mathFunc(Match match) => '${match[1]},';
          for (var element in klidMap["Talla"]!.toList()) {
            bool saleCheck;
            if (collection == "abshdh" ||
                collection == "mesgal1843" ||
                collection == "Telegram") {
              saleCheck = true;
            } else {
              saleCheck = klidMap["Sale"]!.any((el) => el.contains(msgtext));
            }
            if (msgtext.contains(element) && saleCheck) {
              var text =
                  '''قیمت طلا : ${ls.convert(msgtext.substring(msgtext.indexOf(element))).first.replaceAll(RegExp(r'[^0-9]'), '')}
منبع : $manba
هشتگ : #Talla
''';
              await sendToChannel(tg, text.replaceAllMapped(reg, mathFunc));
              String body = json.encode({
                "content": ls
                    .convert(msgtext.substring(msgtext.indexOf(element)))
                    .first
                    .replaceAll(RegExp(r'[^0-9]'), '')
                    .replaceAllMapped(reg, mathFunc),
                "channellink": manba,
                "datetime": datetime,
                "field": "Talla",
              });
              await dio
                  .post(
                    'collections/$collection/records',
                    options: Options(headers: headers),
                    data: body,
                  )
                  .onError((error, stackTrace) async =>
                      await sendToChannel(tg, "*⛔️*"));
            }
          }
        }
      }
//       for (var i = 0; i < channelID.length; i++) {
//         if (update.update['message']['chat_id'] == channelID[i]) {
//           //
//           var msgtext =
//               update.update['message']['content']['text']['text'].toString();
//           var manba = channelUsername[i];
//           //

//           mathFunc(Match match) => '${match[1]},';

//           for (var element in klidText) {
//             String extratext = '';
//             if (element == klidText[0]) {
//               extratext = 'فروش';
//             }

//             if (msgtext.contains(element) && msgtext.contains(extratext)) {
//               var text =
//                   '''قیمت طلا : ${ls.convert(msgtext.substring(msgtext.indexOf(element))).first.replaceAll(RegExp(r'[^0-9]'), '')}
// منبع : $manba
// هشتگ : #Talla
// ''';

//               await sendToChannel(tg, text.replaceAllMapped(reg, mathFunc));
//               String body = json.encode({
//                 "content": ls
//                     .convert(msgtext.substring(msgtext.indexOf(element)))
//                     .first
//                     .replaceAll(RegExp(r'[^0-9]'), '')
//                     .replaceAllMapped(reg, mathFunc),
//                 "channellink": manba,
//                 "datetime": datetime,
//                 "field": "Talla",
//               });
//               await dio
//                   .post(
//                     'collections/${collections[i]}/records',
//                     options: Options(headers: headers),
//                     data: body,
//                   )
//                   .onError((error, stackTrace) async =>
//                       await sendToChannel(tg, "*⛔️*"));
//             }
//           }
//         }
//       }
      //
      //
      //
      //انس طلا
      for (var elemento in datamap["Ons"]!.values.toList()) {
        if (update.update['message']['chat_id'] ==
            int.parse(elemento["channelID"]!)) {
          //
          var msgtext =
              update.update['message']['content']['text']['text'].toString();
          var manba = elemento["channelUsername"];
          var collection = elemento["collections"];
          mathFunc(Match match) => '${match[1]},';
          for (var element in klidMap["Ons"]!.toList()) {
            bool saleCheck;
            if (collection == "qheimat_Abshode" || collection == "Telegram") {
              saleCheck = true;
            } else {
              saleCheck = klidMap["Sale"]!.any((el) => el.contains(msgtext));
            }
            if (msgtext.contains(element) && saleCheck) {
              var text =
                  '''قیمت انس : ${ls.convert(msgtext.substring(msgtext.indexOf(element))).first.replaceAll(RegExp(r'[^0-9.]'), '')}
منبع : $manba
هشتگ : #Ons
''';
              await sendToChannel(tg, text.replaceAllMapped(reg, mathFunc));
              String body = json.encode({
                "content": ls
                    .convert(msgtext.substring(msgtext.indexOf(element)))
                    .first
                    .replaceAll(RegExp(r'[^0-9.]'), '')
                    .replaceAllMapped(reg, mathFunc),
                "channellink": manba,
                "datetime": datetime,
                "field": "Ons",
              });
              await dio
                  .post(
                    'collections/$collection/records',
                    options: Options(headers: headers),
                    data: body,
                  )
                  .onError((error, stackTrace) async =>
                      await sendToChannel(tg, "*⛔️*"));
            }
          }
        }
      }
//       for (var i = 0; i < onschannelID.length; i++) {
//         if (update.update['message']['chat_id'] == onschannelID[i]) {
//           //
//           var msgtext =
//               update.update['message']['content']['text']['text'].toString();
//           var manba = onschannelUsername[i];
//           //

//           for (var element in onsklidText) {
//             String extratext = '';
//             if (element == onsklidText[0]) {
//               extratext = 'فروش';
//             }

//             if (msgtext.contains(element) && msgtext.contains(extratext)) {
//               var text =
//                   '''انس طلا : ${ls.convert(msgtext.substring(msgtext.indexOf(element))).first.replaceAll(RegExp(r'[^0-9&.]'), '')}
// منبع : $manba
// هشتگ : #Ons
// ''';

//               await sendToChannel(tg, text);
//               String body = json.encode({
//                 "content": ls
//                     .convert(msgtext.substring(msgtext.indexOf(element)))
//                     .first
//                     .replaceAll(RegExp(r'[^0-9&.]'), ''),
//                 "channellink": manba,
//                 "datetime": datetime,
//                 "field": "Ons",
//               });
//               await dio
//                   .post(
//                     'collections/${onscollections[i]}/records',
//                     options: Options(headers: headers),
//                     data: body,
//                   )
//                   .onError((error, stackTrace) async =>
//                       await sendToChannel(tg, "*⛔️*"));
//             }
//           }
//         }
      // }
    }
  });
}
