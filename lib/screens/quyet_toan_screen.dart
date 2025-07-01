import 'package:flutter/material.dart';
import '../services/api_service.dart';

class QuyetToanScreen extends StatefulWidget {
  const QuyetToanScreen({super.key});

  @override
  State<QuyetToanScreen> createState() => _QuyetToanScreenState();
}

class _QuyetToanScreenState extends State<QuyetToanScreen> {
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
      final data = await api.fetchQuyetToans();
      setState(() {
        items = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi tải danh sách quyết toán!')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showDialog({Map<String, dynamic>? item, int? index}) {
    final isEdit = item != null;
    final TextEditingController idController = TextEditingController(
      text: item?['idQuyetToanGiaoKhoan'] ?? '',
    );
    final TextEditingController ngayController = TextEditingController(
      text: item?['ngay'] ?? '',
    );
    final TextEditingController userIdController = TextEditingController(
      text: item?['userId'] ?? '',
    );
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(isEdit ? 'Sửa quyết toán' : 'Thêm quyết toán'),
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
                        controller: ngayController,
                        decoration: const InputDecoration(
                          labelText: 'Ngày (yyyy-mm-dd)',
                          prefixIcon: Icon(Icons.date_range),
                        ),
                        validator:
                            (v) => v == null || v.isEmpty ? 'Nhập ngày' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: userIdController,
                        decoration: const InputDecoration(
                          labelText: 'User ID',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty ? 'Nhập User ID' : null,
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
                      'idQuyetToanGiaoKhoan': idController.text,
                      'ngay': ngayController.text,
                      'userId': userIdController.text,
                    };
                    try {
                      if (isEdit && index != null) {
                        await api.updateQuyetToan(idController.text, newItem);
                      } else {
                        await api.addQuyetToan(newItem);
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
              'Bạn có chắc muốn xóa quyết toán "${items[index]['idQuyetToanGiaoKhoan']}"?',
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
                    await api.deleteQuyetToan(
                      items[index]['idQuyetToanGiaoKhoan'],
                    );
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
                'Danh sách quyết toán',
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
                          DataColumn(label: Text('Ngày')),
                          DataColumn(label: Text('User ID')),
                          DataColumn(label: Text('Hành động')),
                        ],
                        rows: List.generate(items.length, (i) {
                          final item = items[i];
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(item['idQuyetToanGiaoKhoan'] ?? ''),
                              ),
                              DataCell(Text(item['ngay'] ?? '')),
                              DataCell(Text(item['userId'] ?? '')),
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
