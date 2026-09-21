import 'package:flutter/material.dart';
import '../models/country.dart';
import '../models/city_state.dart';
import '../models/city.dart';
import '../services/geo_data_service.dart';

/// Cascading Country -> State -> City picker built on [GeoDataService].
class CountryStateCityPicker extends StatefulWidget {
  final void Function(Country? country, CityState? state, City? city)?
      onChanged;
  final String? initialCountry;
  final String? initialState;
  final String? initialCity;

  const CountryStateCityPicker({
    super.key,
    this.onChanged,
    this.initialCountry,
    this.initialState,
    this.initialCity,
  });

  @override
  State<CountryStateCityPicker> createState() =>
      _CountryStateCityPickerState();
}

class _CountryStateCityPickerState extends State<CountryStateCityPicker> {
  final _geo = GeoDataService.instance;

  List<Country> _countries = [];
  List<CityState> _states = [];
  List<City> _cities = [];

  Country? _selectedCountry;
  CityState? _selectedState;
  City? _selectedCity;

  bool _loadingCountries = true;
  bool _loadingStates = false;
  bool _loadingCities = false;

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Country? _matchCountry(List<Country> countries, String? name) {
    if (name == null || name.trim().isEmpty) return null;
    final target = name.trim().toLowerCase();
    return countries.cast<Country?>().firstWhere(
          (c) => c!.name.toLowerCase() == target,
          orElse: () => countries.cast<Country?>().firstWhere(
                (c) => c!.name.toLowerCase().contains(target),
                orElse: () => null,
              ),
        );
  }

  CityState? _matchState(List<CityState> states, String? name) {
    if (name == null || name.trim().isEmpty) return null;
    final target = name.trim().toLowerCase();
    return states.cast<CityState?>().firstWhere(
          (s) => s!.name.toLowerCase() == target,
          orElse: () => states.cast<CityState?>().firstWhere(
                (s) => s!.name.toLowerCase().contains(target),
                orElse: () => null,
              ),
        );
  }

  City? _matchCity(List<City> cities, String? name) {
    if (name == null || name.trim().isEmpty) return null;
    final target = name.trim().toLowerCase();
    return cities.cast<City?>().firstWhere(
          (c) => c!.name.toLowerCase() == target,
          orElse: () => cities.cast<City?>().firstWhere(
                (c) => c!.name.toLowerCase().contains(target),
                orElse: () => null,
              ),
        );
  }

  Future<void> _loadCountries() async {
    final countries = await _geo.getCountries();
    if (!mounted) return;

    final matchedCountry = _matchCountry(countries, widget.initialCountry);
    setState(() {
      _countries = countries;
      _selectedCountry = matchedCountry;
      _loadingCountries = false;
    });

    if (matchedCountry != null) {
      await _loadStatesFor(matchedCountry, selectInitial: true);
    }
  }

  Future<void> _loadStatesFor(Country country,
      {bool selectInitial = false}) async {
    setState(() => _loadingStates = true);
    final states = await _geo.getStatesByCountry(country.id);
    if (!mounted) return;

    final matchedState =
        selectInitial ? _matchState(states, widget.initialState) : null;
    setState(() {
      _states = states;
      _selectedState = matchedState;
      _cities = [];
      _selectedCity = null;
      _loadingStates = false;
    });

    if (matchedState != null) {
      await _loadCitiesFor(matchedState, selectInitial: true);
    }

    widget.onChanged?.call(_selectedCountry, _selectedState, _selectedCity);
  }

  Future<void> _loadCitiesFor(CityState state,
      {bool selectInitial = false}) async {
    setState(() => _loadingCities = true);
    final cities = await _geo.getCitiesByState(state.id);
    if (!mounted) return;

    final matchedCity =
        selectInitial ? _matchCity(cities, widget.initialCity) : null;
    setState(() {
      _cities = cities;
      _selectedCity = matchedCity;
      _loadingCities = false;
    });
    widget.onChanged?.call(_selectedCountry, _selectedState, _selectedCity);
  }

  Future<void> _onCountryChanged(Country? country) async {
    setState(() {
      _selectedCountry = country;
      _selectedState = null;
      _selectedCity = null;
      _states = [];
      _cities = [];
    });
    widget.onChanged?.call(_selectedCountry, _selectedState, _selectedCity);
    if (country != null) {
      await _loadStatesFor(country);
    }
  }

  Future<void> _onStateChanged(CityState? state) async {
    setState(() {
      _selectedState = state;
      _selectedCity = null;
      _cities = [];
    });
    widget.onChanged?.call(_selectedCountry, _selectedState, _selectedCity);
    if (state != null) {
      await _loadCitiesFor(state);
    }
  }

  void _onCityChanged(City? city) {
    setState(() => _selectedCity = city);
    widget.onChanged?.call(_selectedCountry, _selectedState, _selectedCity);
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingCountries) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<Country>(
          key: ValueKey('country-${_selectedCountry?.id}'),
          initialValue: _selectedCountry,
          decoration: const InputDecoration(
            labelText: 'Country',
            border: OutlineInputBorder(),
          ),
          isExpanded: true,
          items: _countries
              .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
              .toList(),
          onChanged: _onCountryChanged,
        ),
        const SizedBox(height: 12),
        if (_loadingStates)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: LinearProgressIndicator(),
          )
        else
          DropdownButtonFormField<CityState>(
            key: ValueKey(
                'state-${_selectedCountry?.id}-${_selectedState?.id}'),
            initialValue: _selectedState,
            decoration: InputDecoration(
              labelText: 'State / Province',
              border: const OutlineInputBorder(),
              enabled: _states.isNotEmpty,
            ),
            isExpanded: true,
            items: _states
                .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
                .toList(),
            onChanged: _states.isEmpty ? null : _onStateChanged,
          ),
        const SizedBox(height: 12),
        if (_loadingCities)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: LinearProgressIndicator(),
          )
        else
          DropdownButtonFormField<City>(
            key: ValueKey('city-${_selectedState?.id}-${_selectedCity?.id}'),
            initialValue: _selectedCity,
            decoration: InputDecoration(
              labelText: 'City',
              border: const OutlineInputBorder(),
              enabled: _cities.isNotEmpty,
            ),
            isExpanded: true,
            items: _cities
                .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
                .toList(),
            onChanged: _cities.isEmpty ? null : _onCityChanged,
          ),
      ],
    );
  }
}
