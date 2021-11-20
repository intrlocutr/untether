class SurveyAnswer {
  final String answer;
  final double pointValue;

  SurveyAnswer({required this.answer, required this.pointValue});
}

class SurveyQuestion {
  /// The question that should be posed to the user.
  final String question;
  /// The weight of this question.
  final double weight;
  /// Possible answers for this question.
  late final List<SurveyAnswer> answers;

  /// The maximum possible points for this question.
  double get maxPoints {
    double max = 0;
    for (var a in answers) {
      if (a.pointValue > max) max = a.pointValue;
    }
    return max;
  }

  SurveyQuestion({
    required this.question,
    required this.weight,
    required this.answers
  });
}

class SurveySchema {
  /// The questions to be asked by this survey;
  final List<SurveyQuestion> questions;

  /// Score the survey with the given answers.
  double scoreSurvey(List<SurveyAnswer?> answers) {
    double max = 0;
    double score = 0;
    for (var i = 0; i < questions.length; i++) {
      max += questions[i].maxPoints;
      score += answers[i]!.pointValue;
    }
    return score / max;
  }

  SurveySchema({required this.questions});
}