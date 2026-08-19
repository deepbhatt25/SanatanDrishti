import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bhagvat_geeta_app/core/services/storage_service.dart';
import 'package:bhagvat_geeta_app/features/kundali/models/kundali_model.dart';
import 'package:bhagvat_geeta_app/features/kundali/services/kundali_calculator.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Kundali Local Storage Tests', () {
    late StorageService storageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      storageService = StorageService();
      storageService.initForTesting(prefs);
    });

    test('Saves, retrieves, and deletes Kundali results accurately', () async {
      final profile = KundaliProfile(
        id: 'k_123',
        name: 'Devashish',
        gender: Gender.male,
        dateOfBirth: DateTime(1998, 5, 20),
        birthTimeHour: 14,
        birthTimeMinute: 45,
        cityName: 'Varanasi',
        latitude: 25.3176,
        longitude: 82.9739,
        timezone: 5.5,
        createdAt: DateTime.now(),
      );

      final result = KundaliCalculator.calculateVedicKundali(profile);

      // 1. Initially empty
      expect(storageService.getSavedKundalis().isEmpty, true);

      // 2. Save result
      await storageService.saveKundaliResult(result);
      final saved = storageService.getSavedKundalis();
      expect(saved.length, 1);
      expect(saved.first.profile.name, 'Devashish');
      expect(saved.first.profile.cityName, 'Varanasi');
      expect(saved.first.lagnaRashiId, result.lagnaRashiId);

      // 3. Retrieve by ID
      final retrieved = storageService.getKundaliById('k_123');
      expect(retrieved != null, true);
      expect(retrieved!.profile.id, 'k_123');

      // 4. Delete result
      await storageService.deleteKundali('k_123');
      expect(storageService.getSavedKundalis().isEmpty, true);
      expect(storageService.getKundaliById('k_123'), null);
    });
  });
}
