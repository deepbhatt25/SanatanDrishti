enum ChoghadiyaQuality { shubh, char, ashubh }

class ChoghadiyaPeriod {
  final String nameHindi;
  final String nameGujarati;
  final String nameEn;
  final String planetHindi;
  final String planetGujarati;
  final ChoghadiyaQuality quality;
  final String qualityLabelHindi;
  final String qualityLabelGujarati;
  final String startTime;
  final String endTime;
  final int startMinutes;
  final int endMinutes;
  final bool isCurrent;

  const ChoghadiyaPeriod({
    required this.nameHindi,
    required this.nameGujarati,
    required this.nameEn,
    required this.planetHindi,
    required this.planetGujarati,
    required this.quality,
    required this.qualityLabelHindi,
    required this.qualityLabelGujarati,
    required this.startTime,
    required this.endTime,
    required this.startMinutes,
    required this.endMinutes,
    this.isCurrent = false,
  });
}

class DayNightChoghadiya {
  final List<ChoghadiyaPeriod> dayChoghadiya;
  final List<ChoghadiyaPeriod> nightChoghadiya;

  const DayNightChoghadiya({
    required this.dayChoghadiya,
    required this.nightChoghadiya,
  });
}
