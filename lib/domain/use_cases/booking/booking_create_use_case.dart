import 'package:logging/logging.dart';
import 'package:meu_compass_app/data/repositories/activity/activity_repository.dart';
import 'package:meu_compass_app/data/repositories/booking/booking_repository.dart';
import 'package:meu_compass_app/data/repositories/destination/destination_repository.dart';
import 'package:meu_compass_app/domain/models/activity/activity.dart';
import 'package:meu_compass_app/domain/models/booking/booking.dart';
import 'package:meu_compass_app/domain/models/destination/destination.dart';
import 'package:meu_compass_app/domain/models/itinerary_config/itinerary_config.dart';
import 'package:meu_compass_app/utils/result.dart';

class BookingCreateUseCase {
  BookingCreateUseCase({
    required DestinationRepository destinationRepository,
    required ActivityRepository activityRepository,
    required BookingRepository bookingRepository,
  })  : _destinationRepository = destinationRepository,
        _activityRepository = activityRepository,
        _bookingRepository = bookingRepository;

  final DestinationRepository _destinationRepository;
  final ActivityRepository _activityRepository;
  final BookingRepository _bookingRepository;

  final _log = Logger('BookingCreateUseCase');

  Future<Result<Booking>> createFrom(ItineraryConfig itineraryConfig) async {
    if (itineraryConfig.destination == null) {
      _log.warning('Destination is not set');
      return Result.error(Exception('Destination is not set'));
    }

    final destinationResult =
        await _fetchDestination(itineraryConfig.destination!);
    switch (destinationResult) {
      case Ok<Destination>():
        _log.fine('Destination loaded: ${destinationResult.value.ref}');
      case Error<Destination>():
        _log.warning('Error fetching destination: ${destinationResult.error}');
        return Result.error(destinationResult.error);
    }

    // Get Activity objects from repository
    if (itineraryConfig.activities.isEmpty) {
      _log.warning('Activities are not set');
      return Result.error(Exception('Activities are not set'));
    }
    final activitiesResult = await _activityRepository.getByDestination(
      itineraryConfig.destination!,
    );
    switch (activitiesResult) {
      case Error<List<Activity>>():
        _log.warning('Error fetching activities: ${activitiesResult.error}');
        return Result.error(activitiesResult.error);
      case Ok<List<Activity>>():
    }
    final activities = activitiesResult.value
        .where(
          (activity) => itineraryConfig.activities.contains(activity.ref),
        )
        .toList();
    _log.fine('Activities loaded (${activities.length})');

    // Check if dates are set
    if (itineraryConfig.startDate == null || itineraryConfig.endDate == null) {
      _log.warning('Dates are not set');
      return Result.error(Exception('Dates are not set'));
    }

    final booking = Booking(
      startDate: itineraryConfig.startDate!,
      endDate: itineraryConfig.endDate!,
      destination: destinationResult.value,
      activity: activities,
    );

    final saveBookingResult = await _bookingRepository.createBooking(booking);
    switch (saveBookingResult) {
      case Ok<void>():
        _log.fine('Booking saved successfully');
        break;
      case Error<void>():
        _log.warning('Failed to save booking', saveBookingResult.error);
        return Result.error(saveBookingResult.error);
    }

    return Result.ok(booking);
  }

  Future<Result<Destination>> _fetchDestination(String destinationRef) async {
    final result = await _destinationRepository.getDestinations();
    switch (result) {
      case Ok<List<Destination>>():
        final destination = result.value
            .firstWhere((destination) => destination.ref == destinationRef);
        return Result.ok(destination);
      case Error<List<Destination>>():
        return Result.error(result.error);
    }
  }
}
