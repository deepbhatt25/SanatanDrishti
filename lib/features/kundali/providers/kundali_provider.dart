import 'package:flutter/foundation.dart';
import '../models/kundali_model.dart';
import '../repositories/kundali_repository.dart';

class KundaliProvider extends ChangeNotifier {
  final KundaliRepository _repository;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  KundaliResult? _currentResult;
  KundaliResult? get currentResult => _currentResult;

  List<KundaliResult> _savedKundalis = [];
  List<KundaliResult> get savedKundalis => List.unmodifiable(_savedKundalis);

  KundaliProvider({required KundaliRepository repository}) : _repository = repository {
    loadSavedKundalis();
  }

  void loadSavedKundalis() {
    try {
      _savedKundalis = _repository.getSavedKundalis();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading saved kundalis: $e');
    }
  }

  void selectKundali(KundaliResult result) {
    _currentResult = result;
    notifyListeners();
  }

  Future<KundaliResult?> generateKundali(KundaliProfile profile) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _repository.generateKundali(profile: profile);
      _currentResult = result;
      _savedKundalis = _repository.getSavedKundalis();
      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> deleteKundali(String id) async {
    try {
      await _repository.deleteKundali(id);
      if (_currentResult?.profile.id == id) {
        _currentResult = null;
      }
      _savedKundalis = _repository.getSavedKundalis();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting kundali: $e');
    }
  }
}
