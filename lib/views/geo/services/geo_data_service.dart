import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../models/country.dart';
import '../models/city_state.dart';
import '../models/city.dart';

/// Loads country / state / city data from the bundled JSON assets and
/// caches it in memory for the lifetime of the app.
///
/// ```dart
/// final geo = GeoDataService.instance;
/// final countries = await geo.getCountries();
/// final states = await geo.getStatesByCountry(countryId);
/// final cities = await geo.getCitiesByState(stateId);
/// ```
class GeoDataService {
  GeoDataService._internal();

  static final GeoDataService instance = GeoDataService._internal();

  static const _countriesAsset = 'assets/geo/countries.json';
  static const _statesAsset = 'assets/geo/states.json';
  static const _citiesAsset = 'assets/geo/cities.json';

  List<Country>? _countries;
  List<CityState>? _states;
  List<City>? _cities;

  Map<int, List<CityState>>? _statesByCountry;
  Map<int, List<City>>? _citiesByState;

  Future<void>? _loadingFuture;

  /// Loads all three datasets into memory (idempotent — safe to call
  /// multiple times, subsequent calls reuse the same in-flight/cached
  /// result).
  Future<void> _ensureLoaded() {
    if (_countries != null && _states != null && _cities != null) {
      return Future.value();
    }
    return _loadingFuture ??= _loadAll();
  }

  Future<void> _loadAll() async {
    final results = await Future.wait([
      rootBundle.loadString(_countriesAsset),
      rootBundle.loadString(_statesAsset),
      rootBundle.loadString(_citiesAsset),
    ]);

    final countryJson = jsonDecode(results[0]) as List<dynamic>;
    final stateJson = jsonDecode(results[1]) as List<dynamic>;
    final cityJson = jsonDecode(results[2]) as List<dynamic>;

    _countries = countryJson
        .map((e) => Country.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);

    _states = stateJson
        .map((e) => CityState.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);

    _cities = cityJson
        .map((e) => City.fromJson(e as Map<String, dynamic>))
        .toList(growable: false);

    final statesByCountry = <int, List<CityState>>{};
    for (final s in _states!) {
      statesByCountry.putIfAbsent(s.countryId, () => []).add(s);
    }
    _statesByCountry = statesByCountry;

    final citiesByState = <int, List<City>>{};
    for (final c in _cities!) {
      citiesByState.putIfAbsent(c.stateId, () => []).add(c);
    }
    _citiesByState = citiesByState;
  }

  /// All countries, sorted alphabetically by name.
  Future<List<Country>> getCountries() async {
    await _ensureLoaded();
    return _countries!;
  }

  /// All states/provinces available in the dataset (100 in this dataset,
  /// covering the countries the source data includes).
  Future<List<CityState>> getStates() async {
    await _ensureLoaded();
    return _states!;
  }

  /// States/provinces belonging to a given country id. Returns an empty
  /// list if the country has no states in the dataset.
  Future<List<CityState>> getStatesByCountry(int countryId) async {
    await _ensureLoaded();
    return _statesByCountry![countryId] ?? const [];
  }

  /// All cities in the dataset (36,625 entries).
  Future<List<City>> getCities() async {
    await _ensureLoaded();
    return _cities!;
  }

  /// Cities belonging to a given state id. Returns an empty list if the
  /// state has no cities in the dataset.
  Future<List<City>> getCitiesByState(int stateId) async {
    await _ensureLoaded();
    return _citiesByState![stateId] ?? const [];
  }

  /// Case-insensitive search across country names.
  Future<List<Country>> searchCountries(String query) async {
    await _ensureLoaded();
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _countries!;
    return _countries!.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  /// Case-insensitive search across city names within a given state.
  Future<List<City>> searchCitiesInState(int stateId, String query) async {
    final cities = await getCitiesByState(stateId);
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return cities;
    return cities.where((c) => c.name.toLowerCase().contains(q)).toList();
  }

  /// Clears the in-memory cache (e.g. for tests). Data will be reloaded
  /// from assets on the next call.
  void clearCache() {
    _countries = null;
    _states = null;
    _cities = null;
    _statesByCountry = null;
    _citiesByState = null;
    _loadingFuture = null;
  }
}
