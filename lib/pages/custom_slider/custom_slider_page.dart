import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/pages/custom_slider/custom_slider.dart';

class CustomSliderPage extends StatelessWidget {
  static const route = '自定义Slider: 自定义Widget+RenderObject';
  CustomSliderPage({Key? key}) : super(key: key);

  final ValueNotifier<double> progress = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('自定义Slider'),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder(
              valueListenable: progress,
              builder: (context, value, _) {
                return Text('$value');
              },
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: CustomSlider(
                barColor: Colors.blue,
                thumbColor: Colors.red,
                thumbSize: 20,
                barHeight: 5,
                progressChanged: (value) => progress.value = value,
                progress: progress.value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
