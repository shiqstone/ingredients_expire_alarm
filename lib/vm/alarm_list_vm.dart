import 'package:ingredients_expire_alarm/base/base_list_vm.dart';
import 'package:ingredients_expire_alarm/constant/constant.dart';
import 'package:ingredients_expire_alarm/db/alarm_db_manage.dart';
import 'package:ingredients_expire_alarm/model/item_alarm.dart';

class AlarmListVM extends BaseListVM {
  static final AlarmListVM _singleton = AlarmListVM._internal();

  AlarmListVM._internal();

  static AlarmListVM get instance {
    return _singleton;
  }

  factory AlarmListVM() {
    return _singleton;
  }

  final AlarmDbManage _databaseManage = AlarmDbManage();
  int _count = 0;

  int get count => _count;

  Map<int, bool> alarmingMap = {};

  @override
  loadData() async {
    Future<List<ItemAlarm>> itemListFuture = _databaseManage.getItemAlarmList(AlarmStatus.normal.index + 1);
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
