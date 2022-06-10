import 'dart:convert';
import 'package:http/http.dart';
import '../web_client.dart';

const messagesUri =
    'https://gist.githubusercontent.com/carlosrvilela/6bc488ddfec5383b35221bf6c29aee54/raw/e69603a5951a9b52b75db46812318faacd20c591/i18N.json';

class I18NWebClient {
  Future<Map<String, dynamic>> findAll() async {
    final Response response = await client.get(
      Uri.parse(messagesUri),
    );
    final Map<String, dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson;
  }
}
