import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:meu_compass_app/data/repositories/booking/booking_repository.dart';
import 'package:meu_compass_app/data/repositories/user/user_repository.dart';
import 'package:meu_compass_app/domain/models/booking/booking_summary.dart';
import 'package:meu_compass_app/domain/models/user/user.dart';
import 'package:meu_compass_app/utils/command.dart';
import 'package:result_dart/result_dart.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({
    required BookingRepository bookingRepository,
    required UserRepository userRepository,
  })  : _bookingRepository = bookingRepository,
        _userRepository = userRepository {
    load = Command0(_load)..execute();
    deleteBooking = Command1(_deleteBooking);
  }

  final BookingRepository _bookingRepository;
  final UserRepository _userRepository;

  final _log = Logger('HomeViewModel');
  List<BookingSummary> _bookings = [];
  User? _user;

  late Command0 load;
  late Command1<void, int> deleteBooking;

  List<BookingSummary> get bookings => _bookings;

  User? get user => _user;

  AsyncResult _load() async {
    try {
      final result = await _bookingRepository.getBookingsList();
      result.fold((bookingsData) {
        _bookings = bookingsData;
        _log.fine('Loaded bookings');
      }, (error) {
        _log.warning('Failed to load bookings', error);
        return Failure(error);
      });

      final userResult = await _userRepository.getUser();
      userResult.fold(
        (userData) {
          _user = userData;
          _log.fine('Loaded user');
        },
        (error) => _log.warning('Failed to load user', error),
      );

      return userResult;
    } finally {
      notifyListeners();
    }
  }

  AsyncResult<Unit> _deleteBooking(int id) async {
    try {
      final result = await _bookingRepository.delete(id);
      result.fold((_) {
        _log.fine('Deleted booking $id');
      }, (error) {
        _log.warning('Failed to delete booking $id', error);
        return Failure(error);
      });

      final resultLoadBookings = await _bookingRepository.getBookingsList();
      return resultLoadBookings.fold(
        (bookingsData) {
          _bookings = bookingsData;
          _log.fine('Loaded bookings');
          return Success(unit);
        },
        (error) {
          _log.warning('Failed to load bookings', error);
          return Failure(error);
        },
      );
    } finally {
      notifyListeners();
    }
  }
}
