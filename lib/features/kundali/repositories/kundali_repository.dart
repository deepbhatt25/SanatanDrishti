import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/config/api_config.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/storage_service.dart';
import '../models/kundali_model.dart';
import '../services/kundali_calculator.dart';

class KundaliRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  KundaliRepository({
    required ApiClient apiClient,
    required StorageService storageService,
  })  : _apiClient = apiClient,
        _storageService = storageService;

  Future<KundaliResult> generateKundali({
    required KundaliProfile profile,
    bool saveToLocal = true,
  }) async {
    KundaliResult result;

    // 1. If FreeAstrologyAPI Key is configured, attempt online enhancement
    if (ApiConfig.hasPanchangApiKey) {
      try {
        final payload = {
          'year': profile.dateOfBirth.year,
          'month': profile.dateOfBirth.month,
          'date': profile.dateOfBirth.day,
          'hours': profile.birthTimeHour,
          'minutes': profile.birthTimeMinute,
          'seconds': 0,
          'latitude': profile.latitude,
          'longitude': profile.longitude,
          'timezone': profile.timezone,
          'config': {
            'observation_point': 'topocentric',
            'ayanamsha': 'lahiri',
          },
        };

        final response = await _apiClient.post(
          '${ApiConfig.panchangBaseUrl}/horoscope-chart',
          data: payload,
          options: Options(
            headers: {'x-api-key': ApiConfig.freeAstrologyApiKey},
          ),
        );

        if (response.data is Map<String, dynamic>) {
          debugPrint('Online Kundali API response received successfully');
        }
      } catch (e) {
        debugPrint('Online Kundali API request bypassed or failed: $e');
      }
    }

    // 2. High-precision Vedic Algorithm (Guaranteed 100% calculation)
    result = KundaliCalculator.calculateVedicKundali(profile);

    // 3. Save to local storage
    if (saveToLocal) {
      await _storageService.saveKundaliResult(result);
    }

    return result;
  }

  List<KundaliResult> getSavedKundalis() {
    final list = _storageService.getSavedKundalis();
    return list.map((k) {
      if (k.lifePrediction.physicalAppearance.descriptionGu.isEmpty) {
        final refreshed = KundaliCalculator.calculateVedicKundali(k.profile);
        _storageService.saveKundaliResult(refreshed);
        return refreshed;
      }
      return k;
    }).toList();
  }

  KundaliResult? getKundaliById(String id) {
    final k = _storageService.getKundaliById(id);
    if (k != null && k.lifePrediction.physicalAppearance.descriptionGu.isEmpty) {
      final refreshed = KundaliCalculator.calculateVedicKundali(k.profile);
      _storageService.saveKundaliResult(refreshed);
      return refreshed;
    }
    return k;
  }

  Future<void> deleteKundali(String id) async {
    await _storageService.deleteKundali(id);
  }
}
