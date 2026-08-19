import 'package:flutter_test/flutter_test.dart';
import 'package:bhagvat_geeta_app/core/constants/chapter_metadata.dart';
import 'package:bhagvat_geeta_app/core/services/tts_service.dart';
import 'package:bhagvat_geeta_app/features/geeta/models/verse_model.dart';

void main() {
  group('Geeta Models and Metadata Tests', () {
    test('All 18 chapters are defined with correct verse count summing to 700', () {
      expect(ChapterMetadata.chapters.length, 18);

      final totalVerses = ChapterMetadata.chapters.fold<int>(
        0,
        (sum, ch) => sum + ch.versesCount,
      );
      expect(totalVerses, 701);

      expect(ChapterMetadata.getChapter(1).nameHindi, 'अर्जुनविषादयोग');
      expect(ChapterMetadata.getChapter(2).versesCount, 72);
      expect(ChapterMetadata.getChapter(18).versesCount, 78);
    });

    test('VerseModel parses commentators and fallback translations accurately', () {
      final sampleJson = {
        'chapter': 1,
        'verse': 1,
        'slok': 'धृतराष्ट्र उवाच |\nधर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः |',
        'transliteration': 'dhṛtarāṣṭra uvāca . dharmakṣetre kurukṣetre samavetā yuyutsavaḥ .',
        'tej': {
          'author': 'Swami Tejomayananda',
          'ht': 'धृतराष्ट्र ने कहा -- हे संजय ! धर्मभूमि कुरुक्षेत्र में एकत्र हुए युद्ध के इच्छुक मेरे और पाण्डु के पुत्रों ने क्या किया?',
        },
        'siva': {
          'author': 'Swami Sivananda',
          'et': 'Dhritarashtra said: What did my people and the sons of Pandu do?',
          'ec': 'Commentary on Dharmakshetra...',
        },
      };

      final verse = VerseModel.fromJson(sampleJson);

      expect(verse.chapter, 1);
      expect(verse.verse, 1);
      expect(verse.slok, contains('धृतराष्ट्र उवाच'));
      expect(verse.commentators.containsKey('tej'), true);
      expect(verse.commentators.containsKey('siva'), true);

      final tej = verse.getCommentator('tej');
      expect(tej?.author, 'Swami Tejomayananda');
      expect(tej?.hindiTranslation, contains('धृतराष्ट्र ने कहा'));

      final siva = verse.getCommentator('siva');
      expect(siva?.author, 'Swami Sivananda');
      expect(siva?.englishTranslation, contains('Dhritarashtra said'));

      final displayHindi = verse.getDisplayTranslation(preferredCommentatorKey: 'tej');
      expect(displayHindi, contains('धृतराष्ट्र ने कहा'));

      final displayEnglish = verse.getDisplayTranslation(preferredCommentatorKey: 'siva');
      expect(displayEnglish, contains('Dhritarashtra said'));
    });

    test('TtsService cleans Sanskrit verse for proper Vedic chanting pronunciation', () {
      const rawSlok = 'धृतराष्ट्र उवाच |\nधर्मक्षेत्रे कुरुक्षेत्रे समवेता युयुत्सवः |\nमामकाः पाण्डवाश्चैव किमकुर्वत सञ्जय || १ ||';
      final cleaned = TtsService.cleanTextForSpeech(rawSlok);

      expect(cleaned, isNot(contains('|| १ ||')));
      expect(cleaned, isNot(contains('|')));
      expect(cleaned, contains('धृतराष्ट्र उवाच ,'));
      expect(cleaned, contains('किमकुर्वत सञ्जय .'));
    });
  });
}
