import 'package:flutter/material.dart';
import 'package:khoan_chi_phi_app/services/api_service.dart';

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
      itemsMerge = mergeData(vatTuList:items,chiTietList:itemsGiaoKhoan);
      setState(() {
      });
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
      vatTu = {
        ...chiTietMap[idTaiSan]!,
        ...vatTu,
      };
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
                'QUYẾT TOÁN GIAO KHOÁN THÁNG 1',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: VatTuExcelTablePage(items: itemsMerge,))
         ],
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
            },
            defaultColumnWidth: FixedColumnWidth(80),
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
List<TableRow> fillData(List<Map<String, dynamic>> items){
  final List<TableRow> rows = [];
  for (int i =0; i < items.length; i ++) {
    rows.add(_dataRow([
                '',
                '',
                '',
                items[i]["idGiaoKhoan"].toString(),
                items[i]["idGiaoKhoan"].toString(),
                items[i]["tenVatTu"].toString(),
                items[i]["donViTinh"].toString(),
                items[i]["donGiaBinhQuanHienTai"].toString(),
                '',
                '',
                '',
                '',
                '',
                '',
                '',
              ],highlight: true),);
    for (int j = 0; j <items[i]["danhSachTaiSan"].toList().length; j++) {
      rows.add(_dataRow([
                '',
                items[i]["danhSachTaiSan"][j]["idTaiSan"].toString(),
                '1',
                '',
                '',
                items[i]["danhSachTaiSan"][j]["tenVatTu"].toString(),
                items[i]["danhSachTaiSan"][j]["donViTinh"].toString(),
                items[i]["danhSachTaiSan"][j]["donGiaBinhQuanHienTai"].toString(),
                '',
                '',
                items[i]["danhSachTaiSan"][j]["soLuongKeHoachNgoaiKhoan"]?.toString() ?? '',
                ((items[i]["danhSachTaiSan"][j]["soLuongKeHoachNgoaiKhoan"] ?? 0) * (items[i]["danhSachTaiSan"][j]["donGiaBinhQuanHienTai"] ?? 0))?.toString() ?? '',
                items[i]["danhSachTaiSan"][j]["soLuongThucHienNgoaiKhoan"]?.toString() ?? '',
                ((items[i]["danhSachTaiSan"][j]["soLuongThucHienNgoaiKhoan"]?? 0) * (items[i]["danhSachTaiSan"][j]["donGiaBinhQuanHienTai"]?? 0))?.toString() ?? '',
                (((items[i]["danhSachTaiSan"][j]["soLuongThucHienNgoaiKhoan"]?? 0) * (items[i]["danhSachTaiSan"][j]["donGiaBinhQuanHienTai"]?? 0)) - ((items[i]["danhSachTaiSan"][j]["soLuongThucHienNgoaiKhoan"]?? 0) * (items[i]["danhSachTaiSan"][j]["donGiaBinhQuanHienTai"]?? 0)))?.toString() ?? '',
              ]),);
    }
  }
  return rows;
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
