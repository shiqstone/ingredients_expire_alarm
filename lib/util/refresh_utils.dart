import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

/// 全局下拉刷新管理类
class RefreshUtils {
  /// 获取下拉头
  static Widget getHeader() {
    // return ClassicHeader();
    return const MaterialClassicHeader(
      color: Colors.blue,
    );
  }

  /// 获取 IM 下拉头
  static Widget getIMHeader() {
    return const MaterialClassicHeader();
  }

  /// 获取上拉加载 Footer
  static Widget getFooter() {
    return const ClassicFooter(noDataText: '没有更多');
  }

  /// 获取上拉加载 Footer
  static Widget getIMFooter() {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        late Widget body;
        if (mode == LoadStatus.idle) {
          // body = Text("pull up load");
        } else if (mode == LoadStatus.loading) {
          body = const CupertinoActivityIndicator();
        } else if (mode == LoadStatus.failed) {
          body = const Text("");
        } else if (mode == LoadStatus.canLoading) {
          body = const Text("");
        } else {
          body = const Text("");
        }
        return SizedBox(
          height: 55.0,
          child: Center(child: body),
        );
      },
    );
  }
}
