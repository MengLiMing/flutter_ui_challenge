import 'package:flutter/material.dart';

class CustomSlider extends LeafRenderObjectWidget {
  const CustomSlider({Key? key}) : super(key: key);

  @override
  CustomSliderRender createRenderObject(BuildContext context) {
    return CustomSliderRender();
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant CustomSliderRender renderObject,
  ) {}
}

class CustomSliderRender extends RenderBox {}
