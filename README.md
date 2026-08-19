# श्रीमद्भगवद्गीता • પંચાંગ • રાશિ ભવિષ્ય (Bhagavad Geeta, Panchang & Rashi App)

A read-only, spiritual, premium Flutter application offering the complete **Bhagavad Gita** (with Sanskrit verses, Gujarati & Hindi translations, multiple commentators, transliterations, and Text-to-Speech audio), **Daily Vedic Panchang** (with Tithi, Nakshatra, Yoga, Karana, Choghadiya, Baby Born Rashi, and Auspicious/Inauspicious Muhurtas), and **Rashi Bhavishya** (Daily Vedic Horoscope & astrological wisdom across 12 Rashis in Hindi & Gujarati).

```
[ પંચાંગ (Panchang) ]     [ ॐ શ્રીમદ્ભગવદ્ગીતા (Center / Home) ]     [ રાશિ ભવિષ્ય (Rashi) ]
```

---

## 🌟 Key Features

### 1. ॐ Bhagavad Geeta (Center Home Tab)
- **All 18 Chapters**: Full chapter metadata with Sanskrit names, Gujarati & Hindi titles, verse counts, and summaries.
- **Verse-by-Verse & Scroll Modes**: Toggle between scrollable list and swipeable PageView.
- **Sanskrit Shlokas & Sacred Typography**: High-legibility Devanagari & Gujarati typography (`GoogleFonts.notoSerifDevanagari`, `GoogleFonts.notoSerifGujarati`) with customizable text scaling.
- **20+ Renowned Commentators**: Switch between Swami Tejomayananda, Swami Sivananda, Swami Chinmayananda, A.C. Bhaktivedanta Swami Prabhupada, Shri Purohit Swami, Swami Gambirananda, Swami Ramsukhdas, Sri Shankaracharya, Sri Ramanujacharya, and more.
- **Text-to-Speech (TTS)**: Clean male Vedic voice chanting for Sanskrit shlokas and natural narration for Hindi & Gujarati translations with speed control (0.2x – 0.9x) and auto-advance.
- **Saved Slokas (Bookmarks)**: Persist favorite verses locally.
- **Quick Jump & Search**: Instant chapter:verse navigator and keyword filter.

### 2. ☀️ Daily Vedic Panchang (Left Tab)
- **Complete Panchang Calculation**: Tithi, Paksha, Nakshatra, Yoga, Karana, and Vaar in Hindi and Gujarati.
- **Day & Night Choghadiya**: 8 Day and 8 Night Choghadiyas with live active indicator (`અમૃત`, `શુભ`, `લાભ`, `ચર`, `કાળ`, `રોગ`, `ઉદ્વેગ`).
- **Baby Born Rashi & Namakshar Floating Feature**: Dynamic Vedic moon sign, nakshatra, charan, auspicious naming letters, and astrology traits for any birth time.
- **Sun & Moon Tracker**: Sunrise, Sunset, Moonrise, and Moonset timings.
- **Auspicious & Inauspicious Timings**: Abhijit Muhurta, Brahma Muhurta, Rahu Kaal, Yamaganda, Gulikai Kaal.
- **Vedic Calendar Attributes**: Vikram Samvat, Shaka Samvat, Ritu (Season), Ayana, and Lunar Month.
- **City Selector & GPS**: Search 45+ sacred pilgrimage and metro cities or auto-detect exact GPS location.

### 3. ♈ Rashi Bhavishya (Right Tab)
- **12 Vedic Rashis**: Mesha (Aries), Vrishabha (Taurus), Mithuna (Gemini), Karka (Cancer), Simha (Leo), Kanya (Virgo), Tula (Libra), Vrischika (Scorpio), Dhanu (Sagittarius), Makara (Capricorn), Kumbha (Aquarius), Meena (Pisces).
- **Interactive Wheel & Grid**: Circular zodiac selector ring and grid views.
- **"My Rashi" Pinning**: Set your default Rashi to open instantly upon launch.
- **Daily Wisdom & Traits**: Astrological outlook, lucky numbers, lucky colors, elements, ruling planets, compatible signs, and ruling deity mantras.
- **Date-Based Cache**: Readings are cached locally so network requests happen at most once per day.

---

## 🌐 Dual Language Support (હિન્દી / ગુજરાતી)
- Quick-toggle language switch (`[ हिं | ગુજ ]`) accessible in the top AppBar across all screens.
- Complete dynamic localization across Geeta translations, Panchang attributes, Choghadiyas, Baby Rashi, and Settings.

---

## 🏗️ Architecture & State Management

- **Provider Architecture**: Clean separation with `ChangeNotifier` (`GeetaProvider`, `PanchangProvider`, `RashiProvider`, `LanguageProvider`, `ThemeProvider`).
- **Network Layer**: Centralized `ApiClient` with Dio, logging, and error handling.
- **Persistence**:
  - `Hive` for heavy structured data (verses, daily panchang, horoscope readings).
  - `SharedPreferences` for settings (language, bookmarks, last read, font scale, theme mode, pinned rashi, TTS rate).
- **Offline First**: Graceful network error handling, offline banners, and cached data serving.

---

## 🚀 Running the App

```bash
# 1. Install dependencies
flutter pub get

# 2. Run analysis
flutter analyze

# 3. Run unit and widget tests
flutter test

# 4. Run the app on connected device or simulator
flutter run
```
