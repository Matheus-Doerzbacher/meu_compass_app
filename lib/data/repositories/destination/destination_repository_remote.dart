import 'package:meu_compass_app/data/repositories/destination/destination_repository.dart';
import 'package:meu_compass_app/data/services/api/api_client.dart';
import 'package:meu_compass_app/domain/models/destination/destination.dart';
import 'package:meu_compass_app/utils/result.dart';

class DestinationRepositoryRemote extends DestinationRepository {
  DestinationRepositoryRemote({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  List<Destination>? _cachedData;

  @override
  Future<Result<List<Destination>>> getDestinations() async {
    if (_cachedData == null) {
      final result = await _apiClient.getDestinations();
      if (result is Ok<List<Destination>>) {
        _cachedData = result.value;
      }
      return result;
    } else {
      return Result.ok(_cachedData!);
    }
  }
}
