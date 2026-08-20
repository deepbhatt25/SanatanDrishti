import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bhagvat_geeta_app/features/kundali/models/kundali_model.dart';
import 'package:bhagvat_geeta_app/features/kundali/services/kundali_calculator.dart';
import 'package:bhagvat_geeta_app/features/kundali/services/kundali_pdf_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  group('Kundali PDF Service Tests', () {
    test('Generates valid Vedic Kundali PDF document', () async {
      final profile = KundaliProfile(
        id: 'test_pdf_1',
        name: 'Bhargav Modi',
        gender: Gender.male,
        dateOfBirth: DateTime(2004, 8, 26),
        birthTimeHour: 8,
        birthTimeMinute: 4,
        cityName: 'Ankleshwar',
        latitude: 21.6264,
        longitude: 73.0033,
        timezone: 5.5,
        createdAt: DateTime.now(),
      );

      final kundali = KundaliCalculator.calculateVedicKundali(profile);
      expect(kundali.profile.name, 'Bhargav Modi');

      final file = await KundaliPdfService.instance.generateAndSaveKundaliPdf(
        kundali: kundali,
        isGujarati: true,
        customTargetDir: Directory.systemTemp,
      );

      expect(await file.exists(), true);
      expect(file.path.endsWith('.pdf'), true);
      expect(file.lengthSync() > 1000, true); // Valid PDF with substantial content

      final bytes = await KundaliPdfService.instance.generateKundaliPdfBytes(
        kundali: kundali,
        isGujarati: true,
      );
      expect(bytes.isNotEmpty, true);
      expect(bytes.lengthInBytes > 1000, true);

      // Cleanup test file
      try {
        if (file.existsSync()) {
          await file.delete();
        }
      } catch (_) {}
    });
  });
}
