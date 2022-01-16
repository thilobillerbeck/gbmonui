import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';

class ValueSlider extends StatefulWidget {
  final double initialValue;
  final double min;
  final double max;
  final String label;
  final String flag;

  ValueSlider(
      {Key? key,
      this.initialValue = 0,
      this.label = "Val",
      this.flag = "-b",
      this.min = 0,
      this.max = 100})
      : super(key: key);

  @override
  _ValueSliderState createState() => _ValueSliderState();
}

class _ValueSliderState extends State<ValueSlider> {
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
