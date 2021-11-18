import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untether/db/provider.dart';
import 'package:untether/model/questions.dart';
import 'package:untether/model/reports.dart';
import 'package:untether/model/survey.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

late ReportDatabase reportDb;

void main() {
  reportDb = ReportDatabase();
  runApp(
    MaterialApp(
      restorationScopeId: 'app',
      title: 'Untether',
      // Start the app with the "/" named route. In this case, the app starts
      // on the FirstScreen widget.
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => const HomePage(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/survey': (context) => const SurveyPage(),
        '/report': (context) => const ReportPage(restorationId: 'main'),
      },
    ),
  );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to Untether'),
      ),
      body: Center(
        child: ButtonBar(
          alignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Survey'),
              style: ElevatedButton.styleFrom(elevation: 8.0),
              onPressed: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, '/survey');
              },
            ),
            ElevatedButton(
              child: const Text('Reports'),
              style: ElevatedButton.styleFrom(elevation: 8.0),
              onPressed: () {
                // Navigate to the second screen using a named route.
                Navigator.pushNamed(context, '/report');
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SurveyPage extends StatefulWidget {
  const SurveyPage({Key? key}) : super(key: key);

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State {
  List<SurveyAnswer?> surveyAnswersList =
      List.filled(untetherQuestions.questions.length, null);
  double _currentSliderValue = 0.5;
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
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Column(
                children: question.answers.map((answer) {
              return RadioListTile<SurveyAnswer>(
                title: Text(answer.answer),
                value: answer,
                groupValue: surveyAnswersList[index],
                onChanged: (SurveyAnswer? value) {
                  setState(() {
                    surveyAnswersList[index] = value;
                  });
                },
              );
            }).toList()),
          ]));
        })
          ..addAll([
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
              child: Slider(
                value: _currentSliderValue,
                min: 0,
                max: 1,
                divisions: 100,
                onChanged: (double value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),
            ),
            Container(
              child: ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text('Home'),
                    style: ElevatedButton.styleFrom(elevation: 8.0),
                    onPressed: () {
                      // Navigate to the second screen using a named route.
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    child: const Text('Submit'),
                    style: ElevatedButton.styleFrom(elevation: 8.0),
                    onPressed: () {
                      Report report = Report(
                          score: _currentSliderValue,
                          timestamp: DateTime.now(),
                          usageMinutes: int.parse(_currentTimeSpentValue));
                      reportDb.insertReport(report);
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

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key, this.restorationId}) : super(key: key);

  final String? restorationId;

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;

  final RestorableDateTimeN _startDate =
      RestorableDateTimeN(DateTime.now().subtract(const Duration(days: 7)));
  final RestorableDateTimeN _endDate = RestorableDateTimeN(DateTime.now());
  late final RestorableRouteFuture<DateTimeRange?>
      _restorableDateRangePickerRouteFuture =
      RestorableRouteFuture<DateTimeRange?>(
    onComplete: _selectDateRange,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator
          .restorablePush(_dateRangePickerRoute, arguments: <String, dynamic>{
        'initialStartDate': _startDate.value?.millisecondsSinceEpoch,
        'initialEndDate': _endDate.value?.millisecondsSinceEpoch,
      });
    },
  );

  void _selectDateRange(DateTimeRange? newSelectedDate) {
    if (newSelectedDate != null) {
      setState(() {
        _startDate.value = newSelectedDate.start;
        _endDate.value = newSelectedDate.end;
      });
    }
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_startDate, 'start_date');
    registerForRestoration(_endDate, 'end_date');
    registerForRestoration(
        _restorableDateRangePickerRouteFuture, 'date_picker_route_future');
  }

  static Route<DateTimeRange?> _dateRangePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTimeRange?>(
      context: context,
      builder: (BuildContext context) {
        return DateRangePickerDialog(
          restorationId: 'date_picker_dialog',
          initialDateRange:
              _initialDateTimeRange(arguments! as Map<dynamic, dynamic>),
          firstDate: DateTime(2021, 1, 1),
          currentDate: DateTime(2021, 1, 25),
          lastDate: DateTime(2022, 1, 1),
        );
      },
    );
  }

  static DateTimeRange? _initialDateTimeRange(Map<dynamic, dynamic> arguments) {
    if (arguments['initialStartDate'] != null &&
        arguments['initialEndDate'] != null) {
      return DateTimeRange(
        start: DateTime.fromMillisecondsSinceEpoch(
            arguments['initialStartDate'] as int),
        end: DateTime.fromMillisecondsSinceEpoch(
            arguments['initialEndDate'] as int),
      );
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: ButtonBar(
        alignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            child: const Text('Dates'),
            style: ElevatedButton.styleFrom(elevation: 8.0),
            onPressed: () {
              _restorableDateRangePickerRouteFuture.present();
            },
          ),
          ElevatedButton(
            // Within the SecondScreen widget
            onPressed: () {
              // Navigate back to the first screen by popping the current route
              // off the stack.
              Navigator.pop(context);
            },
            child: const Text('Home'),
          ),
        ],
      ),
    );
  }
}
