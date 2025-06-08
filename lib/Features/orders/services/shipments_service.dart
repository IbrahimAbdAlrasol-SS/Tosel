import 'package:Tosell/Features/orders/models/Shipment.dart';
import 'package:Tosell/core/Client/BaseClient.dart';
import 'package:Tosell/core/Client/ApiResponse.dart';

class ShipmentsService {
  final BaseClient<Shipment> baseClient;

  ShipmentsService()
      : baseClient =
            BaseClient<Shipment>(fromJson: (json) => Shipment.fromJson(json));

  Future<ApiResponse<Shipment>> getAll(
      {int page = 1, Map<String, dynamic>? queryParams}) async {
    try {
      var result = await baseClient.getAll(
          endpoint: '/shipment/my-shipments',
          page: page,
          queryParams: queryParams);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}
