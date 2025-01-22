import 'package:logging/logging.dart';
import 'package:meu_compass_app/data/repositories/auth/auth_repository.dart';
import 'package:meu_compass_app/data/services/api/api_client.dart';
import 'package:meu_compass_app/data/services/api/auth_api_client.dart';
import 'package:meu_compass_app/data/services/api/model/login_request/login_request.dart';
import 'package:meu_compass_app/data/services/local/shared_preferences_service.dart';
import 'package:result_dart/result_dart.dart';

class AuthRepositoryRemote extends AuthRepository {
  AuthRepositoryRemote({
    required ApiClient apiClient,
    required AuthApiClient authApiClient,
    required SharedPreferencesService sharedPreferencesService,
  })  : _apiClient = apiClient,
        _authApiClient = authApiClient,
        _sharedPreferencesService = sharedPreferencesService {
    _apiClient.authHeaderProvider = _authHeaderProvider;
  }

  final AuthApiClient _authApiClient;
  final ApiClient _apiClient;
  final SharedPreferencesService _sharedPreferencesService;

  bool? _isAuthenticated;
  String? _authToken;
  final _log = Logger('AuthRepositoryRemote');

  /// Fetch token from shared preferences
  Future<void> _fetch() async {
    final result = await _sharedPreferencesService.fetchToken();
    result.fold(
      (token) {
        _authToken = token;
        _isAuthenticated = true;
      },
      (error) {
        _log.severe(
          'Failed to fetch Token from SharedPreferences',
          error,
        );
      },
    );
  }

  @override
  Future<bool> get isAuthenticated async {
    // Status is cached
    if (_isAuthenticated != null) {
      return _isAuthenticated!;
    }
    // No status cached, fetch from storage
    await _fetch();
    return _isAuthenticated ?? false;
  }

  @override
  AsyncResult<Unit> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _authApiClient.login(
        LoginRequest(
          email: email,
          password: password,
        ),
      );
      return await result.fold(
        (loginResponse) async {
          _log.info('User logged in');
          // Set auth status
          _isAuthenticated = true;
          _authToken = loginResponse.token;
          // Store in Shared preferences
          return await _sharedPreferencesService.saveToken(loginResponse.token);
        },
        (error) {
          _log.warning('Error logging in: $error');
          return Failure(error);
        },
      );
    } finally {
      notifyListeners();
    }
  }

  @override
  AsyncResult<Unit> logout() async {
    _log.info('User logged out');
    try {
      // Clear stored auth token
      final result = await _sharedPreferencesService.saveToken(null);
      if (result is Failure) {
        _log.severe('Failed to clear stored auth token');
      }

      // Clear token in ApiClient
      _authToken = null;

      // Clear authenticated status
      _isAuthenticated = false;
      return result;
    } finally {
      notifyListeners();
    }
  }

  String? _authHeaderProvider() =>
      _authToken != null ? 'Bearer $_authToken' : null;
}
