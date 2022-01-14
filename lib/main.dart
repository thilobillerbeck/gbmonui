import 'package:flutter/material.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'Gigabyte Monitor UI'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  double _brightnessSliderValue = 50;
  double _constrastSliderValue = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RangeSlider(
              initialValue: 50,
              label: "Brightness",
              flag: "-b",
            ),
            RangeSlider(
              initialValue: 100,
              label: "Red",
              flag: "--red",
            ),
            RangeSlider(
              initialValue: 100,
              label: "Green",
              flag: "--green",
            ),
            RangeSlider(
              initialValue: 100,
              label: "Blue",
              flag: "--blue",
            ),
            RangeSlider(
              initialValue: 50,
              label: "Contrast",
              flag: "-c",
            ),
            RangeSlider(
              min: 0,
              max: 20,
              initialValue: 10,
              label: "Black Equalizer",
              flag: "-e",
            ),
            RangeSlider(
              min: 0,
              max: 20,
              initialValue: 10,
              label: "Vibrance",
              flag: "--color-vibrance",
            ),
            RangeSlider(
              min: 0,
              max: 10,
              initialValue: 5,
              label: "Sharpness",
              flag: "--sharpness",
            ),
            RangeSlider(
              min: 0,
              max: 4,
              initialValue: 0,
              label: "Super Resolution",
              flag: "--super-resolution",
            ),
            RangeSlider(
              min: 0,
              max: 5,
              initialValue: 3,
              label: "Gamma",
              flag: "--gamma",
            ),
            RangeSlider(
              min: 0,
              max: 10,
              initialValue: 0,
              label: "Low Blue Light",
              flag: "--low-blue-light",
            ),
          ],
        ),
      ),
    );
  }
}

class RangeSlider extends StatefulWidget {
  final double initialValue;
  final double min;
  final double max;
  final String label;
  final String flag;

  RangeSlider(
      {Key? key,
      this.initialValue = 0,
      this.label = "Val",
      this.flag = "-b",
      this.min = 0,
      this.max = 100})
      : super(key: key);

  @override
  _RangeSliderState createState() => _RangeSliderState();
}

class _RangeSliderState extends State<RangeSlider> {
  double _sliderValue = 0;

  void initState() {
    super.initState();
    _sliderValue = widget.initialValue;
  }

  void sendCommandToMonitor(String flag, String value) {
    Process.run('gbmoncli', [flag, value]).then((ProcessResult results) {
      print(results.stdout);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: [
        Text(
          widget.label,
        ),
        TextButton(
            onPressed: () {
            sendCommandToMonitor(widget.flag, "${widget.initialValue.round()}");
            setState(() {
              _sliderValue = widget.initialValue;
            });
            },
            child: const Text('Reset'),
          ),
          ],
        ),
        Slider(
          value: _sliderValue,
          divisions: widget.min == 0 ? widget.max.round() : null,
          max: widget.max,
          min: widget.min,
          label: _sliderValue.round().toString(),
          onChanged: (double value) {
            sendCommandToMonitor(widget.flag, "${value.round()}");
            setState(() {
              _sliderValue = value;
            });
          },
        ),
      ],
    );
  }
}
