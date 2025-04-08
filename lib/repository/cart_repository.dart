import 'package:cart_service/config/network_config.dart';
import 'package:cart_service/config/request.dart';
import 'package:cart_service/models/error/error.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';

class CartRepository<T> {
  Future<Either<ErrorMap, List<T>>> productItems({
    Map<String, dynamic>? params,
    String? token,
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

      debugPrint("response: ${response.data}");

      if (response.status ~/ 100 == 2 && response.data['success']) {
        final List<dynamic> rawList = response.data['data'];

        // Convert List<dynamic> to List<T> using fromJson
        final List<T> itemList = rawList.map((item) => fromJson(item)).toList();

        return Right(itemList);
      } else {
        return Left(ErrorMap(message: response.body, errorMap: response.data));
      }
    } catch (e, stack) {
      debugPrint("🔥 Exception during request: $e");
      debugPrint("🧱 Stack trace: $stack");
      return Left(ErrorMap(message: e.toString(), errorMap: {}));
    }
  }
}
