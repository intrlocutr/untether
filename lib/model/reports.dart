/// A report for a single day.
class Report {
  /// Timestamp of this report.
  final DateTime timestamp;

  /// Minutes of usage since the start of the day.
  final int usageMinutes;

  /// Score on the mental assessment.
  final double score;

  /// Whether or not an external factor to social media usage could
  /// have affected this report.
  final bool externalFactor;

  Report({
    required this.timestamp,
    required this.usageMinutes,
    required this.score,
    required this.externalFactor
  });

  /// Constructs a `Report` from a `Map`.
  Report.fromMap(Map<String, dynamic> map)
      : timestamp = DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
        usageMinutes = map['usageMinutes'],
        score = map['score'],
        externalFactor = map['externalFactor'] as bool;

  /// Converts the `Report` to a `Map` for inserting into a database.
  Map<String, dynamic> toMap() {
    return {
      'timestamp': timestamp.millisecondsSinceEpoch,
      'usageMinutes': usageMinutes,
      'score': score,
      'externalFactor': externalFactor as int
    };
  }

  @override
  String toString() {
    return 'Report{timestamp: ${timestamp.toString()}, usageMinutes: $usageMinutes, score: $score, externalFactor: $externalFactor}';
  }
}
