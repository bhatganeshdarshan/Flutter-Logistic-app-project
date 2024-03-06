class AvailableVehicles {
  final int id;
  final String vehicleName;
  final int wheels;
  final int capacity;

  const AvailableVehicles(
      {required this.id,
      required this.vehicleName,
      required this.wheels,
      required this.capacity});

  AvailableVehicles copyWith({
    int? id,
    String? vehicleName,
    int? wheels,
    int? capacity,
  }) {
    return AvailableVehicles(
        id: id ?? this.id,
        vehicleName: vehicleName ?? this.vehicleName,
        wheels: wheels ?? this.wheels,
        capacity: capacity ?? this.capacity);
  }

  factory AvailableVehicles.fromJson(Map<String, dynamic> json) {
    return AvailableVehicles(
        id: json['id'],
        vehicleName: json['vehicleName'],
        wheels: json['wheels'],
        capacity: json['capacity']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['vehicleName'] = vehicleName;
    data['wheels'] = wheels;
    data['capacity'] = capacity;
    return data;
  }

  @override
  List<Object?> get props => [id, vehicleName, wheels, capacity];
}
