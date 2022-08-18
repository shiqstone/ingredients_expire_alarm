import 'package:ingredients_expire_alarm/base/base_list_vm.dart';
import 'package:ingredients_expire_alarm/constant/constant.dart';
import 'package:ingredients_expire_alarm/db/item_db_manage.dart';
import 'package:ingredients_expire_alarm/model/item_record.dart';

class ItemListVm extends BaseListVM {
  static final ItemListVm _singleton = ItemListVm._internal();

  ItemListVm._internal();

  static ItemListVm get instance {
    return _singleton;
  }

  factory ItemListVm() {
    return _singleton;
  }

  final ItemDbManage _databaseManage = ItemDbManage();
  int _count = 0;

  // UnmodifiableListView<ItemRecord> get allItems => UnmodifiableListView(_items);

  int get count => _count;

  @override
  loadData() async {
    // _items = allItems.toList();
    // _count = allItems.length;
    Future<List<ItemRecord>> itemListFuture = _databaseManage.getItemRecordList();
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
