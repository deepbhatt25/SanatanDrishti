import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../../core/config/api_config.dart';
import '../../../core/constants/rashi_data.dart';
import '../../../core/network/api_client.dart';
import '../../../core/services/storage_service.dart';
import '../models/rashi_model.dart';

class RashiRepository {
  final ApiClient _apiClient;
  final StorageService _storageService;

  RashiRepository({
    required ApiClient apiClient,
    required StorageService storageService,
  })  : _apiClient = apiClient,
        _storageService = storageService;

  Future<RashiReadingModel> getRashiReading(RashiInfo rashi, {DateTime? date}) async {
    final targetDate = date ?? DateTime.now();
    final dateKey = DateFormat('yyyy-MM-dd').format(targetDate);
    final formattedDisplayDate = DateFormat('EEEE, MMMM d, yyyy').format(targetDate);

    // 1. Check local Hive cache
    final cached = _storageService.getCachedRashiReading(rashi.zodiacParam, dateKey);
    if (cached != null) {
      return RashiReadingModel.fromJson(cached, isCached: true);
    }

    // 2. Try API Ninjas Horoscope API if key is present
    if (ApiConfig.hasRashiApiKey) {
      try {
        final url = '${ApiConfig.rashiBaseUrl}/horoscope';
        final response = await _apiClient.get(
          url,
          queryParameters: {'zodiac_sign': rashi.zodiacParam},
          options: Options(
            headers: {'X-Api-Key': ApiConfig.apiNinjasKey},
          ),
        );

        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          final horoscopeText = data['horoscope']?.toString() ?? '';

          final generated = _generateVedicHoroscope(rashi, targetDate, formattedDisplayDate);
          final reading = RashiReadingModel(
            date: formattedDisplayDate,
            zodiacSign: rashi.zodiacParam,
            horoscopeText: horoscopeText.isNotEmpty ? horoscopeText : generated.horoscopeText,
            horoscopeTextHindi: generated.horoscopeTextHindi,
            careerOutlook: generated.careerOutlook,
            careerOutlookHindi: generated.careerOutlookHindi,
            loveOutlook: generated.loveOutlook,
            loveOutlookHindi: generated.loveOutlookHindi,
            healthOutlook: generated.healthOutlook,
            healthOutlookHindi: generated.healthOutlookHindi,
            mood: generated.mood,
            compatibility: generated.compatibility,
            luckyTime: generated.luckyTime,
            luckyNumber: generated.luckyNumber,
            luckyColor: generated.luckyColor,
            luckyGemstone: generated.luckyGemstone,
            luckyDirection: generated.luckyDirection,
            isFromCache: false,
          );

          await _storageService.cacheRashiReading(rashi.zodiacParam, dateKey, reading.toJson());
          return reading;
        }
      } catch (e) {
        debugPrint('Rashi API failed, fallback to Vedic prediction ($e)');
      }
    }

    // 3. Dynamic Astrological Calculation Engine
    final dynamicReading = _generateVedicHoroscope(rashi, targetDate, formattedDisplayDate);
    await _storageService.cacheRashiReading(rashi.zodiacParam, dateKey, dynamicReading.toJson());
    return dynamicReading;
  }

  static RashiReadingModel _generateVedicHoroscope(RashiInfo rashi, DateTime date, String formattedDate) {
    final daySeed = date.year * 10000 + date.month * 100 + date.day + rashi.id * 17;
    final cycleIndex = (daySeed % 7);
    final weekday = date.weekday;

    final englishPredictions = [
      'Today brings auspicious alignment for ${rashi.englishName}. Governed by ${rashi.rulingPlanet}, your natural instincts toward ${rashi.characteristics.toLowerCase()} will guide you smoothly through obstacles. Spiritual contemplation and steady devotion will yield inner clarity and productive accomplishments in your endeavors.',
      'A harmonious day for relationship building and thoughtful planning. With your ruling deity ${rashi.deity}\'s blessings, staying focused on selfless duty (Nishkama Karma) will bring profound peace and unexpected goodwill from peers.',
      'Cosmic energies favor creative problem solving and learning today. Take time for short meditation or sacred chants. Guard against impatience and let your steadfast nature overcome trivial distractions.',
      'A day of vibrant vitality and dynamic action. Your innate strengths are magnified under today\'s stellar transit. Dedicate efforts toward long-term aspirations while maintaining humility in all interactions.',
      'Balance and introspection are your greatest allies today. Nurture your inner peace and practice gratitude. Financial decisions made with careful deliberation will prove prosperous in the coming weeks.',
      'Favorable planetary alignments stimulate progress in communications and teamwork. Your integrity and wisdom inspire confidence among companions. Stay aligned with dharmic values.',
      'An auspicious period for spiritual elevation and completing pending responsibilities. Maintain an equitable mindset and offer thanks for the day\'s blessings.',
    ];

    final hindiPredictions = [
      'आज ${rashi.hindiName} राशि के जातकों के लिए दिन अत्यंत शुभ और सकारात्मक रहने वाला है। ${rashi.rulingPlanet} की कृपा से आपके आत्मविश्वास में वृद्धि होगी। कार्यक्षेत्र में नए अवसर मिलेंगे तथा पारिवारिक वातावरण सुखद रहेगा। \'${rashi.mantra}\' का जप कल्याणकारी होगा।',
      'आज का दिन धैर्य और विवेक से निर्णय लेने का है। आपके स्वामी ग्रह की स्थिति अनुकूल है। आर्थिक मामलों में प्रगति होगी और मित्रों का सहयोग प्राप्त होगा। सात्विक विचार और कर्तव्यनिष्ठा से सभी कार्य सिद्ध होंगे।',
      'आज ज्ञानार्जन और रचनात्मक कार्यों में सफलता का योग है। भगवान की आराधना से मानसिक शांति मिलेगी। वाणी में सौम्यता बनाए रखें। स्वास्थ्य उत्तम रहेगा और मान-सम्मान में वृद्धि होगी।',
      'आज ऊर्जा और पराक्रम का संचार होगा। रुके हुए कार्यों को गति मिलेगी। व्यापार और नौकरी में नवीन संभावनाएं बनेंगी। अपने ईष्टदेव के स्मरण से दिन और अधिक फलदायी रहेगा।',
      'आज संतुलन और आत्म-निरीक्षण का विशेष महत्व रहेगा। किसी भी महत्वपूर्ण कार्य में बड़ों का मार्गदर्शन अवश्य लें। धार्मिक कार्यों में रुचि बढ़ेगी और मन प्रसन्न रहेगा।',
      'आज सामाजिक प्रतिष्ठा एवं मित्रों से सहयोग के योग हैं। व्यावसायिक यात्राएं लाभदायक सिद्ध होंगी। परिवार में किसी मांगलिक कार्य की योजना बन सकती है।',
      'आज मन शांत और आध्यात्मिक ऊर्जा से परिपूर्ण रहेगा। नए संपर्क स्थापित होंगे जो भविष्य में लाभकारी सिद्ध होंगे। ईष्टदेव की आराधना से हर बाधा दूर होगी।',
    ];

    final careerEn = [
      'New professional opportunities align favorably. Stay proactive and collaborative.',
      'Concentrate on finishing pending tasks before taking up new commitments.',
      'Financial decisions taken with prudence yield sustainable gains.',
      'Creative leadership and communication will resolve long-standing bottlenecks.',
      'Auspicious period for investments in learning, skills, and business expansion.',
      'Teamwork and clarity in documentation bring praise from seniors.',
      'Patience in commercial discussions ensures long-term mutual benefit.',
    ];

    final careerHi = [
      'कार्यक्षेत्र में नई जिम्मेदारियां और पदोन्नति के योग बन रहे हैं।',
      'रुके हुए धन की प्राप्ति होगी। व्यावसायिक साझेदारों के साथ संबंध प्रगाढ़ होंगे।',
      'वित्तीय निवेश में सावधानी बरतें। पूर्व में किए गए कार्यों का श्रेष्ठ फल प्राप्त होगा।',
      'नौकरीपेशा लोगों के लिए आज का दिन विशेष उपलब्धियों भरा रहेगा।',
      'व्यापार में नए अनुबंध और लाभ के अवसर उत्पन्न होंगे।',
      'अधिकारियों का पूर्ण सहयोग प्राप्त होगा। निर्णय क्षमता की सराहना होगी।',
      'योजनाबद्ध तरीके से किया गया कार्य अप्रत्याशित सफलता दिलाएगा।',
    ];

    final loveEn = [
      'Warmth and understanding prevail in family relationships.',
      'Open and empathetic conversations strengthen bonds with loved ones.',
      'A joyful gathering or celebration brings cheerful moments at home.',
      'Expressing appreciation brings harmony and emotional closeness.',
      'Mutual trust and shared values deepen romantic partnerships.',
      'Spending quality time with elders brings wisdom and peace.',
      'Peaceful home atmosphere nurtures spiritual growth.',
    ];

    final loveHi = [
      'पारिवारिक जीवन में सुख-शांति बनी रहेगी और परस्पर प्रेम बढ़ेगा।',
      'जीवनसाथी का पूर्ण सहयोग एवं भावनात्मक सम्बल प्राप्त होगा।',
      'घर में परिजनों के साथ आनंददायक और सौहार्दपूर्ण समय व्यतीत होगा।',
      'सच्चे संवाद से आपसी गलतफहमियां दूर होंगी और रिश्ते मजबूत होंगे।',
      'संतान पक्ष से शुभ समाचार मिलने के प्रबल योग हैं।',
      'दांपत्य जीवन में मधुरता और परस्पर विश्वास में वृद्धि होगी।',
      'रिश्तेदारों और प्रियजनों का स्नेहपूर्ण सहयोग मिलेगा।',
    ];

    final healthEn = [
      'Energy levels remain high. Maintain balanced hydration and sattvic diet.',
      'Gentle yoga and mindful breathing enhance mental clarity.',
      'Prioritize good sleep and avoid overexertion in the evening.',
      'Vibrant vitality supports an active and productive schedule.',
      'Outdoor walks and nature connection rejuvenate the senses.',
      'Incorporate warm herbal drinks and light meals for optimal vitality.',
      'Meditative practices keep stress low and spiritual awareness high.',
    ];

    final healthHi = [
      'स्वास्थ्य उत्तम रहेगा। योग एवं प्राणायाम से मन में स्फूर्ति रहेगी।',
      'खान-पान में सात्विकता बनाए रखें। मौसमी विकारों से बचाव रहेगा।',
      'मानसिक शांति के लिए 10 मिनट का ध्यान विशेष रूप से फलदायी रहेगा।',
      'दिनभर ऊर्जा का स्तर बना रहेगा। नियमित दिनचर्या का पालन करें।',
      'हल्के व्यायाम और प्रातःकालीन भ्रमण से स्वास्थ्य में सुधार होगा।',
      'पर्याप्त जल का सेवन करें एवं तनावमुक्त रहने का प्रयास करें।',
      'शारीरिक और मानसिक रूप से ताजगी और प्रसन्नता का अनुभव होगा।',
    ];

    final gemstones = [
      'माणिक्य (Ruby)', 'मोती (Pearl)', 'मूंगा (Red Coral)', 'पन्ना (Emerald)',
      'पुखराज (Yellow Sapphire)', 'हीरा (Diamond)', 'नीलम (Blue Sapphire)',
      'गोमेद (Hessonite)', 'लहसुनिया (Cat\'s Eye)',
    ];

    final directions = ['उत्तर (North)', 'पूर्व (East)', 'उत्तर-पूर्व (North-East)', 'दक्षिण-पूर्व (South-East)', 'उत्तर-पश्चिम (North-West)'];

    final luckyNum = ((rashi.luckyNumber + daySeed % 9) % 9) + 1;
    final luckyDir = directions[daySeed % directions.length];
    final luckyGem = gemstones[(rashi.id + daySeed) % gemstones.length];

    return RashiReadingModel(
      date: formattedDate,
      zodiacSign: rashi.zodiacParam,
      horoscopeText: englishPredictions[cycleIndex],
      horoscopeTextHindi: hindiPredictions[cycleIndex],
      careerOutlook: careerEn[cycleIndex],
      careerOutlookHindi: careerHi[cycleIndex],
      loveOutlook: loveEn[cycleIndex],
      loveOutlookHindi: loveHi[cycleIndex],
      healthOutlook: healthEn[cycleIndex],
      healthOutlookHindi: healthHi[cycleIndex],
      mood: weekday % 2 == 0 ? 'Peaceful & Harmonious' : 'Energetic & Confident',
      compatibility: _getCompatibleRashi(rashi),
      luckyTime: _getLuckyTime(rashi, daySeed),
      luckyNumber: '$luckyNum',
      luckyColor: rashi.luckyColor,
      luckyGemstone: luckyGem,
      luckyDirection: luckyDir,
      isFromCache: false,
    );
  }

  static String _getCompatibleRashi(RashiInfo rashi) {
    switch (rashi.element.split(' ').first) {
      case 'अग्नि':
        return 'सिंह (Leo), धनु (Sagittarius)';
      case 'पृथ्वी':
        return 'वृषभ (Taurus), मकर (Capricorn)';
      case 'वायु':
        return 'मिथुन (Gemini), कुम्भ (Aquarius)';
      case 'जल':
      default:
        return 'कर्क (Cancer), मीन (Pisces)';
    }
  }

  static String _getLuckyTime(RashiInfo rashi, [int seed = 0]) {
    final times = [
      '07:00 AM – 08:30 AM',
      '09:15 AM – 10:45 AM',
      '11:30 AM – 01:00 PM',
      '02:30 PM – 04:00 PM',
      '05:00 PM – 06:30 PM',
      '07:15 PM – 08:45 PM',
    ];
    return times[(rashi.id - 1 + seed) % times.length];
  }
}
