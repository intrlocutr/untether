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
    return max * weight;
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

  /// The maximum possible score for this survey.
  double get maxScore {
    double max = 0;
    for (var q in questions) {
      max += q.maxPoints;
    }
    return max;
  }

  /// Score the survey with the given answers.
  double score(List<double> answers) {
    return answers.reduce((a, b) => a + b) / maxScore;
  }

  SurveySchema({required this.questions});
}