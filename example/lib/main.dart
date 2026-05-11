import 'package:flutter/material.dart';
import 'package:slive_core/slive_core.dart';

Future<void> main() async {
  await RustLib.init();
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
          child: FutureBuilder<String?>(
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
        ),
      ),
    );
  }
}
