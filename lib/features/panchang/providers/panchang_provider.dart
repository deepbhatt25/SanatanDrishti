import 'package:flutter/material.dart';
import '../../../core/services/location_service.dart';
import '../../../core/services/storage_service.dart';
import '../models/panchang_model.dart';
import '../repositories/panchang_repository.dart';

class PanchangProvider extends ChangeNotifier {
  final PanchangRepository _repository;
  final StorageService _storageService;
  final LocationService _locationService;

  PanchangProvider({
    required PanchangRepository repository,
    required StorageService storageService,
    required LocationService locationService,
  })  : _repository = repository,
        _storageService = storageService,
        _locationService = locationService {
    _init();
  }

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  CityLocation _selectedCity = LocationService.defaultCity;
  CityLocation get selectedCity => _selectedCity;

  PanchangModel? _panchang;
  PanchangModel? get panchang => _panchang;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void _init() {
    final savedCityName = _storageService.getSelectedCity();
    _selectedCity = LocationService.getCityByName(savedCityName);
    loadPanchang();
  }

  Future<void> loadPanchang({bool forceRefresh = false}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _panchang = await _repository.getPanchang(
        date: _selectedDate,
        city: _selectedCity,
        forceRefresh: forceRefresh,
      );
      _error = null;
    } catch (e) {
      _error = e.toString();
      // Even in error, generate calculation fallback
      _panchang = PanchangRepository.calculateVedicPanchang(_selectedDate, _selectedCity);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void selectDate(DateTime date) {
    _selectedDate = date;
    loadPanchang();
  }

  void setCity(CityLocation city) {
    _selectedCity = city;
    _storageService.setSelectedCity(city.name);
    loadPanchang();
  }

  Future<void> detectLocation() async {
    _isLoading = true;
    notifyListeners();
    final loc = await _locationService.getCurrentOrFallbackLocation(_selectedCity.name);
    _selectedCity = loc;
    await loadPanchang();
  }
}
