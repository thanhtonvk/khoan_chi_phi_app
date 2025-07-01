import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MaGiaoKhoanScreen extends StatefulWidget {
  const MaGiaoKhoanScreen({super.key});

  @override
  State<MaGiaoKhoanScreen> createState() => _MaGiaoKhoanScreenState();
}

class _MaGiaoKhoanScreenState extends State<MaGiaoKhoanScreen> {
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
      final data = await api.fetchMaGiaoKhoans();
      setState(() {
        items = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi tải danh sách mã giao khoán!')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showDialog({Map<String, dynamic>? item, int? index}) {
    final isEdit = item != null;
    final TextEditingController idController = TextEditingController(
      text: item?['idGiaoKhoan'] ?? '',
    );
    final TextEditingController tenController = TextEditingController(
      text: item?['tenVatTuGiaoKhoan'] ?? '',
    );
    final TextEditingController dvtController = TextEditingController(
      text: item?['donViTinh'] ?? '',
    );
    final TextEditingController giaTruocController = TextEditingController(
      text: item?['donGiaBinhQuanTruoc']?.toString() ?? '',
    );
    final TextEditingController giaHienTaiController = TextEditingController(
      text: item?['donGiaBinhQuanHienTai']?.toString() ?? '',
    );
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(isEdit ? 'Sửa mã giao khoán' : 'Thêm mã giao khoán'),
            content: Form(
              key: _formKey,
              child: SizedBox(
                width: 350,
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
                      'idGiaoKhoan': idController.text,
                      'tenVatTuGiaoKhoan': tenController.text,
                      'donViTinh': dvtController.text,
                      'donGiaBinhQuanTruoc':
                          int.tryParse(giaTruocController.text) ?? 0,
                      'donGiaBinhQuanHienTai':
                          int.tryParse(giaHienTaiController.text) ?? 0,
                    };
                    try {
                      if (isEdit && index != null) {
                        await api.updateMaGiaoKhoan(idController.text, newItem);
                      } else {
                        await api.addMaGiaoKhoan(newItem);
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
              'Bạn có chắc muốn xóa mã giao khoán "${items[index]['tenVatTuGiaoKhoan']}"?',
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
                    await api.deleteMaGiaoKhoan(items[index]['idGiaoKhoan']);
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
                'Danh sách mã giao khoán',
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
                          DataColumn(label: Text('Tên vật tư')),
                          DataColumn(label: Text('Đơn vị tính')),
                          DataColumn(label: Text('Đơn giá trước')),
                          DataColumn(label: Text('Đơn giá hiện tại')),
                          DataColumn(label: Text('Hành động')),
                        ],
                        rows: List.generate(items.length, (i) {
                          final item = items[i];
                          return DataRow(
                            cells: [
                              DataCell(Text(item['idGiaoKhoan'] ?? '')),
                              DataCell(Text(item['tenVatTuGiaoKhoan'] ?? '')),
                              DataCell(Text(item['donViTinh'] ?? '')),
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
