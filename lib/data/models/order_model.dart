class Order {
  final String id;
  final String userId;
  final String pickupAddress;
  final String dropoffAddress;
  final double price;
  final String status;

  Order({
    required this.id,
    required this.userId,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.price,
    required this.status,
  });

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      userId: map['user_id'],
      pickupAddress: map['pickup_address'],
      dropoffAddress: map['dropoff_address'],
      price: map['price']?.toDouble() ?? 0.0,
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'pickup_address': pickupAddress,
      'dropoff_address': dropoffAddress,
      'price': price,
      'status': status,
    };
  }
}
