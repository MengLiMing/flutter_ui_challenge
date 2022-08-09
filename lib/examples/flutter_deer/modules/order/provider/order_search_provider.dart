import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrderSearchProviders {
  static final keyword = StateProvider.autoDispose<String>((ref) => '');
}
