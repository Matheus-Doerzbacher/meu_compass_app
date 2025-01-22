import 'package:meu_compass_app/data/repositories/booking/booking_repository.dart';
import 'package:meu_compass_app/utils/command.dart';

class HomeViewModel {
  HomeViewModel({
    required BookingRepository bookingRepository,
    required UserRepository userRepository,
  })  : _bookingRepository = bookingRepository,
        _userRepository = userRepository {
    // load = Command0(_action)(_load)..execute();
    // deleteBooking = Command1(_deleteBooking);
  }

  final BookingRepository _bookingRepository;
  final UserRepository _userRepository;

  // final _log = Logger('HomeViewModel');
  // final List<BookingSummary> _bookings = [];
  // User? _user;

  late Command0 load;
  late Command1<void, int> deleteBooking;
}
