import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:meu_compass_app/domain/models/booking/booking.dart';
import 'package:meu_compass_app/ui/core/ui/date_format_start_end.dart';
import 'package:meu_compass_app/utils/result.dart';
import 'package:share_plus/share_plus.dart';

typedef ShareFunction = Future<void> Function(String text);

class BookingShareUseCase {
  BookingShareUseCase._(this._share);

  /// Create a [BookingShareUseCase] that uses `share_plus` package.
  factory BookingShareUseCase.withSharePlus() =>
      BookingShareUseCase._(Share.share);

  /// Create a [BookingShareUseCase] with a custom share function.
  factory BookingShareUseCase.custom(ShareFunction share) =>
      BookingShareUseCase._(share);

  final ShareFunction _share;
  final _log = Logger('BookingShareUseCase');

  Future<Result<void>> shareBooking(Booking booking) async {
    final text = 'Trip to ${booking.destination.name}\n'
        'on ${dateFormatStartEnd(DateTimeRange(start: booking.startDate, end: booking.endDate))}\n'
        'Activities:\n'
        '${booking.activity.map((a) => ' - ${a.name}').join('\n')}.';

    _log.info('Sharing booking: $text');
    try {
      await _share(text);
      _log.fine('Shared booking');
      return const Result.ok(null);
    } on Exception catch (error) {
      _log.severe('Failed to share booking', error);
      return Result.error(error);
    }
  }
}
