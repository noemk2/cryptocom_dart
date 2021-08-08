import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

var baseUrl = 'https://api.crypto.com/v2/private/get-account-summary';
var apiKey = 'User API Key';
var secretKey = 'Secret API Key';
var req = {
  'id': 11,
  'method': 'private/get-account-summary',
  'api_key': apiKey,
  'params': {},
  'nonce': DateTime.now().millisecondsSinceEpoch,
};

void signRequest() {
  var sigPayload = req['method'].toString() +
      req['id'].toString() +
      req['api_key'].toString() +
      '' +
      req['nonce'].toString();

  var bytes = utf8.encode(sigPayload);
  var key = utf8.encode(secretKey);

  var hmacSha256 = Hmac(sha256, key);
  var sha256Result = hmacSha256.convert(bytes);

  req['sig'] = sha256Result.toString();

  getData();
}

Future getData() async {
  final response = await http.post(
    Uri.parse(baseUrl),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(req),
  );

  if (response.statusCode == 201) {
    return print(jsonDecode(response.body));
  } else {
    throw (response.body);
  }
}

void main() {
  signRequest();
}
