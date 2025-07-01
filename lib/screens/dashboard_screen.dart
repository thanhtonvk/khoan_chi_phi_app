import 'package:flutter/material.dart';
import 'package:khoan_chi_phi_app/screens/quyet_toan_giao_khoan.dart';
import 'account_screen.dart';
import 'ma_giao_khoan_screen.dart';
import 'tai_san_screen.dart';
import 'khau_screen.dart';
import 'muc_khau_screen.dart';
import 'dinh_muc_screen.dart';
import 'quyet_toan_screen.dart';
import 'chi_tiet_giao_khoan_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  final List<String> _menuTitles = [
    'Tài khoản',
    'Mã giao khoán',
    'Tài sản',
    'Khẩu',
    'Mục khẩu',
    'Định mức',
    'Quyết toán',
    'Chi tiết giao khoán',
    'Quyết toán giao khoán',
  ];
  final List<IconData> _menuIcons = [
    Icons.people,
    Icons.code,
    Icons.inventory,
    Icons.category,
    Icons.list_alt,
    Icons.calculate,
    Icons.assignment,
    Icons.details,
    Icons.details,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý Khoán chi phí'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected:
                (index) => setState(() => _selectedIndex = index),
            labelType: NavigationRailLabelType.all,
            destinations: List.generate(
              _menuTitles.length,
              (i) => NavigationRailDestination(
                icon: Icon(_menuIcons[i]),
                label: Text(_menuTitles[i]),
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child:
                _selectedIndex == 0
                    ? const AccountScreen()
                    : _selectedIndex == 1
                    ? const MaGiaoKhoanScreen()
                    : _selectedIndex == 2
                    ? const TaiSanScreen()
                    : _selectedIndex == 3
                    ? const KhauScreen()
                    : _selectedIndex == 4
                    ? const MucKhauScreen()
                    : _selectedIndex == 5
                    ? const DinhMucScreen()
                    : _selectedIndex == 6
                    ? const QuyetToanScreen()
                    : _selectedIndex == 7
                    ? const ChiTietGiaoKhoanScreen()
                    : _selectedIndex == 8
                    ? const QuyetToanGiaoKhoan()
                    : Center(
                      child: Text(
                        'Chức năng: ${_menuTitles[_selectedIndex]}\n(Đang phát triển)',
                        style: Theme.of(context).textTheme.headlineMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
