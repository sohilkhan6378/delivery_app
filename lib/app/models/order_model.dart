class OrderModel {
  final String orderId;
  final String partyName;
  final String assignedPerson;
  final String pickupPhoto;
  final String pickupTime;
  final String pickupStatus;
  final String deliveryPhoto;
  final String deliveryTime;
  final String deliveryStatus;
  final String receiverPhoto;
  final String deliveryLocation;

  OrderModel({
    required this.orderId,
    required this.partyName,
    required this.assignedPerson,
    required this.pickupPhoto,
    required this.pickupTime,
    required this.pickupStatus,
    required this.deliveryPhoto,
    required this.deliveryTime,
    required this.deliveryStatus,
    required this.receiverPhoto,
    required this.deliveryLocation,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      orderId: json['OrderID']?.toString() ?? '',
      partyName: json['PartyName']?.toString() ?? '',
      assignedPerson: json['AssignedPerson']?.toString() ?? '',
      pickupPhoto: json['PickupPhoto']?.toString() ?? '',
      pickupTime: json['PickupTime']?.toString() ?? '',
      pickupStatus: json['PickupStatus']?.toString() ?? '',
      deliveryPhoto: json['DeliveryPhoto']?.toString() ?? '',
      deliveryTime: json['DeliveryTime']?.toString() ?? '',
      deliveryStatus: json['DeliveryStatus']?.toString() ?? '',
      receiverPhoto: json['ReceiverPhoto']?.toString() ?? '',
      deliveryLocation: json['DeliveryLocation']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'OrderID': orderId,
      'PartyName': partyName,
      'AssignedPerson': assignedPerson,
      'PickupPhoto': pickupPhoto,
      'PickupTime': pickupTime,
      'PickupStatus': pickupStatus,
      'DeliveryPhoto': deliveryPhoto,
      'DeliveryTime': deliveryTime,
      'DeliveryStatus': deliveryStatus,
      'ReceiverPhoto': receiverPhoto,
      'DeliveryLocation': deliveryLocation,
    };
  }

  OrderModel copyWith({
    String? pickupPhoto,
    String? pickupTime,
    String? pickupStatus,
    String? deliveryPhoto,
    String? deliveryTime,
    String? deliveryStatus,
    String? receiverPhoto,
    String? deliveryLocation,
  }) {
    return OrderModel(
      orderId: orderId,
      partyName: partyName,
      assignedPerson: assignedPerson,
      pickupPhoto: pickupPhoto ?? this.pickupPhoto,
      pickupTime: pickupTime ?? this.pickupTime,
      pickupStatus: pickupStatus ?? this.pickupStatus,
      deliveryPhoto: deliveryPhoto ?? this.deliveryPhoto,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      deliveryStatus: deliveryStatus ?? this.deliveryStatus,
      receiverPhoto: receiverPhoto ?? this.receiverPhoto,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
    );
  }
}
