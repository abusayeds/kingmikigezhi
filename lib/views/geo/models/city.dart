class City {
  final int id;
  final int stateId;
  final String name;
  final String type;

  const City({
    required this.id,
    required this.stateId,
    required this.name,
    required this.type,
  });

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'] as int,
      stateId: json['stateId'] as int,
      name: json['name'] as String,
      type: json['type'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'stateId': stateId,
        'name': name,
        'type': type,
      };

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) => other is City && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
