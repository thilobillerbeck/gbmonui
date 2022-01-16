import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';

import 'classes/settings.dart';
import 'components/rangeslider.dart';

void main() {
  runApp(const GbMonUi());
}

class GbMonUi extends StatelessWidget {
  const GbMonUi({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.grey[900],
        scaffoldBackgroundColor: Colors.grey[900],
        textTheme: TextTheme(
          headline6: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      home: const HomePage(title: 'Gigabyte Monitor UI'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

Future<Settings> getSettings() async {
  final results = await Process.run('gbmoncli', ["--print", "true"]);
  final settingsDec = jsonDecode(results.stdout);
  final settings = Settings.fromJson(settingsDec);
  return settings;
}

class _HomePageState extends State<HomePage> {
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
                      ValueSlider(
                        initialValue: snapshot.data!.brightness.toDouble(),
                        label: "Brightness",
                        flag: "-b",
                      ),
                      ValueSlider(
                        initialValue: snapshot.data!.contrast.toDouble(),
                        label: "Red",
                        flag: "--red",
                      ),
                      ValueSlider(
                        initialValue: 100,
                        label: "Green",
                        flag: "--green",
                      ),
                      ValueSlider(
                        initialValue: 100,
                        label: "Blue",
                        flag: "--blue",
                      ),
                      ValueSlider(
                        initialValue: 50,
                        label: "Contrast",
                        flag: "-c",
                      ),
                      ValueSlider(
                        min: 0,
                        max: 20,
                        initialValue: snapshot.data!.black_equalizer.toDouble(),
                        label: "Black Equalizer",
                        flag: "-e",
                      ),
                      ValueSlider(
                        min: 0,
                        max: 20,
                        initialValue: snapshot.data!.color_vibrance.toDouble(),
                        label: "Vibrance",
                        flag: "--color-vibrance",
                      ),
                      ValueSlider(
                        min: 0,
                        max: 10,
                        initialValue: snapshot.data!.sharpness.toDouble(),
                        label: "Sharpness",
                        flag: "--sharpness",
                      ),
                      ValueSlider(
                        min: 0,
                        max: 4,
                        initialValue:
                            snapshot.data!.super_resolution.toDouble(),
                        label: "Super Resolution",
                        flag: "--super-resolution",
                      ),
                      ValueSlider(
                        min: 0,
                        max: 5,
                        initialValue: snapshot.data!.gamma.toDouble(),
                        label: "Gamma",
                        flag: "--gamma",
                      ),
                      ValueSlider(
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
