import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:belema_test_app/core/api/newtwork_repository.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../utils/custom_exception.dart';
import '../utils/token.dart';

class NetworkImplementation extends NetworkRepository {
  Future<Map<String, String>> createHeaders(
    Map<String, dynamic> incomingHeaders,
  ) async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Token.bearerToken}',
      'app_version': packageInfo.version,
      ...incomingHeaders.map((key, value) => MapEntry(key, value.toString())),
    };
    headers['Content-Type'] = 'application/json';
    return headers;
  }

  dynamic handleResponse(http.Response response) {
    // if (response.statusCode == 419) {
    //   LogoutManager().logout();
    //
    //   throw CustomException(
    //     message: 'Session Expired',
    //     statusCode: 419,
    //   );
    // }

    if (!isSuccessResponse(response.statusCode)) {
      var decodedResponse = json.decode(response.body);

      Logger().d(response.statusCode);
      Logger().d(response.request!.url);
      Logger().d(decodedResponse);

      String? errorMessage;
      if (decodedResponse['errors'] != null) {
        decodedResponse['errors'].forEach((key, value) {
          // Check if the value is a list (assuming errors are stored as lists)
          if (value is List) {
            // Access the first error message for each key
            if (value[0] is Map) {
              errorMessage = value[0]['message'];
            } else {
              errorMessage = value[0];
            }
          } else {
            errorMessage = value['message'] ?? value;
          }
        });
      }
      errorMessage ??= decodedResponse['message'] ?? decodedResponse['Message'];

      throw CustomException(
        message: errorMessage ?? 'An error occurred',
        statusCode: response.statusCode,
        data: decodedResponse,
      );
    } else {
      return json.decode(response.body);
    }
  }

  dynamic handleFormResponse(http.StreamedResponse response) async {
    // if (response.statusCode == 419) {
    //   LogoutManager().logout();
    //
    //   throw CustomException(
    //     message: 'Session Expired',
    //     statusCode: 419,
    //   );
    // }
    if (!isSuccessResponse(response.statusCode)) {
      var data = await response.stream.bytesToString();
      var decodedResponse = json.decode(data);

      Logger().d(response.statusCode);
      Logger().d(response.request!.url);
      Logger().d(decodedResponse);

      String? errorMessage;
      if (decodedResponse['errors'] != null) {
        decodedResponse['errors'].forEach((key, value) {
          // Check if the value is a list (assuming errors are stored as lists)
          if (value is List) {
            // Access the first error message for each key
            errorMessage = value[0];
          } else {
            errorMessage = value['message'] ?? value;
          }
        });
      }
      errorMessage ??= decodedResponse['message'] ?? decodedResponse['Message'];

      throw CustomException(
        message: errorMessage ?? 'An error occurred',
        statusCode: response.statusCode,
      );
    } else {
      var data = await response.stream.bytesToString();
      return json.decode(data);
    }
  }

  bool isSuccessResponse(int number) => number >= 200 && number <= 299;

  @override
  Future get(
    String route, {
    bool isFormData = false,
    Map<String, dynamic> incomingHeaders = const {},
  }) async {
    Map<String, String> headers = await createHeaders(incomingHeaders);

    try {
      http.Response response = await http.get(
        Uri.parse(route),
        headers: headers,
      );

      return handleResponse(response);
    } on CustomException catch (e) {
      throw CustomException(message: e.toString(), statusCode: e.statusCode);
    } on TimeoutException catch (_) {
      throw CustomException(
        message: 'Network error, Connection timed out, please try again',
        statusCode: 499,
      );
    } catch (e) {
      throw CustomException(
        message: '$e, please try again',
        statusCode: 499,
      );
    }
  }

  @override
  Future<dynamic> post(
    String route, {
    required dynamic form,
    Map<String, dynamic> incomingHeaders = const {},
  }) async {
    Map<String, String> headers = await createHeaders(incomingHeaders);

    try {
      http.Response response = await http.post(
        Uri.parse(route),
        body: json.encode(form),
        headers: headers,
      );

      Logger().d('Response: ${response.body}');

      return handleResponse(response);
    } on CustomException catch (_) {
      rethrow;
    } on TimeoutException catch (_) {
      Logger().e('Network error: Connection timed out');
      throw CustomException(
        message: 'Network error, Connection timed out, please try again',
        statusCode: 499,
      );
    } catch (e) {
      Logger().e('Network error: $e');
      throw CustomException(
        message: 'Network error, Connection timed out, please try again',
        statusCode: 499,
      );
    }
  }
}
