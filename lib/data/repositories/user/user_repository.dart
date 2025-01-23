import 'package:meu_compass_app/domain/models/user/user.dart';
import 'package:meu_compass_app/utils/result.dart';

abstract class UserRepository {
  Future<Result<User>> getUser();
}
