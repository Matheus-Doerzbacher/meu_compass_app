import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:meu_compass_app/data/repositories/booking/booking_repository.dart';
import 'package:meu_compass_app/data/repositories/itinerary_config/itinerary_config_repository.dart';
import 'package:meu_compass_app/domain/models/booking/booking.dart';
import 'package:meu_compass_app/domain/models/itinerary_config/itinerary_config.dart';
import 'package:meu_compass_app/domain/use_cases/booking/booking_create_use_case.dart';
import 'package:meu_compass_app/domain/use_cases/booking/booking_share_use_case.dart';
import 'package:meu_compass_app/utils/command.dart';
import 'package:meu_compass_app/utils/result.dart';

class BookingViewModel extends ChangeNotifier {
  BookingViewModel({
    required BookingCreateUseCase bookingCreateUseCase,
    required BookingShareUseCase bookingShareUseCase,
    required ItineraryConfigRepository itineraryConfigRepository,
    required BookingRepository bookingRepository,
  })  : _bookingCreateUseCase = bookingCreateUseCase,
        _bookingShareUseCase = bookingShareUseCase,
        _itineraryConfigRepository = itineraryConfigRepository,
        _bookingRepository = bookingRepository {
    createBooking = Command0(_createBooking);
    shareBooking = Command0(() => _bookingShareUseCase.shareBooking(_booking!));
    loadBooking = Command1(_load);
  }

  final BookingCreateUseCase _bookingCreateUseCase;
  final BookingShareUseCase _bookingShareUseCase;
  final ItineraryConfigRepository _itineraryConfigRepository;
  final BookingRepository _bookingRepository;
  final _log = Logger('BookingViewModel');

  Booking? _booking;
  Booking? get booking => _booking;

  /// Cria uma reserva a partir do ItineraryConfig
  /// e salva nas reservas do usuário
  late final Command0 createBooking;

  /// Carrega uma reserva pelo id
  late final Command1<void, int> loadBooking;

  /// Compartilha a reserva atual usando o diálogo de compartilhamento do SO
  late final Command0 shareBooking;

  Future<Result<void>> _createBooking() async {
    _log.fine('Loading Booking');
    final itineraryConfig =
        await _itineraryConfigRepository.getItineraryConfig();
    switch (itineraryConfig) {
      case Ok<ItineraryConfig>():
        _log.fine('Loaded stored ItineraryConfig');
        final result =
            await _bookingCreateUseCase.createFrom(itineraryConfig.value);
        switch (result) {
          case Ok<Booking>():
            _log.fine('Created Booking');
            _booking = result.value;
            notifyListeners();
            return Result.ok(null);
          case Error<Booking>():
            _log.warning('Booking error: ${result.error}');
            notifyListeners();
            return Result.error(result.error);
        }
      case Error<ItineraryConfig>():
        _log.warning('ItineraryConfig error: ${itineraryConfig.error}');
        notifyListeners();
        return Result.error(itineraryConfig.error);
    }
  }

  Future<Result<void>> _load(int id) async {
    final result = await _bookingRepository.getBooking(id);
    switch (result) {
      case Ok<Booking>():
        _log.fine('Loaded booking $id');
        _booking = result.value;
        notifyListeners();
      case Error<Booking>():
        _log.warning('Failed to load booking $id');
    }
    return result;
  }
}
