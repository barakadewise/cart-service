/// A utility class to hold and manage API configuration
/// for the entire app lifecycle. This class should be initialized once
/// before any network requests are made.
class CartNetworkConfig {
  static Map<String, dynamic>? _config;

  /// Initializes the API configuration
  ///
  /// Parameters:
  /// - [baseUrl] (required): The base URL of your backend API.
  /// - [apiResponseSuccessKey] (optional): The key used in API responses
  ///   to check if the response was successful. Defaults to `'success'` if not provided.
  /// - [useJson] (optional): If true, all requests will use `application/json` body format
  ///   instead of `multipart/form-data`. Defaults to `false`.
  ///
  /// Example:
  /// ```dart
  /// CartNetworkConfig.init(
  ///   'https://api.example.com',
  ///   apiResponseSuccessKey: 'status',
  ///   useJson: true,
  /// );
  /// ```
  static void init(
    String baseUrl, {
    String? apiResponseSuccessKey,
    bool useJson = false,
  }) {
    assert(baseUrl.isNotEmpty, 'Base URL is required and cannot be empty');

    _config = {
      'baseUrl': baseUrl,
      'apiSuccessKey': apiResponseSuccessKey,
      'useJson': useJson,
      'headers': {
        'access-control-allow-origin': '*',
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': '*/*',
      },
    };
  }

  /// Returns the full configuration map
  static Map<String, dynamic>? get config => _config;

  /// Returns the base URL set during initialization.
  /// Throws an error if the config is not initialized.
  static String get baseUrl {
    if (_config == null || _config!['baseUrl'].isEmpty) {
      throw Exception(
        'Base URL is not set. Please initialize CartNetworkConfig.',
      );
    }
    return _config?['baseUrl'] ?? '';
  }

  /// Returns the API success key used to evaluate success in responses.
  /// Defaults to `'success'` if not explicitly provided.
  static String get apiSuccessKey => _config?['apiSuccessKey'] ?? 'success';

  /// Returns true if the configuration is set to use JSON format
  /// in the request body; otherwise, false.
  static bool get useJson => _config?['useJson'] ?? false;

  /// Returns the headers to be used in network requests.
  static Map<String, String> get headers =>
      Map<String, String>.from(_config?['headers'] ?? {});
}
