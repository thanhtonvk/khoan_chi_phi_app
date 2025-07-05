import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../widgets/date_picker_field.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class QuyetToanScreen extends StatefulWidget {
  const QuyetToanScreen({super.key});

  @override
  State<QuyetToanScreen> createState() => _QuyetToanScreenState();
}

class _QuyetToanScreenState extends State<QuyetToanScreen> {
  final ApiService api = ApiService();
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> accounts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _fetchAccounts();
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

  Future<void> _fetchAccounts() async {
    try {
      final data = await api.fetchAccounts();
      setState(() {
        accounts = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi tải danh sách tài khoản!')),
      );
    }
  }

  String _getTenTaiKhoan(String userId) {
    for (var account in accounts) {
      if (account['userId'] == userId) {
        return account['fullName'];
      }
    }
    return "";
  }

  Future<void> _exportToExcel() async {
    try {
      // Tạo Excel workbook
      final excel = Excel.createExcel();
      final sheet = excel['Quyết toán giao khoán'];

      // Thêm tiêu đề
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0))
          .value = 'ID';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0))
          .value = 'Ngày';
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0))
          .value = 'Tài khoản';

      // Thêm dữ liệu
      for (int i = 0; i < items.length; i++) {
        final item = items[i];
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1))
            .value = item['idQuyetToanGiaoKhoan'] ?? '';
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1))
            .value = item['ngay'] ?? '';
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1))
            .value = _getTenTaiKhoan(item['userId'] ?? '');
      }

      final fileName =
          'quyet_toan_giao_khoan_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final bytes = excel.encode()!;

      if (kIsWeb) {
        // Xử lý cho web
        final blob = html.Blob([bytes]);
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor =
            html.AnchorElement(href: url)
              ..setAttribute('download', fileName)
              ..click();
        html.Url.revokeObjectUrl(url);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Đã xuất Excel thành công: $fileName'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } else {
        // Thông báo cho mobile/desktop
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Tính năng xuất Excel chỉ hỗ trợ trên web'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi xuất Excel: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                      DatePickerField(
                        controller: ngayController,
                        labelText: 'Ngày',
                        hintText: 'Chọn ngày',
                        prefixIcon: Icons.date_range,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        dateFormat: 'yyyy-MM-dd',
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value:
                            userIdController.text.isEmpty
                                ? null
                                : userIdController.text,
                        decoration: const InputDecoration(
                          labelText: 'Tài khoản',
                          prefixIcon: Icon(Icons.person),
                        ),
                        items:
                            accounts
                                .map(
                                  (e) => DropdownMenuItem<String>(
                                    value: e['userId']?.toString(),
                                    child: Text(
                                      '${e['userId']} - ${e['fullName'] ?? ''}',
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            userIdController.text = value;
                          }
                        },
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? 'Chọn tài khoản'
                                    : null,
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
              Row(
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.file_download),
                    label: const Text('Xuất Excel'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    onPressed: _exportToExcel,
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Thêm'),
                    onPressed: () => _showDialog(),
                  ),
                ],
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
                          DataColumn(label: Text('Tài khoản')),
                          DataColumn(label: Text('Hành động')),
                        ],
                        rows: List.generate(items.length, (i) {
                          final item = items[i];
                          return DataRow(
                            cells: [
                              DataCell(
                                Container(
                                  width: 120,
                                  child: Text(
                                    item['idQuyetToanGiaoKhoan'] ?? '',
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  width: 120,
                                  child: Text(
                                    item['ngay'] ?? '',
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              DataCell(
                                Container(
                                  width: 200,
                                  child: Text(
                                    _getTenTaiKhoan(item['userId'] ?? ''),
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
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
