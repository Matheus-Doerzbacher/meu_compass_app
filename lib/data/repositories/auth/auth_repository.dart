import 'package:flutter/foundation.dart';
import 'package:meu_compass_app/utils/result.dart';

abstract class AuthRepository extends ChangeNotifier {
  Future<bool> get isAuthenticated;

  Future<Result<void>> login({
    required String email,
    required String password,
  });

  Future<Result<void>> logout();
}
