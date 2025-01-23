import 'package:meu_compass_app/domain/models/activity/activity.dart';
import 'package:meu_compass_app/utils/result.dart';

abstract class ActivityRepository {
  Future<Result<List<Activity>>> getByDestination(String ref);
}
