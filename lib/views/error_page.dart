import 'package:flutter/material.dart';
import 'welcome_page.dart';
import 'package:kiwi/constants/app_strings.dart';

class ErrorPage extends StatelessWidget {
  final Object error;
  final StackTrace? stackTrace;

  const ErrorPage({super.key, required this.error, this.stackTrace});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                Text(
                  AppStrings.appInitFailed,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  error.toString(),
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    // WelcomePageに遷移（再起動風）
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => WelcomePage()),
                      (route) => false,
                    );
                  },
                  child: Text(AppStrings.restart),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
