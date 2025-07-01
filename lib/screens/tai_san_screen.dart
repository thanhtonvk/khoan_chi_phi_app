import 'package:flutter/material.dart';
import '../services/api_service.dart';

class TaiSanScreen extends StatefulWidget {
  const TaiSanScreen({super.key});

  @override
  State<TaiSanScreen> createState() => _TaiSanScreenState();
}

class _TaiSanScreenState extends State<TaiSanScreen> {
  final ApiService api = ApiService();
  List<Map<String, dynamic>> items = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchItems();
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
            title: Text(isEdit ? 'Sửa tài sản' : 'Thêm tài sản'),
            content: Form(
              key: _formKey,
              child: SizedBox(
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: idController,
                        decoration: const InputDecoration(
                          labelText: 'ID',
                          prefixIcon: Icon(Icons.code),
                        ),
                        validator:
                            (v) => v == null || v.isEmpty ? 'Nhập ID' : null,
                        enabled: !isEdit,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: idGiaoKhoanController,
                        decoration: const InputDecoration(
                          labelText: 'ID Giao khoán',
                          prefixIcon: Icon(Icons.link),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Nhập ID giao khoán'
                                    : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: tenController,
                        decoration: const InputDecoration(
                          labelText: 'Tên vật tư',
                          prefixIcon: Icon(Icons.label),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Nhập tên vật tư'
                                    : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: dvtController,
                        decoration: const InputDecoration(
                          labelText: 'Đơn vị tính',
                          prefixIcon: Icon(Icons.straighten),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Nhập đơn vị tính'
                                    : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: soLuongController,
                        decoration: const InputDecoration(
                          labelText: 'Số lượng',
                          prefixIcon: Icon(Icons.numbers),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty ? 'Nhập số lượng' : null,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: giaTruocController,
                        decoration: const InputDecoration(
                          labelText: 'Đơn giá trước',
                          prefixIcon: Icon(Icons.attach_money),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Nhập đơn giá trước'
                                    : null,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: giaHienTaiController,
                        decoration: const InputDecoration(
                          labelText: 'Đơn giá hiện tại',
                          prefixIcon: Icon(Icons.money),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Nhập đơn giá hiện tại'
                                    : null,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: ghiChuController,
                        decoration: const InputDecoration(
                          labelText: 'Ghi chú',
                          prefixIcon: Icon(Icons.note),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton.icon(
                icon: Icon(isEdit ? Icons.save : Icons.add),
                label: Text(isEdit ? 'Lưu' : 'Thêm'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newItem = {
                      'idTaiSan': idController.text,
                      'idGiaoKhoan': idGiaoKhoanController.text,
                      'tenVatTu': tenController.text,
                      'donViTinh': dvtController.text,
                      'soLuong': int.tryParse(soLuongController.text) ?? 0,
                      'donGiaBinhQuanTruoc':
                          int.tryParse(giaTruocController.text) ?? 0,
                      'donGiaBinhQuanHienTai':
                          int.tryParse(giaHienTaiController.text) ?? 0,
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
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Lỗi thao tác!')),
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
            title: const Text('Xác nhận xóa'),
            content: Text(
              'Bạn có chắc muốn xóa tài sản "${items[index]['tenVatTu']}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.delete),
                label: const Text('Xóa'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  try {
                    await api.deleteTaiSan(items[index]['idTaiSan']);
                    if (mounted) {
                      Navigator.pop(context);
                      _fetchItems();
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('Lỗi xóa!')));
                  }
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Danh sách tài sản',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Thêm'),
                onPressed: () => _showDialog(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('ID')),
                          DataColumn(label: Text('ID Giao khoán')),
                          DataColumn(label: Text('Tên vật tư')),
                          DataColumn(label: Text('Đơn vị tính')),
                          DataColumn(label: Text('Số lượng')),
                          DataColumn(label: Text('Đơn giá trước')),
                          DataColumn(label: Text('Đơn giá hiện tại')),
                          DataColumn(label: Text('Ghi chú')),
                          DataColumn(label: Text('Hành động')),
                        ],
                        rows: List.generate(items.length, (i) {
                          final item = items[i];
                          return DataRow(
                            cells: [
                              DataCell(Text(item['idTaiSan'] ?? '')),
                              DataCell(Text(item['idGiaoKhoan'] ?? '')),
                              DataCell(Text(item['tenVatTu'] ?? '')),
                              DataCell(Text(item['donViTinh'] ?? '')),
                              DataCell(Text(item['soLuong']?.toString() ?? '')),
                              DataCell(
                                Text(
                                  item['donGiaBinhQuanTruoc']?.toString() ?? '',
                                ),
                              ),
                              DataCell(
                                Text(
                                  item['donGiaBinhQuanHienTai']?.toString() ??
                                      '',
                                ),
                              ),
                              DataCell(Text(item['ghiChu'] ?? '')),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      tooltip: 'Sửa',
                                      onPressed:
                                          () =>
                                              _showDialog(item: item, index: i),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      tooltip: 'Xóa',
                                      onPressed: () => _deleteItem(i),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
