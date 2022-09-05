// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_ui_challenge/examples/flutter_deer/modules/statistics/utils/calendar_utils.dart';
import 'package:intl/intl.dart';

mixin CalendarProviders {
  final manager =
      StateNotifierProvider.autoDispose<CalendarStateNotifier, CalendarState>(
          (ref) => CalendarStateNotifier());

  late final isUnfold =
      Provider.autoDispose<bool>((ref) => ref.watch(manager).isUnFold);

  late final canFold =
      Provider.autoDispose<bool>((ref) => ref.watch(manager).canFold);

  late final selectedStyle = Provider.autoDispose<CalendarSelectedStyle>(
      (ref) => ref.watch(manager).selectedStyle);

  late final year = Provider.autoDispose<int>((ref) => ref.watch(manager).year);
  late final month =
      Provider.autoDispose<int>((ref) => ref.watch(manager).month);

  late final selectedDate = Provider.autoDispose<DateTime>((ref) {
    final state = ref.watch(manager);
    return DateTime(state.year, state.month, state.day);
  });

  late final dayRange = Provider.autoDispose<String>((ref) {
    final state = ref.watch(manager);
    final range = state.dayRange;
    final format = DateFormat('yy.MM.dd');
    final first = range.first.date;
    final last = range.last.date;
    return '${format.format(first)}-${format.format(last)}';
  });

  late final datas = Provider.autoDispose<List<CalendarDate>>((ref) {
    ref.watch(isUnfold);
    switch (ref.watch(selectedStyle)) {
      case CalendarSelectedStyle.range:
        return ref.read(manager).dayRange;
      case CalendarSelectedStyle.month:
        return ref.read(manager).days;
      case CalendarSelectedStyle.year:
        return ref.read(manager).months;
    }
  });
}

class CalendarStateNotifier extends StateNotifier<CalendarState> {
  CalendarStateNotifier() : super(const CalendarState());

  DateTime get now => DateTime.now().toLocal();

  void initState() {
    final currentDate = now;

    state = state.copyWith(
      year: currentDate.year,
      month: currentDate.month,
      day: currentDate.day,
      dayRange: _dayRange(currentDate),
      months: _months(currentDate),
      days: _days(currentDate),
    );
  }

  void changeSelectedStyle(CalendarSelectedStyle style) {
    state = state.copyWith(selectedStyle: style);
  }

  void selectedDate(CalendarDate date) {
    switch (state.selectedStyle) {
      case CalendarSelectedStyle.year:
        selectedMonth(date.date);
        break;
      case CalendarSelectedStyle.month:
        selectedDay(date.date);
        break;
      case CalendarSelectedStyle.range:
        selectedRangeDay(date.date);
        break;
    }
  }

  void selectedMonth(DateTime month) {
    List<CalendarDate>? days;
    List<CalendarDate>? range;
    int? day;
    if (state.month != month.month) {
      if (state.isUnFold) {
        days = _days(month);
      } else {
        days = _dayRange(month);
      }
      day = 1;
      range = _dayRange(month);
    }
    state = state.copyWith(
      month: month.month,
      day: day,
      days: days,
      dayRange: range,
    );
  }

  void selectedDay(DateTime day) {
    List<CalendarDate>? range;

    if (state.day != day.day) {
      range = _dayRange(day);
    }
    state = state.copyWith(day: day.day, dayRange: range);
  }

  void selectedRangeDay(DateTime day) {
    state = state.copyWith(day: day.day);
  }

  void changeUnfold() {
    final isUnfold = !state.isUnFold;
    final date = DateTime(state.year, state.month, state.day);
    state = state.copyWith(
      months: _months(
        DateTime(
          state.year,
          state.month,
        ),
        isUnfold: isUnfold,
      ),
      days: isUnfold ? _days(date) : _dayRange(date),
      isUnFold: isUnfold,
    );
  }

  /// 获取当前月日期
  List<CalendarDate> _days(DateTime date) {
    final firstDate = CalendarUtils.firstDayOfMonth(date.year, date.month);
    final lastDate = CalendarUtils.lastDayOfMonth(date.year, date.month);
    List<CalendarDate> result = [];

    /// 第一天不是周一补全
    if (firstDate.weekday != 1) {
      final count = firstDate.weekday - 1;
      for (int i = 0; i < count; i++) {
        final day = firstDate.subtract(Duration(days: count - i));
        result.add(CalendarDate(date: day, canSelected: false));
      }
    }

    final dayCount = lastDate.day - firstDate.day + 1;
    final currentDate = now;

    for (int i = 0; i < dayCount; i++) {
      final day = DateTime(date.year, date.month, i + 1);
      result
          .add(CalendarDate(date: day, canSelected: day.isBefore(currentDate)));
    }

    /// 最后一天不是周日 补全
    if (lastDate.weekday != 7) {
      final count = 7 - lastDate.weekday;
      for (int i = 0; i < count; i++) {
        final day = lastDate.add(Duration(days: i + 1));
        result.add(CalendarDate(date: day, canSelected: false));
      }
    }

    return result;
  }

  /// 获取月份
  List<CalendarDate> _months(
    DateTime date, {
    bool isUnfold = true,
  }) {
    final nowDate = now;
    final count = isUnfold ? 12 : (date.month <= 7 ? 7 : 5);
    final preCount = isUnfold ? 0 : (date.month <= 7 ? 0 : 7);
    return List.generate(count, (index) {
      final monthIndex = index + 1 + preCount;
      final monthDate = DateTime(date.year, monthIndex);
      return CalendarDate(
          date: monthDate, canSelected: nowDate.month >= monthIndex);
    });
  }

  /// 根据当前日期获取七日数据
  List<CalendarDate> _dayRange(DateTime date) {
    final newDate = DateTime.utc(date.year, date.month, date.day);

    final currentDate = now;

    final currentWeekDay = newDate.weekday;

    return List.generate(7, (index) {
      final weekDay = index + 1;
      DateTime weekDate;
      if (currentWeekDay > weekDay) {
        weekDate = newDate.subtract(Duration(days: currentWeekDay - weekDay));
      } else if (currentWeekDay < weekDay) {
        weekDate = newDate.add(Duration(days: weekDay - currentWeekDay));
      } else {
        weekDate = newDate;
      }
      return CalendarDate(
        date: weekDate,
        canSelected:
            newDate.month == weekDate.month && weekDate.isBefore(currentDate),
      );
    });
  }
}

class CalendarState extends Equatable {
  final int year;
  final int month;
  final int day;

  /// 七日区间
  final List<CalendarDate> dayRange;

  final CalendarSelectedStyle selectedStyle;

  /// 月份
  final List<CalendarDate> months;

  /// 日期
  final List<CalendarDate> days;

  /// 是否展开
  final bool isUnFold;

  const CalendarState({
    this.year = -1,
    this.month = -1,
    this.day = -1,
    this.selectedStyle = CalendarSelectedStyle.year,
    this.isUnFold = true,
    this.months = const [],
    this.days = const [],
    this.dayRange = const [],
  });

  /// 是否可以折叠
  bool get canFold => selectedStyle != CalendarSelectedStyle.range;

  @override
  List<Object?> get props =>
      [year, month, day, selectedStyle, isUnFold, months, days, dayRange];

  CalendarState copyWith({
    int? year,
    int? month,
    int? day,
    List<CalendarDate>? dayRange,
    CalendarSelectedStyle? selectedStyle,
    List<CalendarDate>? months,
    List<CalendarDate>? days,
    bool? isUnFold,
  }) {
    return CalendarState(
      year: year ?? this.year,
      month: month ?? this.month,
      day: day ?? this.day,
      dayRange: dayRange ?? this.dayRange,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      months: months ?? this.months,
      days: days ?? this.days,
      isUnFold: isUnFold ?? this.isUnFold,
    );
  }
}

enum CalendarSelectedStyle { year, month, range }

class CalendarDate extends Equatable {
  final DateTime date;
  final bool canSelected;

  const CalendarDate({
    required this.date,
    required this.canSelected,
  });

  @override
  List<Object?> get props => [date, canSelected];
}
