import 'package:meu_compass_app/data/repositories/auth/auth_repository.dart';
import 'package:meu_compass_app/data/repositories/auth/auth_repository_remote.dart';
import 'package:meu_compass_app/data/repositories/booking/booking_repository.dart';
import 'package:meu_compass_app/data/repositories/booking/booking_repository_remote.dart';
import 'package:meu_compass_app/data/repositories/user/user_repository.dart';
import 'package:meu_compass_app/data/repositories/user/user_repository_remote.dart';
import 'package:meu_compass_app/data/services/api/api_client.dart';
import 'package:meu_compass_app/data/services/api/auth_api_client.dart';
import 'package:meu_compass_app/data/services/local/shared_preferences_service.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> get providers {
  return [
    Provider(
      create: (context) => AuthApiClient(),
    ),
    Provider(
      create: (context) => ApiClient(),
    ),
    Provider(
      create: (context) => SharedPreferencesService(),
    ),
    ChangeNotifierProvider(
      create: (context) => AuthRepositoryRemote(
        apiClient: context.read(),
        authApiClient: context.read(),
        sharedPreferencesService: context.read(),
      ) as AuthRepository,
    ),
    Provider(
      create: (context) => BookingRepositoryRemote(
        apiClient: context.read(),
      ) as BookingRepository,
    ),
    Provider(
      create: (context) => UserRepositoryRemote(
        apiClient: context.read(),
      ) as UserRepository,
    ),
  ];
}
