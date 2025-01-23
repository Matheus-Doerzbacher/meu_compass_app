import 'package:meu_compass_app/data/repositories/activity/activity_repository.dart';
import 'package:meu_compass_app/data/repositories/activity/activity_repository_remote.dart';
import 'package:meu_compass_app/data/repositories/auth/auth_repository.dart';
import 'package:meu_compass_app/data/repositories/auth/auth_repository_remote.dart';
import 'package:meu_compass_app/data/repositories/booking/booking_repository.dart';
import 'package:meu_compass_app/data/repositories/booking/booking_repository_remote.dart';
import 'package:meu_compass_app/data/repositories/destination/destination_repository.dart';
import 'package:meu_compass_app/data/repositories/destination/destination_repository_remote.dart';
import 'package:meu_compass_app/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:meu_compass_app/data/repositories/itinerary_config/itinerary_config_repository_remote.dart';
import 'package:meu_compass_app/data/repositories/user/user_repository.dart';
import 'package:meu_compass_app/data/repositories/user/user_repository_remote.dart';
import 'package:meu_compass_app/data/services/api/api_client.dart';
import 'package:meu_compass_app/data/services/api/auth_api_client.dart';
import 'package:meu_compass_app/data/services/local/shared_preferences_service.dart';
import 'package:meu_compass_app/domain/use_cases/booking/booking_create_use_case.dart';
import 'package:meu_compass_app/domain/use_cases/booking/booking_share_use_case.dart';
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
    Provider.value(
      value: ItineraryConfigRepositoryRemote() as ItineraryConfigRepository,
    ),
    ChangeNotifierProvider(
      create: (context) => AuthRepositoryRemote(
        apiClient: context.read(),
        authApiClient: context.read(),
        sharedPreferencesService: context.read(),
      ) as AuthRepository,
    ),
    Provider(
      create: (context) => DestinationRepositoryRemote(
        apiClient: context.read(),
      ) as DestinationRepository,
    ),
    Provider(
      create: (context) => BookingRepositoryRemote(
        apiClient: context.read(),
      ) as BookingRepository,
    ),
    // Provider(
    //   create: (context) => ContinentRepositoryRemote(
    //     apiClient: context.read(),
    //   ) as ContinentRepository,
    // ),
    Provider(
      create: (context) => ActivityRepositoryRemote(
        apiClient: context.read(),
      ) as ActivityRepository,
    ),
    Provider(
      create: (context) => UserRepositoryRemote(
        apiClient: context.read(),
      ) as UserRepository,
    ),
    Provider(
      lazy: true,
      create: (context) => BookingCreateUseCase(
        destinationRepository: context.read(),
        activityRepository: context.read(),
        bookingRepository: context.read(),
      ),
    ),
    Provider(
      lazy: true,
      create: (context) => BookingShareUseCase.withSharePlus(),
    ),
  ];
}
