import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:coupon_app/user_provider.dart';

class ScanHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Scan History')),
      body: FutureBuilder(
        future: userProvider.getScanHistory(),
        builder: (context, snapshot) {
          // เมื่อกำลังโหลดข้อมูล
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } 
          // เมื่อมีข้อผิดพลาดในการดึงข้อมูล
          else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } 
          // เมื่อไม่มีข้อมูล
          else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
            return Center(child: Text('No scan history found.'));
          }

          final scanHistory = snapshot.data as List;

          return ListView.builder(
            itemCount: scanHistory.length,
            itemBuilder: (context, index) {
              final scan = scanHistory[index];

              // กำหนดค่าที่ปลอดภัยสำหรับฟิลด์ที่อาจเป็น null
              final qrData = scan['qr_data'] ?? 'No QR Data';
              final scannedAt = scan['scanned_at'] ?? 'Unknown Date';

              return ListTile(
                title: Text('QR Data: $qrData'),
                subtitle: Text('Scanned at: $scannedAt'),
              );
            },
          );
        },
      ),
    );
  }
}
