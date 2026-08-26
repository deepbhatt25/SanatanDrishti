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
                ? 'જાતક પરિચય, જન્મ લગ્ન, નવાંશ, ચંદ્ર કુંડળી અને ગ્રહ સ્પષ્ટ સ્થિતિ'
                : 'जातक विवरण, जन्म लग्न, नवमांश, चन्द्र कुंडली एवं ग्रह स्पष्ट स्थिति',
            isGujarati: isGujarati,
          ),
          const SizedBox(height: 8),

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
                        DateFormat('dd MMMM yyyy').format(kundali.profile.dateOfBirth),
                        isGujarati,
                      ),
                      const SizedBox(height: 2),
                      _buildInfoRow(isGujarati ? 'જન્મ સમય (Time):' : 'जन्म समय (Time):', kundali.profile.formattedTime, isGujarati),
                      const SizedBox(height: 2),
                      _buildInfoRow(isGujarati ? 'જન્મ સ્થળ (Place):' : 'जन्म स्थान (Place):', kundali.profile.cityName, isGujarati),
                      const SizedBox(height: 2),
                      _buildInfoRow(
                        isGujarati ? 'અક્ષાંશ/રેખાંશ:' : 'अक्षांश/रेखांश:',
                        '${kundali.profile.latitude.toStringAsFixed(2)}°N, ${kundali.profile.longitude.toStringAsFixed(2)}°E',
                        isGujarati,
                      ),
                      const SizedBox(height: 2),
                      _buildInfoRow(
                        isGujarati ? 'અયનાંશ (Ayanamsha):' : 'अयनांश (Ayanamsha):',
                        'Lahiri 23°51\'22" (Nirayana)',
                        isGujarati,
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
                            isGujarati ? 'અવકહડા ચક્ર (Avakahada Chakra)' : 'अवकहड़ा चक्र (Avakahada Chakra)',
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
          const SizedBox(height: 8),

          // 2. 3 North Indian Vedic Charts Side-by-Side
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
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
                      chartWidget: KundaliChartPainter(
                        kundali: kundali,
                        isGujarati: isGujarati,
                        isNavamsha: false,
                        isChandra: false,
                        isDark: false,
                      ),
                      isGujarati: isGujarati,
                    ),
                    _buildChartBox(
                      title: isGujarati ? '૨. નવાંશ કુંડળી (Navamsha D9)' : '२. नवमांश कुंडली (Navamsha D9)',
                      chartWidget: KundaliChartPainter(
                        kundali: kundali,
                        isGujarati: isGujarati,
                        isNavamsha: true,
                        isChandra: false,
                        isDark: false,
                      ),
                      isGujarati: isGujarati,
                    ),
                    _buildChartBox(
                      title: isGujarati ? '૩. ચંદ્ર કુંડળી (Chandra)' : '३. चन्द्र कुंडली (Chandra)',
                      chartWidget: KundaliChartPainter(
                        kundali: kundali,
                        isGujarati: isGujarati,
                        isNavamsha: false,
                        isChandra: true,
                        isDark: false,
                      ),
                      isGujarati: isGujarati,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                // Planet abbreviations legend
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
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
          const SizedBox(height: 8),

          // 3. Graha Spashta Table (10 Rows)
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
                      isGujarati ? 'ગ્રહ સ્પષ્ટ સ્થિતિ (Graha Spashta - Planetary Positions)' : 'ग्रह स्पष्ट स्थिति (Graha Spashta - Planetary Positions)',
                      style: _fontBold(isGujarati, 9.5, maroonColor),
                    ),
                    Text(
                      isGujarati ? 'નિરાયણ પદ્ધતિ (Lahiri Ayanamsha)' : 'निरयण पद्धति (Lahiri Ayanamsha)',
                      style: _fontRegular(isGujarati, 8.0, maroonColor.withAlpha(200)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
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
  // PAGE 3: Special Yogas, Manglik Dosha, Kaal Sarp, Mahadasha, Mantras
  // =========================================================================
  static Widget buildPage3({
    required KundaliResult kundali,
    required bool isGujarati,
  }) {
    final pred = kundali.lifePrediction;

    return _buildA4Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(
            pageNumber: 3,
            subtitle: isGujarati
                ? 'રાજયોગ, માંગલિક દોષ, કાળસર્પ, સાડાસાતી, ૧૨૦ વર્ષ વિંશોત્તરી મહાદશા & મંત્ર'
                : 'राजयोग, मांगलिक दोष, कालसर्प, साढ़ेसाती, १२० वर्ष विंशोत्तरी महादशा & मंत्र',
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
                          '• લક્ષ્મી યોગ & અમલા યોગ: ભાગ્ય સ્થાન અને કેન્દ્ર સ્થાનના અધિપતિઓની અનુકૂળ દ્રષ્ટિથી ધનલાભ અને અવિરત સુખસંપત્તિ મળે છે.'
                      : '• बुधादित्य राजयोग: सूर्य एवं बुध की युति से तीव्र बुद्धिमत्ता, प्रशासनिक क्षमता, वाकपटुता एवं यश प्राप्त होता है।\n'
                          '• गजकेसरी योग: गुरु व चन्द्र के केंद्र संबंध से दीर्घकालिक समृद्धि, धार्मिक बुद्धि, लोकप्रियता एवं परिवार सुख मिलता है।\n'
                          '• लक्ष्मी योग & अमला योग: भाग्य व केन्द्र भाव स्वामियों की शुभ दृष्टि से अखंड धनलाभ व वैभव प्राप्त होता है।',
                  style: _fontRegular(isGujarati, 7.6, darkBg, height: 1.35),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // 2. Manglik Dosha Analysis
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
                  '${isGujarati ? 'શાંતિ ઉપાય:' : 'शांति उपाय:'} ${isGujarati ? kundali.mangalDosha.remedyGu : kundali.mangalDosha.remedyHi}',
                  style: _fontBold(isGujarati, 7.6, const Color(0xFF9C2A10), height: 1.3),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // 3. Kaal Sarp & Shani Sade Sati Analysis
          Builder(
            builder: (context) {
              final doshaAnalysis = KundaliCalculator.calculateDoshaAnalysis(
                planets: kundali.planets,
                moonRashiId: kundali.moonRashiId,
                lagnaRashiId: kundali.lagnaRashiId,
              );
              return Container(
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
                              '• ${doshaAnalysis.rudrakshaGu.replaceAll('• ', '')} | ${doshaAnalysis.gemstoneGu.replaceAll('• ', '')}'
                          : '• कालसर्प स्थिति: [${doshaAnalysis.kaalSarpNameHi}] ${doshaAnalysis.kaalSarpDescHi}\n'
                              '• शनि साढ़ेसाती: [${doshaAnalysis.shaniStatusHi}] ${doshaAnalysis.shaniDescHi}\n'
                              '• ${doshaAnalysis.vedicMantraHi}\n'
                              '• ${doshaAnalysis.rudrakshaHi.replaceAll('• ', '')} | ${doshaAnalysis.gemstoneHi.replaceAll('• ', '')}',
                      style: _fontRegular(isGujarati, 7.6, darkBg, height: 1.35),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 5),

          // 4. 120-Year Vimshottari Mahadasha Table
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isGujarati ? '૧૨૦ વર્ષ વિંશોત્તરી મહાદશા ચક્ર (Vimshottari Mahadasha 120 Years)' : '१२० वर्ष विंशोत्तरी महादशा चक्र (Vimshottari Mahadasha 120 Years)',
                      style: _fontBold(isGujarati, 9.5, maroonColor),
                    ),
                    Text(
                      isGujarati ? 'કુલ અવધિ: ૧૨૦ વર્ષ' : 'कुल अवधि: १२० वर्ष',
                      style: _fontRegular(isGujarati, 8.0, maroonColor.withAlpha(200)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                _buildDashaTable(kundali, isGujarati),
              ],
            ),
          ),
          const SizedBox(height: 5),

          // 5. Spiritual Guidance & Sacred Mantras
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
              'Page $pageNumber of 3',
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
          Expanded(
            child: Row(
              children: [
                ClipOval(
                  child: Image.asset(
                    'assets/images/sanatandrishti_logo.png',
                    width: 14,
                    height: 14,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(Icons.stars, color: maroonColor, size: 12),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    isGujarati
                        ? 'SanatanDrishti App • પંચાંગ, ગીતા, કુંડળી & રાશિફળ'
                        : 'SanatanDrishti App • पञ्चाङ्ग, गीता, कुंडली एवं राशिफल',
                    style: _fontBold(isGujarati, 7.2, maroonColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            'Google Play & App Store | www.sanatandrishti.app',
            style: _fontOutfit(
              fontSize: 7.2,
              color: darkBg.withAlpha(180),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildInfoRow(
    String label,
    String value,
    bool isGujarati, {
    bool isBoldValue = false,
    bool isHighlight = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 95,
          child: Text(
            label,
            style: _fontBold(isGujarati, 7.8, darkBg),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: isHighlight
                ? _fontBold(isGujarati, 7.8, maroonColor)
                : (isBoldValue ? _fontBold(isGujarati, 7.8, darkBg) : _fontRegular(isGujarati, 7.8, darkBg)),
          ),
        ),
      ],
    );
  }

  static Widget _buildChartBox({
    required String title,
    required CustomPainter chartWidget,
    required bool isGujarati,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: maroonColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            title,
            style: _fontBold(isGujarati, 7.5, Colors.white),
          ),
        ),
        const SizedBox(height: 3),
        Container(
          width: 155,
          height: 145,
          decoration: BoxDecoration(
            color: const Color(0xFFFFF8EE),
            border: Border.all(color: maroonColor, width: 1.0),
          ),
          child: CustomPaint(
            painter: chartWidget,
          ),
        ),
      ],
    );
  }

  static Widget _buildGrahaSpashtaTable(KundaliResult kundali, bool isGujarati) {
    final ascendantName = isGujarati ? 'લગ્ન (Asc)' : 'लग्न (Asc)';
    final ascendantRashiName = _getRashiName(kundali.lagnaRashiId, isGujarati);
    final ascendantLord = _getRashiLord(kundali.lagnaRashiId, isGujarati);
    final ascendantNak = isGujarati ? kundali.nakshatraGu : kundali.nakshatraHi;

    return Table(
      border: TableBorder.all(color: borderCol, width: 0.5),
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(0.9),
        3: FlexColumnWidth(0.7),
        4: FlexColumnWidth(1.5),
        5: FlexColumnWidth(0.7),
        6: FlexColumnWidth(1.3),
        7: FlexColumnWidth(1.0),
      },
      children: [
        // Header Row
        TableRow(
          decoration: const BoxDecoration(color: maroonColor),
          children: [
            _buildTableHeaderCell(isGujarati ? 'ગ્રહ' : 'ग्रह', isGujarati),
            _buildTableHeaderCell(isGujarati ? 'રાશિ' : 'राशि', isGujarati),
            _buildTableHeaderCell(isGujarati ? 'અંશ' : 'अंश', isGujarati),
            _buildTableHeaderCell(isGujarati ? 'ભાવ' : 'भाव', isGujarati),
            _buildTableHeaderCell(isGujarati ? 'નક્ષત્ર' : 'नक्षत्र', isGujarati),
            _buildTableHeaderCell(isGujarati ? 'પાદ' : 'पाद', isGujarati),
            _buildTableHeaderCell(isGujarati ? 'રાશિ સ્વામી' : 'राशि स्वामी', isGujarati),
            _buildTableHeaderCell(isGujarati ? 'ગતિ' : 'गति', isGujarati),
          ],
        ),
        // Ascendant Row
        _buildTableRow(
          planetName: ascendantName,
          rashi: '$ascendantRashiName (${kundali.lagnaRashiId})',
          degree: '${kundali.lagnaDegree.toStringAsFixed(1)}°',
          house: '1',
          nakshatra: ascendantNak,
          pada: '${kundali.charan}',
          lord: ascendantLord,
          motion: isGujarati ? 'ઉદય' : 'उदय',
          isEven: false,
          isRetro: false,
          isGujarati: isGujarati,
          isAscendant: true,
        ),
        // 9 Planets Rows
        ...kundali.planets.asMap().entries.map((entry) {
          final idx = entry.key;
          final p = entry.value;
          final pName = isGujarati ? p.nameGu : p.nameHi;
          final pRashiName = _getRashiName(p.rashiId, isGujarati);
          final pLord = _getRashiLord(p.rashiId, isGujarati);
          final pNak = p.nakshatra;
          final motionStr = p.isRetrograde
              ? (isGujarati ? 'વક્રી (R)' : 'वक्री (R)')
              : (isGujarati ? 'માર્ગી' : 'मार्गी');

          return _buildTableRow(
            planetName: pName,
            rashi: '$pRashiName (${p.rashiId})',
            degree: '${p.degree.toStringAsFixed(1)}°',
            house: '${p.houseNumber}',
            nakshatra: pNak,
            pada: '${p.pada}',
            lord: pLord,
            motion: motionStr,
            isEven: idx % 2 == 1,
            isRetro: p.isRetrograde,
            isGujarati: isGujarati,
          );
        }),
      ],
    );
  }

  static TableRow _buildTableRow({
    required String planetName,
    required String rashi,
    required String degree,
    required String house,
    required String nakshatra,
    required String pada,
    required String lord,
    required String motion,
    required bool isEven,
    required bool isRetro,
    required bool isGujarati,
    bool isAscendant = false,
  }) {
    final bgColor = isEven ? lightRow : Colors.white;
    return TableRow(
      decoration: BoxDecoration(color: bgColor),
      children: [
        _buildTableCell(planetName, isGujarati, isBold: true, color: isAscendant ? maroonColor : darkBg),
        _buildTableCell(rashi, isGujarati, isBold: isAscendant, color: isAscendant ? maroonColor : darkBg),
        _buildTableCell(degree, isGujarati, align: TextAlign.center),
        _buildTableCell(house, isGujarati, align: TextAlign.center, isBold: true),
        _buildTableCell(nakshatra, isGujarati),
        _buildTableCell(pada, isGujarati, align: TextAlign.center),
        _buildTableCell(lord, isGujarati),
        _buildTableCell(
          motion,
          isGujarati,
          align: TextAlign.center,
          isBold: isRetro || isAscendant,
          color: isRetro ? const Color(0xFFC0392B) : (isAscendant ? const Color(0xFF1E824C) : const Color(0xFF27AE60)),
        ),
      ],
    );
  }

  static Widget _buildTableHeaderCell(String text, bool isGujarati) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 2),
      child: Text(
        text,
        style: _fontBold(isGujarati, 7.5, Colors.white),
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.2, horizontal: 3),
      child: Text(
        text,
        style: isBold ? _fontBold(isGujarati, 7.2, color) : _fontRegular(isGujarati, 7.2, color),
        textAlign: align,
      ),
    );
  }

  static Widget _buildAspectCard({
    required String title,
    required String desc,
    required List<String> tags,
    required bool isGujarati,
    String? badge,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
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
                title,
                style: _fontBold(isGujarati, 8.8, maroonColor),
              ),
              if (badge != null && badge.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3CD),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: const Color(0xFFFFEEBA), width: 0.8),
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
            style: _fontRegular(isGujarati, 7.4, darkBg, height: 1.3),
          ),
          if (tags.isNotEmpty) ...[
            const SizedBox(height: 3),
            Wrap(
              spacing: 4,
              runSpacing: 2,
              children: tags.map((t) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.2),
                  decoration: BoxDecoration(
                    color: maroonColor.withAlpha(14),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: maroonColor.withAlpha(50), width: 0.5),
                  ),
                  child: Text(
                    t,
                    style: _fontBold(isGujarati, 6.8, maroonColor),
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
      padding: const EdgeInsets.all(4),
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
          const SizedBox(height: 1),
          Text(
            desc,
            style: _fontRegular(isGujarati, 6.9, darkBg, height: 1.25),
          ),
        ],
      ),
    );
  }

  static Widget _buildDashaTable(KundaliResult kundali, bool isGujarati) {
    return Table(
      border: TableBorder.all(color: borderCol, width: 0.5),
      columnWidths: const {
        0: FlexColumnWidth(1.8),
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

  static String _getRashiLord(int rashiId, bool isGujarati) {
    final rashi = RashiData.getRashiById(rashiId);
    return isGujarati ? rashi.rulingPlanetGujarati : rashi.rulingPlanet;
  }
}
