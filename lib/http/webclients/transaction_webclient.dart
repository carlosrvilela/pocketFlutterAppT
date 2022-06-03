import 'dart:convert';
import 'package:http/http.dart';
import '../../models/transaction.dart';
import '../web_client.dart';

class TransactionWebClient {
  Future<List<Transaction>> findAll() async {
    final Response response = await client.get(
      Uri.parse(connectionURL),
    );

    final List<dynamic> decodedJson = jsonDecode(response.body);
    return decodedJson
        .map((dynamic json) => Transaction.fromJson(json))
        .toList();
  }

  Future<Transaction?> save(Transaction transaction, String password) async {
    final String transactionJson = jsonEncode(transaction.toJson());

    await Future.delayed(const Duration(seconds: 1));

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
      throw HttpException(_getMessage(response.statusCode), response.statusCode);
    }
  }

  String? _getMessage(int statusCode) {
    if (_statusCodeResponse.containsKey(statusCode)) {
      return _statusCodeResponse[statusCode];
    } else {
      return 'Unknown error';
    }
  }

  static final Map<int, String> _statusCodeResponse = {
    400: 'Submitting transaction error!',
    401: 'Authentication failed',
    409: 'Transaction already exists',
  };
}

class HttpException implements Exception {
  final String? message;
  final int? statusCode;

  HttpException(
    this.message,
    this.statusCode,
  );
}
