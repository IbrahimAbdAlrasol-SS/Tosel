class Transaction {
  double? amount;
  String? senderName;
  String? receiverName;
  String? senderId;
  String? receiverId;
  int? type;
  String? id;
  bool? deleted;
  String? creationDate;

  Transaction(
      {this.amount,
      this.senderName,
      this.receiverName,
      this.senderId,
      this.receiverId,
      this.type,
      this.id,
      this.deleted,
      this.creationDate});

  Transaction.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    senderName = json['senderName'];
    receiverName = json['receiverName'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    type = json['type'];
    id = json['id'];
    deleted = json['deleted'];
    creationDate = json['creationDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['amount'] = amount;
    data['senderName'] = senderName;
    data['receiverName'] = receiverName;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['type'] = type;
    data['id'] = id;
    data['deleted'] = deleted;
    data['creationDate'] = creationDate;
    return data;
  }
}
