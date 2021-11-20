import 'package:flutter/material.dart';

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
              onPressed: () {
                Navigator.pushNamed(context, '/survey');
              },
            ),
            ElevatedButton(
              child: const Text('Reports'),
              onPressed: () {
                Navigator.pushNamed(context, '/report');
              },
            ),
          ],
        ),
      ),
    );
  }
}