import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:cart_service/config/network_config.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';

class ApplicationBaseRequest {
  String baseUrl;
  String endpoint;
  String method;
  Map<String, dynamic>? data;
  Map<String, dynamic>? extraHeaders;
  String? token;
  Uri Function(String, String, [Map<String, dynamic>?]) getUri;

  ApplicationBaseRequest._({
    required this.baseUrl,
    required this.endpoint,
    required this.method,
    this.data,
    this.token,
    this.extraHeaders,
    required this.getUri,
  });

  factory ApplicationBaseRequest.bootstrap(
      {required String baseUrl,
      required String endpoint,
      required String method,
      Map<String, dynamic>? data,
      String? token,
      Map<String, dynamic>? extraHeaders}) {
    getUri(String baseUrl, String endpoint, [Map<String, dynamic>? params]) {
      return Uri.https(baseUrl, endpoint, params);
    }

    return ApplicationBaseRequest._(
      baseUrl: baseUrl,
      endpoint: endpoint,
      method: method,
      data: data,
      token: token,
      extraHeaders: extraHeaders,
      getUri: getUri,
    );
  }

  factory ApplicationBaseRequest.get(
    String baseUrl,
    String endpoint, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? extraHeaders,
    String token = "",
  }) =>
      ApplicationBaseRequest.bootstrap(
          baseUrl: baseUrl,
          endpoint: endpoint,
          method: 'get',
          data: params,
          token: token,
          extraHeaders: extraHeaders);

  factory ApplicationBaseRequest.delete(
    String baseUrl,
    String endpoint, {
    Map<String, dynamic>? params,
    Map<String, dynamic>? extraHeaders,
    String token = "",
  }) =>
      ApplicationBaseRequest.bootstrap(
          baseUrl: baseUrl,
          endpoint: endpoint,
          method: 'delete',
          data: params,
          token: token,
          extraHeaders: extraHeaders);

  factory ApplicationBaseRequest.post(
    String baseUrl,
    String endpoint,
    Map<String, dynamic> params, {
    Map<String, dynamic>? extraHeaders,
    String token = "",
  }) =>
      ApplicationBaseRequest.bootstrap(
          baseUrl: baseUrl,
          endpoint: endpoint,
          method: 'post',
          data: params,
          token: token,
          extraHeaders: extraHeaders);

  factory ApplicationBaseRequest.patch(
    String baseUrl,
    String endpoint,
    Map<String, dynamic> params, {
    Map<String, dynamic>? extraHeaders,
    String token = "",
  }) =>
      ApplicationBaseRequest.bootstrap(
          baseUrl: baseUrl,
          endpoint: endpoint,
          method: "put",
          data: params,
          token: token,
          extraHeaders: extraHeaders);

  Future<Response> request() async {
    late http.Response response;
    try {
      final lowerMethod = method.toLowerCase();
      if (lowerMethod == "get") {
        final Map<String, String?> params = data != null
            ? data!.map((key, value) => MapEntry(key, value?.toString()))
            : {};

        final Uri requestUrl = getUri(baseUrl, endpoint, params);
        debugPrint("GET Request URL: $requestUrl ");

        response = await http
            .get(requestUrl, headers: _getHeaders())
            .timeout(const Duration(seconds: 60));
      }

      if (method.toLowerCase() == "delete") {
        final Uri requestUrl = getUri(baseUrl, endpoint);
        debugPrint("DELETE Request URL: $requestUrl");

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
      } else if (lowerMethod == "delete" ||
          lowerMethod == "post" ||
          lowerMethod == "put") {
        if (CartNetworkConfig.useJson) {
          //send data as json format in the body
          final Uri requestUrl = getUri(baseUrl, endpoint);
          debugPrint("${method.toUpperCase()} JSON Request URL: $requestUrl");
          debugPrint("Body: ${jsonEncode(data)}");

          response = await http.Request(method.toUpperCase(), requestUrl)
              .sendJson(data ?? {}, _getHeaders())
              .timeout(const Duration(seconds: 60));
        } else {
          //if not json format data proceed to formdata
          final Uri requestUrl = getUri(baseUrl, endpoint);
          var req = http.MultipartRequest(method.toUpperCase(), requestUrl);
          if (lowerMethod == "put") {
            req.fields['_method'] = "PUT";
          }

          data!.forEach((key, value) async {
            if (value is String || value is num || value is DateTime) {
              req.fields[key] = value.toString();
            } else if (value is List) {
              for (int i = 0; i < value.length; i++) {
                req.fields["$key[$i]"] = value[i].toString();
              }
            } else if (value is Map) {
              value.forEach((k, v) {
                req.fields["$key[$k]"] = v.toString();
              });
            } else if (value is PlatformFile) {
              req.files.add(http.MultipartFile.fromBytes(
                key,
                value.bytes!.toList(),
                filename: value.name,
              ));
            } else if (value is File) {
              req.files.add(await http.MultipartFile.fromPath(key, value.path));
            }
          });

          req.headers.addAll(_getHeaders());
          response = await http.Response.fromStream(await req.send())
              .timeout(const Duration(seconds: 60));
        }
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
      final decoded = jsonDecode(response.body);
      return Response(
        status: response.statusCode,
        data: decoded as Map<String, dynamic>,
        message: response.reasonPhrase,
        body: response.body,
      );
    } catch (e) {
      return Response(
        status: response.statusCode,
        data: {
          "error": "Error decoding response",
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
    //add extra headers if given
    if (extraHeaders != null) {
      extraHeaders!.forEach((k, v) {
        headers[k] = v;
      });
    }
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

extension HttpRequestSendJson on http.Request {
  Future<http.Response> sendJson(
      Map<String, dynamic> data, Map<String, String> headers) async {
    this.headers.addAll(headers);
    body = jsonEncode(data);
    final streamedResponse = await send();
    return await http.Response.fromStream(streamedResponse);
  }
}
