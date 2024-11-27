import 'package:flutter/material.dart';
import 'package:qr_code_dart_scan/qr_code_dart_scan.dart';
import 'package:provider/provider.dart';
import 'package:coupon_app/user_provider.dart';

class QRCodeScanner extends StatefulWidget {
  @override
  _QRCodeScannerState createState() => _QRCodeScannerState();
}

class _QRCodeScannerState extends State<QRCodeScanner> {
  String? scannedData;

  void _onScanComplete(String qrData) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User ID is empty. Please log in first.'),
      ));
      return;
    }

    bool success = await userProvider.saveScanHistory(qrData);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('QR Data saved successfully!'),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to save QR Data.'),
      ));
    }

    setState(() {
      scannedData = qrData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scan QR Code')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRCodeDartScanView(
              scanInvertedQRCode: false,
              onCapture: (result) {
                if (result != null) {
                  String qrData = result.text ?? '';
                  if (qrData.isNotEmpty) {
                    _onScanComplete(qrData);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Invalid QR Code or no data found.'),
                    ));
                  }
                }
              },
            ),
          ),
          Expanded(
            child: Center(
              child: scannedData != null
                  ? Text(
                      'Scanned Data: $scannedData',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )
                  : Text('No QR Code scanned yet.'),
            ),
          ),
        ],
      ),
    );
  }
}
