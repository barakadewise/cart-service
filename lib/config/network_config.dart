export 'package:cart_service/config/network_config.dart';

class CartNetworkConfig {
  static Map<String, dynamic>? _config;

  static init(String baseUrl, String? apiResponseSuccessKey) {
    // Assert that baseUrl is provided and not empty
    assert(baseUrl.isNotEmpty, 'Base URL is required and cannot be empty');

    _config = {
      'baseUrl': baseUrl,
      'apiSuccessKey': apiResponseSuccessKey,
      'headers': {
        'access-control-allow-origin': '*',
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
      },
    };
  }

  static Map<String, dynamic>? get config => _config;

  static String get baseUrl {
    // Throw an error if baseUrl is not set
    if (_config == null || _config!['baseUrl'].isEmpty) {
      throw Exception(
          'Base URL is not set. Please initialize CartNetworkConfig with a base URL.');
    }
    return _config?['baseUrl'] ?? '';
  }

//retreave apiSUccessKey provided
  static String get apiSuccessKey => _config?['apiSuccessKey'] ?? "success";
}
