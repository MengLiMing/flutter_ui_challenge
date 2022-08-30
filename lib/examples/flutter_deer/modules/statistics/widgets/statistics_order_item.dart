import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/widgets/statistics_order_chart.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/image_utils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';

class StatisticsOrderItem extends StatefulWidget {
  final Color bgColor;
  final String title;
  final List<int> numbers;
  final TextSpan Function(int number) content;

  const StatisticsOrderItem({
    Key? key,
    required this.bgColor,
    required this.title,
    required this.numbers,
    required this.content,
  }) : super(key: key);

  @override
  State<StatisticsOrderItem> createState() => _StatisticsOrderItemState();
}

class _StatisticsOrderItemState extends State<StatisticsOrderItem>
    with TickerProviderStateMixin {
  late AnimationController heightAnimationControler;

  late AnimationController showAnimationController;

  final StatisticsOrderLineRepaint _repaint = StatisticsOrderLineRepaint(
    heightProgress: ValueNotifier(0),
    showBubbleProgress: ValueNotifier(1),
  );

  @override
  void initState() {
    super.initState();

    heightAnimationControler =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..addListener(() {
            final heightProgress = Tween(begin: 0.0, end: 1.0)
                .chain(CurveTween(curve: Curves.easeInOut))
                .evaluate(heightAnimationControler);
            _repaint.heightProgress.value = heightProgress;
          })
          ..forward();

    showAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addListener(() {
        final showBubbleProgress = Tween(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut))
            .evaluate(showAnimationController);
        _repaint.showBubbleProgress.value = showBubbleProgress;
      });
  }

  @override
  void dispose() {
    heightAnimationControler.dispose();
    showAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.fit,
      margin: EdgeInsets.only(left: 16.fit, right: 16.fit, bottom: 16.fit),
      padding: EdgeInsets.only(top: 16.fit),
      decoration: BoxDecoration(
        color: widget.bgColor,
        image: DecorationImage(
          image: ImageUtils.getAssetImage('statistic/chart_fg'),
          fit: BoxFit.fill,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8.fit),
        ),
        boxShadow: [
          BoxShadow(
            color: widget.bgColor.withOpacity(0.5),
            offset: Offset(0, 2.fit),
            blurRadius: 8.fit,
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DefaultTextStyle(
            style: const TextStyle(color: Colors.white, fontSize: 14),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.fit),
              child: Row(
                children: [
                  Expanded(child: Text(widget.title)),
                  Text(
                      '${widget.numbers.reduce((value, element) => value + element)}'),
                ],
              ),
            ),
          ),
          Expanded(child: _chart()),
        ],
      ),
    );
  }

  Widget _chart() {
    return SizedBox.expand(
      child: GestureDetector(
        onTap: () {
          if (_repaint.isShowingBubble) {
            _repaint.isShowingBubble = false;
            showAnimationController.reverse(from: 1);
          } else {
            heightAnimationControler.forward(from: 0);
          }
        },
        onLongPressDown: (details) {
          _repaint.localPoint = details.localPosition;
        },
        onLongPress: () {
          _repaint.isShowingBubble = true;
          showAnimationController.forward(from: 0);
        },
        child: RepaintBoundary(
          child: CustomPaint(
            painter: StatisticsOrderLinePainter(
              numbers: widget.numbers,
              bgColor: widget.bgColor,
              content: (index) {
                return widget.content(widget.numbers[index]);
              },
              padding: EdgeInsets.all(16.fit),
              repaint: _repaint,
            ),
          ),
        ),
      ),
    );
  }
}
