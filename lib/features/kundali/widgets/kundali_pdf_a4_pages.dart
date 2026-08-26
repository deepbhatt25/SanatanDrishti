import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/rashi_data.dart';
import '../models/kundali_model.dart';
import '../services/kundali_calculator.dart';
import 'kundali_chart_painter.dart';

/// A4 Sized Flutter Page Widgets for generating high-definition,
/// 100% properly shaped Gujarati & Hindi Kundali PDF reports.
class KundaliPdfA4Pages {
  static const double a4Width = 595.28;
  static const double a4Height = 841.89;

  static const Color maroonColor = Color(0xFF800000);
  static const Color goldColor = Color(0xFFD4AF37);
  static const Color darkBg = Color(0xFF2C1810);
  static const Color lightRow = Color(0xFFFDF8F2);
  static const Color borderCol = Color(0xFFE2C99A);
  static const Color lightCard = Color(0xFFFFFBF5);

  // =========================================================================
  // PAGE 1: Profile Details, 3 North Indian Charts, Graha Spashta Table
  // =========================================================================
  static Widget buildPage1({
    required KundaliResult kundali,
    required bool isGujarati,
  }) {
    final lagnaName = _getRashiName(kundali.lagnaRashiId, isGujarati);
    final moonSignName = _getRashiName(kundali.moonRashiId, isGujarati);
    final sunSignName = _getRashiName(kundali.sunRashiId, isGujarati);
    final nakshatraName = isGujarati ? kundali.nakshatraGu : kundali.nakshatraHi;
    final ganaStr = isGujarati ? kundali.ganaGu : kundali.ganaHi;
    final nadiStr = isGujarati ? kundali.nadiGu : kundali.nadiHi;
    final yoniStr = isGujarati ? kundali.yoniGu : kundali.yoniHi;
    final varnaStr = isGujarati ? kundali.varnaGu : kundali.varnaHi;
    final luckyGemStr = isGujarati ? kundali.luckyGemstoneGu : kundali.luckyGemstoneHi;
    final luckyColStr = isGujarati
        ? (kundali.luckyColorGu.isNotEmpty ? kundali.luckyColorGu : 'પીળો, સોનેરી (Yellow, Gold)')
        : (kundali.luckyColorHi.isNotEmpty ? kundali.luckyColorHi : 'पीला, सुनहरा (Yellow, Gold)');
    final genderStr = kundali.profile.gender == Gender.male
        ? (isGujarati ? 'પુરુષ' : 'पुरुष')
        : (kundali.profile.gender == Gender.female ? (isGujarati ? 'સ્ત્રી' : 'स्त्री') : (isGujarati ? 'અન્ય' : 'अन्य'));

    return _buildA4Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(
            pageNumber: 1,
            subtitle: isGujarati
                ? 'જાતક પરિચય, જન્મ લગ્ન (D1), નવાંશ (D9), ચંદ્ર કુંડળી & અવકહડા ચક્ર'
                : 'जातक विवरण, जन्म लग्न (D1), नवमांश (D9), चन्द्र कुंडली & अवकहड़ा चक्र',
            isGujarati: isGujarati,
          ),
          const SizedBox(height: 7),

          // 1. Birth Details & Avakahada Chakra (2 side-by-side cards)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Card: Birth Details (જાતક પરિચય)
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: lightRow,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: borderCol, width: 0.9),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isGujarati ? 'જાતક પરિચય (Birth Details)' : 'जातक विवरण (Birth Details)',
                            style: _fontBold(isGujarati, 9.5, maroonColor),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: maroonColor.withAlpha(20),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: maroonColor.withAlpha(80), width: 0.5),
                            ),
                            child: Text(
                              genderStr,
                              style: _fontBold(isGujarati, 8.5, maroonColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      const Divider(color: borderCol, thickness: 0.5, height: 4),
                      const SizedBox(height: 3),
                      _buildInfoRow(isGujarati ? 'નામ (Name):' : 'नाम (Name):', kundali.profile.name, isGujarati, isBoldValue: true),
                      const SizedBox(height: 2),
                      _buildInfoRow(
                        isGujarati ? 'જન્મ તારીખ (DOB):' : 'जन्म तिथि (DOB):',
                        DateFormat('dd MMMM yyyy (EEEE)').format(kundali.profile.dateOfBirth),
                        isGujarati,
                      ),
                      const SizedBox(height: 2),
                      _buildInfoRow(isGujarati ? 'જન્મ સમય (Time):' : 'जन्म समय (Time):', kundali.profile.formattedTime, isGujarati),
                      const SizedBox(height: 2),
                      _buildInfoRow(
                        isGujarati ? 'જન્મ સ્થળ (City):' : 'जन्म स्थान (City):',
                        '${kundali.profile.cityName} (Lat: ${kundali.profile.latitude.toStringAsFixed(2)}°, Lon: ${kundali.profile.longitude.toStringAsFixed(2)}°)',
                        isGujarati,
                      ),
                      const SizedBox(height: 2),
                      _buildInfoRow(
                        isGujarati ? 'અયનાંશ (Ayanamsha):' : 'अयनांश (Ayanamsha):',
                        'Lahiri (ચિત્રપક્ષ) 24° 08\' 42"',
                        isGujarati,
                      ),
                      const SizedBox(height: 2),
                      _buildInfoRow(
                        isGujarati ? 'માંગલિક સ્થિતિ:' : 'मांगलिक स्थिति:',
                        kundali.mangalDosha.hasDosha
                            ? (isGujarati ? 'માંગલિક દોષ પ્રભાવ' : 'मांगलिक दोष प्रभावी')
                            : (isGujarati ? 'દોષ મુક્ત / નિર્દોષ (પરિહાર યોગ)' : 'दोष मुक्त / निर्दोष (परिहार योग)'),
                        isGujarati,
                        isHighlight: true,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Right Card: Avakahada Chakra (અવકહડા ચક્ર)
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: lightRow,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: borderCol, width: 0.9),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isGujarati ? 'અવકહડા ચક્ર (Vedic Astrological Profile)' : 'अवकहड़ा चक्र (Vedic Astrological Profile)',
                            style: _fontBold(isGujarati, 9.5, maroonColor),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: maroonColor.withAlpha(20),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: maroonColor.withAlpha(80), width: 0.5),
                            ),
                            child: Text(
                              '${isGujarati ? 'શુભ અંક:' : 'शुभ अंक:'} ${kundali.luckyNumber}',
                              style: _fontBold(isGujarati, 8.5, maroonColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      const Divider(color: borderCol, thickness: 0.5, height: 4),
                      const SizedBox(height: 3),
                      _buildInfoRow(
                        isGujarati ? 'લગ્ન / ચંદ્ર રાશિ:' : 'लग्न / चन्द्र राशि:',
                        '$lagnaName (${kundali.lagnaRashiId}) / $moonSignName (${kundali.moonRashiId})',
                        isGujarati,
                        isHighlight: true,
                      ),
                      const SizedBox(height: 2),
                      _buildInfoRow(
                        isGujarati ? 'સૂર્ય રાશિ / નક્ષત્ર:' : 'सूर्य राशि / नक्षत्र:',
                        '$sunSignName (${kundali.sunRashiId}) / $nakshatraName (${isGujarati ? 'પદ' : 'पद'} ${kundali.charan})',
                        isGujarati,
                      ),
                      const SizedBox(height: 2),
                      _buildInfoRow(
                        isGujarati ? 'ગણ / નાડી / યોનિ:' : 'गण / नाड़ी / योनि:',
                        '$ganaStr / $nadiStr / $yoniStr',
                        isGujarati,
                      ),
                      const SizedBox(height: 2),
                      _buildInfoRow(
                        isGujarati ? 'વર્ણ / શુભ રત્ન:' : 'वर्ण / शुभ रत्न:',
                        '$varnaStr / $luckyGemStr',
                        isGujarati,
                      ),
                      const SizedBox(height: 2),
                      _buildInfoRow(
                        isGujarati ? 'શુભ રંગ & દિશા:' : 'शुभ रंग & दिशा:',
                        '$luckyColStr | ${kundali.lifePrediction.luckyDirection}',
                        isGujarati,
                      ),
                      const SizedBox(height: 2),
                      _buildInfoRow(
                        isGujarati ? 'ઇષ્ટદેવ ઉપાસના:' : 'इष्टदेव उपासना:',
                        kundali.lifePrediction.ishtaDevataGu.isNotEmpty
                            ? (isGujarati ? kundali.lifePrediction.ishtaDevataGu : kundali.lifePrediction.ishtaDevataHi)
                            : (isGujarati ? 'ભગવાન શ્રી હનુમાનજી / કાર્તિકેય' : 'भगवान श्री हनुमान जी / कार्तिकेय'),
                        isGujarati,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),

          // 2. 3 North Indian Vedic Charts Side-by-Side
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
            decoration: BoxDecoration(
              color: lightCard,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderCol, width: 0.9),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildChartBox(
                      title: isGujarati ? '૧. લગ્ન કુંડળી (Lagna D1)' : '१. जन्म लग्न कुंडली (Lagna D1)',
                      chartWidget: KundaliChartWidget(
                        kundali: kundali,
                        isGujarati: isGujarati,
                        isNavamsha: false,
                        isChandra: false,
                        size: 160,
                      ),
                      isGujarati: isGujarati,
                    ),
                    _buildChartBox(
                      title: isGujarati ? '૨. નવાંશ કુંડળી (Navamsha D9)' : '२. नवमांश कुंडली (Navamsha D9)',
                      chartWidget: KundaliChartWidget(
                        kundali: kundali,
                        isGujarati: isGujarati,
                        isNavamsha: true,
                        isChandra: false,
                        size: 160,
                      ),
                      isGujarati: isGujarati,
                    ),
                    _buildChartBox(
                      title: isGujarati ? '૩. ચંદ્ર કુંડળી (Chandra)' : '३. चन्द्र कुंडली (Chandra)',
                      chartWidget: KundaliChartWidget(
                        kundali: kundali,
                        isGujarati: isGujarati,
                        isNavamsha: false,
                        isChandra: true,
                        size: 160,
                      ),
                      isGujarati: isGujarati,
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Planet abbreviations legend
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
                  decoration: BoxDecoration(
                    color: lightRow,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: borderCol.withAlpha(120), width: 0.5),
                  ),
                  child: Text(
                    isGujarati
                        ? 'સૂ: સૂર્ય (Sun)  •  ચં: ચંદ્ર (Moon)  •  મં: મંગળ (Mars)  •  બુ: બુધ (Mercury)  •  ગુ: ગુરુ (Jupiter)  •  શુ: શુક્ર (Venus)  •  શ: શનિ (Saturn)  •  રા: રાહુ (Rahu)  •  કે: કેતુ (Ketu)'
                        : 'सू: सूर्य (Sun)  •  चं: चन्द्र (Moon)  •  मं: मंगल (Mars)  •  बु: बुध (Mercury)  •  गु: गुरु (Jupiter)  •  शु: शुक्र (Venus)  •  श: शनि (Saturn)  •  रा: राहु (Rahu)  •  के: केतु (Ketu)',
                    style: _fontRegular(isGujarati, 6.8, darkBg),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),

          // 3. Graha Spashta Table (10 Rows)
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: lightCard,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderCol, width: 0.9),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isGujarati ? 'ગ્રહ સ્પષ્ટ સ્થિતિ (Graha Spashta - Planetary Positions)' : 'ग्रह स्पष्ट स्थिति (Graha Spashta - Planetary Positions)',
                      style: _fontBold(isGujarati, 9.5, maroonColor),
                    ),
                    Text(
                      isGujarati ? 'લગ્ન અંશ: ${kundali.lagnaDegree.toStringAsFixed(2)}°' : 'लग्न अंश: ${kundali.lagnaDegree.toStringAsFixed(2)}°',
                      style: _fontRegular(isGujarati, 8.0, maroonColor.withAlpha(200)),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                _buildGrahaSpashtaTable(kundali, isGujarati),
              ],
            ),
          ),

          const Spacer(),
          _buildFooter(isGujarati),
        ],
      ),
    );
  }

  // =========================================================================
  // PAGE 2: 5 Life Aspect Cards & 12 Bhavas Summary (4 Quadrants)
  // =========================================================================
  static Widget buildPage2({
    required KundaliResult kundali,
    required bool isGujarati,
  }) {
    final pred = kundali.lifePrediction;

    return _buildA4Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(
            pageNumber: 2,
            subtitle: isGujarati
                ? 'શારીરિક દેખાવ, સ્વભાવ, આરોગ્ય, વિવાહ-દાંપત્ય, કારકિર્દી & ૧૨ ભાવ વિશ્લેષણ'
                : 'शारीरिक रूप, स्वभाव, स्वास्थ्य, विवाह-दाम्पत्य, करियर & १२ भाव विश्लेषण',
            isGujarati: isGujarati,
          ),
          const SizedBox(height: 7),

          // 1. Physical Appearance
          _buildAspectCard(
            title: isGujarati ? 'શારીરિક દેખાવ અને વ્યક્તિત્વ સ્વરૂપ' : 'शारीरिक रूप एवं व्यक्तित्व',
            desc: isGujarati ? pred.physicalAppearance.descriptionGu : pred.physicalAppearance.descriptionHi,
            tags: isGujarati ? pred.physicalAppearance.highlightsGu : pred.physicalAppearance.highlightsHi,
            isGujarati: isGujarati,
          ),
          const SizedBox(height: 5),

          // 2. Temperament & Characteristics
          _buildAspectCard(
            title: isGujarati ? 'સ્વભાવ, આચરણ અને વ્યક્તિત્વ' : 'स्वभाव, आचरण एवं व्यक्तित्व',
            desc: isGujarati ? pred.personalitySwabhav.descriptionGu : pred.personalitySwabhav.descriptionHi,
            tags: isGujarati ? pred.personalitySwabhav.highlightsGu : pred.personalitySwabhav.highlightsHi,
            isGujarati: isGujarati,
          ),
          const SizedBox(height: 5),

          // 3. Health & Wellness
          _buildAspectCard(
            title: isGujarati ? 'આરોગ્ય અને સાવચેતી' : 'स्वास्थ्य एवं सावधानियां',
            desc: isGujarati ? pred.healthPrediction.descriptionGu : pred.healthPrediction.descriptionHi,
            tags: isGujarati ? pred.healthPrediction.highlightsGu : pred.healthPrediction.highlightsHi,
            isGujarati: isGujarati,
          ),
          const SizedBox(height: 5),

          // 4. Marriage & Relationship
          _buildAspectCard(
            title: isGujarati ? 'વિવાહ અને દાંપત્ય યોગ' : 'विवाह एवं दाम्पत्य योग',
            desc: isGujarati ? pred.marriagePrediction.descriptionGu : pred.marriagePrediction.descriptionHi,
            badge: pred.marriagePrediction.timingOrAge,
            tags: isGujarati ? pred.marriagePrediction.highlightsGu : pred.marriagePrediction.highlightsHi,
            isGujarati: isGujarati,
          ),
          const SizedBox(height: 5),

          // 5. Career & Fortune
          _buildAspectCard(
            title: isGujarati ? 'ભાગ્યોદય અને કારકિર્દી યોગ' : 'भाग्योदय एवं करियर योग',
            desc: isGujarati ? pred.careerBhagyodaya.descriptionGu : pred.careerBhagyodaya.descriptionHi,
            badge: pred.careerBhagyodaya.timingOrAge,
            tags: isGujarati ? pred.careerBhagyodaya.highlightsGu : pred.careerBhagyodaya.highlightsHi,
            isGujarati: isGujarati,
          ),
          const SizedBox(height: 6),

          // 6. 12 Bhavas Summary (4 Quadrants in 2x2 Grid)
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: lightCard,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderCol, width: 0.9),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isGujarati
                      ? '૧૨ ભાવ વિશ્લેષણ અને જીવનના ચાર સ્તંભ (12 Bhavas Summary)'
                      : '१२ भाव विश्लेषण एवं जीवन के चार स्तम्भ (12 Bhavas Summary)',
                  style: _fontBold(isGujarati, 9.5, maroonColor),
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Column 1: Kendra & Trikona
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBhavaQuadCard(
                            title: isGujarati
                                ? '• કેન્દ્ર ભાવ (૧, ૪, ૭, ૧૦ - વિષ્ણુ સ્થાન):'
                                : '• केन्द्र भाव (१, ४, ७, १० - विष्णु स्थान):',
                            desc: isGujarati
                                ? 'તનુ (શરીર), સુખ (માતા-મિલકત), જાયા (જીવનસાથી) અને કર્મ (કારકિર્દી) ભાવ જીવનને સ્થિરતા અને સન્માન અર્પે છે.'
                                : 'तनु (शरीर), सुख (माता-सम्पत्ति), जाया (जीवनसाथी) एवं कर्म (करियर) भाव जीवन को स्थिरता व सम्मान प्रदान करते हैं।',
                            isGujarati: isGujarati,
                          ),
                          const SizedBox(height: 4),
                          _buildBhavaQuadCard(
                            title: isGujarati
                                ? '• ત્રિકોણ ભાવ (૧, ૫, ૯ - લક્ષ્મી સ્થાન):'
                                : '• त्रिकोण भाव (१, ५, ९ - लक्ष्मी स्थान):',
                            desc: isGujarati
                                ? 'ધર્મ, પૂર્વપુણ્ય, બુદ્ધિ અને ભાગ્ય ભાવ જીવનમાં દૈવી કૃપા અને આધ્યાત્મિક જ્ઞાન પ્રદાન કરે છે.'
                                : 'धर्म, पूर्वपुण्य, बुद्धि एवं भाग्य भाव जीवन में दैवीय कृपा व आध्यात्मिक ज्ञान प्रदान करते हैं।',
                            isGujarati: isGujarati,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Column 2: Upachaya & Moksha
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildBhavaQuadCard(
                            title: isGujarati
                                ? '• ઉપચય ભાવ (૩, ૬, ૧૦, ૧૧ - વૃદ્ધિ સ્થાન):'
                                : '• उपचय भाव (३, ६, १०, ११ - वृद्धि स्थान):',
                            desc: isGujarati
                                ? 'પરાક્રમ, પુરુષાર્થ, શત્રુવિજય અને સર્વાંગી લાભ ભાવ વય સાથે સતત ઉન્નતિ અને ધનલાભ આપે છે.'
                                : 'पराक्रम, पुरुषार्थ, शत्रुविजय एवं सर्वांगीण लाभ भाव उम्र के साथ सतत उन्नति व धनलाभ कराते हैं।',
                            isGujarati: isGujarati,
                          ),
                          const SizedBox(height: 4),
                          _buildBhavaQuadCard(
                            title: isGujarati
                                ? '• મોક્ષ ત્રિકોણ (૪, ૮, ૧૨ - આધ્યાત્મિક સ્થાન):'
                                : '• मोक्ष त्रिकोण (४, ८, १२ - आध्यात्मिक स्थान):',
                            desc: isGujarati
                                ? 'માનસિક શાંતિ, રહસ્ય વિદ્યા, સાધના અને ઈશ્વર સમર્પણથી આત્મસાક્ષાત્કારનો માર્ગ સરળ બને છે.'
                                : 'मानसिक शांति, गूढ़ विद्या, साधना एवं ईश्वर समर्पण से आत्मसाक्षात्कार का मार्ग सुगम बनता है।',
                            isGujarati: isGujarati,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Spacer(),
          _buildFooter(isGujarati),
        ],
      ),
    );
  }

  // =========================================================================
  // PAGE 3: Special Yogas, Manglik Dosha, Kaal Sarp, Sadhesati, Mantras
  // =========================================================================
  static Widget buildPage3({
    required KundaliResult kundali,
    required bool isGujarati,
  }) {
    final pred = kundali.lifePrediction;
    final doshaAnalysis = KundaliCalculator.calculateDoshaAnalysis(
      planets: kundali.planets,
      moonRashiId: kundali.moonRashiId,
      lagnaRashiId: kundali.lagnaRashiId,
    );

    return _buildA4Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(
            pageNumber: 3,
            subtitle: isGujarati
                ? 'રાજયોગ, માંગલિક દોષફળ, વિશેષ કાળસર્પ દોષ, શનિ સાડાસાતી & ઈષ્ટદેવ ઉપાસના'
                : 'राजयोग, मांगलिक दोषफल, विशेष कालसर्प दोष, शनि साढ़ेसाती & इष्टदेव उपासना',
            isGujarati: isGujarati,
          ),
          const SizedBox(height: 7),

          // 1. Special Vedic Yogas
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: lightCard,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderCol, width: 0.9),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isGujarati ? 'કુંડળીના વિશેષ રાજયોગ અને ધન યોગ (Special Vedic Yogas)' : 'कुंडली के विशेष राजयोग एवं धन योग (Special Vedic Yogas)',
                  style: _fontBold(isGujarati, 9.5, maroonColor),
                ),
                const SizedBox(height: 3),
                const Divider(color: borderCol, thickness: 0.5, height: 4),
                const SizedBox(height: 3),
                Text(
                  isGujarati
                      ? '• બુધાદિત્ય રાજયોગ: સૂર્ય અને બુધની શુભ યુતિથી તીવ્ર બુદ્ધિપ્રતિભા, વહીવટી કુશળતા, ઉત્તમ વાણી અને સમાજમાં પ્રતિષ્ઠા પ્રાપ્ત થાય છે.\n'
                          '• ગજકેસરી યોગ: ગુરુ અને ચંદ્રના કેન્દ્ર સંબંધથી દીર્ઘકાલીન સમૃદ્ધિ, ધાર્મિક બુદ્ધિ, જનપ્રિયતા અને પરિવાર સુખ પ્રાપ્ત થાય છે.\n'
                          '• શુભ કર્તરી & લક્ષ્મી યોગ: કેન્દ્ર તથા ત્રિકોણ ભાવના સ્વામીઓની શુભ અનુકૂળતાથી અવિરત સુખસંપત્તિ, દૈવી રક્ષા અને સ્થિર સમૃદ્ધિ મળે છે.'
                      : '• बुधादित्य राजयोग: सूर्य एवं बुध की युति से तीव्र बुद्धिमत्ता, प्रशासनिक क्षमता, वाकपटुता एवं यश प्राप्त होता है।\n'
                          '• गजकेसरी योग: गुरु व चन्द्र के केंद्र संबंध से दीर्घकालिक समृद्धि, धार्मिक बुद्धि, लोकप्रियता एवं परिवार सुख मिलता है।\n'
                          '• शुभ कर्तरी & लक्ष्मी योग: केन्द्र तथा त्रिकोण भावों की शुभ अनुकूलता से अखंड धनलाभ, ईश्वरीय कृपा व सतत सुरक्षा मिलती है।',
                  style: _fontRegular(isGujarati, 7.6, darkBg, height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // 2. Manglik Dosha Analysis & Doshfal
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9F5),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFE8B89A), width: 0.9),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isGujarati
                          ? 'માંગલિક દોષ વિશ્લેષણ: ${kundali.mangalDosha.hasDosha ? 'માંગલિક દોષ પ્રભાવ' : 'દોષ મુક્ત / નિર્દોષ (પરિહાર યોગ)'}'
                          : 'मांगलिक दोष विश्लेषण: ${kundali.mangalDosha.hasDosha ? 'मांगलिक दोष प्रभावी' : 'दोष मुक्त / निर्दोष (परिहार योग)'}',
                      style: _fontBold(isGujarati, 9.5, const Color(0xFF9C2A10)),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                const Divider(color: Color(0xFFE8B89A), thickness: 0.5, height: 4),
                const SizedBox(height: 3),
                Text(
                  isGujarati ? kundali.mangalDosha.descriptionGu : kundali.mangalDosha.descriptionHi,
                  style: _fontRegular(isGujarati, 7.6, darkBg, height: 1.35),
                ),
                const SizedBox(height: 2),
                Text(
                  '${isGujarati ? 'શાંતિ ઉપાય / નિવારણ:' : 'शांति उपाय / निवारण:'} ${isGujarati ? kundali.mangalDosha.remedyGu : kundali.mangalDosha.remedyHi}',
                  style: _fontBold(isGujarati, 7.6, const Color(0xFF9C2A10), height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // 3. Kaal Sarp & Shani Sade Sati Analysis
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: lightCard,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderCol, width: 0.9),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isGujarati ? 'વિશેષ કાળસર્પ & સાડાસાતી વિશ્લેષણ (Kaal Sarp & Shani Analysis)' : 'विशेष कालसर्प & साढ़ेसाती विश्लेषण (Kaal Sarp & Shani Analysis)',
                  style: _fontBold(isGujarati, 9.5, maroonColor),
                ),
                const SizedBox(height: 3),
                const Divider(color: borderCol, thickness: 0.5, height: 4),
                const SizedBox(height: 3),
                Text(
                  isGujarati
                      ? '• કાળસર્પ સ્થિતિ: [${doshaAnalysis.kaalSarpNameGu}] ${doshaAnalysis.kaalSarpDescGu}\n'
                          '• શનિ સાડાસાતી: [${doshaAnalysis.shaniStatusGu}] ${doshaAnalysis.shaniDescGu}\n'
                          '• ${doshaAnalysis.vedicMantraGu}\n'
                          '• રુદ્રાક્ષ & રત્ન ઉપાય: ${doshaAnalysis.rudrakshaGu.replaceAll('• ', '')} | ${doshaAnalysis.gemstoneGu.replaceAll('• ', '')}'
                      : '• कालसर्प स्थिति: [${doshaAnalysis.kaalSarpNameHi}] ${doshaAnalysis.kaalSarpDescHi}\n'
                          '• शनि साढ़ेसाती: [${doshaAnalysis.shaniStatusHi}] ${doshaAnalysis.shaniDescHi}\n'
                          '• ${doshaAnalysis.vedicMantraHi}\n'
                          '• रुद्राक्ष & रत्न उपाय: ${doshaAnalysis.rudrakshaHi.replaceAll('• ', '')} | ${doshaAnalysis.gemstoneHi.replaceAll('• ', '')}',
                  style: _fontRegular(isGujarati, 7.6, darkBg, height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // 4. Spiritual Guidance & Sacred Mantras
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: lightRow,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderCol, width: 0.9),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isGujarati ? 'ઇષ્ટદેવ અને વૈદિક કલ્યાણ મંત્ર (Spiritual Guidance & Mantras)' : 'इष्टदेव एवं वैदिक कल्याण मंत्र (Spiritual Guidance & Mantras)',
                  style: _fontBold(isGujarati, 9.5, maroonColor),
                ),
                const SizedBox(height: 3),
                const Divider(color: borderCol, thickness: 0.5, height: 4),
                const SizedBox(height: 3),
                Text(
                  '${isGujarati ? 'ઇષ્ટદેવ ઉપાસના:' : 'इष्टदेव उपासना:'} ${isGujarati ? (pred.ishtaDevataGu.isNotEmpty ? pred.ishtaDevataGu : 'ભગવાન શ્રી હનુમાનજી / કાર્તિકેય') : (pred.ishtaDevataHi.isNotEmpty ? pred.ishtaDevataHi : 'भगवान श्री हनुमान जी / कार्तिकेय')}',
                  style: _fontBold(isGujarati, 8.2, darkBg),
                ),
                const SizedBox(height: 2),
                Text(
                  '${isGujarati ? 'કલ્યાણ મહામંત્ર:' : 'कल्याण महामंत्र:'} ${isGujarati ? pred.sacredMantraGu : pred.sacredMantraHi}',
                  style: _fontBold(isGujarati, 8.2, maroonColor),
                ),
                const SizedBox(height: 2),
                Text(
                  '${isGujarati ? 'શુભ દિશા:' : 'शुभ दिशा:'} ${pred.luckyDirection}  |  ${isGujarati ? 'રત્ન:' : 'रत्न:'} ${isGujarati ? kundali.luckyGemstoneGu : kundali.luckyGemstoneHi} (${isGujarati ? 'વિધિવત્ પૂજન કરી શુક્લ પક્ષમાં ધારણ કરવું' : 'विधिवत पूजन कर शुक्ल पक्ष में धारण करें'})',
                  style: _fontRegular(isGujarati, 7.6, darkBg),
                ),
              ],
            ),
          ),

          const Spacer(),
          _buildFooter(isGujarati),
        ],
      ),
    );
  }

  // =========================================================================
  // PAGE 4: Planetary Positions & Detailed Vedic Graha Phal (All 9 Planets)
  // =========================================================================
  static Widget buildPage4({
    required KundaliResult kundali,
    required bool isGujarati,
  }) {
    return _buildA4Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(
            pageNumber: 4,
            subtitle: isGujarati
                ? 'નવગ્રહ સ્પષ્ટ સ્થિતિ સારણી અને પ્રત્યેક ગ્રહનું ભાવ અનુસાર વિસ્તૃત ફળાદેશ'
                : 'नवग्रह स्पष्ट स्थिति सारणी एवं प्रत्येक ग्रह का भाव अनुसार विस्तृत फलादेश',
            isGujarati: isGujarati,
          ),
          const SizedBox(height: 6),

          // Detailed Vedic Graha Phal for all 9 Planets in list
          ...kundali.planets.map((planet) {
            final rashiName = _getRashiName(planet.rashiId, isGujarati);
            final planetName = isGujarati ? planet.nameGu : planet.nameHi;
            final dignity = KundaliCalculator.getPlanetDignity(planet);
            final dignityLabel = isGujarati ? (dignity['labelGu'] as String) : (dignity['labelHi'] as String);
            final grahaFalMap = KundaliCalculator.getGrahaFal(planet, kundali.lagnaRashiId);
            final grahaFalText = isGujarati ? (grahaFalMap['gu'] ?? '') : (grahaFalMap['hi'] ?? '');

            return Container(
              margin: const EdgeInsets.only(bottom: 4),
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
              decoration: BoxDecoration(
                color: lightCard,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: borderCol, width: 0.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: maroonColor,
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              isGujarati ? planet.shortGu : planet.shortHi,
                              style: _fontBold(isGujarati, 7.5, goldColor),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '$planetName  •  $rashiName (${planet.formattedDegree})  •  ${isGujarati ? '${planet.houseNumber} મો ભાવ' : '${planet.houseNumber} वां भाव'}',
                            style: _fontBold(isGujarati, 8.2, maroonColor),
                          ),
                          if (planet.isRetrograde) ...[
                            const SizedBox(width: 4),
                            Text(
                              isGujarati ? '(વક્રી)' : '(वक्री)',
                              style: _fontBold(isGujarati, 7.5, const Color(0xFFD35400)),
                            ),
                          ],
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: maroonColor.withAlpha(15),
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: borderCol, width: 0.5),
                        ),
                        child: Text(
                          dignityLabel,
                          style: _fontBold(isGujarati, 7.2, maroonColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    grahaFalText,
                    style: _fontRegular(isGujarati, 7.2, darkBg, height: 1.28),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          }),

          const Spacer(),
          _buildFooter(isGujarati),
        ],
      ),
    );
  }

  // =========================================================================
  // PAGE 5: 120-Year Vimshottari Mahadasha Timeline & Detailed Dasha Phal
  // =========================================================================
  static Widget buildPage5({
    required KundaliResult kundali,
    required bool isGujarati,
  }) {
    return _buildA4Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(
            pageNumber: 5,
            subtitle: isGujarati
                ? '૧૨૦ વર્ષ વિંશોત્તરી મહાદશા સંપૂર્ણ ચક્ર, વર્તમાન દશા & પ્રત્યેક દશાનું વિસ્તૃત ફળ'
                : '१२० वर्ष विंशोत्तरी महादशा संपूर्ण चक्र, वर्तमान दशा & प्रत्येक दशा का विस्तृत फल',
            isGujarati: isGujarati,
          ),
          const SizedBox(height: 6),

          // 1. Vimshottari Mahadasha Timeline Table (All 9 Mahadashas)
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: lightCard,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: borderCol, width: 0.9),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isGujarati ? '૧૨૦ વર્ષ વિંશોત્તરી મહાદશા સંપૂર્ણ ચક્ર (Vimshottari Mahadasha 120 Years)' : '१२० वर्ष विंशोत्तरी महादशा संपूर्ण चक्र (Vimshottari Mahadasha 120 Years)',
                      style: _fontBold(isGujarati, 9.2, maroonColor),
                    ),
                    Text(
                      isGujarati ? 'કુલ અવધિ: ૧૨૦ વર્ષ' : 'कुल अवधि: १२० वर्ष',
                      style: _fontRegular(isGujarati, 7.8, maroonColor.withAlpha(200)),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                _buildDashaTable(kundali, isGujarati),
              ],
            ),
          ),
          const SizedBox(height: 6),

          // 2. Detailed Predictive Mahadasha Phal for All 9 Mahadashas
          Text(
            isGujarati ? 'પ્રત્યેક મહાદશાનું વિસ્તૃત જીવન ફળાદેશ (Mahadasha Interpretations):' : 'प्रत्येक महादशा का विस्तृत जीवन फलादेश (Mahadasha Interpretations):',
            style: _fontBold(isGujarati, 8.8, maroonColor),
          ),
          const SizedBox(height: 4),

          ...kundali.dashas.map((dasha) {
            final dashaName = isGujarati ? dasha.planetNameGu : dasha.planetNameHi;
            final startStr = DateFormat('dd/MM/yyyy').format(dasha.startDate);
            final endStr = DateFormat('dd/MM/yyyy').format(dasha.endDate);
            final dashaFal = KundaliCalculator.getAntardashaFal(dasha.planetNameGu, dasha.planetNameGu);
            final dashaFalText = isGujarati ? dashaFal['gu']! : dashaFal['hi']!;

            return Container(
              margin: const EdgeInsets.only(bottom: 3),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: dasha.isCurrent ? const Color(0xFFFFF3CD) : lightRow,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: dasha.isCurrent ? maroonColor : borderCol,
                  width: dasha.isCurrent ? 1.0 : 0.6,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 85,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$dashaName (${dasha.durationYears} ${isGujarati ? 'વર્ષ' : 'वर्ष'})',
                          style: _fontBold(isGujarati, 7.8, dasha.isCurrent ? maroonColor : darkBg),
                        ),
                        Text(
                          '$startStr - $endStr',
                          style: _fontRegular(isGujarati, 6.8, Colors.grey.shade700),
                        ),
                        if (dasha.isCurrent)
                          Container(
                            margin: const EdgeInsets.only(top: 1.5),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: maroonColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text(
                              isGujarati ? 'ચાલુ છે' : 'सक्रिय',
                              style: _fontBold(isGujarati, 6.5, Colors.white),
                            ),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      dashaFalText,
                      style: _fontRegular(isGujarati, 7.2, darkBg, height: 1.25),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }),

          const Spacer(),
          _buildFooter(isGujarati),
        ],
      ),
    );
  }

  // =========================================================================
  // COMMON HELPER WIDGETS & FORMATTERS
  // =========================================================================

  static Widget _buildA4Container({required Widget child}) {
    return Container(
      width: a4Width,
      height: a4Height,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Stack(
        children: [
          // Background subtle watermark
          Center(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/sanatandrishti_logo.png',
                width: 320,
                height: 320,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }

  static Widget _buildHeader({
    required int pageNumber,
    required String subtitle,
    required bool isGujarati,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: maroonColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: goldColor, width: 1.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/sanatandrishti_logo.png',
                    width: 24,
                    height: 24,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.auto_awesome, color: goldColor, size: 20),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SanatanDrishti - Vedic Janam Kundali',
                        style: _fontOutfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: goldColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: _fontRegular(isGujarati, 7.8, Colors.white.withAlpha(230)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: goldColor,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'Page $pageNumber of 5',
              style: _fontOutfit(
                fontSize: 8.5,
                fontWeight: FontWeight.bold,
                color: maroonColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildFooter(bool isGujarati) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: borderCol, width: 0.6)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isGujarati
                ? 'સનાતન દૃષ્ટિ વૈદિક જ્યોતિષ સંસ્થા  •  સર્વે ભવન્તુ સુખિનઃ'
                : 'सनातन दृष्टि वैदिक ज्योतिष संस्थान  •  सर्वे भवन्तु सुखिनः',
            style: _fontRegular(isGujarati, 7.2, maroonColor),
          ),
          Text(
            'SanatanDrishti App',
            style: _fontOutfit(
              fontSize: 7.2,
              fontWeight: FontWeight.bold,
              color: maroonColor,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildInfoRow(String label, String value, bool isGujarati, {bool isHighlight = false, bool isBoldValue = false}) {
    return Row(
      children: [
        SizedBox(
          width: 85,
          child: Text(
            label,
            style: _fontRegular(isGujarati, 7.6, darkBg.withAlpha(210)),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: isHighlight
                ? _fontBold(isGujarati, 7.8, maroonColor)
                : (isBoldValue ? _fontBold(isGujarati, 7.6, darkBg) : _fontRegular(isGujarati, 7.6, darkBg)),
          ),
        ),
      ],
    );
  }

  static Widget _buildChartBox({
    required String title,
    required Widget chartWidget,
    required bool isGujarati,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            color: maroonColor,
            borderRadius: BorderRadius.circular(3),
          ),
          child: Text(
            title,
            style: _fontBold(isGujarati, 7.2, goldColor),
          ),
        ),
        const SizedBox(height: 3),
        Container(
          width: 172,
          height: 172,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: goldColor, width: 1.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: chartWidget,
        ),
      ],
    );
  }

  static Widget _buildGrahaSpashtaTable(KundaliResult kundali, bool isGujarati) {
    return Table(
      border: TableBorder.all(color: borderCol, width: 0.5),
      columnWidths: const {
        0: FlexColumnWidth(1.4),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1.0),
        3: FlexColumnWidth(1.0),
        4: FlexColumnWidth(1.2),
      },
      children: [
        // Header
        TableRow(
          decoration: const BoxDecoration(color: maroonColor),
          children: [
            _buildTableHeaderCell(isGujarati ? 'ગ્રહ' : 'ग्रह', isGujarati),
            _buildTableHeaderCell(isGujarati ? 'રાશિ' : 'राशि', isGujarati),
            _buildTableHeaderCell(isGujarati ? 'ભાવ' : 'भाव', isGujarati),
            _buildTableHeaderCell(isGujarati ? 'અંશ' : 'अंश', isGujarati),
            _buildTableHeaderCell(isGujarati ? 'સ્થિતિ' : 'स्थिति', isGujarati),
          ],
        ),
        // Lagna Row
        TableRow(
          decoration: const BoxDecoration(color: Color(0xFFFFF3CD)),
          children: [
            _buildTableCell(isGujarati ? 'લગ્ન (Lagna)' : 'लग्न (Lagna)', isGujarati, isBold: true, color: maroonColor),
            _buildTableCell(_getRashiName(kundali.lagnaRashiId, isGujarati), isGujarati, align: TextAlign.center, isBold: true),
            _buildTableCell(isGujarati ? '૧ લો ભાવ' : '१ ला भाव', isGujarati, align: TextAlign.center),
            _buildTableCell('${kundali.lagnaDegree.toStringAsFixed(2)}°', isGujarati, align: TextAlign.center),
            _buildTableCell(isGujarati ? 'ઉદય લગ્ન' : 'उदय लग्न', isGujarati, align: TextAlign.center),
          ],
        ),
        // 9 Planets
        ...kundali.planets.map((planet) {
          final rashiName = _getRashiName(planet.rashiId, isGujarati);
          final dignity = KundaliCalculator.getPlanetDignity(planet);
          final dignityLabel = isGujarati ? (dignity['labelGu'] as String) : (dignity['labelHi'] as String);
          final retroStr = planet.isRetrograde ? (isGujarati ? ' (વક્રી)' : ' (वक्री)') : '';

          return TableRow(
            decoration: const BoxDecoration(color: Colors.white),
            children: [
              _buildTableCell('${isGujarati ? planet.nameGu : planet.nameHi}$retroStr', isGujarati),
              _buildTableCell(rashiName, isGujarati, align: TextAlign.center),
              _buildTableCell(isGujarati ? '${planet.houseNumber} મો' : '${planet.houseNumber} वां', isGujarati, align: TextAlign.center),
              _buildTableCell(planet.formattedDegree, isGujarati, align: TextAlign.center),
              _buildTableCell(dignityLabel, isGujarati, align: TextAlign.center),
            ],
          );
        }),
      ],
    );
  }

  static Widget _buildAspectCard({
    required String title,
    required String desc,
    String? badge,
    required List<String> tags,
    required bool isGujarati,
  }) {
    return Container(
      padding: const EdgeInsets.all(5.5),
      decoration: BoxDecoration(
        color: lightCard,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: borderCol, width: 0.8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: _fontBold(isGujarati, 8.5, maroonColor),
              ),
              if (badge != null && badge.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  decoration: BoxDecoration(
                    color: maroonColor.withAlpha(20),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: borderCol, width: 0.5),
                  ),
                  child: Text(
                    badge,
                    style: _fontBold(isGujarati, 7.2, maroonColor),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            desc,
            style: _fontRegular(isGujarati, 7.3, darkBg, height: 1.25),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 2.5),
            Wrap(
              spacing: 3,
              runSpacing: 2,
              children: tags.take(4).map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(
                    color: lightRow,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: borderCol.withAlpha(150), width: 0.4),
                  ),
                  child: Text(
                    '• $tag',
                    style: _fontRegular(isGujarati, 6.6, maroonColor),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  static Widget _buildBhavaQuadCard({
    required String title,
    required String desc,
    required bool isGujarati,
  }) {
    return Container(
      padding: const EdgeInsets.all(4.5),
      decoration: BoxDecoration(
        color: lightRow,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: borderCol.withAlpha(120), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: _fontBold(isGujarati, 7.6, maroonColor),
          ),
          const SizedBox(height: 1.5),
          Text(
            desc,
            style: _fontRegular(isGujarati, 7.0, darkBg, height: 1.25),
          ),
        ],
      ),
    );
  }

  static Widget _buildTableHeaderCell(String text, bool isGujarati) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 3.5, horizontal: 2),
      alignment: Alignment.center,
      child: Text(
        text,
        style: _fontBold(isGujarati, 7.5, goldColor),
        textAlign: TextAlign.center,
      ),
    );
  }

  static Widget _buildTableCell(
    String text,
    bool isGujarati, {
    TextAlign align = TextAlign.left,
    bool isBold = false,
    Color color = darkBg,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 3.5),
      alignment: align == TextAlign.center ? Alignment.center : Alignment.centerLeft,
      child: Text(
        text,
        style: isBold ? _fontBold(isGujarati, 7.2, color) : _fontRegular(isGujarati, 7.2, color),
        textAlign: align,
      ),
    );
  }

  static Widget _buildDashaTable(KundaliResult kundali, bool isGujarati) {
    return Table(
      border: TableBorder.all(color: borderCol, width: 0.5),
      columnWidths: const {
        0: FlexColumnWidth(1.5),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1.2),
        3: FlexColumnWidth(1.2),
      },
      children: [
        // Header
        TableRow(
          decoration: const BoxDecoration(color: maroonColor),
          children: [
            _buildTableHeaderCell(isGujarati ? 'મહાદશા ગ્રહ' : 'महादशा ग्रह', isGujarati),
            _buildTableHeaderCell(isGujarati ? 'પ્રારંભ તારીખ' : 'प्रारंभ तिथि', isGujarati),
            _buildTableHeaderCell(isGujarati ? 'સમાપ્તિ તારીખ' : 'समाप्ति तिथि', isGujarati),
            _buildTableHeaderCell(isGujarati ? 'સ્થિતિ' : 'स्थिति', isGujarati),
          ],
        ),
        // 9 Dashas
        ...kundali.dashas.asMap().entries.map((entry) {
          final idx = entry.key + 1;
          final d = entry.value;
          final lordName = isGujarati ? d.planetNameGu : d.planetNameHi;
          final statusStr = d.isCurrent
              ? (isGujarati ? 'ચાલુ છે (ACTIVE)' : 'सक्रिय (ACTIVE)')
              : (isGujarati ? 'સામાન્ય' : 'सामान्य');

          final startStr = DateFormat('dd/MM/yyyy').format(d.startDate);
          final endStr = DateFormat('dd/MM/yyyy').format(d.endDate);

          return TableRow(
            decoration: BoxDecoration(
              color: d.isCurrent ? const Color(0xFFFFF3CD) : Colors.white,
            ),
            children: [
              _buildTableCell(
                '$idx. $lordName (${d.durationYears} ${isGujarati ? 'વર્ષ' : 'वर्ष'})',
                isGujarati,
                isBold: d.isCurrent,
                color: d.isCurrent ? maroonColor : darkBg,
              ),
              _buildTableCell(startStr, isGujarati, align: TextAlign.center),
              _buildTableCell(endStr, isGujarati, align: TextAlign.center),
              _buildTableCell(
                statusStr,
                isGujarati,
                align: TextAlign.center,
                isBold: d.isCurrent,
                color: d.isCurrent ? maroonColor : darkBg,
              ),
            ],
          );
        }),
      ],
    );
  }

  static TextStyle _fontOutfit({
    required double fontSize,
    FontWeight fontWeight = FontWeight.normal,
    Color color = darkBg,
  }) {
    try {
      return GoogleFonts.outfit(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      );
    } catch (_) {
      return TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontFamilyFallback: const ['Outfit', 'Roboto', 'sans-serif'],
      );
    }
  }

  static TextStyle _fontBold(bool isGujarati, double size, Color color, {double? height}) {
    try {
      if (isGujarati) {
        return GoogleFonts.notoSansGujarati(
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: color,
          height: height,
        );
      } else {
        return GoogleFonts.notoSansDevanagari(
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: color,
          height: height,
        );
      }
    } catch (_) {
      return TextStyle(
        fontSize: size,
        fontWeight: FontWeight.bold,
        color: color,
        height: height,
        fontFamilyFallback: isGujarati
            ? const ['Noto Sans Gujarati', 'Gujarati Sangam MN', 'Shruti', 'sans-serif']
            : const ['Noto Sans Devanagari', 'Devanagari Sangam MN', 'Mangal', 'sans-serif'],
      );
    }
  }

  static TextStyle _fontRegular(bool isGujarati, double size, Color color, {double? height}) {
    try {
      if (isGujarati) {
        return GoogleFonts.notoSansGujarati(
          fontSize: size,
          fontWeight: FontWeight.normal,
          color: color,
          height: height,
        );
      } else {
        return GoogleFonts.notoSansDevanagari(
          fontSize: size,
          fontWeight: FontWeight.normal,
          color: color,
          height: height,
        );
      }
    } catch (_) {
      return TextStyle(
        fontSize: size,
        fontWeight: FontWeight.normal,
        color: color,
        height: height,
        fontFamilyFallback: isGujarati
            ? const ['Noto Sans Gujarati', 'Gujarati Sangam MN', 'Shruti', 'sans-serif']
            : const ['Noto Sans Devanagari', 'Devanagari Sangam MN', 'Mangal', 'sans-serif'],
      );
    }
  }

  static String _getRashiName(int rashiId, bool isGujarati) {
    final rashi = RashiData.getRashiById(rashiId);
    return isGujarati ? rashi.gujaratiName : rashi.hindiName;
  }
}
