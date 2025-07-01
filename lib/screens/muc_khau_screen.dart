import 'package:flutter/material.dart';
import '../services/api_service.dart';

class MucKhauScreen extends StatefulWidget {
  const MucKhauScreen({super.key});

  @override
  State<MucKhauScreen> createState() => _MucKhauScreenState();
}

class _MucKhauScreenState extends State<MucKhauScreen> {
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
      final data = await api.fetchMucKhaus();
      setState(() {
        items = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi tải danh sách mục khẩu!')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showDialog({Map<String, dynamic>? item, int? index}) {
    final isEdit = item != null;
    final TextEditingController idController = TextEditingController(
      text: item?['idMucKhau'] ?? '',
    );
    final TextEditingController idKhauController = TextEditingController(
      text: item?['idKhau'] ?? '',
    );
    final TextEditingController tenController = TextEditingController(
      text: item?['tenMucKhau'] ?? '',
    );
    final TextEditingController vietTatController = TextEditingController(
      text: item?['vietTat'] ?? '',
    );
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(isEdit ? 'Sửa mục khẩu' : 'Thêm mục khẩu'),
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
                        controller: idKhauController,
                        decoration: const InputDecoration(
                          labelText: 'ID Khẩu',
                          prefixIcon: Icon(Icons.link),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty ? 'Nhập ID khẩu' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: tenController,
                        decoration: const InputDecoration(
                          labelText: 'Tên mục khẩu',
                          prefixIcon: Icon(Icons.label),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Nhập tên mục khẩu'
                                    : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: vietTatController,
                        decoration: const InputDecoration(
                          labelText: 'Viết tắt',
                          prefixIcon: Icon(Icons.short_text),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty ? 'Nhập viết tắt' : null,
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
                      'idMucKhau': idController.text,
                      'idKhau': idKhauController.text,
                      'tenMucKhau': tenController.text,
                      'vietTat': vietTatController.text,
                    };
                    try {
                      if (isEdit && index != null) {
                        await api.updateMucKhau(idController.text, newItem);
                      } else {
                        await api.addMucKhau(newItem);
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
              'Bạn có chắc muốn xóa mục khẩu "${items[index]['tenMucKhau']}"?',
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
                    await api.deleteMucKhau(items[index]['idMucKhau']);
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
                'Danh sách mục khẩu',
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
                          DataColumn(label: Text('ID Khẩu')),
                          DataColumn(label: Text('Tên mục khẩu')),
                          DataColumn(label: Text('Viết tắt')),
                          DataColumn(label: Text('Hành động')),
                        ],
                        rows: List.generate(items.length, (i) {
                          final item = items[i];
                          return DataRow(
                            cells: [
                              DataCell(Text(item['idMucKhau'] ?? '')),
                              DataCell(Text(item['idKhau'] ?? '')),
                              DataCell(Text(item['tenMucKhau'] ?? '')),
                              DataCell(Text(item['vietTat'] ?? '')),
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
