import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ingredients_expire_alarm/util/size_fit_util.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:ingredients_expire_alarm/constant/constant.dart';
import 'package:ingredients_expire_alarm/pages/settings/edit_item_page.dart';
import 'package:ingredients_expire_alarm/pages/settings/widget/item_view_widget.dart';
import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/scanner/full_screen_scanner_page.dart';
import 'package:ingredients_expire_alarm/util/refresh_utils.dart';
import 'package:ingredients_expire_alarm/util/view_utils.dart';
import 'package:ingredients_expire_alarm/vm/item_list_vm.dart';
import 'package:ingredients_expire_alarm/widget/provider_widget.dart';
import 'package:ingredients_expire_alarm/widget/status_view.dart';

class ItemListPage extends StatefulWidget {
  const ItemListPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ItemListPageState();
  }
}

class ItemListPageState extends State<ItemListPage> with AutomaticKeepAliveClientMixin {
  late ItemListVm _vm;
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
    _vm = ItemListVm.instance;
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
    return WillPopScope(
        onWillPop: () async {
          Get.to(() => IndexPage(
                tindex: 2,
              ));
          return true;
        },
        child: Scaffold(
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
              child: _buildListView(),
            ))));
  }

  Widget _buildListView() {
    if (_vm.viewStatus == ViewStatus.success || _vm.viewStatus == ViewStatus.noMore) {
      return ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 24.w),
          itemBuilder: (ctx, index) {
            var entity = _vm.datas[index];
            var item = ItemView(
              index: index,
              entity: entity,
              onPressed: () {
                Get.to(() => EditItemRecordPage(id: entity!.id!));
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
        title: '????????????',
        onTap: () {
          // ToastUtil.showLoading();
          _vm.loadData().then((value) {
            // ToastUtil.hiddenLoading();
          });
        },
      );
    } else {
      return StatusView(
        title: '????????????',
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
        leading: IconButton(
            icon: ImageIcon(ViewUtils.getAssetImage('icon_activity_back')),
            color: Colors.black,
            onPressed: () {
              Get.to(() => IndexPage(
                    tindex: 2,
                  ));
            }),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // IconButton(
            //     icon: ImageIcon(ViewUtils.getAssetImage('icon_activity_back')),
            //     color: Colors.white,
            //     onPressed: () {
            //       Get.to(() => IndexPage(
            //         tindex: 2,
            //       ));
            //     }),
            // SizedBox(
            //   height: 16.w,
            // ),
            Text(
              '????????????',
              style: TextStyle(fontSize: 18.sp, color: const Color(0xFF222222), fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.w, width: (SizeFit.screenWidth ?? 240.w / 2) - 34.w),
            // SizedBox(
            //   height: 16.w,
            // ),
            IconButton(
              icon: ViewUtils.getImage(
                'ic_active_add_img',
                24.w,
                24.w,
                // color: themeColor.primaryColor,
              ),
              onPressed: () => Get.to(() => const FullScreenScannerPage(srcPath: 'addItem')),
            ),
          ],
        ),
        elevation: 0.5);
  }
}
