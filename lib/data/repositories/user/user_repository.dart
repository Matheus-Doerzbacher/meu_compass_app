import 'package:meu_compass_app/domain/models/user/user.dart';
import 'package:result_dart/result_dart.dart';

abstract class UserRepository {
  AsyncResult<User> getUser();
}
