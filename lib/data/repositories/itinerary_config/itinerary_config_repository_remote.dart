import 'package:meu_compass_app/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:meu_compass_app/domain/models/itinerary_config/itinerary_config.dart';
import 'package:meu_compass_app/utils/result.dart';

class ItineraryConfigRepositoryRemote extends ItineraryConfigRepository {
  ItineraryConfig? _itineraryConfig;

  @override
  Future<Result<ItineraryConfig>> getItineraryConfig() async {
    return Result.ok(_itineraryConfig ?? const ItineraryConfig());
  }

  @override
  Future<Result<void>> setItineraryConfig(
      ItineraryConfig itineraryConfig) async {
    _itineraryConfig = itineraryConfig;
    // ignore: void_checks
    return const Result.ok(true);
  }
}
