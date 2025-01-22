import 'dart:convert';
import 'dart:io';

import 'package:meu_compass_app/data/services/api/model/booking/booking_api_model.dart';
import 'package:meu_compass_app/data/services/api/model/user/user_api_model.dart';
import 'package:meu_compass_app/domain/models/activity/activity.dart';
import 'package:meu_compass_app/domain/models/continent/continent.dart';
import 'package:meu_compass_app/domain/models/destination/destination.dart';
import 'package:result_dart/result_dart.dart';

typedef AuthHeaderProvider = String? Function();

class ApiClient {
  ApiClient({
    String? host,
    int? port,
    HttpClient Function()? clientFactory,
  })  : _host = host ?? 'localhost',
        _port = port ?? 8080,
        _clientFactory = clientFactory ?? HttpClient.new;

  final String _host;
  final int _port;
  final HttpClient Function() _clientFactory;

  AuthHeaderProvider? _authHeaderProvider;

  set authHeaderProvider(AuthHeaderProvider authHeaderProvider) {
    _authHeaderProvider = authHeaderProvider;
  }

  Future<void> _authHeader(HttpHeaders headers) async {
    final header = _authHeaderProvider?.call();
    if (header != null) {
      headers.add(HttpHeaders.authorizationHeader, header);
    }
  }

  AsyncResult<List<Continent>> getContinents() async {
    final client = _clientFactory();
    try {
      final request = await client.get(_host, _port, '/continent');
      await _authHeader(request.headers);
      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final json = jsonDecode(stringData) as List<dynamic>;
        return Success(
            json.map((element) => Continent.fromJson(element)).toList());
      } else {
        return Failure(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Failure(error);
    } finally {
      client.close();
    }
  }

  AsyncResult<List<Destination>> getDestinations() async {
    final client = _clientFactory();
    try {
      final request = await client.get(_host, _port, '/destination');
      await _authHeader(request.headers);
      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final json = jsonDecode(stringData) as List<dynamic>;
        return Success(
            json.map((element) => Destination.fromJson(element)).toList());
      } else {
        return const Failure(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Failure(error);
    } finally {
      client.close();
    }
  }

  AsyncResult<List<Activity>> getActivityByDestination(String ref) async {
    final client = _clientFactory();
    try {
      final request =
          await client.get(_host, _port, '/destination/$ref/activity');
      await _authHeader(request.headers);
      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final json = jsonDecode(stringData) as List<dynamic>;
        final activities =
            json.map((element) => Activity.fromJson(element)).toList();
        return Success(activities);
      } else {
        return const Failure(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Failure(error);
    } finally {
      client.close();
    }
  }

  AsyncResult<List<BookingApiModel>> getBookings() async {
    final client = _clientFactory();
    try {
      final request = await client.get(_host, _port, '/booking');
      await _authHeader(request.headers);
      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final json = jsonDecode(stringData) as List<dynamic>;
        final bookings =
            json.map((element) => BookingApiModel.fromJson(element)).toList();
        return Success(bookings);
      } else {
        return const Failure(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Failure(error);
    } finally {
      client.close();
    }
  }

  AsyncResult<BookingApiModel> getBooking(int id) async {
    final client = _clientFactory();
    try {
      final request = await client.get(_host, _port, '/booking/$id');
      await _authHeader(request.headers);
      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final booking = BookingApiModel.fromJson(jsonDecode(stringData));
        return Success(booking);
      } else {
        return const Failure(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Failure(error);
    } finally {
      client.close();
    }
  }

  AsyncResult<BookingApiModel> postBooking(BookingApiModel booking) async {
    final client = _clientFactory();
    try {
      final request = await client.post(_host, _port, '/booking');
      await _authHeader(request.headers);
      request.write(jsonEncode(booking));
      final response = await request.close();
      if (response.statusCode == 201) {
        final stringData = await response.transform(utf8.decoder).join();
        final booking = BookingApiModel.fromJson(jsonDecode(stringData));
        return Success(booking);
      } else {
        return const Failure(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Failure(error);
    } finally {
      client.close();
    }
  }

  AsyncResult<UserApiModel> getUser() async {
    final client = _clientFactory();
    try {
      final request = await client.get(_host, _port, '/user');
      await _authHeader(request.headers);
      final response = await request.close();
      if (response.statusCode == 200) {
        final stringData = await response.transform(utf8.decoder).join();
        final user = UserApiModel.fromJson(jsonDecode(stringData));
        return Success(user);
      } else {
        return const Failure(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Failure(error);
    } finally {
      client.close();
    }
  }

  AsyncResult<void> deleteBooking(int id) async {
    final client = _clientFactory();
    try {
      final request = await client.delete(_host, _port, '/booking/$id');
      await _authHeader(request.headers);
      final response = await request.close();
      // Response 204 "No Content", delete was successful
      if (response.statusCode == 204) {
        return const Success(Unit);
      } else {
        return const Failure(HttpException("Invalid response"));
      }
    } on Exception catch (error) {
      return Failure(error);
    } finally {
      client.close();
    }
  }
}
