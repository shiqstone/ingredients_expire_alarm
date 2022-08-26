import 'package:ingredients_expire_alarm/base/base_list_vm.dart';
import 'package:ingredients_expire_alarm/constant/constant.dart';
import 'package:ingredients_expire_alarm/db/home_alarm_db_manage.dart';
import 'package:ingredients_expire_alarm/model/home_item_alarm.dart';

class HomeAlarmListVM extends BaseListVM {
  static final HomeAlarmListVM _singleton = HomeAlarmListVM._internal();

  HomeAlarmListVM._internal();

  static HomeAlarmListVM get instance {
    return _singleton;
  }

  factory HomeAlarmListVM() {
    return _singleton;
  }

  final HomeAlarmDbManage _databaseManage = HomeAlarmDbManage();
  int _count = 0;

  int get count => _count;

  Map<int, bool> alarmingMap = {};

  @override
  loadData() async {
    Future<List<HomeItemAlarm>> itemListFuture = _databaseManage.getHomeItemAlarmList(1);
    itemListFuture.then((itemList) {
      _count = itemList.length;

      datas = itemList;
      if (datas.isEmpty) {
        showViewState(ViewStatus.empty);
      } else {
        showViewState(ViewStatus.noMore);
      }
      notifyListeners();
    });
  }
}
