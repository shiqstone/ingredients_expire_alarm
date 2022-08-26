import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ingredients_expire_alarm/pages/alarm/add_alarm_page.dart';
import 'package:ingredients_expire_alarm/pages/home_alarm/add_alarm_page.dart';
import 'package:ingredients_expire_alarm/pages/settings/add_item_page.dart';
import 'package:ingredients_expire_alarm/public.dart';

import 'app_barcode_scanner_widget.dart';

/// FullScreenScannerPage
class FullScreenScannerPage extends StatefulWidget {
  final String srcPath;
  const FullScreenScannerPage({Key? key, required this.srcPath}) : super(key: key);

  @override
  _FullScreenScannerPageState createState() => _FullScreenScannerPageState();
}

class _FullScreenScannerPageState extends State<FullScreenScannerPage> {
  String _code = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          _code,
          style: TextStyle(fontSize: 14.sp, color: const Color(0xFF222222)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: AppBarcodeScannerWidget.defaultStyle(
              resultCallback: (String code) {
                setState(() {
                  _code = code;
                });
                if (widget.srcPath == 'addItem') {
                  Get.to(() => AddItemRecordPage(
                        barcode: code,
                      ));
                } else if (widget.srcPath == 'scan') {
                  Get.off(() => AddAlarmRecordPage(
                        barcode: code,
                      ));
                } else if (widget.srcPath == 'homeAlarm') {
                  Get.off(() => AddHomeAlarmRecordPage(
                        barcode: code,
                      ));
                }
              },
              srcPath: widget.srcPath,
              openManual: false,
            ),
          ),
        ],
      ),
    );
  }
}
