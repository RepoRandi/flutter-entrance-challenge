
import 'package:intl/intl.dart';

final idrFormat = NumberFormat.currency(
  name: "IDR",
  locale: 'in_ID',
  decimalDigits: 0, // change it to get decimal places
  symbol: 'Rp ',
);

extension DoubleFormatter on double? {
  String inRupiah() {
    return idrFormat.format(this ?? 0);
  }
}

extension IntegerFormatter on int? {
  String inRupiah() {
    return idrFormat.format(this ?? 0);
  }
}