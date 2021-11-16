import 'package:untether/model/survey.dart';

SurveySchema untetherQuestions = SurveySchema(
  questions: <SurveyQuestion>[
    SurveyQuestion(question: 'Fake Question', weight: 2.0, answers: <SurveyAnswer>[
      SurveyAnswer(answer: 'ans1', pointValue: 0.3),
      SurveyAnswer(answer: 'ans2', pointValue: 0.5),
      SurveyAnswer(answer: 'ans3', pointValue: 0.8)
    ]),
    SurveyQuestion(question: 'Question 2', weight: 4.0, answers: <SurveyAnswer>[
      SurveyAnswer(answer: 'Yes', pointValue: 2),
      SurveyAnswer(answer: 'No', pointValue: 0.5),
      SurveyAnswer(answer: 'Maybe', pointValue: 1.0),
      SurveyAnswer(answer: 'Definitely Not', pointValue: 0.1),
    ]),
    SurveyQuestion(question: 'Meaningless question', weight: 0.1, answers: <SurveyAnswer>[
      SurveyAnswer(answer: 'Who cares', pointValue: 0.2),
      SurveyAnswer(answer: 'Asdf', pointValue: 0.5),
      SurveyAnswer(answer: 'Booooo', pointValue: 0.0001),
      SurveyAnswer(answer: 'fffff', pointValue: 0.1),
      SurveyAnswer(answer: 'Are we done yet?', pointValue: 1.2),
    ]),
  ]
);