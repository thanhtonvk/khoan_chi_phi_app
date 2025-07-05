import 'package:intl/intl.dart';

class MoneyFormatter {
  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  static final NumberFormat _formatterWithDecimal = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 2,
  );

  static final NumberFormat _formatterNoSymbol = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '',
    decimalDigits: 0,
  );

  /// Format số tiền với symbol VND và không có phần thập phân
  /// Ví dụ: 1,000,000 ₫
  static String formatVND(dynamic amount) {
    if (amount == null) return '0 ₫';

    final num value = amount is String ? double.tryParse(amount) ?? 0 : amount;
    return _formatter.format(value);
  }

  /// Format số tiền với symbol VND và có phần thập phân
  /// Ví dụ: 1,000,000.50 ₫
  static String formatVNDWithDecimal(dynamic amount) {
    if (amount == null) return '0.00 ₫';

    final num value = amount is String ? double.tryParse(amount) ?? 0 : amount;
    return _formatterWithDecimal.format(value);
  }

  /// Format số tiền không có symbol
  /// Ví dụ: 1,000,000
  static String formatNumber(dynamic amount) {
    if (amount == null) return '0';

    final num value = amount is String ? double.tryParse(amount) ?? 0 : amount;
    return _formatterNoSymbol.format(value);
  }

  /// Format số tiền với đơn vị tùy chỉnh
  /// Ví dụ: 1,000,000 VNĐ
  static String formatWithUnit(dynamic amount, String unit) {
    if (amount == null) return '0 $unit';

    final num value = amount is String ? double.tryParse(amount) ?? 0 : amount;
    return '${_formatterNoSymbol.format(value)} $unit';
  }

  /// Format số tiền ngắn gọn (K, M, B)
  /// Ví dụ: 1.5M ₫, 2.3B ₫
  static String formatCompact(dynamic amount) {
    if (amount == null) return '0 ₫';

    final num value = amount is String ? double.tryParse(amount) ?? 0 : amount;

    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B ₫';
    } else if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M ₫';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K ₫';
    } else {
      return '${value.toStringAsFixed(0)} ₫';
    }
  }

  /// Parse string thành số
  static double? parseAmount(String? amount) {
    if (amount == null || amount.isEmpty) return null;

    // Loại bỏ các ký tự không phải số và dấu chấm
    final cleanAmount = amount.replaceAll(RegExp(r'[^\d.]'), '');
    return double.tryParse(cleanAmount);
  }

  /// Kiểm tra xem có phải là số tiền hợp lệ không
  static bool isValidAmount(String? amount) {
    if (amount == null || amount.isEmpty) return false;
    return parseAmount(amount) != null;
  }
}
