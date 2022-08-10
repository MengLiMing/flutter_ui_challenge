extension StringExtension on String {
  /// 添加分隔符
  String get text => split('').join('\u{200B}');
}
