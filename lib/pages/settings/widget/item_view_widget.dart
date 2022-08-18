import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ingredients_expire_alarm/db/item_db_manage.dart';
import 'package:ingredients_expire_alarm/model/item_record.dart';
import 'package:ingredients_expire_alarm/pages/settings/edit_item_page.dart';
import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/util/utils.dart';
import 'package:ingredients_expire_alarm/util/view_utils.dart';
import 'package:ingredients_expire_alarm/vm/item_list_vm.dart';

class ItemView extends StatelessWidget {
  final int index;
  final ItemRecord? entity;
  final VoidCallback? onPressed;
  ItemView({Key? key, required this.index, required this.entity, required this.onPressed}) : super(key: key);

  String ptype = '';
  int period = 0;

  final ItemDbManage _databaseManage = ItemDbManage();

  @override
  Widget build(BuildContext context) {
    if ((entity?.validityPeriod)! > 86400 * 30) {
      ptype = '月';
      period = ((entity?.validityPeriod)! / 86400 / 30).round();
    } else if ((entity?.validityPeriod)! > 86400) {
      ptype = '天';
      period = ((entity?.validityPeriod)! / 86400).round();
    } else {
      ptype = '小时';
      period = ((entity?.validityPeriod)! / 3600).round();
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(left: 10.w, right: 16.w),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.w),
              height: 64.w,
              decoration: BoxDecoration(
                  // color: themeColor.mainBgColor,
                  borderRadius: BorderRadius.all(Radius.circular(16.w)),
                  border: Border.all(
                      width: 0.5.w, color: index == -1 ? themeColor.primaryColor : themeColor.underlineColor)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(Utils.maxLengthWithEllipse(entity?.name ?? '', 25),
                                maxLines: 1,
                                style: TextStyle(
                                    color: themeColor.titleLightColor, fontWeight: FontWeight.w600, fontSize: 16.sp)),
                            SizedBox(
                              height: 15.w,
                              width: 22.w,
                            ),
                            Text(period.toString(),
                                style: TextStyle(
                                  height: 1.4.w,
                                    color: themeColor.primaryColor, fontWeight: FontWeight.w600, fontSize: 16.sp)),
                            SizedBox(
                              height: 15.w,
                              width: 5.w,
                            ),
                            Text(ptype,
                                style: TextStyle(
                                    height: 1.4.w,
                                    color: themeColor.titleBlackColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp)),
                            SizedBox(
                              height: 15.w,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => {
                      Get.to(() => EditItemRecordPage(id: entity!.id!))
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ViewUtils.getImage('ic_comment_bi', 25.w, 21.w),
                        SizedBox(height: 4.w,),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => {
                      onDelete(entity!.id!)
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ViewUtils.getImage('ic_delete', 25.w, 21.w),
                        SizedBox(height: 4.w,),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onDelete(int id) async {
      await _databaseManage.deleteItemRecord(id);
      ItemListVm.instance.loadData();
  }
}
