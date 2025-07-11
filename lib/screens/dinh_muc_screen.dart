import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DinhMucScreen extends StatefulWidget {
  const DinhMucScreen({super.key});

  @override
  State<DinhMucScreen> createState() => _DinhMucScreenState();
}

class _DinhMucScreenState extends State<DinhMucScreen> {
  final ApiService api = ApiService();
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> maGiaoKhoans = [];
  List<Map<String, dynamic>> mucKhaus = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _fetchMaGiaoKhoans();
    _fetchMucKhaus();
  }

  Future<void> _fetchItems() async {
    setState(() => isLoading = true);
    try {
      final data = await api.fetchDinhMucs();
      setState(() {
        items = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi tải danh sách định mức!')),
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

  Future<void> _fetchMucKhaus() async {
    try {
      final data = await api.fetchMucKhaus();
      setState(() {
        mucKhaus = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi tải danh sách mục khấu!')),
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

  String _getTenMucKhau(String idMucKhau) {
    final mucKhau = mucKhaus.firstWhere(
      (e) => e['idMucKhau']?.toString() == idMucKhau,
      orElse: () => <String, dynamic>{},
    );
    return mucKhau['tenMucKhau'] ?? '';
  }

  void _showDialog({Map<String, dynamic>? item, int? index}) {
    final isEdit = item != null;
    final TextEditingController idController = TextEditingController(
      text: item?['idDinhMuc'] ?? '',
    );
    final TextEditingController idGiaoKhoanController = TextEditingController(
      text: item?['idGiaoKhoan'] ?? '',
    );
    final TextEditingController idMucKhauController = TextEditingController(
      text: item?['idMucKhau'] ?? '',
    );
    final TextEditingController dinhMucController = TextEditingController(
      text: item?['dinhMuc']?.toString() ?? '',
    );
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(isEdit ? 'Sửa định mức' : 'Thêm định mức'),
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
                      DropdownButtonFormField<String>(
                        value:
                            idGiaoKhoanController.text.isEmpty
                                ? null
                                : idGiaoKhoanController.text,
                        decoration: const InputDecoration(
                          labelText: 'Mã giao khoán',
                          prefixIcon: Icon(Icons.link),
                        ),
                        items:
                            maGiaoKhoans
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e['idGiaoKhoan']?.toString(),
                                    child: Text('${e['idGiaoKhoan']}'),
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
                                    ? 'Chọn mã giao khoán'
                                    : null,
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value:
                            idMucKhauController.text.isEmpty
                                ? null
                                : idMucKhauController.text,
                        decoration: const InputDecoration(
                          labelText: 'Mục khấu',
                          prefixIcon: Icon(Icons.link),
                        ),
                        items:
                            mucKhaus
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e['idMucKhau']?.toString(),
                                    child: Text(
                                      '${e['idMucKhau']} - ${e['tenMucKhau'] ?? ''}',
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            idMucKhauController.text = value;
                          }
                        },
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Chọn mục khấu'
                                    : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: dinhMucController,
                        decoration: const InputDecoration(
                          labelText: 'Định mức',
                          prefixIcon: Icon(Icons.calculate),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty ? 'Nhập định mức' : null,
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
                      'idDinhMuc': idController.text,
                      'idGiaoKhoan': idGiaoKhoanController.text,
                      'idMucKhau': idMucKhauController.text,
                      'dinhMuc': double.tryParse(dinhMucController.text) ?? 0,
                    };
                    try {
                      if (isEdit && index != null) {
                        await api.updateDinhMuc(idController.text, newItem);
                      } else {
                        await api.addDinhMuc(newItem);
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
              'Bạn có chắc muốn xóa định mức "${items[index]['idDinhMuc']}"?',
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
                    await api.deleteDinhMuc(items[index]['idDinhMuc']);
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
                'Danh sách định mức',
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
                          DataColumn(label: Text('Mã giao khoán')),
                          DataColumn(label: Text('Mục khấu')),
                          DataColumn(label: Text('Định mức')),
                          DataColumn(label: Text('Hành động')),
                        ],
                        rows: List.generate(items.length, (i) {
                          final item = items[i];
                          return DataRow(
                            cells: [
                              DataCell(
                                Container(
                                  width: 100,
                                  child: Text(
                                    item['idDinhMuc'] ?? '',
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  width: 120,
                                  child: Text(
                                    '${item['idGiaoKhoan'] ?? ''}',
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  width: 200,
                                  child: Text(
                                    '${item['idMucKhau'] ?? ''} - ${_getTenMucKhau(item['idMucKhau'] ?? '')}',
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  width: 120,
                                  child: Text(
                                    item['dinhMuc']?.toString() ?? '',
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
