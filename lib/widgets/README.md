# Widgets

Thư mục này chứa các widget tái sử dụng cho ứng dụng.

## DatePickerField

Widget để chọn ngày tháng với giao diện đẹp và dễ sử dụng.

### Sử dụng:

```dart
import '../widgets/date_picker_field.dart';

DatePickerField(
  controller: myDateController,
  labelText: 'Ngày sinh',
  hintText: 'Chọn ngày sinh',
  prefixIcon: Icons.cake_outlined,
  firstDate: DateTime(1900),
  lastDate: DateTime.now(),
  dateFormat: 'dd/MM/yyyy', // hoặc 'yyyy-MM-dd'
)
```

### Tham số:

- `controller`: TextEditingController để lưu giá trị ngày
- `labelText`: Nhãn hiển thị
- `hintText`: Gợi ý cho người dùng
- `prefixIcon`: Icon hiển thị bên trái
- `validator`: Hàm kiểm tra hợp lệ (tùy chọn)
- `initialDate`: Ngày mặc định (tùy chọn)
- `firstDate`: Ngày sớm nhất có thể chọn (tùy chọn)
- `lastDate`: Ngày muộn nhất có thể chọn (tùy chọn)
- `dateFormat`: Định dạng ngày ('dd/MM/yyyy' hoặc 'yyyy-MM-dd')

### Tính năng:

- Giao diện đẹp với theme xanh da trời
- Hỗ trợ 2 định dạng ngày phổ biến
- Validation tự động
- Icon calendar để dễ nhận biết
- Responsive design

## MoneyDisplay

Widget để hiển thị tiền tệ với format đẹp.

### Sử dụng:

```dart
import '../widgets/money_display.dart';

// Hiển thị tiền cơ bản
MoneyDisplay(amount: 1000000)

// Hiển thị tiền với style tùy chỉnh
MoneyDisplay(
  amount: 1000000,
  maxWidth: 120,
  style: TextStyle(color: Colors.red),
)

// Hiển thị tiền ngắn gọn (1.5M ₫)
MoneyDisplay(amount: 1500000, showCompact: true)

// Hiển thị tiền với phần thập phân
MoneyDisplay(amount: 1000000.50, showDecimal: true)
```

### Tham số:

- `amount`: Số tiền cần hiển thị
- `maxWidth`: Chiều rộng tối đa (tùy chọn)
- `style`: Style cho text (tùy chọn)
- `showCompact`: Hiển thị dạng ngắn gọn (tùy chọn)
- `showDecimal`: Hiển thị phần thập phân (tùy chọn)

## MoneyDisplayBold

Widget để hiển thị tiền với font in đậm.

```dart
MoneyDisplayBold(
  amount: 1000000,
  color: Color(0xFF4CAF50),
)
```

## MoneyDisplayCard

Widget để hiển thị tiền trong card với background màu.

```dart
MoneyDisplayCard(
  amount: 1000000,
  label: 'Tổng tiền',
  icon: Icons.money,
  color: Color(0xFF4CAF50),
)
``` 