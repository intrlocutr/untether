import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untether/model/reports.dart';
import 'package:untether/model/survey.dart';
import 'package:untether/model/questions.dart';

import '../main.dart';

class SurveyPage extends StatefulWidget {
  const SurveyPage({Key? key}) : super(key: key);

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State {
  bool isChecked = false;
  List<SurveyAnswer?> surveyAnswersList =
  List.filled(untetherQuestions.questions.length, null);
  String _currentTimeSpentValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survey'),
      ),
      body: ListView(
        children: List.generate(untetherQuestions.questions.length, (index) {
          var question = untetherQuestions.questions[index];
          return Container(
              child: Column(children: [
                Text(
                  question.question,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.visible,
                  style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                Column(
                    children: question.answers.map((answer) {
                      return RadioListTile<SurveyAnswer>(
                        title: Text(answer.answer, overflow: TextOverflow.visible),
                        value: answer,
                        groupValue: surveyAnswersList[index],
                        onChanged: (SurveyAnswer? value) {
                          setState(() {
                            surveyAnswersList[index] = value;
                          });
                        },
                      );
                    }).toList()
                ),
              ])
          );
        })..addAll([
          Container(
            child: Column(children: [
              TextField(
                decoration: const InputDecoration(
                    labelText: "Time spent on Social Media in minutes"),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (String value) {
                  setState(() {
                    _currentTimeSpentValue = value;
                  });
                },
              ),
            ]),
          ),
          Container(
            child: Row(
              children: <Widget>[
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'External Factors: ',
                  style: TextStyle(fontSize: 17.0),
                ),
                const SizedBox(width: 10),
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Container(
            child: ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  child: const Text('Submit'),
                  onPressed: () {
                    Report report = Report(
                      score: untetherQuestions.scoreSurvey(surveyAnswersList),
                      timestamp: DateTime.now(),
                      usageMinutes: int.parse(_currentTimeSpentValue),
                      externalFactor: isChecked,
                    );
                    reportDb.insertReport(report);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}