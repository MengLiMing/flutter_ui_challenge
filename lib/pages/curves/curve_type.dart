import 'package:flutter/material.dart';

enum CurveType {
  bounceIn,
  bounceInOut,
  bounceOut,
  decelerate,
  ease,
  easeIn,
  easeInBack,
  easeInCirc,
  easeInCubic,
  easeInExpo,
  easeInOut,
  easeInOutBack,
  easeInOutCirc,
  easeInOutCubic,
  easeInOutCubicEmphasized,
  easeInOutExpo,
  easeInOutQuad,
  easeInOutQuart,
  easeInOutQuint,
  easeInOutSine,
  easeInQuad,
  easeInQuart,
  easeInQuint,
  easeInSine,
  easeInToLinear,
  easeOut,
  easeOutBack,
  easeOutCirc,
  easeOutCubic,
  easeOutExpo,
  easeOutQuad,
  easeOutQuart,
  easeOutQuint,
  easeOutSine,
  elasticIn,
  elasticInOut,
  elasticOut,
  fastLinearToSlowEaseIn,
  fastOutSlowIn,
  linear,
  linearToEaseOut,
  slowMiddle,
}

Curve curveBy(CurveType curveType) {
  switch (curveType) {
    case CurveType.bounceIn:
      return Curves.bounceIn;
    case CurveType.bounceInOut:
      return Curves.bounceInOut;
    case CurveType.bounceOut:
      return Curves.bounceOut;
    case CurveType.decelerate:
      return Curves.decelerate;
    case CurveType.ease:
      return Curves.ease;
    case CurveType.easeIn:
      return Curves.easeIn;
    case CurveType.easeInBack:
      return Curves.easeInBack;
    case CurveType.easeInCirc:
      return Curves.easeInCirc;
    case CurveType.easeInCubic:
      return Curves.easeInCubic;
    case CurveType.easeInExpo:
      return Curves.easeInExpo;
    case CurveType.easeInOut:
      return Curves.easeInOut;
    case CurveType.easeInOutBack:
      return Curves.easeInOutBack;
    case CurveType.easeInOutCirc:
      return Curves.easeInOutCirc;
    case CurveType.easeInOutCubic:
      return Curves.easeInOutCubic;
    case CurveType.easeInOutCubicEmphasized:
      return Curves.easeInOutCubicEmphasized;
    case CurveType.easeInOutExpo:
      return Curves.easeInOutExpo;
    case CurveType.easeInOutQuad:
      return Curves.easeInOutQuad;
    case CurveType.easeInOutQuart:
      return Curves.easeInOutQuart;
    case CurveType.easeInOutQuint:
      return Curves.easeInOutQuint;
    case CurveType.easeInOutSine:
      return Curves.easeInOutSine;
    case CurveType.easeInQuad:
      return Curves.easeInQuad;
    case CurveType.easeInQuart:
      return Curves.easeInQuart;
    case CurveType.easeInQuint:
      return Curves.easeInQuint;
    case CurveType.easeInSine:
      return Curves.easeInSine;
    case CurveType.easeInToLinear:
      return Curves.easeInToLinear;
    case CurveType.easeOut:
      return Curves.easeOut;
    case CurveType.easeOutBack:
      return Curves.easeOutBack;
    case CurveType.easeOutCirc:
      return Curves.easeOutCirc;
    case CurveType.easeOutCubic:
      return Curves.easeOutCubic;
    case CurveType.easeOutExpo:
      return Curves.easeOutExpo;
    case CurveType.easeOutQuad:
      return Curves.easeOutQuad;
    case CurveType.easeOutQuart:
      return Curves.easeOutQuart;
    case CurveType.easeOutQuint:
      return Curves.easeOutQuint;
    case CurveType.easeOutSine:
      return Curves.easeOutSine;
    case CurveType.elasticIn:
      return Curves.elasticIn;
    case CurveType.elasticInOut:
      return Curves.elasticInOut;
    case CurveType.elasticOut:
      return Curves.elasticOut;
    case CurveType.fastLinearToSlowEaseIn:
      return Curves.fastLinearToSlowEaseIn;
    case CurveType.fastOutSlowIn:
      return Curves.fastOutSlowIn;
    case CurveType.linear:
      return Curves.linear;
    case CurveType.linearToEaseOut:
      return Curves.linearToEaseOut;
    case CurveType.slowMiddle:
      return Curves.slowMiddle;
  }
}
