import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(seconds: 1)); // Giả lập đăng nhập
      setState(() => _isLoading = false);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width > 1200;
    final isMediumScreen = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1976D2), Color(0xFF2196F3), Color(0xFF64B5F6)],
          ),
        ),
        child: Center(
          child:
              isLargeScreen
                  ? _buildLargeScreenLayout()
                  : isMediumScreen
                  ? _buildMediumScreenLayout()
                  : _buildMobileLayout(),
        ),
      ),
    );
  }

  Widget _buildLargeScreenLayout() {
    return Container(
      width: 1000,
      height: 600,
      child: Card(
        elevation: 16,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Row(
          children: [
            // Left side - Branding
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF1976D2), Color(0xFF2196F3)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.dashboard, size: 80, color: Colors.white),
                      SizedBox(height: 24),
                      Text(
                        'Quản lý Khoán chi phí',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Hệ thống quản lý khoán chi phí hiệu quả',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildFeatureItem(Icons.security, 'Bảo mật cao'),
                          SizedBox(width: 32),
                          _buildFeatureItem(Icons.speed, 'Hiệu suất tốt'),
                          SizedBox(width: 32),
                          _buildFeatureItem(Icons.support_agent, 'Hỗ trợ 24/7'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Right side - Login form
            Expanded(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(40),
                child: _buildLoginForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediumScreenLayout() {
    return Container(
      width: 600,
      child: Card(
        elevation: 16,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Icon(Icons.dashboard, size: 64, color: Color(0xFF2196F3)),
              SizedBox(height: 16),
              Text(
                'Quản lý Khoán chi phí',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Đăng nhập để tiếp tục',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              SizedBox(height: 32),
              _buildLoginForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return Container(
      padding: EdgeInsets.all(24),
      child: Card(
        elevation: 16,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Icon(Icons.dashboard, size: 48, color: Color(0xFF2196F3)),
              SizedBox(height: 16),
              Text(
                'Quản lý Khoán chi phí',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Đăng nhập để tiếp tục',
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              _buildLoginForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: _userIdController,
            decoration: InputDecoration(
              labelText: 'Tên đăng nhập',
              hintText: 'Nhập tên đăng nhập của bạn',
              prefixIcon: Icon(Icons.person_outline),
              suffixIcon: Icon(Icons.verified_user, color: Colors.grey[400]),
            ),
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? 'Vui lòng nhập tên đăng nhập'
                        : null,
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              labelText: 'Mật khẩu',
              hintText: 'Nhập mật khẩu của bạn',
              prefixIcon: Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey[600],
                ),
                onPressed:
                    () => setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            validator:
                (value) =>
                    value == null || value.isEmpty
                        ? 'Vui lòng nhập mật khẩu'
                        : null,
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Checkbox(
                value: false,
                onChanged: (value) {},
                activeColor: Color(0xFF2196F3),
              ),
              Text(
                'Ghi nhớ đăng nhập',
                style: TextStyle(color: Colors.grey[600]),
              ),
              Spacer(),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Tính năng đang phát triển')),
                  );
                },
                child: Text(
                  'Quên mật khẩu?',
                  style: TextStyle(color: Color(0xFF2196F3)),
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            icon:
                _isLoading
                    ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                    : Icon(Icons.login),
            label: Text(
              _isLoading ? 'Đang đăng nhập...' : 'Đăng nhập',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: _isLoading ? null : _login,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('hoặc', style: TextStyle(color: Colors.grey[600])),
              ),
              Expanded(child: Divider()),
            ],
          ),
          SizedBox(height: 16),
          OutlinedButton.icon(
            icon: Icon(Icons.support_agent),
            label: Text('Liên hệ hỗ trợ'),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tính năng đang phát triển')),
              );
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 32),
        SizedBox(height: 8),
        Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
