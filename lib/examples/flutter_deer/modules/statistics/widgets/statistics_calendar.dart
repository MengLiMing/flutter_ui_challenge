import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/provider/statistics_calendar_providers.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/res/colors.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/utils/screen_untils.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/widgets/load_image.dart';

class StatisticsCalendar extends ConsumerStatefulWidget {
  const StatisticsCalendar({Key? key}) : super(key: key);

  @override
  ConsumerState<StatisticsCalendar> createState() =>
      _StatisticsCalendarHeadherState();
}

class _StatisticsCalendarHeadherState extends ConsumerState<StatisticsCalendar>
    with CalendarProviders {
  @override
  void initState() {
    super.initState();
    ref.read(manager.notifier).initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _info(),
        Container(
          color: Colours.bgGray_,
          child: Column(
            children: [
              _week(),
              AnimatedSize(
                duration: const Duration(milliseconds: 100),
                child: _calendar(),
              ),
              _foldArrow(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _foldArrow() {
    return Consumer(builder: (context, ref, child) {
      final isUnfold = ref.watch(this.isUnfold);
      final canFold = ref.watch(this.canFold);
      if (canFold) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            ref.read(manager.notifier).changeUnfold();
          },
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 11.fit),
            alignment: Alignment.center,
            child: LoadAssetImage('statistic/${isUnfold ? 'up' : 'down'}',
                width: 16.0),
          ),
        );
      } else {
        return SizedBox(height: 16.fit);
      }
    });
  }

  Widget _week() {
    const weeks = ['周一', '周二', '周三', '周四', '周五', '周六', '周日'];
    return Consumer(
      builder: (context, ref, child) {
        final style = ref.watch(selectedStyle);
        return Column(
          children: [
            SizedBox(height: 8.fit),
            Visibility(
              visible: style == CalendarSelectedStyle.month,
              child: child!,
            ),
            SizedBox(height: 8.fit),
          ],
        );
      },
      child: _gridView(
        itemCount: weeks.length,
        itemBuilder: (context, index) {
          return Container(
            height: 32.fit,
            alignment: Alignment.center,
            child: Text(
              weeks[index],
              style: const TextStyle(
                color: Colours.textGray,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _gridView({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.fit),
      shrinkWrap: true,
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 16.fit,
        mainAxisSpacing: 16.fit,
      ),
      itemBuilder: itemBuilder,
    );
  }

  Widget _calendar() {
    return Consumer(builder: (context, ref, child) {
      final datas = ref.watch(this.datas);
      final date = ref.watch(selectedDate);
      return _gridView(
          itemCount: datas.length,
          itemBuilder: (context, index) {
            final itemData = datas[index];
            final style = ref.read(selectedStyle);
            Widget content;
            bool isSelected = false;

            switch (style) {
              case CalendarSelectedStyle.year:
                content = Text.rich(TextSpan(
                  children: [
                    TextSpan(text: '${itemData.date.month}'),
                    const TextSpan(
                      text: '月',
                      style: TextStyle(fontSize: 10),
                    ),
                  ],
                ));
                isSelected = itemData.date.month == date.month;
                break;
              default:
                content = Text('${itemData.date.day}');
                isSelected = itemData.date.month == date.month &&
                    itemData.date.day == date.day;
            }

            return CalendarSelectedButton<CalendarDate>(
              content: content,
              data: itemData,
              isSelected: isSelected,
              height: 32.fit,
              fontSize: 14,
              onTap: itemData.canSelected
                  ? (data) {
                      ref.read(manager.notifier).selectedDate(data);
                    }
                  : null,
            );
          });
    });
  }

  Widget _info() {
    return Container(
      color: Colors.white,
      height: 64.fit,
      child: Consumer(builder: (context, ref, _) {
        final year = ref.watch(this.year);
        final month = ref.watch(this.month);
        final dayRange = ref.watch(this.dayRange);
        final selectedStyle = ref.watch(this.selectedStyle);
        return Row(
          children: [
            _headButton(
              Text('$year'),
              selected: selectedStyle,
              style: CalendarSelectedStyle.year,
            ),
            SizedBox(
              width: 1,
              height: 24.fit,
              child: const ColoredBox(color: Colours.line),
            ),
            _headButton(
              Text.rich(TextSpan(
                children: [
                  TextSpan(text: '$month'),
                  const TextSpan(
                    text: '月',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              )),
              selected: selectedStyle,
              style: CalendarSelectedStyle.month,
            ),
            SizedBox(
              width: 1,
              height: 24.fit,
              child: const ColoredBox(color: Colours.line),
            ),
            _headButton(
              Text(dayRange),
              isSelected: selectedStyle == CalendarSelectedStyle.range,
              selected: selectedStyle,
              style: CalendarSelectedStyle.range,
            ),
          ],
        );
      }),
    );
  }

  Widget _headButton(
    Widget content, {
    bool isSelected = false,
    required CalendarSelectedStyle selected,
    required CalendarSelectedStyle style,
  }) {
    return CalendarSelectedButton<CalendarSelectedStyle>(
      content: content,
      data: style,
      isSelected: style == selected,
      height: 32.fit,
      margin: EdgeInsets.only(left: 16.fit, right: 16.fit),
      padding: EdgeInsets.symmetric(horizontal: 8.fit),
      onTap: (data) => ref.read(manager.notifier).changeSelectedStyle(data),
    );
  }
}

class CalendarSelectedButton<T> extends StatelessWidget {
  final Widget content;
  final T data;
  final bool isSelected;
  final ValueChanged<T>? onTap;
  final double height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final double fontSize;
  const CalendarSelectedButton({
    Key? key,
    required this.content,
    required this.data,
    required this.isSelected,
    required this.height,
    this.fontSize = 16,
    this.onTap,
    this.margin,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap == null
          ? null
          : () {
              onTap?.call(data);
            },
      child: DefaultTextStyle(
        style: TextStyle(fontSize: fontSize),
        child: Container(
          alignment: Alignment.center,
          height: height,
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(16.fit),
            ),
            gradient: isSelected
                ? const LinearGradient(
                    colors: [
                      Color(0xFF5758FA),
                      Color(0xFF5793FA),
                    ],
                  )
                : null,
          ),
          child: DefaultTextStyle(
            style: onTap == null
                ? const TextStyle(color: Colours.textGrayC)
                : (isSelected
                    ? const TextStyle(color: Colors.white)
                    : const TextStyle(color: Colours.darkTextGray)),
            child: content,
          ),
        ),
      ),
    );
  }
}
