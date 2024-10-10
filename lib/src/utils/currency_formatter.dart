import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

final currencyFormatterProvider = Provider<NumberFormat>((ref) {
  /// Currency formatter.
  return NumberFormat.simpleCurrency(locale: "en_US");
});
