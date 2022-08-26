import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ingredients_expire_alarm/pages/settings/setting_page.dart';
import 'package:ingredients_expire_alarm/scanner/full_screen_scanner_page.dart';
import 'package:ingredients_expire_alarm/util/size_fit_util.dart';
import 'package:ingredients_expire_alarm/util/view_utils.dart';
import 'package:ingredients_expire_alarm/vm/home_alarm_list_vm.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ingredients_expire_alarm/constant/constant.dart';
import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/util/refresh_utils.dart';
import 'package:ingredients_expire_alarm/widget/provider_widget.dart';
import 'package:ingredients_expire_alarm/widget/status_view.dart';

import 'add_alarm_page.dart';
// import 'edit_alarm_page.dart';
import 'widget/item_view_widget.dart';
import 'widget/menu_widget.dart';
import 'widget/sheet_widget.dart';

class HomeAlarmListPage extends StatefulWidget {
  const HomeAlarmListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeAlarmListPageState();
  }
}

class HomeAlarmListPageState extends State<HomeAlarmListPage> with AutomaticKeepAliveClientMixin {
  late HomeAlarmListVM _vm;
  final RefreshController _refreshController = RefreshController(initialRefresh: true);

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _vm = HomeAlarmListVM.instance;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ProviderWidget(
        model: _vm,
        autoDispose: false,
        onModelReady: (_) {},
        builder: (BuildContext context, _, __) {
          if (_vm.viewStatus != ViewStatus.loading) {
            _refreshController.refreshCompleted();
          }
          if (_vm.viewStatus == ViewStatus.success) {
            _refreshController.loadComplete();
          } else if (_vm.viewStatus == ViewStatus.noMore || _vm.viewStatus == ViewStatus.empty) {
            _refreshController.loadNoData();
          } else if (_vm.viewStatus == ViewStatus.fail) {
            _refreshController.loadFailed();
          }
          return _build(context);
        });
  }

  Widget _build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: SafeArea(
            child: SmartRefresher(
                enablePullDown: _vm.viewStatus == ViewStatus.loading ? false : true,
                enablePullUp: false,
                header: RefreshUtils.getHeader(),
                // footer: RefreshUtils.getFooter(),
                controller: _refreshController,
                onRefresh: () {
                  _vm.loadData();
                },
                onLoading: () {},
                child: Stack(alignment: Alignment.center, children: [
                  _buildListView(),
                  Positioned(
                    right: 40,
                    bottom: 60,
                    child: FloatingActionButton(
                        onPressed: () {
                          //dialog
                          showMenuDialog();
                        },
                        child: const Icon(Icons.add)),
                  ),
                ]))));
  }

  Widget _buildListView() {
    if (_vm.viewStatus == ViewStatus.success || _vm.viewStatus == ViewStatus.noMore) {
      return ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 24.w),
          itemBuilder: (ctx, index) {
            var entity = _vm.datas[index];
            var item = AlarmItemView(
              index: index,
              entity: entity,
              onPressed: () {
                // Get.to(() => EditAlarmRecordPage(id: entity!.id!));
              },
            );

            return item;
          },
          itemCount: _vm.datas.length,
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 24.w,
            );
          });
    } else if (_vm.viewStatus == ViewStatus.empty) {
      return StatusView(
        title: '没有记录',
        onTap: () {
          // ToastUtil.showLoading();
          _vm.loadData().then((value) {
            // ToastUtil.hiddenLoading();
          });
        },
      );
    } else {
      return StatusView(
        title: '查询失败',
        onTap: () {
          // ToastUtil.showLoading();
          _vm.loadData().then((value) {
            ToastUtil.hiddenLoading();
          });
        },
      );
    }
  }

  AppBar buildAppBar() {
    return AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            SizedBox(
              height: 16.w,
            ),
            Text(
              '',
              style: TextStyle(fontSize: 18.sp, color: const Color(0xFF222222), fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.w, width: (SizeFit.screenWidth ?? 240.w / 2) - 22.w),
            IconButton(
              icon: ViewUtils.getImage(
                'icon_mine_setting',
                24.w,
                24.w,
                // color: themeColor.primaryColor,
              ),
              onPressed: () => Get.to(() => const SettingPage()),
            ),
          ],
        ),
        elevation: 0.5);
  }

  void showMenuDialog() {
    List<MenuItem> items = [];
    items.add(MenuItem(
        '扫码添加',
        () => {
              Get.to(() => const FullScreenScannerPage(srcPath: 'homeAlarm'))
            }));
    items.add(MenuItem(
        '手动添加',
        () => {
              Get.to(() => const AddHomeAlarmRecordPage(
                    barcode: '',
                  ))
            }));
    items.add(MenuItem('取消', () {
      Get.back();
    }));

    showModalBottomSheetSelf(
        shape: ContinuousRectangleBorder(
          side: BorderSide.none,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(4.w),
            topLeft: Radius.circular(4.w),
          ),
        ),
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) {
          return MenuBottomWidget(items: items);
        });
  }
}
