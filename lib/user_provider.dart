import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserProvider extends ChangeNotifier {
  String? _userId; // เก็บ user_id หลังจาก login สำเร็จ

  String get userId => _userId ?? '';

  Future<bool> login(String email, String password) async {
    try {
      final url = Uri.parse('http://10.8.18.73/coupon_app/login.php');
      final response = await http.post(url, body: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'success') {
          // ตรวจสอบและบันทึก user_id
          _userId = data['user_id'];
          notifyListeners();
          debugPrint('Login successful. User ID: $_userId');
          return true;
        } else {
          debugPrint('Login failed: ${data['message']}');
        }
      } else {
        debugPrint('Login failed with status code: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error during login: $e');
    }
    return false;
  }

  // ฟังก์ชัน Register
  Future<bool> register(String email, String password) async {
    try {
      final url = Uri.parse('http://10.8.18.73/coupon_app/register.php');
      final response = await http.post(url, body: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'];
      }
    } catch (e) {
      debugPrint('Register error: $e');
    }
    return false;
  }

  // ฟังก์ชัน Get Scan History
  // ฟังก์ชัน Get Scan History
Future<List> getScanHistory() async {
  try {
    if (_userId == null || _userId!.isEmpty) {
      throw Exception('User is not logged in. Please log in first.');
    }

    // พิมพ์ค่าที่ส่งไปเพื่อดีบัก
    debugPrint('Fetching scan history for user_id: $_userId');

    final url = Uri.parse('http://10.8.18.73/coupon_app/get_scan_history.php');
    final response = await http.post(url, body: {'user_id': _userId});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success']) {
        // ส่งกลับข้อมูลประวัติการสแกน
        return data['history'];  // ข้อมูลควรจะอยู่ใน 'history' ตามที่เซิร์ฟเวอร์ส่งกลับ
      } else {
        debugPrint('Failed to fetch scan history: ${data['message']}');
      }
    } else {
      debugPrint('Failed to fetch scan history. Server responded with status code: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Get scan history error: $e');
  }
  return [];  // ถ้ามีข้อผิดพลาดจะส่งกลับเป็น list ว่าง
}


  // ฟังก์ชัน Save Scan History
  Future<bool> saveScanHistory(String qrData) async {
    try {
      if (_userId == null || _userId!.isEmpty) {
        throw Exception('User ID is null or empty');
      }

      final url = Uri.parse('http://10.8.18.73/coupon_app/scan_history.php');
      final response = await http.post(url, body: {
        'user_id': _userId,
        'qr_data': qrData,
      });

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint('Save Scan History response: $data');
        return data['status'] == 'success';
      }
    } catch (e) {
      debugPrint('Error saving scan history: $e');
    }
    return false;
  }




}
