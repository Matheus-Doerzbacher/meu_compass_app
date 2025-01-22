import 'package:meu_compass_app/data/repositories/user/user_repository.dart';
import 'package:meu_compass_app/data/services/api/api_client.dart';
import 'package:meu_compass_app/domain/models/user/user.dart';
import 'package:result_dart/result_dart.dart';

class UserRepositoryRemote extends UserRepository {
  UserRepositoryRemote({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  User? _cachedData;

  @override
  AsyncResult<User> getUser() async {
    if (_cachedData != null) {
      return Future.value(Success(_cachedData!));
    }

    final result = await _apiClient.getUser();

    return result.fold(
      (userData) {
        final user = User(
          name: userData.name,
          picture: userData.picture,
        );
        _cachedData = user;
        return Success(user);
      },
      (error) {
        return Failure(error);
      },
    );
  }
}
