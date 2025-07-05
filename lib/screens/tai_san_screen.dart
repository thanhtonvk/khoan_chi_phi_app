import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../utils/money_formatter.dart';

class TaiSanScreen extends StatefulWidget {
  const TaiSanScreen({super.key});

  @override
  State<TaiSanScreen> createState() => _TaiSanScreenState();
}

class _TaiSanScreenState extends State<TaiSanScreen> {
  final ApiService api = ApiService();
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> maGiaoKhoans = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _fetchMaGiaoKhoans();
  }

  Future<void> _fetchItems() async {
    setState(() => isLoading = true);
    try {
      final data = await api.fetchTaiSans();
      setState(() {
        items = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi tải danh sách tài sản!')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchMaGiaoKhoans() async {
    try {
      final data = await api.fetchMaGiaoKhoans();
      setState(() {
        maGiaoKhoans = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi tải danh sách mã giao khoán!')),
      );
    }
  }

  String _getTenGiaoKhoan(String idGiaoKhoan) {
    final giaoKhoan = maGiaoKhoans.firstWhere(
      (e) => e['idGiaoKhoan']?.toString() == idGiaoKhoan,
      orElse: () => <String, dynamic>{},
    );
    return giaoKhoan['tenGiaoKhoan'] ?? '';
  }

  void _showDialog({Map<String, dynamic>? item, int? index}) {
    final isEdit = item != null;
    final TextEditingController idController = TextEditingController(
      text: item?['idTaiSan'] ?? '',
    );
    final TextEditingController idGiaoKhoanController = TextEditingController(
      text: item?['idGiaoKhoan'] ?? '',
    );
    final TextEditingController tenController = TextEditingController(
      text: item?['tenVatTu'] ?? '',
    );
    final TextEditingController dvtController = TextEditingController(
      text: item?['donViTinh'] ?? '',
    );
    final TextEditingController soLuongController = TextEditingController(
      text: item?['soLuong']?.toString() ?? '',
    );
    final TextEditingController giaTruocController = TextEditingController(
      text: item?['donGiaBinhQuanTruoc']?.toString() ?? '',
    );
    final TextEditingController giaHienTaiController = TextEditingController(
      text: item?['donGiaBinhQuanHienTai']?.toString() ?? '',
    );
    final TextEditingController ghiChuController = TextEditingController(
      text: item?['ghiChu'] ?? '',
    );
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  isEdit ? Icons.edit : Icons.inventory_2,
                  color: Color(0xFFFF9800),
                ),
                SizedBox(width: 12),
                Text(isEdit ? 'Sửa tài sản' : 'Thêm tài sản'),
              ],
            ),
            content: Form(
              key: _formKey,
              child: SizedBox(
                width: 450,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: idController,
                        decoration: InputDecoration(
                          labelText: 'ID Tài sản',
                          hintText: 'Nhập mã tài sản',
                          prefixIcon: Icon(Icons.qr_code_outlined),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Vui lòng nhập ID'
                                    : null,
                        enabled: !isEdit,
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value:
                            idGiaoKhoanController.text.isEmpty
                                ? null
                                : idGiaoKhoanController.text,
                        decoration: InputDecoration(
                          labelText: 'Mã giao khoán',
                          hintText: 'Chọn mã giao khoán',
                          prefixIcon: Icon(Icons.link_outlined),
                        ),
                        items:
                            maGiaoKhoans
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e['idGiaoKhoan']?.toString(),
                                    child: Text(
                                      '${e['idGiaoKhoan']} - ${e['tenGiaoKhoan']}',
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            idGiaoKhoanController.text = value;
                          }
                        },
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Vui lòng chọn mã giao khoán'
                                    : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: tenController,
                        decoration: InputDecoration(
                          labelText: 'Tên vật tư',
                          hintText: 'Nhập tên vật tư, thiết bị',
                          prefixIcon: Icon(Icons.label_outlined),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Vui lòng nhập tên vật tư'
                                    : null,
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: dvtController,
                              decoration: InputDecoration(
                                labelText: 'Đơn vị tính',
                                hintText: 'Cái, kg, m...',
                                prefixIcon: Icon(Icons.straighten_outlined),
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Vui lòng nhập đơn vị tính'
                                          : null,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: soLuongController,
                              decoration: InputDecoration(
                                labelText: 'Số lượng',
                                hintText: 'Nhập số lượng',
                                prefixIcon: Icon(Icons.numbers_outlined),
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Vui lòng nhập số lượng'
                                          : null,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: giaTruocController,
                              decoration: InputDecoration(
                                labelText: 'Đơn giá trước',
                                hintText: 'Giá trước đây',
                                prefixIcon: Icon(Icons.attach_money_outlined),
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Vui lòng nhập đơn giá trước'
                                          : null,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: giaHienTaiController,
                              decoration: InputDecoration(
                                labelText: 'Đơn giá hiện tại',
                                hintText: 'Giá hiện tại',
                                prefixIcon: Icon(Icons.money_outlined),
                              ),
                              validator:
                                  (v) =>
                                      v == null || v.isEmpty
                                          ? 'Vui lòng nhập đơn giá hiện tại'
                                          : null,
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: ghiChuController,
                        decoration: InputDecoration(
                          labelText: 'Ghi chú',
                          hintText: 'Thông tin bổ sung',
                          prefixIcon: Icon(Icons.note_outlined),
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton.icon(
                icon: Icon(Icons.cancel_outlined),
                label: Text('Hủy'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton.icon(
                icon: Icon(isEdit ? Icons.save_outlined : Icons.add),
                label: Text(isEdit ? 'Lưu thay đổi' : 'Thêm mới'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newItem = {
                      'idTaiSan': idController.text,
                      'idGiaoKhoan': idGiaoKhoanController.text,
                      'tenVatTu': tenController.text,
                      'donViTinh': dvtController.text,
                      'soLuong': int.tryParse(soLuongController.text) ?? 0,
                      'donGiaBinhQuanTruoc':
                          double.tryParse(giaTruocController.text) ?? 0.0,
                      'donGiaBinhQuanHienTai':
                          double.tryParse(giaHienTaiController.text) ?? 0.0,
                      'ghiChu': ghiChuController.text,
                    };
                    try {
                      if (isEdit && index != null) {
                        await api.updateTaiSan(idController.text, newItem);
                      } else {
                        await api.addTaiSan(newItem);
                      }
                      if (mounted) {
                        Navigator.pop(context);
                        _fetchItems();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isEdit
                                  ? 'Cập nhật tài sản thành công!'
                                  : 'Thêm tài sản thành công!',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Lỗi thao tác tài sản!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
    );
  }

  void _deleteItem(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange),
                SizedBox(width: 12),
                Text('Xác nhận xóa'),
              ],
            ),
            content: Text(
              'Bạn có chắc chắn muốn xóa tài sản "${items[index]['tenVatTu']}"?',
            ),
            actions: [
              TextButton.icon(
                icon: Icon(Icons.cancel_outlined),
                label: Text('Hủy'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.delete_forever),
                label: Text('Xóa'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  try {
                    await api.deleteTaiSan(items[index]['idTaiSan']);
                    if (mounted) {
                      Navigator.pop(context);
                      _fetchItems();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Xóa tài sản thành công!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lỗi xóa tài sản!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 1200;

    // Calculate total value
    double totalValue = 0;
    for (var item in items) {
      final quantity = item['soLuong'] ?? 0;
      final price = item['donGiaBinhQuanHienTai'] ?? 0.0;
      totalValue += quantity * price;
    }

    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.inventory_2, size: 32, color: Color(0xFFFF9800)),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quản lý Tài sản',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE65100),
                      ),
                    ),
                    Text(
                      'Quản lý vật tư, thiết bị và tài sản',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Thêm tài sản'),
                onPressed: () => _showDialog(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF9800),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Stats Cards
          if (isLargeScreen) ...[
            Row(
              children: [
                _buildStatCard(
                  'Tổng tài sản',
                  items.length.toString(),
                  Icons.inventory,
                  Color(0xFFFF9800),
                ),
                SizedBox(width: 16),
                _buildStatCard(
                  'Tổng giá trị',
                  MoneyFormatter.formatVND(totalValue),
                  Icons.account_balance_wallet,
                  Color(0xFF4CAF50),
                ),
                SizedBox(width: 16),
                _buildStatCard(
                  'Mã giao khoán',
                  maGiaoKhoans.length.toString(),
                  Icons.qr_code,
                  Color(0xFF2196F3),
                ),
              ],
            ),
            SizedBox(height: 24),
          ],

          // Data Table
          Expanded(
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child:
                  isLoading
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Color(0xFFFF9800)),
                            SizedBox(height: 16),
                            Text('Đang tải dữ liệu...'),
                          ],
                        ),
                      )
                      : items.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inventory_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Chưa có tài sản nào',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Nhấn "Thêm tài sản" để bắt đầu',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      )
                      : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.qr_code, size: 16),
                                  SizedBox(width: 8),
                                  Text('ID'),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.link, size: 16),
                                  SizedBox(width: 8),
                                  Text('Mã GK'),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.label, size: 16),
                                  SizedBox(width: 8),
                                  Text('Tên vật tư'),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.straighten, size: 16),
                                  SizedBox(width: 8),
                                  Text('ĐVT'),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.numbers, size: 16),
                                  SizedBox(width: 8),
                                  Text('SL'),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.attach_money, size: 16),
                                  SizedBox(width: 8),
                                  Text('Giá trước'),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.money, size: 16),
                                  SizedBox(width: 8),
                                  Text('Giá hiện tại'),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.calculate, size: 16),
                                  SizedBox(width: 8),
                                  Text('Thành tiền'),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.settings, size: 16),
                                  SizedBox(width: 8),
                                  Text('Thao tác'),
                                ],
                              ),
                            ),
                          ],
                          rows:
                              items.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                final quantity = item['soLuong'] ?? 0;
                                final currentPrice =
                                    item['donGiaBinhQuanHienTai'] ?? 0.0;
                                final totalPrice = quantity * currentPrice;

                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 100,
                                        ),
                                        child: Text(
                                          item['idTaiSan'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 120,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              item['idGiaoKhoan'] ?? '',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              _getTenGiaoKhoan(
                                                item['idGiaoKhoan'] ?? '',
                                              ),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 200,
                                        ),
                                        child: Text(
                                          item['tenVatTu'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 80,
                                        ),
                                        child: Text(
                                          item['donViTinh'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(
                                            0xFF2196F3,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          quantity.toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2196F3),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 100,
                                        ),
                                        child: Text(
                                          MoneyFormatter.formatVND(
                                            item['donGiaBinhQuanTruoc'],
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 100,
                                        ),
                                        child: Text(
                                          MoneyFormatter.formatVND(
                                            currentPrice,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Color(
                                            0xFF4CAF50,
                                          ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                          border: Border.all(
                                            color: Color(0xFF4CAF50),
                                          ),
                                        ),
                                        child: Text(
                                          MoneyFormatter.formatVND(totalPrice),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF4CAF50),
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Color(0xFFFF9800),
                                            ),
                                            tooltip: 'Sửa',
                                            onPressed:
                                                () => _showDialog(
                                                  item: item,
                                                  index: index,
                                                ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            tooltip: 'Xóa',
                                            onPressed: () => _deleteItem(index),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                        ),
                      ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
