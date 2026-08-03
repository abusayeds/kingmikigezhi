/// Named `CityState` (not `State`) to avoid clashing with Flutter's
/// built-in `State<T>` widget class.
class CityState {
  final int id;
  final int countryId;
  final String name;
  final String iso2;
  final String area;

  const CityState({
    required this.id,
    required this.countryId,
    required this.name,
    required this.iso2,
    required this.area,
  });

  factory CityState.fromJson(Map<String, dynamic> json) {
    return CityState(
      id: json['id'] as int,
      countryId: json['countryId'] as int,
      name: json['name'] as String,
      iso2: json['iso2'] as String,
      area: json['area'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'countryId': countryId,
        'name': name,
        'iso2': iso2,
        'area': area,
      };

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) => other is CityState && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
