import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../../core/config/api_config.dart';
import '../../../core/constants/chapter_metadata.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/api_exceptions.dart';
import '../../../core/services/storage_service.dart';
import '../models/chapter_model.dart';
import '../models/verse_model.dart';

class GeetaRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  GeetaRepository({
    required ApiClient apiClient,
    required StorageService storageService,
  })  : _apiClient = apiClient,
        _storageService = storageService;

  List<ChapterModel> getStaticChapters() {
    return ChapterMetadata.chapters.map((c) {
      return ChapterModel(
        chapterNumber: c.chapterNumber,
        versesCount: c.versesCount,
        name: c.nameHindi,
        translation: c.nameEnglish,
        transliteration: c.transliteration,
        meaningEn: c.meaningEnglish,
        meaningHi: c.meaningHindi,
        summaryEn: c.summaryEnglish,
        summaryHi: c.summaryHindi,
      );
    }).toList();
  }

  Future<List<ChapterModel>> getChapters() async {
    // Return static bundle immediately to ensure 0ms latency
    try {
      final response = await _apiClient.get(
        '${ApiConfig.geetaBaseUrl}/chapters',
        options: Options(responseType: ResponseType.plain),
      );

      final dynamic data = response.data is String ? jsonDecode(response.data as String) : response.data;
      if (data is List) {
        return data.map((json) => ChapterModel.fromJson(json as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      debugPrint('GeetaRepository: Using static chapters fallback ($e)');
    }
    return getStaticChapters();
  }

  Future<VerseModel> getVerse(int chapter, int verse) async {
    // 1. Check local Hive cache
    final cachedData = _storageService.getCachedVerse(chapter, verse);
    if (cachedData != null) {
      return VerseModel.fromJson(cachedData);
    }

    // 2. Fetch from API
    try {
      final url = '${ApiConfig.geetaBaseUrl}/slok/$chapter/$verse';
      final response = await _apiClient.get(
        url,
        options: Options(
          responseType: ResponseType.plain,
          followRedirects: true,
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      final dynamic raw = response.data is String ? jsonDecode(response.data as String) : response.data;
      if (raw is Map<String, dynamic>) {
        // Save to Hive cache
        await _storageService.cacheVerse(chapter, verse, raw);
        return VerseModel.fromJson(raw);
      } else {
        throw ApiException(message: 'Invalid verse data format');
      }
    } catch (e) {
      // If we have cache, fallback to it
      if (cachedData != null) {
        return VerseModel.fromJson(cachedData);
      }
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Failed to load verse $chapter.$verse: $e', originalError: e);
    }
  }

  Future<void> preloadChapter(int chapter, int count) async {
    for (int v = 1; v <= count; v++) {
      if (_storageService.getCachedVerse(chapter, v) == null) {
        try {
          await getVerse(chapter, v);
          await Future.delayed(const Duration(milliseconds: 100));
        } catch (_) {}
      }
    }
  }
}
