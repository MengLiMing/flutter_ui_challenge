import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/pages/curves/curve_type.dart';

class CurveItem extends StatefulWidget {
  final CurveType curveType;

  const CurveItem({Key? key, required this.curveType}) : super(key: key);

  @override
  State<CurveItem> createState() => _CurveItemState();
}

class _CurveItemState extends State<CurveItem>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black38, blurRadius: 2),
      ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text(widget.curveType.name),
          ),
          SizedBox(
            height: 150,
            width: double.infinity,
            child: CustomPaint(
              painter: CurvePainter(),
            ),
          )
        ],
      ),
    );
  }
}

class CurvePainter extends CustomPainter {
  late final tTextPaint = TextPainter(
    textDirection: TextDirection.ltr,
    text: const TextSpan(
      text: '1.0',
      style: TextStyle(color: Colors.grey, fontSize: 13),
    ),
  )..layout();

  @override
  void paint(Canvas canvas, Size size) {
    _drawXY(canvas, size);
  }

  void _drawXY(Canvas canvas, Size size) {
    print(size);
    canvas.save();

    final leftSpace = tTextPaint.width * 2;
    final rightSpace = tTextPaint.width;

    final topSpace = tTextPaint.height / 2;
    final bottomSpace = tTextPaint.height * 2;

    canvas.translate(leftSpace, size.height - bottomSpace);

    final axisPaint = Paint()
      ..style = PaintingStyle.stroke
      ..color = Colors.black
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset.zero,
      Offset(0, -(size.height - bottomSpace - topSpace)),
      axisPaint,
    );

    canvas.drawLine(
      Offset.zero,
      Offset(size.width - leftSpace - rightSpace, 0),
      axisPaint,
    );

    canvas.restore();

    tTextPaint.paint(canvas, Offset(leftSpace / 4, 0));
    tTextPaint.paint(
        canvas, Offset(size.width - rightSpace, size.height - bottomSpace));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
