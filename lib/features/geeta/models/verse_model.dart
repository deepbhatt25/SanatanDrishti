import '../../../core/providers/language_provider.dart';

class CommentatorItem {
  final String key;
  final String author;
  final String? englishTranslation;
  final String? englishCommentary;
  final String? hindiTranslation;
  final String? hindiCommentary;
  final String? sanskritCommentary;

  const CommentatorItem({
    required this.key,
    required this.author,
    this.englishTranslation,
    this.englishCommentary,
    this.hindiTranslation,
    this.hindiCommentary,
    this.sanskritCommentary,
  });

  factory CommentatorItem.fromJson(String key, Map<String, dynamic> json) {
    return CommentatorItem(
      key: key,
      author: json['author']?.toString() ?? key,
      englishTranslation: json['et']?.toString(),
      englishCommentary: json['ec']?.toString(),
      hindiTranslation: json['ht']?.toString(),
      hindiCommentary: json['hc']?.toString(),
      sanskritCommentary: json['sc']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'author': author,
      if (englishTranslation != null) 'et': englishTranslation,
      if (englishCommentary != null) 'ec': englishCommentary,
      if (hindiTranslation != null) 'ht': hindiTranslation,
      if (hindiCommentary != null) 'hc': hindiCommentary,
      if (sanskritCommentary != null) 'sc': sanskritCommentary,
    };
  }

  bool get hasHindi => (hindiTranslation != null && hindiTranslation!.isNotEmpty) ||
      (hindiCommentary != null && hindiCommentary!.isNotEmpty);

  bool get hasEnglish => (englishTranslation != null && englishTranslation!.isNotEmpty) ||
      (englishCommentary != null && englishCommentary!.isNotEmpty);
}

class VerseModel {
  final int chapter;
  final int verse;
  final String slok;
  final String transliteration;
  final Map<String, CommentatorItem> commentators;

  const VerseModel({
    required this.chapter,
    required this.verse,
    required this.slok,
    required this.transliteration,
    required this.commentators,
  });

  factory VerseModel.fromJson(Map<String, dynamic> json) {
    final chapterNum = json['chapter'] is int
        ? json['chapter']
        : int.tryParse(json['chapter']?.toString() ?? '1') ?? 1;

    final verseNum = json['verse'] is int
        ? json['verse']
        : int.tryParse(json['verse']?.toString() ?? '1') ?? 1;

    final Map<String, CommentatorItem> commentatorMap = {};

    json.forEach((k, v) {
      if (v is Map<String, dynamic> && (v.containsKey('author') || v.containsKey('et') || v.containsKey('ht'))) {
        commentatorMap[k] = CommentatorItem.fromJson(k, v);
      }
    });

    return VerseModel(
      chapter: chapterNum,
      verse: verseNum,
      slok: json['slok']?.toString() ?? '',
      transliteration: json['transliteration']?.toString() ?? '',
      commentators: commentatorMap,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> map = {
      'chapter': chapter,
      'verse': verse,
      'slok': slok,
      'transliteration': transliteration,
    };
    commentators.forEach((k, v) {
      map[k] = v.toJson();
    });
    return map;
  }

  CommentatorItem? getCommentator(String key) {
    if (commentators.containsKey(key)) return commentators[key];
    // Fallbacks in priority order
    final preferredOrder = ['tej', 'siva', 'chinmay', 'prabhu', 'purohit', 'gambir', 'rams', 'adi', 'sankar'];
    for (final pref in preferredOrder) {
      if (commentators.containsKey(pref)) return commentators[pref];
    }
    return commentators.values.isNotEmpty ? commentators.values.first : null;
  }

  String getDisplayTranslation({String? preferredCommentatorKey}) {
    final comm = getCommentator(preferredCommentatorKey ?? 'tej');
    if (comm != null) {
      if (comm.hindiTranslation != null && comm.hindiTranslation!.trim().isNotEmpty) {
        return comm.hindiTranslation!.trim();
      }
      if (comm.englishTranslation != null && comm.englishTranslation!.trim().isNotEmpty) {
        return comm.englishTranslation!.trim();
      }
      if (comm.hindiCommentary != null && comm.hindiCommentary!.trim().isNotEmpty) {
        return comm.hindiCommentary!.trim();
      }
      if (comm.englishCommentary != null && comm.englishCommentary!.trim().isNotEmpty) {
        return comm.englishCommentary!.trim();
      }
    }

    // Try any other commentator with non-empty translation
    for (final other in commentators.values) {
      if (other.hindiTranslation != null && other.hindiTranslation!.trim().isNotEmpty) {
        return other.hindiTranslation!.trim();
      }
      if (other.englishTranslation != null && other.englishTranslation!.trim().isNotEmpty) {
        return other.englishTranslation!.trim();
      }
      if (other.hindiCommentary != null && other.hindiCommentary!.trim().isNotEmpty) {
        return other.hindiCommentary!.trim();
      }
      if (other.englishCommentary != null && other.englishCommentary!.trim().isNotEmpty) {
        return other.englishCommentary!.trim();
      }
    }

    // Ultimate fallback to transliteration
    return transliteration.trim();
  }

  /// Returns translation localized for the active app language (translating Devanagari text into Gujarati script)
  String getDisplayTranslationForLanguage(AppLanguage language, {String? preferredCommentatorKey}) {
    final rawText = getDisplayTranslation(preferredCommentatorKey: preferredCommentatorKey);
    if (language == AppLanguage.gujarati) {
      return convertToGujaratiScript(rawText);
    }
    return rawText;
  }

  static String convertToGujaratiScript(String text) {
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final codeUnit = text.codeUnitAt(i);
      // Devanagari range: 0x0901 to 0x097F
      if (codeUnit >= 0x0901 && codeUnit <= 0x097F) {
        final gujCode = codeUnit + 0x0180;
        if ((gujCode >= 0x0A81 && gujCode <= 0x0A83) ||
            (gujCode >= 0x0A85 && gujCode <= 0x0A8D) ||
            (gujCode >= 0x0A8F && gujCode <= 0x0A91) ||
            (gujCode >= 0x0A93 && gujCode <= 0x0AA8) ||
            (gujCode >= 0x0AAA && gujCode <= 0x0AB0) ||
            (gujCode >= 0x0AB2 && gujCode <= 0x0AB3) ||
            (gujCode >= 0x0AB5 && gujCode <= 0x0AB9) ||
            (gujCode >= 0x0ABC && gujCode <= 0x0AC5) ||
            (gujCode >= 0x0AC7 && gujCode <= 0x0AC9) ||
            (gujCode >= 0x0ACB && gujCode <= 0x0ACD) ||
            (gujCode >= 0x0AE0 && gujCode <= 0x0AE3) ||
            (gujCode >= 0x0AE6 && gujCode <= 0x0AEF)) {
          buffer.writeCharCode(gujCode);
        } else {
          buffer.writeCharCode(codeUnit);
        }
      } else {
        buffer.writeCharCode(codeUnit);
      }
    }
    return buffer.toString();
  }
}
