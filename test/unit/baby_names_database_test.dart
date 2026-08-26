import 'package:flutter_test/flutter_test.dart';
import 'package:bhagvat_geeta_app/features/panchang/data/baby_names_database.dart';

void main() {
  group('Baby Names Database Tests', () {
    test('Database contains comprehensive names for all 12 Rashis for both Boys and Girls', () {
      final allNames = BabyNamesDatabase.getAllNames();
      expect(allNames.isNotEmpty, isTrue);

      for (int i = 0; i < 12; i++) {
        final boyNames = BabyNamesDatabase.getNamesForRashi(rashiIndex: i, isBoy: true);
        final girlNames = BabyNamesDatabase.getNamesForRashi(rashiIndex: i, isBoy: false);

        expect(boyNames.isNotEmpty, isTrue, reason: 'Rashi $i should have boy names');
        expect(girlNames.isNotEmpty, isTrue, reason: 'Rashi $i should have girl names');

        for (final b in boyNames) {
          expect(b.gujarati.isNotEmpty, isTrue);
          expect(b.hindi.isNotEmpty, isTrue);
          expect(b.english.isNotEmpty, isTrue);
          expect(b.meaningGu.isNotEmpty, isTrue);
        }
        for (final g in girlNames) {
          expect(g.gujarati.isNotEmpty, isTrue);
          expect(g.hindi.isNotEmpty, isTrue);
          expect(g.english.isNotEmpty, isTrue);
          expect(g.meaningGu.isNotEmpty, isTrue);
        }
      }
    });

    test('Searches and filters baby names accurately by query and starting letter', () {
      final filtered = BabyNamesDatabase.getNamesForRashi(
        rashiIndex: 9, // Makara
        isBoy: true,
        searchQuery: 'Khyat',
      );
      expect(filtered.any((n) => n.english == 'Khyat'), isTrue);

      final girlFiltered = BabyNamesDatabase.getNamesForRashi(
        rashiIndex: 9, // Makara
        isBoy: false,
        searchQuery: 'Jaanvi',
      );
      expect(girlFiltered.any((n) => n.english == 'Jaanvi'), isTrue);
    });
  });
}
