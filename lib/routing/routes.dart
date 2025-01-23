abstract final class Routes {
  static const home = '/';
  static const login = '/login';
  static const bookingRelative = 'booking';
  static const booking = '/$bookingRelative';
  static String bookingWithId(int id) => '$booking/$id';
}
