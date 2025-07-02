import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ChiTietGiaoKhoanScreen extends StatefulWidget {
  const ChiTietGiaoKhoanScreen({super.key});

  @override
  State<ChiTietGiaoKhoanScreen> createState() => _ChiTietGiaoKhoanScreenState();
}

class _ChiTietGiaoKhoanScreenState extends State<ChiTietGiaoKhoanScreen> {
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
      final data = await api.fetchChiTietGiaoKhoans();
      setState(() {
        items = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi tải danh sách chi tiết giao khoán!')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showDialog({Map<String, dynamic>? item, int? index}) {
    final isEdit = item != null;
    final TextEditingController idController = TextEditingController(
      text: item?['idChiTietGiaoKhoan'] ?? '',
    );
    final TextEditingController idGiaoKhoanController = TextEditingController(
      text: item?['idGiaoKhoan'] ?? '',
    );
    final TextEditingController dinhMucGocController = TextEditingController(
      text: item?['dinhMucGoc']?.toString() ?? '',
    );
    final TextEditingController heSoDieuChinhController = TextEditingController(
      text: item?['heSoDieuChinh']?.toString() ?? '',
    );
    final TextEditingController soLuongKeHoachController =
        TextEditingController(
          text: item?['soLuongKeHoachNgoaiKhoan']?.toString() ?? '',
        );
    final TextEditingController soLuongThucHienController =
        TextEditingController(
          text: item?['soLuongThucHienNgoaiKhoan']?.toString() ?? '',
        );
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(
              isEdit ? 'Sửa chi tiết giao khoán' : 'Thêm chi tiết giao khoán',
            ),
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
                          labelText: 'ID Tài sản',
                          prefixIcon: Icon(Icons.link),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Nhập ID tài sản'
                                    : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: dinhMucGocController,
                        decoration: const InputDecoration(
                          labelText: 'Định mức gốc',
                          prefixIcon: Icon(Icons.calculate),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Nhập định mức gốc'
                                    : null,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: heSoDieuChinhController,
                        decoration: const InputDecoration(
                          labelText: 'Hệ số điều chỉnh',
                          prefixIcon: Icon(Icons.tune),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Nhập hệ số điều chỉnh'
                                    : null,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: soLuongKeHoachController,
                        decoration: const InputDecoration(
                          labelText: 'Số lượng kế hoạch ngoài khoán',
                          prefixIcon: Icon(Icons.numbers),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Nhập số lượng kế hoạch'
                                    : null,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: soLuongThucHienController,
                        decoration: const InputDecoration(
                          labelText: 'Số lượng thực hiện ngoài khoán',
                          prefixIcon: Icon(Icons.numbers),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Nhập số lượng thực hiện'
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
                      'idChiTietGiaoKhoan': idController.text,
                      'idGiaoKhoan': idGiaoKhoanController.text,
                      'dinhMucGoc':
                          double.tryParse(dinhMucGocController.text) ?? 0,
                      'heSoDieuChinh':
                          double.tryParse(heSoDieuChinhController.text) ?? 0,
                      'soLuongKeHoachNgoaiKhoan':
                          int.tryParse(soLuongKeHoachController.text) ?? 0,
                      'soLuongThucHienNgoaiKhoan':
                          int.tryParse(soLuongThucHienController.text) ?? 0,
                    };
                    try {
                      if (isEdit && index != null) {
                        await api.updateChiTietGiaoKhoan(
                          idController.text,
                          newItem,
                        );
                      } else {
                        await api.addChiTietGiaoKhoan(newItem);
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
              'Bạn có chắc muốn xóa chi tiết giao khoán "${items[index]['idChiTietGiaoKhoan']}"?',
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
                    await api.deleteChiTietGiaoKhoan(
                      items[index]['idChiTietGiaoKhoan'],
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
                'Danh sách chi tiết giao khoán',
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
                          DataColumn(label: Text('ID Tài sản')),
                          DataColumn(label: Text('Định mức gốc')),
                          DataColumn(label: Text('Hệ số điều chỉnh')),
                          DataColumn(label: Text('Số lượng KH ngoài khoán')),
                          DataColumn(label: Text('Số lượng TH ngoài khoán')),
                          DataColumn(label: Text('Hành động')),
                        ],
                        rows: List.generate(items.length, (i) {
                          final item = items[i];
                          return DataRow(
                            cells: [
                              DataCell(Text(item['idChiTietGiaoKhoan'] ?? '')),
                              DataCell(Text(item['idGiaoKhoan'] ?? '')),
                              DataCell(
                                Text(item['dinhMucGoc']?.toString() ?? ''),
                              ),
                              DataCell(
                                Text(item['heSoDieuChinh']?.toString() ?? ''),
                              ),
                              DataCell(
                                Text(
                                  item['soLuongKeHoachNgoaiKhoan']
                                          ?.toString() ??
                                      '',
                                ),
                              ),
                              DataCell(
                                Text(
                                  item['soLuongThucHienNgoaiKhoan']
                                          ?.toString() ??
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
