import 'package:flutter/material.dart';
import '../../../core/constants/rashi_data.dart';
import '../../../core/services/storage_service.dart';
import '../models/rashi_model.dart';
import '../repositories/rashi_repository.dart';

class RashiProvider extends ChangeNotifier {
  final RashiRepository _repository;
  final StorageService _storageService;

  RashiProvider({
    required RashiRepository repository,
    required StorageService storageService,
  })  : _repository = repository,
        _storageService = storageService {
    _init();
  }

  List<RashiInfo> get rashis => RashiData.rashis;

  late RashiInfo _selectedRashi;
  RashiInfo get selectedRashi => _selectedRashi;

  int _defaultRashiId = 1;
  int get defaultRashiId => _defaultRashiId;

  DateTime _selectedDate = DateTime.now();
  DateTime get selectedDate => _selectedDate;

  RashiReadingModel? _currentReading;
  RashiReadingModel? get currentReading => _currentReading;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  void _init() {
    _defaultRashiId = _storageService.getDefaultRashiId();
    _selectedRashi = RashiData.getRashiById(_defaultRashiId);
    loadReadingForRashi(_selectedRashi);
  }

  Future<void> selectRashi(RashiInfo rashi) async {
    _selectedRashi = rashi;
    await loadReadingForRashi(rashi, date: _selectedDate);
  }

  Future<void> selectDate(DateTime date, {RashiInfo? rashi}) async {
    _selectedDate = date;
    await loadReadingForRashi(rashi ?? _selectedRashi, date: _selectedDate);
  }

  Future<void> setDefaultRashi(int id) async {
    _defaultRashiId = id;
    await _storageService.setDefaultRashiId(id);
    notifyListeners();
  }

  bool isDefaultRashi(int id) => _defaultRashiId == id;

  Future<void> loadReadingForRashi(RashiInfo rashi, {DateTime? date, bool force = false}) async {
    if (date != null) {
      _selectedDate = date;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentReading = await _repository.getRashiReading(rashi, date: _selectedDate);
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<RashiReadingModel?> fetchRashiPreview(RashiInfo rashi) async {
    try {
      return await _repository.getRashiReading(rashi, date: _selectedDate);
    } catch (_) {
      return null;
    }
  }
}
