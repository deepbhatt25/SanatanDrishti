class ChapterModel {
  final int chapterNumber;
  final int versesCount;
  final String name;
  final String translation;
  final String transliteration;
  final String meaningEn;
  final String meaningHi;
  final String summaryEn;
  final String summaryHi;

  const ChapterModel({
    required this.chapterNumber,
    required this.versesCount,
    required this.name,
    required this.translation,
    required this.transliteration,
    required this.meaningEn,
    required this.meaningHi,
    required this.summaryEn,
    required this.summaryHi,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    final meaning = json['meaning'] as Map<String, dynamic>? ?? {};
    final summary = json['summary'] as Map<String, dynamic>? ?? {};

    return ChapterModel(
      chapterNumber: json['chapter_number'] is int
          ? json['chapter_number']
          : int.tryParse(json['chapter_number']?.toString() ?? '1') ?? 1,
      versesCount: json['verses_count'] is int
          ? json['verses_count']
          : int.tryParse(json['verses_count']?.toString() ?? '0') ?? 0,
      name: json['name']?.toString() ?? '',
      translation: json['translation']?.toString() ?? '',
      transliteration: json['transliteration']?.toString() ?? '',
      meaningEn: meaning['en']?.toString() ?? '',
      meaningHi: meaning['hi']?.toString() ?? '',
      summaryEn: summary['en']?.toString() ?? '',
      summaryHi: summary['hi']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'chapter_number': chapterNumber,
      'verses_count': versesCount,
      'name': name,
      'translation': translation,
      'transliteration': transliteration,
      'meaning': {
        'en': meaningEn,
        'hi': meaningHi,
      },
      'summary': {
        'en': summaryEn,
        'hi': summaryHi,
      },
    };
  }
}
