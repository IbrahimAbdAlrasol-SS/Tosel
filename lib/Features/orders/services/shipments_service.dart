// lib/Features/orders/services/shipments_service.dart
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
          endpoint: '/shipment/merchant/my-shipments',
          page: page,
          queryParams: queryParams);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  Future<Shipment?> getShipmentById(String shipmentId) async {
    try {
      var result =
          await baseClient.getById(endpoint: '/shipment', id: shipmentId);
      return result.singleData;
    } catch (e) {
      print('Error fetching shipment by ID: $e');
      return null;
    }
  }

  Future<(Shipment?, String?)> createShipment(
      Shipment shipmentData) async {
    try {
      var result = await baseClient.create(
          endpoint: '/shipment/pick-up', data: shipmentData.toJson());

      if (result.code == 200 || result.code == 201) {
        return (result.singleData, null);
      } else {
        return (null, result.message ?? 'فشل في إنشاء الشحنة');
      }
    } catch (e) {
      return (null, e.toString());
    }
  }

  Future<(Shipment?, String?)> createPickupShipment(
      Map<String, dynamic> shipmentData) async {
    try {
      print('ShipmentsService: Sending data to /shipment/pick-up');
      print('Data: $shipmentData');
      
      var result = await baseClient.create(
          endpoint: '/shipment/pick-up', data: shipmentData);

      print('ShipmentsService: Response code: ${result.code}');
      print('ShipmentsService: Response message: ${result.message}');
      print('ShipmentsService: Response data: ${result.singleData}');

      if (result.code == 200 || result.code == 201) {
        return (result.singleData, null);
      } else {
        return (null, result.message ?? 'فشل في إنشاء الشحنة');
      }
    } catch (e) {
      print('ShipmentsService: Error: $e');
      return (null, e.toString());
    }
  }

  Future<ApiResponse<dynamic>> getShipmentOrders({
    required String shipmentId,
    int page = 1,
  }) async {
    try {
      var result = await BaseClient().getAll(
        endpoint: '/shipment/$shipmentId',
        page: page,
      );
      return result;
    } catch (e) {
      rethrow;
    }
  }
}