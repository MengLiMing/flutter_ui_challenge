import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/widgets/statistics_line_painter.dart';

class StatisticsLineChart extends StatefulWidget {
  final Color textColor;
  final Color lineColor;
  final List<double> datas;
  final StatisticsLineAnimationStyle animationStyle;
  const StatisticsLineChart({
    Key? key,
    required this.textColor,
    required this.lineColor,
    required this.datas,
    required this.animationStyle,
  }) : super(key: key);

  @override
  State<StatisticsLineChart> createState() => _StatisticsLineChartState();
}

class _StatisticsLineChartState extends State<StatisticsLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  late Animation<double> progress;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..forward();

    progress = CurveTween(curve: Curves.easeInOut).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => animationController.forward(from: 0),
      child: Column(
        children: [
          const SizedBox(width: double.infinity),
          DefaultTextStyle(
            style: TextStyle(color: widget.textColor, fontSize: 11),
            child: _week(context),
          ),
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: CustomPaint(
                painter: StatisticsLinePainter(
                  datas: widget.datas,
                  lineColor: widget.lineColor,
                  progress: progress,
                  style: widget.animationStyle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _week(BuildContext context) {
    const weeks = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return GridView.builder(
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: weeks.length * 2 - 1,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) {
        final weekIndex = index ~/ 2;
        if (index % 2 == 0 && weeks.length > weekIndex) {
          return Center(
            child: Text(weeks[weekIndex]),
          );
        }
        return Container();
      },
      itemCount: weeks.length * 2 - 1,
    );
  }
}
