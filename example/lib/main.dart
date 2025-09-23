import 'package:flutter/material.dart';
import 'package:number_field/number_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Field Example',
      theme: ThemeData(
        colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: Colors.blue,
            onPrimary: Colors.white,
            secondary: Colors.blue,
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black),
      ),
      builder: (context, child) =>
          NumberKeyboardViewInsets(child: child ?? const SizedBox.shrink()),
      home: const MyHomePage(
        title: 'Number Field Example',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _controller = NumberEditingController(
    decimalDigits: 2,
  );
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              NumberField(
                controller: _controller,
                textAlign: TextAlign.center,
                keyboardStyles: NumberKeyboardStyles(
                  widthRatio: 2,
                ),
                onChanged: (value) {
                  print('Value changed: $value');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
