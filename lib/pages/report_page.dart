import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:untether/model/reports.dart';

import '../main.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({Key? key}) : super(key: key);

  final String? restorationId = 'main';

  @override
  _ReportPageState createState() => _ReportPageState();
}

class SimpleBarChart extends StatelessWidget {
  final List<charts.Series<dynamic, String>> seriesList;
  final bool animate;

  SimpleBarChart(this.seriesList, {required this.animate});

  factory SimpleBarChart.withData(List<Report> data) {
    return SimpleBarChart(
      _translateData(data),
      animate: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
    );
  }

  static List<charts.Series<Report, String>> _translateData(List<Report> data) {
    List<double> scores = data.map((r) => r.score).toList()..sort();
    var colors = charts.MaterialPalette.blue.makeShades(scores.length);
    return [
      charts.Series<Report, String>(
        id: 'Report',
        colorFn: (Report report, _) => report.externalFactor
            ? charts.MaterialPalette.black
            : colors[scores.indexOf(report.score)],
        domainFn: (Report report, _) =>
            report.timestamp.toString().split(' ')[0],
        measureFn: (Report report, _) => report.usageMinutes,
        data: data,
      )
    ];
  }
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

  void _selectDateRange(DateTimeRange? newSelectedDate) async {
    if (newSelectedDate != null) {
      Iterable<Report> chartIterable = await reportDb.readReports(DateTimeRange(
          start: newSelectedDate.start, end: newSelectedDate.end));
      chartData = chartIterable.toList();
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
        DateTime today = DateTime.now();
        return DateRangePickerDialog(
          restorationId: 'date_picker_dialog',
          initialDateRange:
          _initialDateTimeRange(arguments! as Map<dynamic, dynamic>),
          firstDate: DateTime(today.year, today.month, 1),
          currentDate: today,
          lastDate: today.add(const Duration(days: 30)),
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
        body: Column(children: [
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Select Dates'),
                onPressed: () {
                  _restorableDateRangePickerRouteFuture.present();
                },
              ),
            ],
          ),
          chartData.isNotEmpty
              ? Container(
              height: 200, child: SimpleBarChart.withData(chartData))
              : const SizedBox.shrink(),
          const Text(
            'The lighter colors reflect better moods as inferred from the survey. Black represents a day with heavy external factors.',
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ])
    );
  }
}