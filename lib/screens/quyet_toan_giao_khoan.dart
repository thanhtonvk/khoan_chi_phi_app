import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:khoan_chi_phi_app/services/api_service.dart';
import '../utils/money_formatter.dart';
import '../widgets/money_display.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class QuyetToanGiaoKhoan extends StatefulWidget {
  const QuyetToanGiaoKhoan({super.key});

  @override
  State<QuyetToanGiaoKhoan> createState() => _QuyetToanGiaoKhoanState();
}

class _QuyetToanGiaoKhoanState extends State<QuyetToanGiaoKhoan> {
  final ApiService api = ApiService();
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> itemsGiaoKhoan = [];
  List<Map<String, dynamic>> itemsMerge = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchChiTietGiaoKhoans();
  }

  Future<void> _fetchChiTietGiaoKhoans() async {
    setState(() => isLoading = true);
    try {
      final data = await api.fetchChiTietGiaoKhoans();
      itemsGiaoKhoan = List<Map<String, dynamic>>.from(data);
      final data2 = await api.fetchTaiSans();
      items = List<Map<String, dynamic>>.from(data2);
      itemsMerge = mergeData(vatTuList: items, chiTietList: itemsGiaoKhoan);
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi tải danh sách chi tiết giao khoán!')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  List<Map<String, dynamic>> mergeData({
    required List<Map<String, dynamic>> vatTuList,
    required List<Map<String, dynamic>> chiTietList,
  }) {
    // Tạo map nhanh từ idTaiSan -> chiTiet
    final chiTietMap = {
      for (var item in chiTietList) item['idGiaoKhoan']: item,
    };

    // Gom nhóm theo các trường yêu cầu
    final Map<String, List<Map<String, dynamic>>> grouped = {};

    for (var vatTu in vatTuList) {
      final idTaiSan = vatTu['idTaiSan'];

      // Tạo key gom nhóm
      final key = "${vatTu['idGiaoKhoan']}";

      // Nếu tài sản có chi tiết => merge thêm
      if (chiTietMap.containsKey(idTaiSan)) {
        vatTu = {...chiTietMap[idTaiSan]!, ...vatTu};
        grouped.putIfAbsent(key, () => []);
        grouped[key]!.add(vatTu);
      }
    }

    // Chuyển map thành list kết quả cuối
    return grouped.entries.map((entry) {
      final parts = entry.key.split('|');
      return {
        'idGiaoKhoan': parts[0],
        'tenVatTu': entry.value[0]['tenVatTu'],
        'donViTinh': entry.value[0]['donViTinh'],
        'donGiaBinhQuanHienTai': entry.value[0]['donGiaBinhQuanHienTai'],
        'danhSachTaiSan': entry.value,
      };
    }).toList();
  }

  Future<void> _exportToExcel() async {
    try {
      // Tạo Excel workbook
      final excel = Excel.createExcel();
      final sheet = excel['Quyết toán giao khoán'];

      // Thêm tiêu đề
      final headers = [
        'TT',
        'Mã vật tư',
        'Trùng mã vật tư',
        'Mã thiết bị',
        'Mã giao khoán',
        'Tên vật tư, tài sản',
        'ĐVT',
        'Đơn giá khoán',
        '',
        'HS điều chỉnh ĐM',
        'Định mức',
        'Số lượng Kế hoạch',
        '',
        '',
        'Giá trị Kế hoạch',
        'Số lượng thực hiện',
        '',
        '',
        'Giá trị Thực hiện',
        'So sánh lãi (+); lỗ (-)',
        '',
      ];

      for (int i = 0; i < headers.length; i++) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0))
            .value = headers[i];
      }

      // Thêm dữ liệu
      int rowIndex = 1;
      for (int i = 0; i < itemsMerge.length; i++) {
        final item = itemsMerge[i];

        // Dòng tổng hợp
        sheet
            .cell(
              CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex),
            )
            .value = '';
        sheet
            .cell(
              CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex),
            )
            .value = '';
        sheet
            .cell(
              CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex),
            )
            .value = '';
        sheet
            .cell(
              CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex),
            )
            .value = item['idGiaoKhoan']?.toString() ?? '';
        sheet
            .cell(
              CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex),
            )
            .value = item['idGiaoKhoan']?.toString() ?? '';
        sheet
            .cell(
              CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex),
            )
            .value = item['tenVatTu']?.toString() ?? '';
        sheet
            .cell(
              CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex),
            )
            .value = item['donViTinh']?.toString() ?? '';
        sheet
            .cell(
              CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex),
            )
            .value = item['donGiaBinhQuanHienTai']?.toString() ?? '';
        rowIndex++;

        // Dòng chi tiết
        final danhSachTaiSan = item['danhSachTaiSan'] as List<dynamic>;
        for (int j = 0; j < danhSachTaiSan.length; j++) {
          final taiSan = danhSachTaiSan[j];

          sheet
              .cell(
                CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex),
              )
              .value = '';
          sheet
              .cell(
                CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex),
              )
              .value = taiSan['idTaiSan']?.toString() ?? '';
          sheet
              .cell(
                CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex),
              )
              .value = '1';
          sheet
              .cell(
                CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex),
              )
              .value = '';
          sheet
              .cell(
                CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex),
              )
              .value = '';
          sheet
              .cell(
                CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex),
              )
              .value = taiSan['tenVatTu']?.toString() ?? '';
          sheet
              .cell(
                CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex),
              )
              .value = taiSan['donViTinh']?.toString() ?? '';
          sheet
              .cell(
                CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex),
              )
              .value = taiSan['donGiaBinhQuanHienTai']?.toString() ?? '';

          // Tính toán giá trị
          final soLuongKeHoach = taiSan['soLuongKeHoachNgoaiKhoan'] ?? 0;
          final soLuongThucHien = taiSan['soLuongThucHienNgoaiKhoan'] ?? 0;
          final donGia = taiSan['donGiaBinhQuanHienTai'] ?? 0;

          final giaTriKeHoach = soLuongKeHoach * donGia;
          final giaTriThucHien = soLuongThucHien * donGia;
          final soSanh = giaTriThucHien - giaTriKeHoach;

          sheet
              .cell(
                CellIndex.indexByColumnRow(columnIndex: 10, rowIndex: rowIndex),
              )
              .value = soLuongKeHoach.toString();
          sheet
              .cell(
                CellIndex.indexByColumnRow(columnIndex: 14, rowIndex: rowIndex),
              )
              .value = MoneyFormatter.formatVND(giaTriKeHoach);
          sheet
              .cell(
                CellIndex.indexByColumnRow(columnIndex: 15, rowIndex: rowIndex),
              )
              .value = soLuongThucHien.toString();
          sheet
              .cell(
                CellIndex.indexByColumnRow(columnIndex: 19, rowIndex: rowIndex),
              )
              .value = MoneyFormatter.formatVND(giaTriThucHien);
          sheet
              .cell(
                CellIndex.indexByColumnRow(columnIndex: 20, rowIndex: rowIndex),
              )
              .value = MoneyFormatter.formatVND(soSanh);

          rowIndex++;
        }
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

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 1200;

    // Tính tổng các giá trị
    double totalGiaTriKeHoach = 0;
    double totalGiaTriThucHien = 0;
    double totalSoSanh = 0;

    for (var item in itemsMerge) {
      final danhSachTaiSan = item['danhSachTaiSan'] as List<dynamic>;
      for (var taiSan in danhSachTaiSan) {
        final soLuongKeHoach = taiSan['soLuongKeHoachNgoaiKhoan'] ?? 0;
        final soLuongThucHien = taiSan['soLuongThucHienNgoaiKhoan'] ?? 0;
        final donGia = taiSan['donGiaBinhQuanHienTai'] ?? 0;

        final giaTriKeHoach = soLuongKeHoach * donGia;
        final giaTriThucHien = soLuongThucHien * donGia;

        totalGiaTriKeHoach += giaTriKeHoach;
        totalGiaTriThucHien += giaTriThucHien;
      }
    }
    totalSoSanh = totalGiaTriThucHien - totalGiaTriKeHoach;

    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.analytics_outlined,
                size: 32,
                color: Color(0xFF3F51B5),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quyết toán Giao khoán',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF303F9F),
                      ),
                    ),
                    Text(
                      'Báo cáo quyết toán giao khoán chi tiết',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.file_download),
                label: Text('Xuất Excel'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF4CAF50),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                onPressed: _exportToExcel,
              ),
            ],
          ),
          SizedBox(height: 24),

          // Stats Cards
          if (isLargeScreen) ...[
            Row(
              children: [
                _buildStatCard(
                  'Tổng giá trị Kế hoạch',
                  MoneyFormatter.formatVND(totalGiaTriKeHoach),
                  Icons.assignment_turned_in,
                  Color(0xFF2196F3),
                ),
                SizedBox(width: 16),
                _buildStatCard(
                  'Tổng giá trị Thực hiện',
                  MoneyFormatter.formatVND(totalGiaTriThucHien),
                  Icons.check_circle,
                  Color(0xFF4CAF50),
                ),
                SizedBox(width: 16),
                _buildStatCard(
                  'Chênh lệch',
                  MoneyFormatter.formatVND(totalSoSanh),
                  totalSoSanh >= 0 ? Icons.trending_up : Icons.trending_down,
                  totalSoSanh >= 0 ? Color(0xFF4CAF50) : Color(0xFFF44336),
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
                            CircularProgressIndicator(color: Color(0xFF3F51B5)),
                            SizedBox(height: 16),
                            Text('Đang tải dữ liệu...'),
                          ],
                        ),
                      )
                      : itemsMerge.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.analytics_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Chưa có dữ liệu quyết toán',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Dữ liệu sẽ được hiển thị khi có thông tin giao khoán',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      )
                      : VatTuExcelTablePage(items: itemsMerge),
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
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

class VatTuExcelTablePage extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const VatTuExcelTablePage({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Table(
          columnWidths: {
            0: FixedColumnWidth(50),
            1: FixedColumnWidth(120),
            2: FixedColumnWidth(50),
            3: FixedColumnWidth(50),
            4: FixedColumnWidth(70),
            5: FixedColumnWidth(230),
            11: FixedColumnWidth(120),
            13: FixedColumnWidth(120),
            14: FixedColumnWidth(120),
          },
          defaultColumnWidth: FixedColumnWidth(65),
          border: TableBorder.all(color: Colors.black26, width: 1),
          children: [
            // Header dòng 1
            TableRow(
              children: [
                _headerCell('TT', rowSpan: 2),
                _headerCell('Mã vật tư', rowSpan: 2),
                _headerCell('Trùng mã vật tư', rowSpan: 2),
                _headerCell('Mã thiết bị', rowSpan: 2),
                _headerCell('Mã giao khoán', rowSpan: 2),
                _headerCell('Tên vật tư, tài sản', rowSpan: 2),
                _headerCell('ĐVT', rowSpan: 2),
                _headerCell('Đơn giá khoán', colSpan: 2),
                _headerCell('HS điều chỉnh ĐM', rowSpan: 2),
                _headerCell('Định mức', rowSpan: 2),
                _headerCell('Số lượng Kế hoạch', colSpan: 3),
                _headerCell('Giá trị Kế hoạch', rowSpan: 2),
                _headerCell('Số lượng thực hiện', colSpan: 3),
                _headerCell('Giá trị Thực hiện', rowSpan: 2),
                _headerCell('So sánh lãi (+); lỗ (-)', colSpan: 2),
              ],
            ),
            // Header dòng 2

            // Dữ liệu mẫu (5 dòng đầu)
            ...fillData(items),
          ],
        ),
      ),
    );
  }
}

List<TableRow> fillData(List<Map<String, dynamic>> items) {
  final List<TableRow> rows = [];
  for (int i = 0; i < items.length; i++) {
    rows.add(
      _dataRow([
        '',
        '',
        '',
        items[i]["idGiaoKhoan"].toString(),
        items[i]["idGiaoKhoan"].toString(),
        items[i]["tenVatTu"].toString(),
        items[i]["donViTinh"].toString(),
        items[i]["donGiaBinhQuanHienTai"].toString().toCurrency(),
        '',
        '',
        '',
        '',
        '',
        '',
        '',
      ], highlight: true),
    );
    for (int j = 0; j < items[i]["danhSachTaiSan"].toList().length; j++) {
      rows.add(
        _dataRow([
          '',
          items[i]["danhSachTaiSan"][j]["idTaiSan"].toString(),
          '1',
          '',
          '',
          items[i]["danhSachTaiSan"][j]["tenVatTu"].toString(),
          items[i]["danhSachTaiSan"][j]["donViTinh"].toString(),
          items[i]["danhSachTaiSan"][j]["donGiaBinhQuanHienTai"]
              .toString()
              .toCurrency(),
          '',
          '',
          items[i]["danhSachTaiSan"][j]["soLuongKeHoachNgoaiKhoan"]
                  ?.toString() ??
              '',
          ((items[i]["danhSachTaiSan"][j]["soLuongKeHoachNgoaiKhoan"] ?? 0) *
                      (items[i]["danhSachTaiSan"][j]["donGiaBinhQuanHienTai"] ??
                          0))
                  ?.toString()
                  .toCurrency() ??
              '',
          items[i]["danhSachTaiSan"][j]["soLuongThucHienNgoaiKhoan"]
                  ?.toString() ??
              '',
          ((items[i]["danhSachTaiSan"][j]["soLuongThucHienNgoaiKhoan"] ?? 0) *
                      (items[i]["danhSachTaiSan"][j]["donGiaBinhQuanHienTai"] ??
                          0))
                  ?.toString()
                  .toCurrency() ??
              '',
          (((items[i]["danhSachTaiSan"][j]["soLuongThucHienNgoaiKhoan"] ?? 0) *
                          (items[i]["danhSachTaiSan"][j]["donGiaBinhQuanHienTai"] ??
                              0)) -
                      ((items[i]["danhSachTaiSan"][j]["soLuongKeHoachNgoaiKhoan"] ??
                              0) *
                          (items[i]["danhSachTaiSan"][j]["donGiaBinhQuanHienTai"] ??
                              0)))
                  ?.toString()
                  .toCurrency() ??
              '',
        ]),
      );
    }
  }
  return rows;
}

extension StringMoneyFormat on String {
  String toCurrency({String locale = 'vi_VN'}) {
    try {
      final numValue = num.parse(this.replaceAll(',', ''));
      final formatter = NumberFormat.currency(locale: locale, symbol: '₫');
      return formatter.format(numValue).trim(); // Ví dụ: 1.000.000 ₫
    } catch (e) {
      return this;
    }
  }
}

Widget _headerCell(String text, {int rowSpan = 1, int colSpan = 1}) {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
    child: Text(
      text,
      textAlign: TextAlign.center,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
    ),
  );
}

TableRow _dataRow(List<String> cells, {bool highlight = false}) {
  return TableRow(
    decoration:
        highlight ? const BoxDecoration(color: Color(0xFFFFFF99)) : null,
    children:
        cells
            .map(
              (cell) => Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
                child: Text(cell, style: const TextStyle(fontSize: 13)),
              ),
            )
            .toList(),
  );
}
