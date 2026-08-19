import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import '../providers/language_provider.dart';

class CityLocation {
  final String name;
  final String nameHindi;
  final String? nameGujarati;
  final double latitude;
  final double longitude;
  final double timezone;
  final bool isSacred;

  const CityLocation({
    required this.name,
    required this.nameHindi,
    this.nameGujarati,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    this.isSacred = false,
  });

  String getLocalizedName(AppLanguage lang) {
    if (lang == AppLanguage.gujarati) {
      if (nameGujarati != null && nameGujarati!.isNotEmpty) {
        return nameGujarati!;
      }
      return _convertToGujarati(nameHindi);
    }
    return nameHindi;
  }

  static String _convertToGujarati(String devanagariText) {
    final buffer = StringBuffer();
    for (int i = 0; i < devanagariText.length; i++) {
      final codeUnit = devanagariText.codeUnitAt(i);
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

  Map<String, dynamic> toJson() => {
        'name': name,
        'nameHindi': nameHindi,
        'nameGujarati': nameGujarati,
        'latitude': latitude,
        'longitude': longitude,
        'timezone': timezone,
        'isSacred': isSacred,
      };

  factory CityLocation.fromJson(Map<String, dynamic> json) => CityLocation(
        name: json['name'] ?? '',
        nameHindi: json['nameHindi'] ?? '',
        nameGujarati: json['nameGujarati'],
        latitude: (json['latitude'] as num?)?.toDouble() ?? 28.6139,
        longitude: (json['longitude'] as num?)?.toDouble() ?? 77.2090,
        timezone: (json['timezone'] as num?)?.toDouble() ?? 5.5,
        isSacred: json['isSacred'] ?? false,
      );
}

class LocationService {
  static const List<CityLocation> presetCities = [
    // Sacred Pilgrimage Cities (તીર્થ ક્ષેત્ર / तीर्थ क्षेत्र)
    CityLocation(
      name: 'Varanasi (Kashi)',
      nameHindi: 'वाराणसी (काशी)',
      nameGujarati: 'વારાણસી (કાશી)',
      latitude: 25.3176,
      longitude: 82.9739,
      timezone: 5.5,
      isSacred: true,
    ),
    CityLocation(
      name: 'Ujjain (Mahakal)',
      nameHindi: 'उज्जैन (महाकाल)',
      nameGujarati: 'ઉજ્જૈન (મહાકાલ)',
      latitude: 23.1765,
      longitude: 75.7885,
      timezone: 5.5,
      isSacred: true,
    ),
    CityLocation(
      name: 'Ayodhya',
      nameHindi: 'अयोध्या',
      nameGujarati: 'અયોધ્યા',
      latitude: 26.7922,
      longitude: 82.1998,
      timezone: 5.5,
      isSacred: true,
    ),
    CityLocation(
      name: 'Mathura - Vrindavan',
      nameHindi: 'मथुरा - वृन्दावन',
      nameGujarati: 'મથુરા - વૃંદાવન',
      latitude: 27.4924,
      longitude: 77.6737,
      timezone: 5.5,
      isSacred: true,
    ),
    CityLocation(
      name: 'Haridwar - Rishikesh',
      nameHindi: 'हरिद्वार - ऋषिकेश',
      nameGujarati: 'હરિદ્વાર - ઋષિકેશ',
      latitude: 29.9457,
      longitude: 78.1642,
      timezone: 5.5,
      isSacred: true,
    ),
    CityLocation(
      name: 'Puri (Jagannath)',
      nameHindi: 'पुरी (जगन्नाथ धाम)',
      nameGujarati: 'પુરી (જગન્નાથ ધામ)',
      latitude: 19.8135,
      longitude: 85.8312,
      timezone: 5.5,
      isSacred: true,
    ),
    CityLocation(
      name: 'Rameswaram',
      nameHindi: 'रामेश्वरम',
      nameGujarati: 'રામેશ્વરમ',
      latitude: 9.2876,
      longitude: 79.3129,
      timezone: 5.5,
      isSacred: true,
    ),
    CityLocation(
      name: 'Dwarka',
      nameHindi: 'द्वारका (द्वारकाधीश)',
      nameGujarati: 'દ્વારકા (દ્વારકાધીશ)',
      latitude: 22.2442,
      longitude: 68.9685,
      timezone: 5.5,
      isSacred: true,
    ),
    CityLocation(
      name: 'Tirupati',
      nameHindi: 'तिरुपति (बालाजी)',
      nameGujarati: 'તિરુપતિ (બાલાજી)',
      latitude: 13.6288,
      longitude: 79.4192,
      timezone: 5.5,
      isSacred: true,
    ),
    CityLocation(
      name: 'Somnath',
      nameHindi: 'सोमनाथ (प्रभात पाटन)',
      nameGujarati: 'સોમનાથ (પ્રભાસ પાટણ)',
      latitude: 20.8880,
      longitude: 70.4012,
      timezone: 5.5,
      isSacred: true,
    ),
    CityLocation(
      name: 'Badrinath',
      nameHindi: 'बद्रीनाथ',
      nameGujarati: 'બદ્રીનાથ',
      latitude: 30.7433,
      longitude: 79.4938,
      timezone: 5.5,
      isSacred: true,
    ),
    CityLocation(
      name: 'Kedarnath',
      nameHindi: 'केदारनाथ',
      nameGujarati: 'કેદારનાથ',
      latitude: 30.7352,
      longitude: 79.0669,
      timezone: 5.5,
      isSacred: true,
    ),
    CityLocation(
      name: 'Prayagraj',
      nameHindi: 'प्रयागराज (तीर्थराज)',
      nameGujarati: 'પ્રયાગરાજ (તીર્થરાજ)',
      latitude: 25.4358,
      longitude: 81.8463,
      timezone: 5.5,
      isSacred: true,
    ),
    CityLocation(
      name: 'Nashik (Trimbakeshwar)',
      nameHindi: 'नासिक (त्र्यंबकेश्वर)',
      nameGujarati: 'નાસિક (ત્ર્યંબકેશ્વર)',
      latitude: 19.9975,
      longitude: 73.7898,
      timezone: 5.5,
      isSacred: true,
    ),
    CityLocation(
      name: 'Kathmandu (Pashupatinath)',
      nameHindi: 'काठमांडू (पशुपतिनाथ)',
      nameGujarati: 'કાઠમંડુ (પશુપતિનાથ)',
      latitude: 27.7172,
      longitude: 85.3240,
      timezone: 5.75,
      isSacred: true,
    ),

    // Major Indian Cities & Metros (મુખ્ય ભારતીય નગરો)
    CityLocation(
      name: 'New Delhi',
      nameHindi: 'नई दिल्ली',
      nameGujarati: 'નવી દિલ્હી',
      latitude: 28.6139,
      longitude: 77.2090,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Mumbai',
      nameHindi: 'मुंबई',
      nameGujarati: 'મુંબઈ',
      latitude: 19.0760,
      longitude: 72.8777,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Ahmedabad',
      nameHindi: 'अहमदाबाद',
      nameGujarati: 'અમદાવાદ',
      latitude: 23.0225,
      longitude: 72.5714,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Surat',
      nameHindi: 'सूरत',
      nameGujarati: 'સુરત',
      latitude: 21.1702,
      longitude: 72.8311,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Vadodara',
      nameHindi: 'वडोदरा',
      nameGujarati: 'વડોદરા',
      latitude: 22.3072,
      longitude: 73.1812,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Rajkot',
      nameHindi: 'राजकोट',
      nameGujarati: 'રાજકોટ',
      latitude: 22.3039,
      longitude: 70.8022,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Bhavnagar',
      nameHindi: 'भावनगर',
      nameGujarati: 'ભાવનગર',
      latitude: 21.7645,
      longitude: 72.1519,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Jamnagar',
      nameHindi: 'जामनगर',
      nameGujarati: 'જામનગર',
      latitude: 22.4707,
      longitude: 70.0577,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Junagadh',
      nameHindi: 'जूनागढ़ (गिरनार)',
      nameGujarati: 'જૂનાગઢ (ગિરનાર)',
      latitude: 21.5222,
      longitude: 70.4579,
      timezone: 5.5,
      isSacred: true,
    ),
    CityLocation(
      name: 'Gandhinagar',
      nameHindi: 'गांधीनगर (अक्षरधाम)',
      nameGujarati: 'ગાંધીનગર (અક્ષરધામ)',
      latitude: 23.2156,
      longitude: 72.6369,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Pune',
      nameHindi: 'पुणे',
      nameGujarati: 'પુણે',
      latitude: 18.5204,
      longitude: 73.8567,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Nagpur',
      nameHindi: 'नागपुर',
      nameGujarati: 'નાગપુર',
      latitude: 21.1458,
      longitude: 79.0882,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Jaipur',
      nameHindi: 'जयपुर',
      nameGujarati: 'જયપુર',
      latitude: 26.9124,
      longitude: 75.7873,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Jodhpur',
      nameHindi: 'जोधपुर',
      nameGujarati: 'જોધપુર',
      latitude: 26.2389,
      longitude: 73.0243,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Indore',
      nameHindi: 'इन्दौर',
      nameGujarati: 'ઇન્દોર',
      latitude: 22.7196,
      longitude: 75.8577,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Bhopal',
      nameHindi: 'भोपाल',
      nameGujarati: 'ભોપાલ',
      latitude: 23.2599,
      longitude: 77.4126,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Bengaluru',
      nameHindi: 'बेंगलुरु',
      nameGujarati: 'બેંગલુરુ',
      latitude: 12.9716,
      longitude: 77.5946,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Hyderabad',
      nameHindi: 'हैदराबाद',
      nameGujarati: 'હૈદરાબાદ',
      latitude: 17.3850,
      longitude: 78.4867,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Chennai',
      nameHindi: 'चेन्नई',
      nameGujarati: 'ચેન્નઈ',
      latitude: 13.0827,
      longitude: 80.2707,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Kolkata',
      nameHindi: 'कोलकाता',
      nameGujarati: 'કોલકાતા',
      latitude: 22.5726,
      longitude: 88.3639,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Lucknow',
      nameHindi: 'लखनऊ',
      nameGujarati: 'લખનૌ',
      latitude: 26.8467,
      longitude: 80.9462,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Kanpur',
      nameHindi: 'कानपुर',
      nameGujarati: 'કાનપુર',
      latitude: 26.4499,
      longitude: 80.3319,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Patna',
      nameHindi: 'पटना',
      nameGujarati: 'પટના',
      latitude: 25.5941,
      longitude: 85.1376,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Chandigarh',
      nameHindi: 'चंडीगढ़',
      nameGujarati: 'ચંદીગઢ',
      latitude: 30.7333,
      longitude: 76.7794,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Ludhiana',
      nameHindi: 'लुधियाना',
      nameGujarati: 'લુધિયાણા',
      latitude: 30.9010,
      longitude: 75.8573,
      timezone: 5.5,
    ),
    CityLocation(
      name: 'Guwahati',
      nameHindi: 'गुवाहाटी (कामाख्या)',
      nameGujarati: 'ગુવાહાટી (કામાખ્યા)',
      latitude: 26.1445,
      longitude: 91.7362,
      timezone: 5.5,
      isSacred: true,
    ),

    // International Cities (આંતરરાષ્ટ્રીય શહેરો)
    CityLocation(
      name: 'London',
      nameHindi: 'लंदन (UK)',
      nameGujarati: 'લંડન (UK)',
      latitude: 51.5074,
      longitude: -0.1278,
      timezone: 0.0,
    ),
    CityLocation(
      name: 'New York',
      nameHindi: 'न्यू यॉर्क (USA)',
      nameGujarati: 'ન્યૂયોર્ક (USA)',
      latitude: 40.7128,
      longitude: -74.0060,
      timezone: -5.0,
    ),
    CityLocation(
      name: 'San Francisco',
      nameHindi: 'सैन फ्रांसिस्को (USA)',
      nameGujarati: 'સેન ફ્રાન્સિસ્કો (USA)',
      latitude: 37.7749,
      longitude: -122.4194,
      timezone: -8.0,
    ),
    CityLocation(
      name: 'Toronto',
      nameHindi: 'टोरंटो (कनाडा)',
      nameGujarati: 'ટોરોન્ટો (કેનેડા)',
      latitude: 43.6532,
      longitude: -79.3832,
      timezone: -5.0,
    ),
    CityLocation(
      name: 'Dubai',
      nameHindi: 'दुबई (UAE)',
      nameGujarati: 'દુબઈ (UAE)',
      latitude: 25.2048,
      longitude: 55.2708,
      timezone: 4.0,
    ),
    CityLocation(
      name: 'Singapore',
      nameHindi: 'सिंगापुर',
      nameGujarati: 'સિંગાપોર',
      latitude: 1.3521,
      longitude: 103.8198,
      timezone: 8.0,
    ),
    CityLocation(
      name: 'Sydney',
      nameHindi: 'सिडनी (ऑस्ट्रेलिया)',
      nameGujarati: 'સિડની (ઓસ્ટ્રેલિયા)',
      latitude: -33.8688,
      longitude: 151.2093,
      timezone: 10.0,
    ),
    CityLocation(
      name: 'Tokyo',
      nameHindi: 'टोक्यो (जापान)',
      nameGujarati: 'ટોક્યો (જાપાન)',
      latitude: 35.6762,
      longitude: 139.6503,
      timezone: 9.0,
    ),
  ];

  static CityLocation get defaultCity => presetCities.firstWhere(
        (c) => c.name == 'New Delhi',
        orElse: () => presetCities.first,
      );

  static CityLocation getCityByName(String name) {
    final lower = name.toLowerCase().trim();
    return presetCities.firstWhere(
      (c) =>
          c.name.toLowerCase() == lower ||
          c.nameHindi.toLowerCase() == lower ||
          (c.nameGujarati?.toLowerCase() == lower) ||
          c.name.toLowerCase().contains(lower) ||
          c.nameHindi.contains(name) ||
          (c.nameGujarati?.contains(name) ?? false),
      orElse: () => defaultCity,
    );
  }

  /// Calculates geodesic distance between two points in kilometers (Haversine formula)
  static double calculateDistanceKm(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371.0;
    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) * cos(_degreesToRadians(lat2)) * sin(dLon / 2) * sin(dLon / 2);
    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) => degrees * pi / 180.0;

  /// Finds the closest preset city from given coordinates
  static CityLocation findNearestPresetCity(double latitude, double longitude) {
    CityLocation closest = presetCities.first;
    double minDistance = double.infinity;

    for (final city in presetCities) {
      final dist = calculateDistanceKm(latitude, longitude, city.latitude, city.longitude);
      if (dist < minDistance) {
        minDistance = dist;
        closest = city;
      }
    }

    return closest;
  }

  /// Reverse geocodes coordinates to a human-readable city name
  static Future<String?> reverseGeocodeCoordinates(double lat, double lon) async {
    try {
      final dio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 4),
          receiveTimeout: const Duration(seconds: 4),
          headers: {'User-Agent': 'BhagvatGeetaPanchangApp/1.0'},
        ),
      );

      final response = await dio.get(
        'https://nominatim.openstreetmap.org/reverse',
        queryParameters: {
          'format': 'json',
          'lat': lat,
          'lon': lon,
          'zoom': 12,
          'addressdetails': 1,
        },
      );

      if (response.statusCode == 200 && response.data is Map) {
        final address = response.data['address'] as Map<String, dynamic>?;
        if (address != null) {
          final cityName = address['city'] ??
              address['town'] ??
              address['municipality'] ??
              address['suburb'] ??
              address['village'] ??
              address['county'] ??
              address['state_district'];
          if (cityName != null && cityName.toString().trim().isNotEmpty) {
            return cityName.toString().trim();
          }
        }
      }
    } catch (e) {
      debugPrint('Reverse geocoding network note: $e');
    }
    return null;
  }

  /// Fetches the user's live GPS location, reverse geocodes the exact city name,
  /// and configures exact coordinates & local timezone.
  Future<CityLocation> getCurrentOrFallbackLocation(String savedCityName) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return getCityByName(savedCityName);
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return getCityByName(savedCityName);
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return getCityByName(savedCityName);
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 6),
        ),
      );

      final localTimezoneOffset = DateTime.now().timeZoneOffset.inMinutes / 60.0;

      // 1. Attempt online reverse geocoding for precise town/city name
      final reverseName = await reverseGeocodeCoordinates(position.latitude, position.longitude);

      // 2. Find nearest preset landmark city
      final nearestPreset = findNearestPresetCity(position.latitude, position.longitude);
      final distToNearest = calculateDistanceKm(
        position.latitude,
        position.longitude,
        nearestPreset.latitude,
        nearestPreset.longitude,
      );

      String finalNameEn;
      String finalNameHi;
      String? finalNameGu;

      if (reverseName != null && reverseName.isNotEmpty) {
        finalNameEn = reverseName;
        // If nearest city is the same or within 25km, use traditional Hindi and Gujarati names
        if (distToNearest < 25 || nearestPreset.name.toLowerCase().contains(reverseName.toLowerCase())) {
          finalNameHi = nearestPreset.nameHindi;
          finalNameGu = nearestPreset.nameGujarati;
        } else {
          finalNameHi = reverseName;
          finalNameGu = CityLocation._convertToGujarati(reverseName);
        }
      } else if (distToNearest < 40) {
        finalNameEn = nearestPreset.name;
        finalNameHi = nearestPreset.nameHindi;
        finalNameGu = nearestPreset.nameGujarati;
      } else {
        finalNameEn = 'Near ${nearestPreset.name}';
        finalNameHi = '${nearestPreset.nameHindi} के समीप';
        finalNameGu = '${nearestPreset.nameGujarati ?? nearestPreset.nameHindi} નજીક';
      }

      return CityLocation(
        name: finalNameEn,
        nameHindi: finalNameHi,
        nameGujarati: finalNameGu,
        latitude: position.latitude,
        longitude: position.longitude,
        timezone: localTimezoneOffset,
        isSacred: distToNearest < 15 && nearestPreset.isSacred,
      );
    } catch (e) {
      debugPrint('Location lookup fallback: $e');
      return getCityByName(savedCityName);
    }
  }
}
