import 'package:flutter/material.dart';
import 'package:ingredients_expire_alarm/constant/constant.dart';

abstract class BaseVM extends ChangeNotifier {

  /// 防止页面销毁后,异步任务才完成,导致报错
  bool _disposed = false;

  bool get disposed => _disposed;

  int _viewStatus = ViewStatus.success;

  int get viewStatus => _viewStatus;

  void showViewState(int viewStatus) {
    _viewStatus = viewStatus;
    notifyListeners();
  }

  // 加载数据
  loadData();

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    // release res
    _disposed = true;
    super.dispose();
  }
}
