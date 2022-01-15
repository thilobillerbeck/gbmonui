import 'dart:convert';

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

class Settings {
  final int contrast;
  final int brightness;
  final int gamma;
  final int black_equalizer;
  final int color_vibrance;
  final int color_temperature;
  final int sharpness;
  final int low_blue_light;
  final int super_resolution;
  final int overdrive;

  factory Settings.fromJson(Map<String, dynamic> data) {
    final contrast = data['contrast'] as int;
    final brightness = data['brightness'] as int;
    final gamma = data['gamma'] as int;
    final black_equalizer = data['black_equalizer'] as int;
    final color_vibrance = data['color_vibrance'] as int;
    final color_temperature = data['color_temperature'] as int;
    final sharpness = data['sharpness'] as int;
    final low_blue_light = data['low_blue_light'] as int;
    final super_resolution = data['super_resolution'] as int;
    final overdrive = data['overdrive'] as int;

    return Settings(
        contrast,
        brightness,
        gamma,
        black_equalizer,
        color_vibrance,
        color_temperature,
        sharpness,
        low_blue_light,
        super_resolution,
        overdrive);
  }

  Settings(
      this.contrast,
      this.brightness,
      this.gamma,
      this.black_equalizer,
      this.color_vibrance,
      this.color_temperature,
      this.sharpness,
      this.low_blue_light,
      this.super_resolution,
      this.overdrive);
}

Future<Settings> getSettings() async {
  final results = await Process.run('gbmoncli', ["--print", "true"]);
  final settingsDec = jsonDecode(results.stdout);
  final settings = Settings.fromJson(settingsDec);
  return settings;
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<Settings> _settings = getSettings();
  bool initialized = false;

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder<Settings>(
            future: _settings,
            builder: (
              BuildContext context,
              AsyncSnapshot<Settings> snapshot,
            ) {
              if (snapshot.hasData) {
                return Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RangeSlider(
                        initialValue: snapshot.data!.brightness.toDouble(),
                        label: "Brightness",
                        flag: "-b",
                      ),
                      RangeSlider(
                        initialValue: snapshot.data!.contrast.toDouble(),
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
                        initialValue: snapshot.data!.black_equalizer.toDouble(),
                        label: "Black Equalizer",
                        flag: "-e",
                      ),
                      RangeSlider(
                        min: 0,
                        max: 20,
                        initialValue: snapshot.data!.color_vibrance.toDouble(),
                        label: "Vibrance",
                        flag: "--color-vibrance",
                      ),
                      RangeSlider(
                        min: 0,
                        max: 10,
                        initialValue: snapshot.data!.sharpness.toDouble(),
                        label: "Sharpness",
                        flag: "--sharpness",
                      ),
                      RangeSlider(
                        min: 0,
                        max: 4,
                        initialValue:
                            snapshot.data!.super_resolution.toDouble(),
                        label: "Super Resolution",
                        flag: "--super-resolution",
                      ),
                      RangeSlider(
                        min: 0,
                        max: 5,
                        initialValue: snapshot.data!.gamma.toDouble(),
                        label: "Gamma",
                        flag: "--gamma",
                      ),
                      RangeSlider(
                        min: 0,
                        max: 10,
                        initialValue: snapshot.data!.low_blue_light.toDouble(),
                        label: "Low Blue Light",
                        flag: "--low-blue-light",
                      ),
                    ],
                  ),
                );
              } else {
                return Center(child: Text("data"));
              }
            }));
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
                sendCommandToMonitor(
                    widget.flag, "${widget.initialValue.round()}");
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
