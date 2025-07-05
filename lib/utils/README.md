# Utils

Thư mục này chứa các utility class và helper functions.

## MoneyFormatter

Class để format tiền tệ theo chuẩn Việt Nam.

### Sử dụng:

```dart
import '../utils/money_formatter.dart';

// Format tiền với symbol VND
MoneyFormatter.formatVND(1000000) // "1,000,000 ₫"

// Format tiền với phần thập phân
MoneyFormatter.formatVNDWithDecimal(1000000.50) // "1,000,000.50 ₫"

// Format tiền không có symbol
MoneyFormatter.formatNumber(1000000) // "1,000,000"

// Format tiền với đơn vị tùy chỉnh
MoneyFormatter.formatWithUnit(1000000, 'VNĐ') // "1,000,000 VNĐ"

// Format tiền ngắn gọn
MoneyFormatter.formatCompact(1500000) // "1.5M ₫"
MoneyFormatter.formatCompact(2500000000) // "2.5B ₫"

// Parse string thành số
MoneyFormatter.parseAmount('1,000,000 ₫') // 1000000.0

// Kiểm tra tính hợp lệ
MoneyFormatter.isValidAmount('1,000,000') // true
MoneyFormatter.isValidAmount('invalid') // false
```

### Tính năng:

- Hỗ trợ format tiền theo chuẩn Việt Nam
- Tự động thêm dấu phẩy phân cách hàng nghìn
- Hỗ trợ hiển thị ngắn gọn (K, M, B)
- Parse string thành số
- Validation số tiền
- Hỗ trợ nhiều định dạng khác nhau 