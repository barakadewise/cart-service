import 'package:cart_service/config/network_config.dart';
import 'package:cart_service/config/request.dart';
import 'package:cart_service/models/error/error.dart';
import 'package:either_dart/either.dart';

class CartRepository<T> {
  Future<Either<ErrorMap, T>> productItems(
      {Map<String, dynamic>? params,
      String? token,
      required String endPoint,
      required T Function(Map<String, dynamic>) fromJson}) async {
    try {
      final response = await ApplicationBaseRequest.get(
              CartNetworkConfig.baseUrl, endPoint,
              params: params, token: token ?? "")
          .request();
      print("response:${response.data}");
      if (response.status ~/ 100 == 2 && response.data['success']) {
        return Right(fromJson(response.data['data']));
      } else {
        return Left(ErrorMap(message: response.body, errorMap: response.data));
      }
    } catch (e, stack) {
      print("Errro associated with request :$stack");
      rethrow;
    }
  }
}
