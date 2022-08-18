import 'package:ingredients_expire_alarm/constant/constant.dart';

import 'base_vm.dart';

/// 列表页面 BaseViewModel
abstract class BaseListVM<T> extends BaseVM {
  List<T> datas = [];
  int total = 0; //总和
  int page = 1; // 从 1 开始

  // 加载数据
  @override
  loadData() {
    clearData();
  }

  clearData() {
    page = 1;
    // datas.clear();
  }

  // 加载数据
  loadMore(){}

  void updateUI() {
    if (datas.isEmpty) {
      showViewState(ViewStatus.empty);
    } else {
      if (datas.length < total) {
        page++;
        showViewState(ViewStatus.success);
      } else {
        showViewState(ViewStatus.noMore);
      }
    }
    notifyListeners();
  }

}
