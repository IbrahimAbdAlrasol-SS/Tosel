class OrderFilter {
  String? code;
  int? status;
  String? zoneId;
  String? shipmentId;
  String? shipmentCode;

  OrderFilter({
    this.code,
    this.status,
    this.zoneId,
    this.shipmentId,
    this.shipmentCode,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.code != null) {
      data['code'] = this.code;
    }
    if (this.status != null) {
      data['status'] = this.status;
    }
    if (this.zoneId != null) {
      data['zoneId'] = this.zoneId;
    }
    if (this.shipmentId != null) {
      data['shipmentId'] = this.shipmentId;
    }

    return data;
  }
}
