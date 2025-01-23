import 'package:meu_compass_app/domain/models/destination/destination.dart';
import 'package:meu_compass_app/utils/result.dart';

abstract class DestinationRepository {
  Future<Result<List<Destination>>> getDestinations();
}
