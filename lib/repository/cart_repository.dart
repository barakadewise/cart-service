import 'package:cart_service/config/network_config.dart';
import 'package:cart_service/config/request.dart';
import 'package:cart_service/models/error/error.dart';
import 'package:either_dart/either.dart';

class CartRepository {
  CartRepository() {
    CartNetworkConfig.init("http://exmaple/service.com");
  }
  // Future<Either<ErrorMap, Type>> getCartItems() async {
  //   try {
  //     var response = await ApplicationBaseRequest.get(
  //       CartNetworkConfig.baseUrl,
  //       "/cart",
  //     ).request();
  //     if (response== 200) {
  //       return Right(Type.fromJson(response.body));
  //     } else {
  //       return Left(ErrorModel.fromJson(response.body));
  //     }
  //   } catch (e) {
  //     return Left(ErrorModel(message: e.toString()));
  //   }
  // }
}
