import 'package:untether/model/survey.dart';

SurveySchema untetherQuestions = SurveySchema(
  questions: <SurveyQuestion>[
    SurveyQuestion(question: 'How difficult was your day?', weight: 0.15, answers: <SurveyAnswer>[
      SurveyAnswer(answer: '1 š', pointValue: 10),
      SurveyAnswer(answer: '2 š', pointValue: 9),
      SurveyAnswer(answer: '3 š', pointValue: 8),
      SurveyAnswer(answer: '4 š', pointValue: 7),
      SurveyAnswer(answer: '5 š', pointValue: 6),
      SurveyAnswer(answer: '6 š', pointValue: 5),
      SurveyAnswer(answer: '7 š', pointValue: 4),
      SurveyAnswer(answer: '8 š', pointValue: 3),
      SurveyAnswer(answer: '9 š ', pointValue: 2),
      SurveyAnswer(answer: '10 š”', pointValue: 1),
    ]),
    SurveyQuestion(question: 'Did anything out of your control happen today?', weight: 0.1, answers: <SurveyAnswer>[
      SurveyAnswer(answer: 'No', pointValue: 3),
      SurveyAnswer(answer: 'Not really, but...', pointValue: 2),
      SurveyAnswer(answer: 'Kind of', pointValue: 1),
      SurveyAnswer(answer: 'Very much so', pointValue: 0),
    ]),
    SurveyQuestion(question: 'How much did event(s) out of your control affect your mental space today?', weight: 0.2, answers: <SurveyAnswer>[
      SurveyAnswer(answer: 'Not at all', pointValue: 0),
      SurveyAnswer(answer: 'Not really, but...', pointValue: 1),
      SurveyAnswer(answer: 'Kind of', pointValue: 2),
      SurveyAnswer(answer: 'Very much so', pointValue: 3),
    ]),
    SurveyQuestion(question: 'I felt lesser than someone else', weight: 0.15, answers: <SurveyAnswer>[
      SurveyAnswer(answer: 'Yes', pointValue: 0),
      SurveyAnswer(answer: 'No', pointValue: 1),
    ]),
    SurveyQuestion(question: 'Iām still thinking about a comment I saw', weight: 0.1, answers: <SurveyAnswer>[
      SurveyAnswer(answer: 'Yes', pointValue: 0),
      SurveyAnswer(answer: 'No', pointValue: 1),
    ]),
    SurveyQuestion(question: 'I felt anxious because of something I saw online', weight: 0.15, answers: <SurveyAnswer>[
      SurveyAnswer(answer: 'Yes', pointValue: 0),
      SurveyAnswer(answer: 'No', pointValue: 1),
    ]),
    SurveyQuestion(question: 'How many times did you view topics that made you feel these emotions?', weight: 0.1, answers: <SurveyAnswer>[
      SurveyAnswer(answer: '0', pointValue: 10),
      SurveyAnswer(answer: '1', pointValue: 9),
      SurveyAnswer(answer: '2', pointValue: 8),
      SurveyAnswer(answer: '3', pointValue: 7),
      SurveyAnswer(answer: '4', pointValue: 6),
      SurveyAnswer(answer: '5', pointValue: 5),
      SurveyAnswer(answer: '6', pointValue: 4),
      SurveyAnswer(answer: '7', pointValue: 3),
      SurveyAnswer(answer: '8', pointValue: 2),
      SurveyAnswer(answer: '9', pointValue: 1),
      SurveyAnswer(answer: '10+', pointValue: 0),
    ]),
  ]
);