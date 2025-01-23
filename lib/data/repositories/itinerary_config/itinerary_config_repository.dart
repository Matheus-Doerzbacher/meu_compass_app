import 'package:meu_compass_app/domain/models/itinerary_config/itinerary_config.dart';
import 'package:meu_compass_app/utils/result.dart';

abstract class ItineraryConfigRepository {
  Future<Result<ItineraryConfig>> getItineraryConfig();
  Future<Result<void>> setItineraryConfig(ItineraryConfig itineraryConfig);
}
