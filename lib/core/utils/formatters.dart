import 'package:intl/intl.dart';

class AppFormatters {
  static final _currencyFormat =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);

  static final _currencyFormatDecimal =
      NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 2);

  static String formatPrice(double price) {
    return _currencyFormat.format(price);
  }

  static String formatPriceDecimal(double price) {
    return _currencyFormatDecimal.format(price);
  }

  static String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(date);
  }

  static String formatDateShort(DateTime date) {
    return DateFormat('dd MMM, hh:mm a').format(date);
  }

  static String formatTime(DateTime date) {
    return DateFormat('hh:mm a').format(date);
  }

  static String formatOrderId(String id) {
    if (id.length > 8) return '#${id.substring(0, 8).toUpperCase()}';
    return '#${id.toUpperCase()}';
  }

  static double calculateGST(double amount) {
    return amount * 0.05;
  }

  static double calculateTotal(double subtotal) {
    return subtotal + calculateGST(subtotal);
  }
}
