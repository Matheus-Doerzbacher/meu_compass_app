import 'package:meu_compass_app/domain/models/booking/booking.dart';
import 'package:meu_compass_app/domain/models/booking/booking_summary.dart';
import 'package:result_dart/result_dart.dart';

abstract class BookingRepository {
  /// Returns the list of [BookingSummary] for the current user.
  AsyncResult<List<BookingSummary>> getBookingsList();

  /// Returns a full [Booking] given the id.
  AsyncResult<Booking> getBooking(int id);

  /// Creates a new [Booking].
  AsyncResult<void> createBooking(Booking booking);

  /// Delete booking
  AsyncResult<void> delete(int id);
}
