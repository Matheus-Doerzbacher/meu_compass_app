import 'package:logging/logging.dart';
import 'package:meu_compass_app/data/repositories/auth/auth_repository.dart';
import 'package:meu_compass_app/utils/command.dart';
import 'package:result_dart/result_dart.dart';

class LoginViewModel {
  LoginViewModel({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository {
    login = Command1<void, (String email, String password)>(_login);
  }

  final AuthRepository _authRepository;
  final _log = Logger('LoginViewModel');

  late Command1 login;

  AsyncResult<Unit> _login((String, String) credentials) async {
    final (email, password) = credentials;
    final result = await _authRepository.login(
      email: email,
      password: password,
    );
    if (result is Failure) {
      _log.warning('Login failed! $result');
    }
    return result;
  }
}
