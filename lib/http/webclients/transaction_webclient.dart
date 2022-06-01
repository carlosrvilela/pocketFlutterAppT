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
    return decodedJson.map((dynamic json)=> Transaction.fromJson(json)).toList();
  }

  Future<Transaction> save(Transaction transaction) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    final Response response = await client.post(
      Uri.parse(connectionURL),
      headers: {
        'Content-type': 'application/json',
        'password': '1000',
      },
      body: transactionJson,
    );

    Transaction responseTransaction = Transaction.fromJson(jsonDecode(response.body));

    return responseTransaction;
  }
}
