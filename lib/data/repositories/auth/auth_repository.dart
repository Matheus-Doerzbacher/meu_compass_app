import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';

abstract class AuthRepository extends ChangeNotifier {
  Future<bool> get isAuthenticated;

  AsyncResult<Unit> login({
    required String email,
    required String password,
  });

  AsyncResult<Unit> logout();
}
