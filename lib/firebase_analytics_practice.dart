import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class FirebaseAnalyticsPractice extends StatefulWidget {
  const FirebaseAnalyticsPractice({super.key});

  @override
  State<FirebaseAnalyticsPractice> createState() => _FirebaseAnalyticsPracticeState();
}

class _FirebaseAnalyticsPracticeState extends State<FirebaseAnalyticsPractice> {

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  @override
  void initState() {
    super.initState();

  }

  Future<void> logAppOpenEvent() async {
    await _analytics.logEvent(
      name: 'login',
      parameters: <String, dynamic>{
        'key' : 'value'
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      body: Center(
        child: ElevatedButton(onPressed: () {
          logAppOpenEvent();
        },
        child: const Text("Login"),

        ),
      ),
    ));
  }

  // Future<void> logAppOpenEvent() async {
  //   await _analytics.logEvent(
  //     name: 'app_open',
  //     parameters: <String, dynamic>{},
  //   );
}
