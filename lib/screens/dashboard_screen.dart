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
  final List<Map<String, dynamic>> _menuItems = [
    {
      'title': 'Tài khoản',
      'icon': Icons.people_alt,
      'description': 'Quản lý tài khoản người dùng',
      'color': Color(0xFF2196F3),
    },
    {
      'title': 'Mã giao khoán',
      'icon': Icons.qr_code,
      'description': 'Quản lý mã giao khoán',
      'color': Color(0xFF4CAF50),
    },
    {
      'title': 'Tài sản',
      'icon': Icons.inventory_2,
      'description': 'Quản lý tài sản, vật tư',
      'color': Color(0xFFFF9800),
    },
    {
      'title': 'Khẩu',
      'icon': Icons.category_outlined,
      'description': 'Quản lý danh mục khẩu',
      'color': Color(0xFF9C27B0),
    },
    {
      'title': 'Mục khẩu',
      'icon': Icons.list_alt,
      'description': 'Quản lý mục khẩu chi tiết',
      'color': Color(0xFF607D8B),
    },
    {
      'title': 'Định mức',
      'icon': Icons.calculate_outlined,
      'description': 'Quản lý định mức giao khoán',
      'color': Color(0xFF795548),
    },
    {
      'title': 'Quyết toán',
      'icon': Icons.assignment_turned_in,
      'description': 'Quản lý quyết toán',
      'color': Color(0xFFE91E63),
    },
    {
      'title': 'Chi tiết giao khoán',
      'icon': Icons.details_outlined,
      'description': 'Quản lý chi tiết giao khoán',
      'color': Color(0xFF00BCD4),
    },
    {
      'title': 'Quyết toán giao khoán',
      'icon': Icons.analytics_outlined,
      'description': 'Báo cáo quyết toán giao khoán',
      'color': Color(0xFF3F51B5),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 1200;
    final isMediumScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.dashboard, color: Colors.white),
            SizedBox(width: 12),
            Text('Quản lý Khoán chi phí'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            tooltip: 'Thông báo',
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Không có thông báo mới')));
            },
          ),
          IconButton(
            icon: Icon(Icons.settings_outlined),
            tooltip: 'Cài đặt',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tính năng đang phát triển')),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar
          if (isLargeScreen)
            Container(
              width: 280,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 0),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF1976D2),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.person, color: Color(0xFF1976D2)),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Admin',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                'Quản trị viên',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Menu items
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      itemCount: _menuItems.length,
                      itemBuilder: (context, index) {
                        final item = _menuItems[index];
                        final isSelected = _selectedIndex == index;

                        return Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap:
                                  () => setState(() => _selectedIndex = index),
                              child: Container(
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color:
                                      isSelected
                                          ? item['color'].withOpacity(0.1)
                                          : null,
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      isSelected
                                          ? Border.all(
                                            color: item['color'],
                                            width: 2,
                                          )
                                          : null,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      item['icon'],
                                      color:
                                          isSelected
                                              ? item['color']
                                              : Colors.grey[600],
                                      size: 24,
                                    ),
                                    SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item['title'],
                                            style: TextStyle(
                                              fontWeight:
                                                  isSelected
                                                      ? FontWeight.bold
                                                      : FontWeight.normal,
                                              color:
                                                  isSelected
                                                      ? item['color']
                                                      : Colors.grey[800],
                                            ),
                                          ),
                                          Text(
                                            item['description'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: item['color'],
                                        size: 16,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          else if (isMediumScreen)
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected:
                  (index) => setState(() => _selectedIndex = index),
              labelType: NavigationRailLabelType.all,
              backgroundColor: Colors.white,
              selectedIconTheme: IconThemeData(color: Color(0xFF2196F3)),
              unselectedIconTheme: IconThemeData(color: Colors.grey[600]),
              destinations:
                  _menuItems
                      .map(
                        (item) => NavigationRailDestination(
                          icon: Icon(item['icon']),
                          label: Text(item['title']),
                        ),
                      )
                      .toList(),
            )
          else
            Container(), // Mobile will use bottom navigation

          if (isLargeScreen || isMediumScreen) VerticalDivider(width: 1),

          // Main content
          Expanded(
            child: Container(color: Colors.grey[50], child: _buildContent()),
          ),
        ],
      ),
      bottomNavigationBar:
          isLargeScreen || isMediumScreen
              ? null
              : BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: _selectedIndex,
                onTap: (index) => setState(() => _selectedIndex = index),
                selectedItemColor: Color(0xFF2196F3),
                unselectedItemColor: Colors.grey[600],
                items:
                    _menuItems
                        .take(5)
                        .map(
                          (item) => BottomNavigationBarItem(
                            icon: Icon(item['icon']),
                            label: item['title'],
                          ),
                        )
                        .toList(),
              ),
    );
  }

  Widget _buildContent() {
    return Container(
      padding: EdgeInsets.all(24),
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
              : _buildComingSoon(),
    );
  }

  Widget _buildComingSoon() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.construction, size: 80, color: Colors.grey[400]),
          SizedBox(height: 24),
          Text(
            'Chức năng: ${_menuItems[_selectedIndex]['title']}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 12),
          Text(
            'Đang phát triển...',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 32),
          ElevatedButton.icon(
            icon: Icon(Icons.arrow_back),
            label: Text('Quay lại'),
            onPressed: () => setState(() => _selectedIndex = 0),
          ),
        ],
      ),
    );
  }
}
