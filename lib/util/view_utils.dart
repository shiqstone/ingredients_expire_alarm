import 'package:flutter/material.dart';
import 'package:ingredients_expire_alarm/util/utils.dart';

class ViewUtils{

  static Image getImage(String imgId, double width, double height,{String? format, BoxFit? fit, Color? color}){
    return Image.asset(
      Utils.getImgPath(imgId,format: format),
      gaplessPlayback: true,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }

  static AssetImage getAssetImage(String imgId){
    return AssetImage(Utils.getImgPath(imgId));
  }

  static Image getAvatar(String imgId, double width, double height,{String? format, BoxFit? fit, Color? color}){
    return Image.asset(
      Utils.getAvatarPath(imgId,format: format),
      gaplessPlayback: true,
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }
}
