import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused }

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();

  TtsState _state = TtsState.stopped;
  TtsState get state => _state;
  bool get isPlaying => _state == TtsState.playing;

  double _speechRate = 0.40; // Dignified, serene chanting tempo
  double get speechRate => _speechRate;

  double _pitch = 0.78; // Deep, resonant authentic male baritone tone
  double get pitch => _pitch;

  String _currentLanguage = 'hi-IN';
  String get currentLanguage => _currentLanguage;

  Map<String, String>? _selectedHindiMaleVoice;
  Map<String, String>? _selectedGujaratiMaleVoice;
  Map<String, String>? _selectedEnglishMaleVoice;

  bool _isStopping = false;

  VoidCallback? onCompletion;
  Function(TtsState)? onStateChanged;

  Future<void> init({double initialRate = 0.40}) async {
    _speechRate = initialRate;
    try {
      if (!kIsWeb && defaultTargetPlatform == TargetPlatform.iOS) {
        await _flutterTts.setIosAudioCategory(
          IosTextToSpeechAudioCategory.playback,
          [
            IosTextToSpeechAudioCategoryOptions.defaultToSpeaker,
            IosTextToSpeechAudioCategoryOptions.allowBluetooth,
            IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
          ],
        );
      }

      _flutterTts.setStartHandler(() {
        _state = TtsState.playing;
        onStateChanged?.call(_state);
      });

      _flutterTts.setCompletionHandler(() {
        final wasPlaying = _state == TtsState.playing;
        _state = TtsState.stopped;
        onStateChanged?.call(_state);
        // Only trigger completion callback if speech finished naturally without manual stop
        if (wasPlaying && !_isStopping) {
          onCompletion?.call();
        }
      });

      _flutterTts.setCancelHandler(() {
        _state = TtsState.stopped;
        onStateChanged?.call(_state);
      });

      _flutterTts.setPauseHandler(() {
        _state = TtsState.paused;
        onStateChanged?.call(_state);
      });

      _flutterTts.setContinueHandler(() {
        _state = TtsState.playing;
        onStateChanged?.call(_state);
      });

      _flutterTts.setErrorHandler((msg) {
        _state = TtsState.stopped;
        onStateChanged?.call(_state);
        debugPrint('TTS Error: $msg');
      });

      // Discover and lock authentic male voices during initialization
      await _configureMaleVoices();

      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(_pitch);
      await _flutterTts.setSpeechRate(_speechRate);
      await _flutterTts.setLanguage(_currentLanguage);
    } catch (e) {
      debugPrint('TTS init warning: $e');
    }
  }

  Future<void> _configureMaleVoices() async {
    try {
      final voices = await _flutterTts.getVoices;
      if (voices is List) {
        for (final v in voices) {
          if (v is Map) {
            final name = v['name']?.toString().toLowerCase() ?? '';
            final locale = v['locale']?.toString() ?? '';

            // 1. Hindi Male Voice (Rishi, Neel, -local male, Google hi-in)
            if (locale.toLowerCase().startsWith('hi')) {
              if (name.contains('rishi') ||
                  name.contains('neel') ||
                  name.contains('male') ||
                  name.contains('hie') ||
                  name.contains('hid') ||
                  name.contains('hia') ||
                  name.contains('guy')) {
                _selectedHindiMaleVoice = {
                  'name': v['name'].toString(),
                  'locale': locale,
                };
              } else {
                _selectedHindiMaleVoice ??= {
                  'name': v['name'].toString(),
                  'locale': locale,
                };
              }
            }

            // 2. Gujarati Voice (gu-IN)
            if (locale.toLowerCase().startsWith('gu')) {
              _selectedGujaratiMaleVoice = {
                'name': v['name'].toString(),
                'locale': locale,
              };
            }

            // 3. English Male Voice (Rishi, Aaron, Daniel, David, George, Oliver)
            if (locale.toLowerCase().startsWith('en')) {
              if (name.contains('rishi') ||
                  name.contains('neel') ||
                  name.contains('aaron') ||
                  name.contains('daniel') ||
                  name.contains('david') ||
                  name.contains('george') ||
                  name.contains('oliver') ||
                  name.contains('male') ||
                  name.contains('guy')) {
                _selectedEnglishMaleVoice = {
                  'name': v['name'].toString(),
                  'locale': locale,
                };
              } else {
                _selectedEnglishMaleVoice ??= {
                  'name': v['name'].toString(),
                  'locale': locale,
                };
              }
            }
          }
        }
      }

      // Apply initial Hindi male voice if available
      if (_selectedHindiMaleVoice != null) {
        await _flutterTts.setVoice(_selectedHindiMaleVoice!);
      }
    } catch (e) {
      debugPrint('Error finding male voices: $e');
    }
  }

  Future<void> speak(String text, {String? language}) async {
    final cleanText = cleanTextForSpeech(text);
    if (cleanText.isEmpty) return;

    try {
      // 1. Stop previous utterance without triggering premature auto-advance callback
      _isStopping = true;
      await _flutterTts.stop();
      _isStopping = false;

      // 2. Detect language: Gujarati -> gu-IN, Devanagari -> hi-IN, English / Latin -> en-IN
      final hasGujarati = RegExp(r'[\u0A80-\u0AFF]').hasMatch(cleanText);
      final hasDevanagari = RegExp(r'[\u0900-\u097F]').hasMatch(cleanText);

      String targetLang;
      if (language != null) {
        targetLang = language;
      } else if (hasGujarati) {
        targetLang = 'gu-IN';
      } else if (hasDevanagari) {
        targetLang = 'hi-IN';
      } else {
        targetLang = 'en-IN';
      }

      if (_currentLanguage != targetLang) {
        _currentLanguage = targetLang;
        await _flutterTts.setLanguage(targetLang);
      }

      // 3. Set male / regional voice if available
      Map<String, String>? voice;
      if (targetLang.startsWith('gu')) {
        voice = _selectedGujaratiMaleVoice ?? _selectedHindiMaleVoice;
      } else if (targetLang.startsWith('hi') || hasDevanagari) {
        voice = _selectedHindiMaleVoice;
      } else {
        voice = _selectedEnglishMaleVoice;
      }

      if (voice != null) {
        await _flutterTts.setVoice(voice);
      }

      // 4. Set deep male pitch and tranquil chanting pace
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(_pitch);
      await _flutterTts.setSpeechRate(_speechRate);

      _state = TtsState.playing;
      onStateChanged?.call(_state);

      // 5. Speak the entire utterance
      await _flutterTts.speak(cleanText);
    } catch (e) {
      debugPrint('TTS speak error: $e');
      _state = TtsState.stopped;
      onStateChanged?.call(_state);
    }
  }

  /// Cleans and formats Sanskrit / Hindi / Gujarati text for proper pronunciation and pacing
  static String cleanTextForSpeech(String text) {
    var cleaned = text.trim();

    // 1. Remove bracketed verse numbers only e.g. ॥ १-२ ॥, || 1.1 ||, [1.2], (1), ॥ ૧-૨ ॥
    cleaned = cleaned.replaceAll(RegExp(r'[॥।]\s*[\d०-९૦-૯\.\-\s]+[॥।]'), ' . ');
    cleaned = cleaned.replaceAll(RegExp(r'\|\|\s*[\d०-९૦-૯\.\-\s]+\|\|'), ' . ');
    cleaned = cleaned.replaceAll(RegExp(r'\[\s*[\d०-९૦-૯\.\-\s]+\s*\]'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\(\s*[\d०-९૦-૯\.\-\s]+\s*\)'), '');

    // 2. Replace traditional Danda punctuation with natural breathing pauses
    cleaned = cleaned.replaceAll('॥', ' . ');
    cleaned = cleaned.replaceAll('।', ' , ');
    cleaned = cleaned.replaceAll('||', ' . ');
    cleaned = cleaned.replaceAll('|', ' , ');

    // 3. Clean up Sanskrit Avagraha (ऽ) so it sustains the vowel naturally
    cleaned = cleaned.replaceAll('ऽ', ' ');

    // 4. Normalize multiple whitespaces and newlines
    cleaned = cleaned.replaceAll(RegExp(r'\s+'), ' ').trim();

    return cleaned;
  }

  Future<void> pause() async {
    try {
      await _flutterTts.pause();
      _state = TtsState.paused;
      onStateChanged?.call(_state);
    } catch (e) {
      debugPrint('TTS pause error: $e');
    }
  }

  Future<void> stop() async {
    try {
      _isStopping = true;
      await _flutterTts.stop();
      _state = TtsState.stopped;
      onStateChanged?.call(_state);
      _isStopping = false;
    } catch (e) {
      debugPrint('TTS stop error: $e');
    }
  }

  Future<void> setRate(double rate) async {
    _speechRate = rate;
    try {
      await _flutterTts.setSpeechRate(rate);
    } catch (e) {
      debugPrint('TTS setRate error: $e');
    }
  }

  Future<void> setPitch(double pitch) async {
    _pitch = pitch;
    try {
      await _flutterTts.setPitch(pitch);
    } catch (e) {
      debugPrint('TTS setPitch error: $e');
    }
  }

  Future<void> setLanguage(String lang) async {
    _currentLanguage = lang;
    try {
      await _flutterTts.setLanguage(lang);
      final voice = lang.startsWith('gu')
          ? (_selectedGujaratiMaleVoice ?? _selectedHindiMaleVoice)
          : (lang.startsWith('hi') ? _selectedHindiMaleVoice : _selectedEnglishMaleVoice);
      if (voice != null) {
        await _flutterTts.setVoice(voice);
      }
    } catch (e) {
      debugPrint('TTS setLanguage error: $e');
    }
  }

  void dispose() {
    _flutterTts.stop();
  }
}
