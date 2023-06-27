# telegram_userbot_tdlib_template

## Requirement
Bahan yang di perlukan untuk mengdevelop / menjalankan kode ini

1. [Dart](https://dart.dev)<br>
   Source Code bahasa ini menggunakan bahasa code dart jadi anda perlu menginstall dart dahulu (jika anda sudah menginstall flutter tidak usah karena sudah include)
2. [Tdlib](https://github.com/tdlib/td.git)<br>
   Untuk menjalankan program ini anda wajib menginstall tdlib dahulu
3. Operating System<br>
   Source code ini bisa di jalankan di manapun Android, Windows, Linux, MacOS

## Environment

| No | Name          | Value  | Default Value | Example Value | Require | Description |
|----|---------------|--------|---------------|---------------|---------|-------------|
| 1. | api_id        | number |               | 12345         | YEs     |             |
| 2. | api_hash      | string |               | abchdkosa     | YES     |             |
| 3. | owner_chat_id | number | 0             | 9000          | YES     |             |

## Compile To Executable

```bash
dart pub get
dart compile exe ./bin/telegram_userbot_tdlib_template.dart -o telegram_userbot_tdlib_template
```

## Development Run In Local

```bash
api_id=12345 api_hash=abdkakm owner_chat_id=0 dart run
```

### Resources
jika anda ingin serius membuat ini silahkan baca dokumentasi

1. [Dart](https://dart.dev)
2. [Tdlib](https://github.com/tdlib/td.git)
3. [Telegram Client](https://github.com/azkadev/telegram_client)

Library yang saya buat selalu update dengan docs tdlib jadi anda perlu baca docs tdlib official ya

## Run In Local

```bash
api_id=12345 api_hash=abdkakm owner_chat_id=0 ./telegram_userbot_tdlib_template
```

## Run In Docker
Untuk menjalankan project ini di docker anda harus mencompile dahulu ke exe, jika anda menggunakan docker anda bisa juga bisa menjalankan di manapun di vps, heroku, railway, local pc, dll

```Dockerfile
FROM ubuntu

WORKDIR /app/

ADD ./ /app/

RUN apt-get update

RUN apt-get install -y \
    sudo \
    wget \
    unzip

RUN apt-get update && \
    apt-get install -yq tzdata

ENV TZ="Asia/Jakarta"
 
ENV api_id="" 
ENV api_hash=""
ENV owner_chat_id="0"

CMD ["./telegram_userbot_tdlib_template"]
```

#### Tips

1. Run Program di layanan services gratis (Heroku, Railway, Okteto, Koyeb, Moge dll)<br>
   Sebelum deploy pastikan program ini berjalan di bawah memory dan cpu yang di berikan secara gratis, pastikan program ini berjalan dengan executable (bukan source code utuh), hapus kata terlarang "Bot, Userbot, Userbot Mirror", dan coba buat kode sefficient mungkin pastikan ada time out di loop, jika anda butuh bantuan silahkan Konsultasi Ke Azkadev

---

## Support Developer

Source Code , Library ini di buat 100% oleh [Azkadev](https://youtube.com/@azkadev) library ini bisa di gunakan lebih dari bot bisa juga untuk menjalankan multi bot userbot dan menghasilkan uang jika anda bisa menggunakan tolong jangan gunakan skill anda untuk melakukan tindakan kriminal (Phising, Scam, Doxing, Bullying), Jika anda ingin developer terus maintance library ini / lainya silahkan anda melakukan donasi (Subscribe semua social media, Donate uang, Tukar / Barter Source Code, Bikin video library ini di social media)# userbot
