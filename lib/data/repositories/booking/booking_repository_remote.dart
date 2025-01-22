import 'package:meu_compass_app/data/services/api/api_client.dart';
import 'package:meu_compass_app/data/services/api/model/booking/booking_api_model.dart';
import 'package:meu_compass_app/domain/models/booking/booking.dart';
import 'package:meu_compass_app/domain/models/booking/booking_summary.dart';
import 'package:meu_compass_app/domain/models/destination/destination.dart';
import 'package:result_dart/result_dart.dart';

import 'booking_repository.dart';

class BookingRepositoryRemote implements BookingRepository {
  BookingRepositoryRemote({
    required ApiClient apiClient,
  }) : _apiClient = apiClient;

  final ApiClient _apiClient;

  List<Destination>? _cachedDestinations;

  @override
  AsyncResult<void> createBooking(Booking booking) async {
    try {
      final bookingApiModel = BookingApiModel(
        startDate: booking.startDate,
        endDate: booking.endDate,
        name: '${booking.destination.name}, ${booking.destination.continent}',
        destinationRef: booking.destination.ref,
        activitiesRef:
            booking.activity.map((activity) => activity.ref).toList(),
      );
      return _apiClient.postBooking(bookingApiModel);
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  AsyncResult<Booking> getBooking(int id) async {
    try {
      // Get booking by ID from server
      final resultBooking = await _apiClient.getBooking(id);

      final booking = resultBooking.getOrThrow();

      // Load destinations if not loaded yet
      if (_cachedDestinations == null) {
        final resultDestination = await _apiClient.getDestinations();

        _cachedDestinations = resultDestination.getOrThrow();
      }

      // Get destination for booking
      final destination = _cachedDestinations!.firstWhere(
          (destination) => destination.ref == booking.destinationRef);

      final resultActivities =
          await _apiClient.getActivityByDestination(destination.ref);

      final activities = resultActivities
          .getOrThrow()
          .where((activity) => booking.activitiesRef.contains(activity.ref))
          .toList();

      return Success(
        Booking(
          id: booking.id,
          startDate: booking.startDate,
          endDate: booking.endDate,
          destination: destination,
          activity: activities,
        ),
      );
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  AsyncResult<List<BookingSummary>> getBookingsList() async {
    try {
      final result = await _apiClient.getBookings();

      return result.fold((bookingsApi) {
        return Success(
          bookingsApi
              .map((bookingApi) => BookingSummary(
                    id: bookingApi.id!,
                    name: bookingApi.name,
                    startDate: bookingApi.startDate,
                    endDate: bookingApi.endDate,
                  ))
              .toList(),
        );
      }, (error) => Failure(error));
    } on Exception catch (e) {
      return Failure(e);
    }
  }

  @override
  AsyncResult<void> delete(int id) async {
    try {
      return _apiClient.deleteBooking(id);
    } on Exception catch (e) {
      return Failure(e);
    }
  }
}
