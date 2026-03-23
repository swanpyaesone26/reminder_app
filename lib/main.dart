import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Test',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple),
      home: const TestPage(),
    );
  }
}

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  int _counter = 0;
  String _message = 'Hello, Flutter!';
  bool _isDark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text('Flutter Playground'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text test
            Text(
              _message,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Counter test
            Text('Counter: $_counter', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _counter--),
                  child: const Text('-'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () => setState(() => _counter++),
                  child: const Text('+'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Toggle dark mode test
            Switch(
              value: _isDark,
              onChanged: (val) => setState(() => _isDark = val),
            ),
            Text(_isDark ? 'Dark Mode ON' : 'Dark Mode OFF'),
            const SizedBox(height: 20),

            // Snackbar test
            ElevatedButton(
              onPressed: () {
                setState(() => _message = 'Button Pressed! 🎉');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Snackbar works!')),
                );
              },
              child: const Text('Test Snackbar'),
            ),
          ],
        ),
      ),
    );
  }
}