import 'package:flutter/material.dart';
import 'package:slive_core/slive_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init();
  CoreLog.startRustLog();

  testLog();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('slive_core example')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder<String?>(
                future: detectPlatform(
                  url: 'https://live.bilibili.com/12345',
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  return Text('Platform: ${snapshot.data ?? "unknown"}');
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => testLog(),
                child: const Text('Test Rust Logs'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
