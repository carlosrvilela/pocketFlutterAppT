import 'dart:convert';

import 'package:bytebank/models/contact.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import '../models/transaction.dart';

final Client client = InterceptedClient.build(interceptors: [
  LoggingInterceptor(),
]);

const String connectionURL = 'http://172.26.0.1:8080/transactions';

Future<List<Transaction>> findAll() async {
  final Response response = await client
      .get(Uri.parse(connectionURL))
      .timeout(const Duration(seconds: 5));
  final List<dynamic> decodedJson = jsonDecode(response.body);
  final List<Transaction> transactions = [];
  for (Map<String, dynamic> transactionJson in decodedJson) {
    final Map<String, dynamic> contactJson = transactionJson['contact'];
    final Transaction transaction = Transaction(
      transactionJson['value'],
      Contact(
        0,
        contactJson['name'],
        contactJson['accountNumber'],
      ),
    );
    transactions.add(transaction);
  }
  return transactions;
}

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print('Request');
    print('url: ${data.url}');
    print('headers: ${data.headers}');
    print('body: ${data.body}');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print('Response');
    print('status code: ${data.statusCode}');
    print('headers: ${data.headers}');
    print('body: ${data.body}');
    return data;
  }
}

Future<Transaction> save(Transaction transaction) async {
  final Map<String, dynamic> transactionMap = {
    'value': transaction.value,
    'contact': {
      'name': transaction.contact.name,
      'accountNumber': transaction.contact.accountNumber
    }
  };
  final String transactionJson = jsonEncode(transactionMap);

  final Response response = await client.post(
    Uri.parse(connectionURL),
    headers: {
      'Content-type': 'application/json',
      'password': '1000',
    },
    body: transactionJson,
  );

  Map<String, dynamic> responseJson = jsonDecode(response.body);
  final Map<String, dynamic> contactJson = responseJson['contact'];
  final Transaction responseTransaction = Transaction(
    responseJson['value'],
    Contact(
      0,
      contactJson['name'],
      contactJson['accountNumber'],
    ),
  );

  return responseTransaction;
}
