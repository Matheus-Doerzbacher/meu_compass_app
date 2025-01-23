import 'package:meu_compass_app/domain/models/booking/booking.dart';
import 'package:meu_compass_app/domain/models/booking/booking_summary.dart';
import 'package:meu_compass_app/utils/result.dart';

abstract class BookingRepository {
  /// Returns the list of [BookingSummary] for the current user.
  Future<Result<List<BookingSummary>>> getBookingsList();

  /// Returns a full [Booking] given the id.
  Future<Result<Booking>> getBooking(int id);

  /// Creates a new [Booking].
  Future<Result<void>> createBooking(Booking booking);

  /// Delete booking
  Future<Result<void>> delete(int id);
}
