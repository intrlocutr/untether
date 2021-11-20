import 'package:flutter/material.dart';
import 'package:untether/db/provider.dart';
import 'package:untether/model/reports.dart';
import 'package:untether/pages/home_page.dart';
import 'package:untether/pages/report_page.dart';
import 'package:untether/pages/survey_page.dart';

late ReportDatabase reportDb;
List<Report> chartData = [];

void main() {
  reportDb = ReportDatabase();
  runApp(
    MaterialApp(
      restorationScopeId: 'app',
      title: 'Untether',
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/survey': (context) => const SurveyPage(),
        '/report': (context) => const ReportPage(),
      },
    ),
  );
}
