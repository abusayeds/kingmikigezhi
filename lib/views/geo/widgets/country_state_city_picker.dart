import 'package:flutter/material.dart';

import '../models/country.dart';
import '../models/city_state.dart';
import '../models/city.dart';
import '../services/geo_data_service.dart';

/// A simple cascading Country -> State -> City picker built on top of
/// [GeoDataService]. Selecting a country loads its states; selecting a
/// state loads its cities. Calls [onChanged] whenever the final
/// selection changes.
class CountryStateCityPicker extends StatefulWidget {
  final void Function(Country? country, CityState? state, City? city)?
      onChanged;

  const CountryStateCityPicker({super.key, this.onChanged});

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

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    final countries = await _geo.getCountries();
    setState(() {
      _countries = countries;
      _loadingCountries = false;
    });
  }

  Future<void> _onCountryChanged(Country? country) async {
    final states = country == null
        ? <CityState>[]
        : await _geo.getStatesByCountry(country.id);
    setState(() {
      _selectedCountry = country;
      _states = states;
      _selectedState = null;
      _cities = [];
      _selectedCity = null;
    });
    widget.onChanged?.call(_selectedCountry, _selectedState, _selectedCity);
  }

  Future<void> _onStateChanged(CityState? state) async {
    final cities =
        state == null ? <City>[] : await _geo.getCitiesByState(state.id);
    setState(() {
      _selectedState = state;
      _cities = cities;
      _selectedCity = null;
    });
    widget.onChanged?.call(_selectedCountry, _selectedState, _selectedCity);
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
          initialValue: _selectedCountry,
          decoration: const InputDecoration(labelText: 'Country'),
          isExpanded: true,
          items: _countries
              .map((c) => DropdownMenuItem(value: c, child: Text(c.name)))
              .toList(),
          onChanged: _onCountryChanged,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<CityState>(
          initialValue: _selectedState,
          decoration: InputDecoration(
            labelText: 'State / Province',
            enabled: _states.isNotEmpty,
          ),
          isExpanded: true,
          items: _states
              .map((s) => DropdownMenuItem(value: s, child: Text(s.name)))
              .toList(),
          onChanged: _states.isEmpty ? null : _onStateChanged,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<City>(
          initialValue: _selectedCity,
          decoration: InputDecoration(
            labelText: 'City',
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
