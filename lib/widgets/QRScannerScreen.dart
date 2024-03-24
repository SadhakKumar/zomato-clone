// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class QRScannerScreen extends StatefulWidget {
//   @override
//   _QRScannerScreenState createState() => _QRScannerScreenState();
// }

// class _QRScannerScreenState extends State<QRScannerScreen> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('QR Code Scanner'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Expanded(
//             flex: 4,
//             child: QRView(
//               key: qrKey,
//               onQRViewCreated: _onQRViewCreated,
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Center(
//               child: Text('Scan the QR Code'),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       // Here you can handle the scanned data, for example, print the result
//       print('Scanned Data: ${scanData.code}');
//       // You can navigate to a new page with the scanned link
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => ScannedResultScreen(scanData.code!),
//         ),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }

// class ScannedResultScreen extends StatelessWidget {
//   final String scannedLink;

//   ScannedResultScreen(this.scannedLink);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Scanned Result'),
//       ),
//       body: Center(
//         child: Text(
//           scannedLink,
//           style: TextStyle(fontSize: 20),
//         ),
//       ),
//     );
//   }
// }
