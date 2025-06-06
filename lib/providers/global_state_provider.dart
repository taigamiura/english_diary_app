import 'package:flutter_riverpod/flutter_riverpod.dart';

final globalLoadingProvider = StateProvider<bool>((ref) => false);
final globalErrorProvider = StateProvider<String?>((ref) => null);
