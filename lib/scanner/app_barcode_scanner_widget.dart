import 'package:ai_barcode/ai_barcode.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ingredients_expire_alarm/pages/alarm/add_alarm_page.dart';
import 'package:ingredients_expire_alarm/pages/settings/add_item_page.dart';
import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/util/view_utils.dart';
import 'package:permission_handler/permission_handler.dart';

late String _label;
late Function(String result) _resultCallback;

class AppBarcodeScannerWidget extends StatefulWidget {
  final bool openManual;
  final String srcPath;

  AppBarcodeScannerWidget.defaultStyle({
    Key? key,
    Function(String result)? resultCallback,
    this.srcPath = '',
    this.openManual = false,
    String label = '',
  }) : super(key: key) {
    _resultCallback = resultCallback ?? (String result) {};
    _label = label;
  }

  @override
  _AppBarcodeState createState() => _AppBarcodeState();
}

class _AppBarcodeState extends State<AppBarcodeScannerWidget> {
  bool _isGranted = false;

  bool _useCameraScan = true;

  bool _openManual = false;

  String _inputValue = "";

  @override
  void initState() {
    super.initState();

    _openManual = widget.openManual;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      TargetPlatform platform = Theme.of(context).platform;
      if (!kIsWeb) {
        if (platform == TargetPlatform.android || platform == TargetPlatform.iOS) {
          _requestMobilePermission();
        } else {
          setState(() {
            _isGranted = true;
          });
        }
      } else {
        setState(() {
          _isGranted = true;
        });
      }
    });
  }

  void _requestMobilePermission() async {
    bool isGrated = true;
    if (await Permission.camera.status.isGranted) {
      isGrated = true;
    } else {
      if (await Permission.camera.request().isGranted) {
        isGrated = true;
      }
    }
    setState(() {
      _isGranted = isGrated;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _isGranted
              ? _useCameraScan
                  ? _BarcodeScannerWidget(srcPath: widget.srcPath)
                  : _BarcodeInputWidget.defaultStyle(
                      changed: (String value) {
                        _inputValue = value;
                      },
                    )
              : Center(
                  child: OutlinedButton(
                    onPressed: () {
                      _requestMobilePermission();
                    },
                    child: const Text("请求权限"),
                  ),
                ),
        ),
        _openManual
            ? _useCameraScan
                ? OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _useCameraScan = false;
                      });
                    },
                    child: Text("手动输入$_label"),
                  )
                : Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          setState(() {
                            _useCameraScan = true;
                          });
                        },
                        child: Text("扫描$_label"),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          _resultCallback(_inputValue);
                        },
                        child: const Text("确定"),
                      ),
                    ],
                  )
            : Container(),
      ],
    );
  }
}

class _BarcodeInputWidget extends StatefulWidget {
  late ValueChanged<String> _changed;

  _BarcodeInputWidget.defaultStyle({
    required ValueChanged<String> changed,
  }) {
    _changed = changed;
  }

  @override
  State<StatefulWidget> createState() {
    return _BarcodeInputState();
  }
}

class _BarcodeInputState extends State<_BarcodeInputWidget> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection: TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(8)),
        Row(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(8)),
            Text(
              "$_label：",
            ),
            Expanded(
              child: TextFormField(
                controller: _controller,
                onChanged: widget._changed,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
          ],
        ),
        const Padding(padding: EdgeInsets.all(8)),
      ],
    );
  }
}

///ScannerWidget
class _BarcodeScannerWidget extends StatefulWidget {
  final String srcPath;

  const _BarcodeScannerWidget({Key? key, required this.srcPath}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AppBarcodeScannerWidgetState();
  }
}

class _AppBarcodeScannerWidgetState extends State<_BarcodeScannerWidget> {
  late ScannerController _scannerController;

  bool flashOn = true;

  @override
  void initState() {
    super.initState();

    _scannerController = ScannerController(scannerResult: (result) {
      _resultCallback(result);
    }, scannerViewCreated: () {
      TargetPlatform platform = Theme.of(context).platform;
      if (TargetPlatform.iOS == platform) {
        Future.delayed(const Duration(seconds: 2), () {
          _scannerController.startCamera();
          _scannerController.startCameraPreview();
        });
      } else {
        _scannerController.startCamera();
        _scannerController.startCameraPreview();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();

    _scannerController.stopCameraPreview();
    _scannerController.stopCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _getScanWidgetByPlatform(),
        // Expanded(
        //   child: _getScanWidgetByPlatform(),
        // ),
        Positioned(
            bottom: 25.h,
            right: 35.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
              height: 64.w,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Visibility(
                    visible: widget.srcPath == 'scan' || widget.srcPath == 'addItem',
                    child: CircleAvatar(
                      radius: 25.5.w,
                      backgroundColor: Colors.white.withOpacity(0.6),
                      child: IconButton(
                        icon: ViewUtils.getImage(
                          'keyboard_black',
                          24.w,
                          24.w,
                          // color: Colors.transparent,
                        ),
                        onPressed: () {
                          if (widget.srcPath == 'addItem') {
                            Get.to(
                              () => const AddItemRecordPage(barcode: ''),
                            );
                          } else if (widget.srcPath == 'scan') {
                            Get.off(() => const AddAlarmRecordPage(
                                  barcode: '',
                                ));
                          }
                        },
                      )),
                  )
                  
                  // IconButton(
                  //     icon: ViewUtils.getImage(
                  //       'keyboard_black',
                  //       24.w,
                  //       24.w,
                  //       // color: Colors.transparent,
                  //     ),
                  //     onPressed: () => Get.to(
                  //           () => const AddItemRecordPage(barcode: ''),
                  //         )),
                  // SizedBox(
                  //   height: 16.h,
                  // ),
                  // IconButton(
                  //   icon: ViewUtils.getImage(
                  //     'flashlight',
                  //     24.w,
                  //     24.w,
                  //     // color: Colors.transparent,
                  //   ),
                  //   onPressed: () => {
                  //     flashOn ? _scannerController.closeFlash() : _scannerController.openFlash()
                  //   },
                  // ),
                ],
              ),
            ))
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //   children: [
        //     ElevatedButton(
        //         onPressed: () {
        //           _scannerController.openFlash();
        //         },
        //         child: const Text("Open")),
        //     ElevatedButton(
        //         onPressed: () {
        //           _scannerController.closeFlash();
        //         },
        //         child: const Text("Close")),
        //   ],
        // ),
      ],
    );
  }

  Widget _getScanWidgetByPlatform() {
    return PlatformAiBarcodeScannerWidget(
      platformScannerController: _scannerController,
    );
  }
}
