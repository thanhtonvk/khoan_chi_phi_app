import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://192.168.1.13:2803';

  // Account
  Future<List<dynamic>> fetchAccounts() async {
    final res = await http.get(Uri.parse('$baseUrl/accounts'));
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> addAccount(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/accounts'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> updateAccount(
    String userId,
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('$baseUrl/accounts/$userId'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  Future<void> deleteAccount(String userId) async {
    await http.delete(Uri.parse('$baseUrl/accounts/$userId'));
  }

  // MaGiaoKhoan
  Future<List<dynamic>> fetchMaGiaoKhoans() async {
    final res = await http.get(Uri.parse('$baseUrl/magiaokhoans'));
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> addMaGiaoKhoan(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/magiaokhoans'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> updateMaGiaoKhoan(
    String id,
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('$baseUrl/magiaokhoans/$id'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  Future<void> deleteMaGiaoKhoan(String id) async {
    await http.delete(Uri.parse('$baseUrl/magiaokhoans/$id'));
  }

  // TaiSan
  Future<List<dynamic>> fetchTaiSans() async {
    final res = await http.get(Uri.parse('$baseUrl/taisans'));
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> addTaiSan(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/taisans'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> updateTaiSan(
    String id,
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('$baseUrl/taisans/$id'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  Future<void> deleteTaiSan(String id) async {
    await http.delete(Uri.parse('$baseUrl/taisans/$id'));
  }

  // Khau
  Future<List<dynamic>> fetchKhaus() async {
    final res = await http.get(Uri.parse('$baseUrl/khaus'));
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> addKhau(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/khaus'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> updateKhau(
    String id,
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('$baseUrl/khaus/$id'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  Future<void> deleteKhau(String id) async {
    await http.delete(Uri.parse('$baseUrl/khaus/$id'));
  }

  // MucKhau
  Future<List<dynamic>> fetchMucKhaus() async {
    final res = await http.get(Uri.parse('$baseUrl/muckhaus'));
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> addMucKhau(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/muckhaus'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> updateMucKhau(
    String id,
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('$baseUrl/muckhaus/$id'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  Future<void> deleteMucKhau(String id) async {
    await http.delete(Uri.parse('$baseUrl/muckhaus/$id'));
  }

  // DinhMuc
  Future<List<dynamic>> fetchDinhMucs() async {
    final res = await http.get(Uri.parse('$baseUrl/dinhmucs'));
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> addDinhMuc(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/dinhmucs'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> updateDinhMuc(
    String id,
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('$baseUrl/dinhmucs/$id'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  Future<void> deleteDinhMuc(String id) async {
    await http.delete(Uri.parse('$baseUrl/dinhmucs/$id'));
  }

  // QuyetToanGiaoKhoan
  Future<List<dynamic>> fetchQuyetToans() async {
    final res = await http.get(Uri.parse('$baseUrl/quyettoans'));
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> addQuyetToan(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/quyettoans'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> updateQuyetToan(
    String id,
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('$baseUrl/quyettoans/$id'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  Future<void> deleteQuyetToan(String id) async {
    await http.delete(Uri.parse('$baseUrl/quyettoans/$id'));
  }

  // ChiTietGiaoKhoan
  Future<List<dynamic>> fetchChiTietGiaoKhoans() async {
    final res = await http.get(Uri.parse('$baseUrl/chitietgiaokhoans'));
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> addChiTietGiaoKhoan(
    Map<String, dynamic> data,
  ) async {
    final res = await http.post(
      Uri.parse('$baseUrl/chitietgiaokhoans'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  Future<Map<String, dynamic>> updateChiTietGiaoKhoan(
    String id,
    Map<String, dynamic> data,
  ) async {
    final res = await http.put(
      Uri.parse('$baseUrl/chitietgiaokhoans/$id'),
      body: jsonEncode(data),
      headers: {'Content-Type': 'application/json'},
    );
    return jsonDecode(res.body);
  }

  Future<void> deleteChiTietGiaoKhoan(String id) async {
    await http.delete(Uri.parse('$baseUrl/chitietgiaokhoans/$id'));
  }
}
