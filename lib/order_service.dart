import 'package:cart_service/config/network_config.dart';
import 'package:cart_service/config/request.dart';
import 'package:cart_service/models/error/error.dart';
import 'package:either_dart/either.dart';
import 'package:flutter/foundation.dart';

/// A service class to manage and fetch orders from a server.
///
/// [O] is the generic order model type. You must provide a concrete type
/// when creating an instance of this class.
///
/// Example:
/// ```dart
/// final orderService = OrderService<MyOrderModel>();
/// final result = await orderService.getOrders(
///   endPoint: '/user/orders',
///   fromJson: (json) => MyOrderModel.fromJson(json),
/// );
/// ```
class OrderService<O> {
  OrderService() {
    assert(O != dynamic,
        'You must explicitly specify the type parameter <O> when creating OrderService');
  }

  List<O> _orderItems = [];

  /// Returns the list of cached order items.
  List<O> get orderItems => _orderItems;

  /// Fetches user orders from the server and parses them into a list of type [O].
  ///
  /// Parameters:
  /// - [dataKey] (optional): The key in the JSON response that holds the orders. Defaults to `'orders'`.
  /// - [params], [extraHeaders], [token]: Optional HTTP request parameters and headers.
  /// - [endPoint]: API endpoint to fetch orders from.
  /// - [fromJson]: A function that converts a JSON map into an instance of type [O].
  ///
  /// Returns: `Either<ErrorMap, List<O>>`
  Future<Either<ErrorMap, List<O>>> getOrders({
    String? dataKey,
    Map<String, dynamic>? params,
    Map<String, dynamic>? extraHeaders,
    String? token,
    required String endPoint,
    required O Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      var res = await ApplicationBaseRequest.get(
        CartNetworkConfig.baseUrl,
        endPoint,
        extraHeaders: extraHeaders,
        params: params,
        token: token ?? "",
      ).request();

      if (res.status ~/ 100 == 2 && res.data[CartNetworkConfig.apiSuccessKey]) {
        final rawList = res.data[dataKey ?? 'orders'] as List<dynamic>;
        final List<O> orders = rawList.map((e) => fromJson(e)).toList();
        _orderItems = orders;
        return Right(orders);
      } else {
        return Left(ErrorMap(errorMap: res.data));
      }
    } catch (e, stack) {
      debugPrint("Exception caught: $e\nStacktrace:\n$stack");
      rethrow;
    }
  }
}
