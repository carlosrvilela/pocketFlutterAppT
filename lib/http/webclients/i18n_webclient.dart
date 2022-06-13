import 'dart:convert';
import 'package:http/http.dart';
import '../web_client.dart';

const baseMessagesUri =
    'https://gist.githubusercontent.com/carlosrvilela/6bc488ddfec5383b35221bf6c29aee54/raw/';

class I18NWebClient {
  final String _viewKey;
  final String _locale;

  I18NWebClient(this._locale, this._viewKey);

  Future<Map<String, dynamic>> findAll() async {
    String versionFile = '4b0a4c581e590d03a6dc38a64e60aebc4d5e1ada/';
    final Response response = await client.get(
      Uri.parse('$baseMessagesUri$versionFile$_viewKey.$_locale.json'),
    );
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson;
  }
}
