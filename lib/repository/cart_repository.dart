import 'package:cart_service/config/network_config.dart';
import 'package:cart_service/config/request.dart';
import 'package:cart_service/models/error/error.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';

class CartRepository<T> {
  Future<Either<ErrorMap, List<T>>> productItems({
    Map<String, dynamic>? params,
    String? token,
    String? dataKey,
    required String endPoint,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await ApplicationBaseRequest.get(
        CartNetworkConfig.baseUrl,
        endPoint,
        params: params,
        token: token ?? "",
      ).request();
      debugPrint("API RESPONSE DATA: ${response.data}");
      if (response.status ~/ 100 == 2) {
        final List<dynamic> rawList = response.data[dataKey ?? 'products'];
        // Convert List<dynamic> to List<T> using fromJson
        final List<T> itemList = rawList.map((item) => fromJson(item)).toList();

        return Right(itemList);
      } else {
        return Left(ErrorMap(message: response.body, errorMap: response.data));
      }
    } catch (e, stack) {
      debugPrint("🔥 Exception during request: $e stack trace:\n$stack");
      rethrow;
    }
  }

  Future<Either<ErrorMap, Response>> fetchUserCarts(
    String?dataKey,
      Map<String, dynamic> params, String? token) async {
    try {
      var response = await ApplicationBaseRequest.post(
              token: token ?? "", CartNetworkConfig.baseUrl, 'endpoint', params)
          .request();
      if (response.status ~/ 100 == 2 && response.data[dataKey ?? 'products']) {
        return Right(response);
      } else {
        return Left(ErrorMap(
            body: response.body,
            message: response.message,
            errorMap: response.data));
      }
    } catch (e, trace) {
      debugPrint("Error occured while sending order:$e \n $trace");
      rethrow;
    }
  }
}
