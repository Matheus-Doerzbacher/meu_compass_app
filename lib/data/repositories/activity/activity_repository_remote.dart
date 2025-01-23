import 'package:meu_compass_app/data/repositories/activity/activity_repository.dart';
import 'package:meu_compass_app/data/services/api/api_client.dart';
import 'package:meu_compass_app/domain/models/activity/activity.dart';
import 'package:meu_compass_app/utils/result.dart';

class ActivityRepositoryRemote extends ActivityRepository {
  ActivityRepositoryRemote({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  final Map<String, List<Activity>> _cachedData = {};

  @override
  Future<Result<List<Activity>>> getByDestination(String ref) async {
    if (!_cachedData.containsKey(ref)) {
      final result = await _apiClient.getActivityByDestination(ref);

      if (result is Ok<List<Activity>>) {
        _cachedData[ref] = result.value;
      }

      return result;
    } else {
      return Result.ok(_cachedData[ref]!);
    }
  }
}
