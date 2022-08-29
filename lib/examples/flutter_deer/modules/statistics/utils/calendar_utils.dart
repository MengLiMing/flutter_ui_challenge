class CalendarUtils {
  /// 获取第一天
  static DateTime firstDayOfMonth(int year, int month) {
    return DateTime.utc(year, month);
  }

  /// 获取最后一天
  static DateTime lastDayOfMonth(int year, int month) {
    DateTime lastMonthDate;
    if (month < 12) {
      lastMonthDate = DateTime.utc(year, month + 1);
    } else {
      lastMonthDate = DateTime.utc(year + 1);
    }

    return lastMonthDate.subtract(Duration(days: 1));
  }
}
