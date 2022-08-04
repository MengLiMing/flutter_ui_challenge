import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/pages/curves/curve_type.dart';
import 'package:flutter_ui_challenge/pages/curves/curves_item.dart';

class CurvesPage extends StatelessWidget {
  static const route = 'Curves - 效果展示';
  const CurvesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final curves = CurveType.values;
    return Scaffold(
      appBar: AppBar(
        title: Text('${curves.length}种Curve效果'),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        itemBuilder: (context, index) {
          return CurveItem(curveType: curves[index]);
        },
        separatorBuilder: (context, index) => SizedBox(height: 10),
        itemCount: curves.length,
      ),
    );
  }
}
