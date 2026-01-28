

abstract class NetworkRepository {
  Future<dynamic> get(
      String route, {
        Map<String, dynamic> incomingHeaders = const {},
      });
  Future<dynamic> post(
      String route, {
        required dynamic form,
        Map<String, dynamic> incomingHeaders = const {},
      });
}
