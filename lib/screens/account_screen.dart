import 'package:flutter/material.dart';
import '../services/api_service.dart';

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
            title: Text(isEdit ? 'Sửa tài khoản' : 'Thêm tài khoản'),
            content: Form(
              key: _formKey,
              child: SizedBox(
                width: 350,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: userIdController,
                        decoration: const InputDecoration(
                          labelText: 'User ID',
                          prefixIcon: Icon(Icons.badge),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty ? 'Nhập User ID' : null,
                        enabled: !isEdit,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: userNameController,
                        decoration: const InputDecoration(
                          labelText: 'Tên đăng nhập',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Nhập tên đăng nhập'
                                    : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: fullNameController,
                        decoration: const InputDecoration(
                          labelText: 'Họ tên',
                          prefixIcon: Icon(Icons.account_circle),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty ? 'Nhập họ tên' : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: dobController,
                        decoration: const InputDecoration(
                          labelText: 'Ngày sinh',
                          prefixIcon: Icon(Icons.cake),
                        ),
                        validator:
                            (v) =>
                                v == null || v.isEmpty
                                    ? 'Nhập ngày sinh'
                                    : null,
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: permissionController,
                        decoration: const InputDecoration(
                          labelText: 'Quyền',
                          prefixIcon: Icon(Icons.security),
                        ),
                        validator:
                            (v) => v == null || v.isEmpty ? 'Nhập quyền' : null,
                      ),
                      if (!isEdit) ...[
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Mật khẩu',
                            prefixIcon: Icon(Icons.lock),
                          ),
                          validator:
                              (v) =>
                                  v == null || v.isEmpty
                                      ? 'Nhập mật khẩu'
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
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Hủy'),
              ),
              ElevatedButton.icon(
                icon: Icon(isEdit ? Icons.save : Icons.add),
                label: Text(isEdit ? 'Lưu' : 'Thêm'),
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
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Lỗi thao tác tài khoản!'),
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
            title: const Text('Xác nhận xóa'),
            content: Text(
              'Bạn có chắc muốn xóa tài khoản "${accounts[index]['userName']}"?',
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
                    await api.deleteAccount(accounts[index]['userId']);
                    if (mounted) {
                      Navigator.pop(context);
                      _fetchAccounts();
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lỗi xóa tài khoản!')),
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Danh sách tài khoản',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Thêm'),
                onPressed: () => _showAccountDialog(),
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
                          DataColumn(label: Text('User ID')),
                          DataColumn(label: Text('Tên đăng nhập')),
                          DataColumn(label: Text('Họ tên')),
                          DataColumn(label: Text('Ngày sinh')),
                          DataColumn(label: Text('Quyền')),
                          DataColumn(label: Text('Hành động')),
                        ],
                        rows: List.generate(accounts.length, (i) {
                          final acc = accounts[i];
                          return DataRow(
                            cells: [
                              DataCell(Text(acc['userId'] ?? '')),
                              DataCell(Text(acc['userName'] ?? '')),
                              DataCell(Text(acc['fullName'] ?? '')),
                              DataCell(Text(acc['dob'] ?? '')),
                              DataCell(
                                Text(acc['permission']?.toString() ?? ''),
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
                                          () => _showAccountDialog(
                                            account: acc,
                                            index: i,
                                          ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      tooltip: 'Xóa',
                                      onPressed: () => _deleteAccount(i),
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
