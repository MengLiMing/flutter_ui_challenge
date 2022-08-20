import 'package:flutter_riverpod/flutter_riverpod.dart';

mixin HomeProviders {
  final homeIndexProvider = StateProvider.autoDispose<int>((ref) => 0);
}
