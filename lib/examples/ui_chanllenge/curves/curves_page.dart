import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/ui_chanllenge/curves/curve_type.dart';
import 'package:flutter_ui_challenge/examples/ui_chanllenge/curves/curves_item.dart';

class CurvesPage extends StatelessWidget {
  static const route = 'Curves - 效果展示';
  const CurvesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const curves = CurveType.values;
    return Scaffold(
      appBar: AppBar(
        title: Text('${curves.length}种Curve效果'),
      ),
      body: ListView.separated(
        padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).padding.bottom),
        itemBuilder: (context, index) {
          return CurveItem(curveType: curves[index]);
        },
        separatorBuilder: (context, index) => const SizedBox(height: 10),
        itemCount: curves.length,
      ),
    );
  }
}
