import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:cart_service/config/network_config.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class ApplicationBaseRequest {
  String baseUrl;
  String endpoint;
  String method;
  Map<String, dynamic>? data;
  String? token;
  Uri Function(String, String, [Map<String, dynamic>?]) getUri;

  ApplicationBaseRequest._({
    required this.baseUrl,
    required this.endpoint,
    required this.method,
    this.data,
    this.token,
    required this.getUri,
  });

  factory ApplicationBaseRequest.bootstrap({
    required String baseUrl,
    required String endpoint,
    required String method,
    Map<String, dynamic>? data,
    String? token,
  }) {
    getUri(String baseUrl, String endpoint, [Map<String, dynamic>? params]) {
      return Uri.https(baseUrl, endpoint, params);
    }

    return ApplicationBaseRequest._(
      baseUrl: baseUrl,
      endpoint: endpoint,
      method: method,
      data: data,
      token: token,
      getUri: getUri,
    );
  }

  factory ApplicationBaseRequest.get(
    String baseUrl,
    String endpoint, {
    Map<String, dynamic>? params,
    String token = "",
  }) =>
      ApplicationBaseRequest.bootstrap(
        baseUrl: baseUrl,
        endpoint: endpoint,
        method: 'get',
        data: params,
        token: token,
      );

  factory ApplicationBaseRequest.delete(
    String baseUrl,
    String endpoint, {
    Map<String, dynamic>? params,
    String token = "",
  }) =>
      ApplicationBaseRequest.bootstrap(
        baseUrl: baseUrl,
        endpoint: endpoint,
        method: 'delete',
        data: params,
        token: token,
      );

  factory ApplicationBaseRequest.post(
    String baseUrl,
    String endpoint,
    Map<String, dynamic> payload, {
    String token = "",
  }) =>
      ApplicationBaseRequest.bootstrap(
        baseUrl: baseUrl,
        endpoint: endpoint,
        method: 'post',
        data: payload,
        token: token,
      );

  factory ApplicationBaseRequest.patch(
    String baseUrl,
    String endpoint,
    Map<String, dynamic> payload, {
    String token = "",
  }) =>
      ApplicationBaseRequest.bootstrap(
        baseUrl: baseUrl,
        endpoint: endpoint,
        method: "put",
        data: payload,
        token: token,
      );

  Future<Response> request() async {
    late http.Response response;
    try {
      if (method.toLowerCase() == "get") {
        final Map<String, String?> params = data != null
            ? data!.map((key, value) => MapEntry(key, value?.toString()))
            : {};

        print("method $method");
        final Uri requestUrl = getUri(baseUrl, endpoint, params);
        print("GET Request URL: $requestUrl ");

        response = await http
            .get(requestUrl, headers: _getHeaders())
            .timeout(const Duration(seconds: 60));
        print("Complleted request:");
      }

      if (method.toLowerCase() == "delete") {
        final Uri requestUrl = getUri(baseUrl, endpoint);
        print("DELETE Request URL: $requestUrl");

        var req = http.MultipartRequest(method.toUpperCase(), requestUrl);
        data!.forEach((key, value) async {
          if (value is String || value is num) {
            req.fields[key] = value.toString();
          }
          if (value is PlatformFile) {
            req.files.add(http.MultipartFile.fromBytes(
              key,
              value.bytes!.toList(),
            ));
          }
        });

        req.headers.addAll(_getHeaders());
        response = await http.Response.fromStream(await req.send())
            .timeout(const Duration(seconds: 60));
      }

      if (method.toLowerCase() == "post") {
        final Uri requestUrl = getUri(baseUrl, endpoint);
        print("POST Request URL: $requestUrl");

        var req = http.MultipartRequest(method.toUpperCase(), requestUrl);
        data!.forEach((key, value) async {
          if (value is String ||
              value is double ||
              value is int ||
              value is DateTime) {
            req.fields[key] = value.toString();
          }
          if (value is List) {
            for (int i = 0; i < value.length; i++) {
              req.fields["$key[$i]"] = value[i].toString();
            }
          }
          if (value is Map) {
            value.forEach((k, v) {
              req.fields["$key[$k]"] = v.toString();
            });
          }
          if (value is PlatformFile || value is File) {
            req.files.add(await http.MultipartFile.fromPath(
              key,
              value.path!,
            ));
          }
        });

        req.headers.addAll(_getHeaders());
        response = await http.Response.fromStream(await req.send())
            .timeout(const Duration(seconds: 60));
      }

      if (method.toLowerCase() == "put") {
        final Uri requestUrl = getUri(baseUrl, endpoint);
        print("PUT Request URL: $requestUrl");

        var req = http.MultipartRequest(method.toUpperCase(), requestUrl);
        req.fields['_method'] = "PUT";
        data!.forEach((key, value) async {
          if (value is String || value is double || value is int) {
            req.fields[key] = value.toString();
          }
        });

        req.headers.addAll(_getHeaders());
        response = await http.Response.fromStream(await req.send())
            .timeout(const Duration(seconds: 60));
      }
    } on SocketException {
      return Response(
        status: 408,
        message: "No Internet Connection",
        data: {},
        body: "",
      );
    } on TimeoutException {
      return Response(
        status: 408,
        message: "Request Timeout",
        data: {},
        body: "",
      );
    } catch (e) {
      return Response(
        status: 500,
        message: "Something went wrong please wait and try again",
        data: {},
        body: "",
      );
    }

    try {
      final statusCode = response.statusCode;
      final decoded = jsonDecode(response.body);
      return Response(
        status: statusCode,
        data: decoded,
        message: response.reasonPhrase,
        body: response.body,
      );
    } catch (e) {
      return Response(
        status: response.statusCode,
        data: {
          "error": "Decoding Error",
          "response": response.body,
        },
        message: response.reasonPhrase,
        body: response.body,
      );
    }
  }

//return the headers
  Map<String, String> _getHeaders() {
    Map<String, String> headers = CartNetworkConfig.config!['headers'];
    if (token != "") {
      headers['Authorization'] = 'Bearer $token';
    }
    print("Headers:$headers");
    return headers;
  }
}

//Customised response class
class Response {
  final int status;
  final String? message;
  final Map<String, dynamic> data;
  final String? body;

  Response({
    required this.status,
    required this.data,
    this.message,
    this.body,
  });
}
