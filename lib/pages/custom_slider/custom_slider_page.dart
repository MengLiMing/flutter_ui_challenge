import 'package:flutter/material.dart';

class CustomSliderPage extends StatelessWidget {
  static const route = '自定义Slider: 自定义Widget+RenderObject';
  const CustomSliderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('自定义Slider'),
      ),
      body: Container(),
    );
  }
}
