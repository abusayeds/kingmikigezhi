class Country {
  final int id;
  final String name;
  final String iso2;
  final String continent;
  final String capital;

  const Country({
    required this.id,
    required this.name,
    required this.iso2,
    required this.continent,
    required this.capital,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'] as int,
      name: json['name'] as String,
      iso2: json['iso2'] as String,
      continent: json['continent'] as String,
      capital: json['capital'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'iso2': iso2,
        'continent': continent,
        'capital': capital,
      };

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) => other is Country && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
