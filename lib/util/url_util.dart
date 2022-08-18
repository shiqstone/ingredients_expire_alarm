import 'package:ingredients_expire_alarm/util/toast_util.dart';

import '../public.dart';

///type:
///1,内部跳转，2,外部跳转
/// pages:
/// [√]blog:线索详情页，参数为blogId
/// [√]topic:话题详情页，参数为topicId
/// [√]active:活动详情页，参数为activityId
/// [√]groupInvite:入群申请页面,参数为groupId
/// [√]user:用户详情页，参数为userId
/// [√]notify:通知列表页，
///   参数:0,系统通知，1,赞和喂豆，2,评论和@
/// [√]skittles:彩虹豆页面,参数可不传
/// [√]editInfo:个人资料编辑页面,参数可不传
/// [√]walk:首页，
///   参数:0,首页-发现tab，1,首页-欢聚tab，2线索tab，
/// [√]webview:跳转到H5页面，参数为链接
///
class UrlUtil {
  static jump(
      {String? type = '1',
      String? url,
      String? title,
      bool? isBanner = false}) {
    if (isBanner == true) {
    }

    if (url == null) {
      return;
    }

    if (type == '1') {
      //内部跳转
      if (url.startsWith('blog:')) {
      } else {
        ToastUtil.show('The current version does not support'); //当前版本不支持，请升级后使用
      }
    } else if (type == '2') {
      //外部跳转
      // Get.to(() => JumpOutPage(externalUrl: url), preventDuplicates: false);
    }
  }
}
