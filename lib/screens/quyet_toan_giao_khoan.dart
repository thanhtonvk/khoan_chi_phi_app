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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _fetchChiTietGiaoKhoans();
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
        const SnackBar(content: Text('Lỗi tải danh sách quyết toán!')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _fetchChiTietGiaoKhoans() async {
    setState(() => isLoading = true);
    try {
      final data = await api.fetchChiTietGiaoKhoans();
      setState(() {
        itemsGiaoKhoan = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi tải danh sách chi tiết giao khoán!')),
      );
    } finally {
      setState(() => isLoading = false);
    }
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
          Expanded(child: VatTuExcelTablePage())
         ],
      ),
    );
  }
}

class VatTuExcelTablePage extends StatelessWidget {
  const VatTuExcelTablePage({Key? key}) : super(key: key);

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
              _dataRow([
                '',
                'GL01158VNMM',
                '1',
                'KT',
                'KT10',
                'Gỗ Bạch đàn, keo chèn lò Φ8:-12 cm L=2,2m',
                'm³',
                '1.054.664',
                '',
                '',
                '1,000',
                '1.054.664',
                '2,000',
                '2.109.328',
                '-1.054.664',
              ]),
              _dataRow([
                '',
                'GL01206VNMM',
                '1',
                'KT',
                '',
                'Gỗ Keo chèn lò   Φ8-:-12cm L=2,4 m',
                'm³',
                '1.054.664',
                '',
                '',
                '1,000',
                '1.054.664',
                '3,000',
                '3.163.993',
                '-2.109.328',
              ]),
              _dataRow([
                '',
                'GL01217VNMM',
                '1',
                'KT',
                '',
                'Gỗ Bạch đàn chèn lò   Φ6 -:-8cm L=2,4 m',
                'm³',
                '1.054.664',
                '',
                '',
                '1,000',
                '1.054.664',
                '3,000',
                '3.163.993',
                '-2.109.328',
              ]),
              _dataRow([
                '',
                'GL01157VNMM',
                '1',
                'KT',
                '',
                'Gỗ bạch đàn , keo chèn lò Φ8-:-12 cm L=2,4m',
                'm³',
                '1.054.664',
                '',
                '',
                '1,000',
                '1.054.664',
                '3,000',
                '3.163.993',
                '-2.109.328',
              ]),
              _dataRow([
                '',
                '',
                '1',
                'KT',
                'KT12',
                'Thuốc nổ NTLT-2',
                'kg',
                '42.578',
                '',
                '',
                '',
                '',
                '',
                '',
                '',
              ],highlight: true),
              _dataRow([
                '',
                'TN10002VNMM',
                '1',
                'KT',
                '',
                'Thuốc nổ nhũ tương an toàn dùng cho mỏ hầm lò có khí nổ (NTLT) - D36  ',
                'Kg',
                '42.578',
                '',
                '',
                '2,000',
                '85.157',
                '3,000',
                '127.735',
                '-42.578',
              ]),
              _dataRow([
                '',
                'TN10006VNMM',
                '1',
                'KT',
                '',
                'Thuốc nổ nhũ tương an toàn dùng cho mỏ hầm lò có khí nổ (NTLT2) - D36  ',
                'Kg',
                '42.578',
                '',
                '',
                '2,000',
                '85.157',
                '1,000',
                '42.578',
                '42.578',
              ]),
            ],
          ),
        ),
      );
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
