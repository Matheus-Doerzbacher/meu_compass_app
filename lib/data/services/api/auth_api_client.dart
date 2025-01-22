import 'dart:convert';
import 'dart:io';

import 'package:meu_compass_app/data/services/api/model/login_request/login_request.dart';
import 'package:meu_compass_app/data/services/api/model/login_response/login_response.dart';
import 'package:result_dart/result_dart.dart';

class AuthApiClient {
  AuthApiClient({
    String? host,
    int? port,
    HttpClient Function()? clientFactory,
  })  : _host = host ?? 'localhost',
        _port = port ?? 8080,
        _clientFactory = clientFactory ?? HttpClient.new;

  final String _host;
  final int _port;
  final HttpClient Function() _clientFactory;

  AsyncResult<LoginResponse> login(LoginRequest loginRequest) async {
    final client = _clientFactory();
    try {
      final request = await client.post(_host, _port, '/login');
      request.write(jsonEncode(loginRequest));
      final response = await request.close();

      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        return Success(LoginResponse.fromJson(jsonDecode(stringData)));
      } else {
        return Failure(HttpException("Login error"));
      }
    } on Exception catch (error) {
      return Failure(error);
    } finally {
      client.close();
    }
  }
}
