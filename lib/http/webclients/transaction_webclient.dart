import 'dart:convert';
import 'package:http/http.dart';
import '../../models/transaction.dart';
import '../web_client.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response = await client
        .get(Uri.parse(connectionURL))
        .timeout(const Duration(seconds: 5));

    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction?> save(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(
      Uri.parse(connectionURL),
      headers: {
        'Content-type': 'application/json',
        'password': password,
      },
      body: transactionJson,
    );
    if (response.statusCode == 200) {
      return Transaction.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(_statusCodeResponse[response.statusCode]);
    }
  }

  static final Map<int, String> _statusCodeResponse = {
    400: 'Submitting transaction error!',
    401: 'Authentication failed',
  };
}
