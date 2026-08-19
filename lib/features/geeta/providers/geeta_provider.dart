import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/chapter_metadata.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/tts_service.dart';
import '../models/chapter_model.dart';
import '../models/verse_model.dart';
import '../repositories/geeta_repository.dart';

enum GeetaViewMode { list, swipe }

class GeetaProvider extends ChangeNotifier {
  final GeetaRepository _repository;
  final StorageService _storageService;
  final TtsService _ttsService;

  GeetaProvider({
    required GeetaRepository repository,
    required StorageService storageService,
    required TtsService ttsService,
  })  : _repository = repository,
        _storageService = storageService,
        _ttsService = ttsService {
    _init();
  }

  List<ChapterModel> _chapters = [];
  List<ChapterModel> get chapters => _chapters;

  bool _isLoadingChapters = false;
  bool get isLoadingChapters => _isLoadingChapters;

  int _currentChapter = 1;
  int get currentChapter => _currentChapter;

  int _currentVerse = 1;
  int get currentVerse => _currentVerse;

  VerseModel? _currentVerseModel;
  VerseModel? get currentVerseModel => _currentVerseModel;

  bool _isLoadingVerse = false;
  bool get isLoadingVerse => _isLoadingVerse;

  String? _verseError;
  String? get verseError => _verseError;

  String _preferredCommentator = 'tej';
  String get preferredCommentator => _preferredCommentator;

  GeetaViewMode _viewMode = GeetaViewMode.list;
  GeetaViewMode get viewMode => _viewMode;

  double _fontScale = 1.0;
  double get fontScale => _fontScale;

  bool _autoAdvance = false;
  bool get autoAdvance => _autoAdvance;

  List<String> _bookmarks = [];
  List<String> get bookmarks => _bookmarks;

  TtsState get ttsState => _ttsService.state;
  bool get isTtsPlaying => _ttsService.isPlaying;
  double get ttsSpeed => _ttsService.speechRate;
  String get ttsLanguage => _ttsService.currentLanguage;

  void _init() {
    _chapters = _repository.getStaticChapters();
    _currentChapter = _storageService.getLastChapter();
    _currentVerse = _storageService.getLastVerse();
    _preferredCommentator = _storageService.getPreferredCommentator();
    _fontScale = _storageService.getFontScale();
    _autoAdvance = _storageService.getTtsAutoAdvance();
    _bookmarks = _storageService.getBookmarks();

    _ttsService.onStateChanged = (_) => notifyListeners();
    _ttsService.onCompletion = _handleTtsCompletion;

    loadChapters();
  }

  Future<void> loadChapters() async {
    _isLoadingChapters = true;
    notifyListeners();
    try {
      _chapters = await _repository.getChapters();
    } catch (_) {
      _chapters = _repository.getStaticChapters();
    } finally {
      _isLoadingChapters = false;
      notifyListeners();
    }
  }

  Future<void> selectVerse(int chapter, int verse) async {
    await _ttsService.stop();
    _currentChapter = chapter;
    _currentVerse = verse;
    _verseError = null;
    _isLoadingVerse = true;
    notifyListeners();

    _storageService.saveLastRead(chapter, verse);

    try {
      _currentVerseModel = await _repository.getVerse(chapter, verse);
      _verseError = null;
    } catch (e) {
      _verseError = e.toString();
      _currentVerseModel = null;
    } finally {
      _isLoadingVerse = false;
      notifyListeners();
    }
  }

  Future<VerseModel?> fetchVerseData(int chapter, int verse) async {
    try {
      return await _repository.getVerse(chapter, verse);
    } catch (_) {
      return null;
    }
  }

  void nextVerse() {
    final maxVerses = ChapterMetadata.getVerseCount(_currentChapter);
    if (_currentVerse < maxVerses) {
      selectVerse(_currentChapter, _currentVerse + 1);
    } else if (_currentChapter < 18) {
      selectVerse(_currentChapter + 1, 1);
    }
  }

  void previousVerse() {
    if (_currentVerse > 1) {
      selectVerse(_currentChapter, _currentVerse - 1);
    } else if (_currentChapter > 1) {
      final prevChapter = _currentChapter - 1;
      final prevMax = ChapterMetadata.getVerseCount(prevChapter);
      selectVerse(prevChapter, prevMax);
    }
  }

  void setPreferredCommentator(String commentatorKey) {
    _preferredCommentator = commentatorKey;
    _storageService.setPreferredCommentator(commentatorKey);
    notifyListeners();
  }

  void setViewMode(GeetaViewMode mode) {
    _viewMode = mode;
    notifyListeners();
  }

  void setFontScale(double scale) {
    _fontScale = scale.clamp(0.8, 1.6);
    _storageService.setFontScale(_fontScale);
    notifyListeners();
  }

  void toggleBookmark(int chapter, int verse) {
    final id = '${chapter}_$verse';
    if (_bookmarks.contains(id)) {
      _bookmarks.remove(id);
    } else {
      _bookmarks.add(id);
    }
    _storageService.toggleBookmark(chapter, verse);
    notifyListeners();
  }

  bool isVerseBookmarked(int chapter, int verse) {
    return _bookmarks.contains('${chapter}_$verse');
  }

  // --- TTS Controls ---
  bool _speakTranslation = false;
  bool get speakTranslation => _speakTranslation;

  void setSpeakTranslation(bool value) {
    _speakTranslation = value;
    if (isTtsPlaying) {
      playCurrentVerseSpeech(speakTranslation: value);
    } else {
      notifyListeners();
    }
  }

  Future<void> playCurrentVerseSpeech({bool? speakTranslation}) async {
    if (_currentVerseModel == null) return;
    final shouldSpeakTranslation = speakTranslation ?? _speakTranslation;
    _speakTranslation = shouldSpeakTranslation;

    if (shouldSpeakTranslation) {
      final translationText = _currentVerseModel!.getDisplayTranslation(
        preferredCommentatorKey: _preferredCommentator,
      );
      if (translationText.isNotEmpty) {
        await _ttsService.speak(translationText);
      }
    } else {
      // Speak Sanskrit Slok
      await _ttsService.speak(_currentVerseModel!.slok);
    }
    notifyListeners();
  }

  Timer? _autoAdvanceTimer;

  Future<void> pauseSpeech() async {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;
    await _ttsService.pause();
    notifyListeners();
  }

  Future<void> stopSpeech() async {
    _autoAdvanceTimer?.cancel();
    _autoAdvanceTimer = null;
    await _ttsService.stop();
    notifyListeners();
  }

  Future<void> setTtsSpeed(double speed) async {
    await _ttsService.setRate(speed);
    await _storageService.setTtsSpeed(speed);
    notifyListeners();
  }

  Future<void> setTtsLanguage(String lang) async {
    await _ttsService.setLanguage(lang);
    notifyListeners();
  }

  void toggleAutoAdvance(bool value) {
    _autoAdvance = value;
    if (!value) {
      _autoAdvanceTimer?.cancel();
      _autoAdvanceTimer = null;
    }
    _storageService.setTtsAutoAdvance(value);
    notifyListeners();
  }

  void _handleTtsCompletion() {
    _autoAdvanceTimer?.cancel();
    if (_autoAdvance && _ttsService.state == TtsState.stopped) {
      final maxVerses = ChapterMetadata.getVerseCount(_currentChapter);
      if (_currentVerse < maxVerses) {
        // Natural 1.5s contemplation pause before advancing
        _autoAdvanceTimer = Timer(const Duration(milliseconds: 1500), () {
          if (_autoAdvance && _ttsService.state == TtsState.stopped) {
            nextVerse();
            _autoAdvanceTimer = Timer(const Duration(milliseconds: 600), () {
              if (_autoAdvance) {
                playCurrentVerseSpeech(speakTranslation: _speakTranslation);
              }
            });
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _ttsService.stop();
    super.dispose();
  }
}
