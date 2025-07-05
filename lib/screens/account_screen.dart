import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../widgets/date_picker_field.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final ApiService api = ApiService();
  List<Map<String, dynamic>> accounts = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAccounts();
  }

  Future<void> _fetchAccounts() async {
    setState(() => isLoading = true);
    try {
      final data = await api.fetchAccounts();
      setState(() {
        accounts = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi tải danh sách tài khoản!')),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _showAccountDialog({Map<String, dynamic>? account, int? index}) {
    final isEdit = account != null;
    final TextEditingController userIdController = TextEditingController(
      text: account?['userId'] ?? '',
    );
    final TextEditingController userNameController = TextEditingController(
      text: account?['userName'] ?? '',
    );
    final TextEditingController fullNameController = TextEditingController(
      text: account?['fullName'] ?? '',
    );
    final TextEditingController dobController = TextEditingController(
      text: account?['dob'] ?? '',
    );
    final TextEditingController permissionController = TextEditingController(
      text: account?['permission']?.toString() ?? '',
    );
    final TextEditingController passwordController = TextEditingController();
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(
                  isEdit ? Icons.edit : Icons.person_add,
                  color: Color(0xFF2196F3),
                ),
                SizedBox(width: 12),
                Text(isEdit ? 'Sửa tài khoản' : 'Thêm tài khoản'),
              ],
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
                        controller: userIdController,
                        decoration: InputDecoration(
                          labelText: 'User ID',
                          hintText: 'Nhập mã người dùng',
                          prefixIcon: Icon(Icons.badge_outlined),
                          suffixIcon: Icon(
                            Icons.verified_user,
                            color: Colors.grey[400],
                          ),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Vui lòng nhập User ID'
                                    : null,
                        enabled: !isEdit,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: userNameController,
                        decoration: InputDecoration(
                          labelText: 'Tên đăng nhập',
                          hintText: 'Nhập tên đăng nhập',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Vui lòng nhập tên đăng nhập'
                                    : null,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: fullNameController,
                        decoration: InputDecoration(
                          labelText: 'Họ tên',
                          hintText: 'Nhập họ và tên đầy đủ',
                          prefixIcon: Icon(Icons.account_circle_outlined),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Vui lòng nhập họ tên'
                                    : null,
                      ),
                      SizedBox(height: 16),
                      DatePickerField(
                        controller: dobController,
                        labelText: 'Ngày sinh',
                        hintText: 'Chọn ngày sinh',
                        prefixIcon: Icons.cake_outlined,
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                        dateFormat: 'dd/MM/yyyy',
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: permissionController,
                        decoration: InputDecoration(
                          labelText: 'Quyền hạn',
                          hintText: 'Nhập cấp độ quyền (0-9)',
                          prefixIcon: Icon(Icons.security_outlined),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Vui lòng nhập quyền hạn'
                                    : null,
                      ),
                      if (!isEdit) ...[
                        SizedBox(height: 16),
                        TextFormField(
                          controller: passwordController,
                          decoration: InputDecoration(
                            labelText: 'Mật khẩu',
                            hintText: 'Nhập mật khẩu mới',
                            prefixIcon: Icon(Icons.lock_outline),
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Vui lòng nhập mật khẩu'
                                      : null,
                          obscureText: true,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              TextButton.icon(
                icon: Icon(Icons.cancel_outlined),
                label: Text('Hủy'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton.icon(
                icon: Icon(isEdit ? Icons.save_outlined : Icons.add),
                label: Text(isEdit ? 'Lưu thay đổi' : 'Thêm mới'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final newAccount = {
                      'userId': userIdController.text,
                      'userName': userNameController.text,
                      'fullName': fullNameController.text,
                      'dob': dobController.text,
                      'permission':
                          int.tryParse(permissionController.text) ?? 0,
                      if (!isEdit) 'password': passwordController.text,
                    };
                    try {
                      if (isEdit && index != null) {
                        await api.updateAccount(
                          userIdController.text,
                          newAccount,
                        );
                      } else {
                        await api.addAccount(newAccount);
                      }
                      if (mounted) {
                        Navigator.pop(context);
                        _fetchAccounts();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isEdit
                                  ? 'Cập nhật tài khoản thành công!'
                                  : 'Thêm tài khoản thành công!',
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Lỗi thao tác tài khoản!'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
    );
  }

  void _deleteAccount(int index) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange),
                SizedBox(width: 12),
                Text('Xác nhận xóa'),
              ],
            ),
            content: Text(
              'Bạn có chắc chắn muốn xóa tài khoản "${accounts[index]['userName']}"?',
            ),
            actions: [
              TextButton.icon(
                icon: Icon(Icons.cancel_outlined),
                label: Text('Hủy'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.delete_forever),
                label: Text('Xóa'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () async {
                  try {
                    await api.deleteAccount(accounts[index]['userId']);
                    if (mounted) {
                      Navigator.pop(context);
                      _fetchAccounts();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Xóa tài khoản thành công!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Lỗi xóa tài khoản!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 1200;

    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.people_alt, size: 32, color: Color(0xFF2196F3)),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quản lý Tài khoản',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    Text(
                      'Quản lý thông tin người dùng và phân quyền',
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                  ],
                ),
              ),
              ElevatedButton.icon(
                icon: Icon(Icons.add),
                label: Text('Thêm tài khoản'),
                onPressed: () => _showAccountDialog(),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),

          // Stats Cards
          if (isLargeScreen) ...[
            Row(
              children: [
                _buildStatCard(
                  'Tổng tài khoản',
                  accounts.length.toString(),
                  Icons.people,
                  Color(0xFF2196F3),
                ),
                SizedBox(width: 16),
                _buildStatCard(
                  'Admin',
                  accounts.where((a) => a['permission'] == 1).length.toString(),
                  Icons.admin_panel_settings,
                  Color(0xFF4CAF50),
                ),
                SizedBox(width: 16),
                _buildStatCard(
                  'Người dùng',
                  accounts.where((a) => a['permission'] == 0).length.toString(),
                  Icons.person,
                  Color(0xFFFF9800),
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
                            CircularProgressIndicator(color: Color(0xFF2196F3)),
                            SizedBox(height: 16),
                            Text('Đang tải dữ liệu...'),
                          ],
                        ),
                      )
                      : accounts.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.people_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Chưa có tài khoản nào',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Nhấn "Thêm tài khoản" để bắt đầu',
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                          ],
                        ),
                      )
                      : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: [
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.badge, size: 16),
                                  SizedBox(width: 8),
                                  Text('User ID'),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.person, size: 16),
                                  SizedBox(width: 8),
                                  Text('Tên đăng nhập'),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.account_circle, size: 16),
                                  SizedBox(width: 8),
                                  Text('Họ tên'),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.cake, size: 16),
                                  SizedBox(width: 8),
                                  Text('Ngày sinh'),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.security, size: 16),
                                  SizedBox(width: 8),
                                  Text('Quyền'),
                                ],
                              ),
                            ),
                            DataColumn(
                              label: Row(
                                children: [
                                  Icon(Icons.settings, size: 16),
                                  SizedBox(width: 8),
                                  Text('Thao tác'),
                                ],
                              ),
                            ),
                          ],
                          rows:
                              accounts.asMap().entries.map((entry) {
                                final index = entry.key;
                                final account = entry.value;
                                return DataRow(
                                  cells: [
                                    DataCell(
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 120,
                                        ),
                                        child: Text(
                                          account['userId'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 150,
                                        ),
                                        child: Text(
                                          account['userName'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 200,
                                        ),
                                        child: Text(
                                          account['fullName'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: 120,
                                        ),
                                        child: Text(
                                          account['dob'] ?? '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              (account['permission'] == 1)
                                                  ? Color(
                                                    0xFF4CAF50,
                                                  ).withOpacity(0.1)
                                                  : Color(
                                                    0xFFFF9800,
                                                  ).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color:
                                                (account['permission'] == 1)
                                                    ? Color(0xFF4CAF50)
                                                    : Color(0xFFFF9800),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              (account['permission'] == 1)
                                                  ? Icons.admin_panel_settings
                                                  : Icons.person,
                                              size: 16,
                                              color:
                                                  (account['permission'] == 1)
                                                      ? Color(0xFF4CAF50)
                                                      : Color(0xFFFF9800),
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              (account['permission'] == 1)
                                                  ? 'Admin'
                                                  : 'User',
                                              style: TextStyle(
                                                color:
                                                    (account['permission'] == 1)
                                                        ? Color(0xFF4CAF50)
                                                        : Color(0xFFFF9800),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Color(0xFF2196F3),
                                            ),
                                            tooltip: 'Sửa',
                                            onPressed:
                                                () => _showAccountDialog(
                                                  account: account,
                                                  index: index,
                                                ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            tooltip: 'Xóa',
                                            onPressed:
                                                () => _deleteAccount(index),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                        ),
                      ),
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    Text(
                      title,
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
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
