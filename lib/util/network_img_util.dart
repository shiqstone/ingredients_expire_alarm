import 'package:cached_network_image/cached_network_image.dart';
import 'package:ingredients_expire_alarm/util/string_util.dart';
import 'package:flutter/painting.dart';

class NetWorkImgUtil {
  //auto add http or https
  static ImageProvider? loadImg(String url) {
    if (StringUtil.isEmpty(url)) {
      return null;
    }
    return NetworkImage(url.startsWith('http') ? url : 'https:' + url);
  }

  static String getUrl(String url) {
    if (StringUtil.isEmpty(url)) {
      return "";
    }
    return url.startsWith('http') ? url : 'https:' + url;
  }

  //获取ali oss 视频文件的截图,前提是必须是ali oss视频文件，其他地址不支持
  static String getVideoSnapUrl(String sourceUrl,
      [int width = 0, int height = 0]) {
    if (!isAliyunOss(sourceUrl)) {
      return sourceUrl;
    }
    String tmp = 'x-oss-process=video/snapshot,t_0,m_fast,ar_auto,f_jpg' +
        (width == 0 || height == 0
            ? ''
            : ',w_' + width.toString() + ',h_' + height.toString());

    sourceUrl = sourceUrl + (sourceUrl.contains('?w=') ? '&' : '?') + tmp;
    // print('[snapUrl]' + sourceUrl);
    return sourceUrl;
  }

  static String getLowQImgUrl(String url,
      {bool isEllipsis = true,
      int quality = 40,
      int? width = 200,
      int? height = 200}) {
    if (!isAliyunOss(url)) {
      return url;
    }
    Uri uri = Uri.parse(url);
    String opParam = 'x-oss-process=image';
    String lqUrl = url;
    //try webp
    // opParam = opParam + '/format,webp';
    lqUrl = url + (url.contains('?') ? '&' : '?') + opParam;
    String resizeParam = '';
    if (isEllipsis) {
      if (uri.path.toLowerCase().endsWith('png') ||
          uri.path.toLowerCase().endsWith('jpg') ||
          uri.path.toLowerCase().endsWith('jpeg')) {
        String h = height != null ? height.toString() : '200';
        String w = width != null ? width.toString() : '200';
        resizeParam = '/resize,m_fill,h_' + h + ',w_' + w;
        lqUrl = lqUrl + resizeParam;
      }
    }
    String fmtParam = '/format,webp';
    /**
     * https://help.aliyun.com/document_detail/44703.html
     * 注意事项
     * 图片处理包含缩放操作时，建议将格式转换参数放到处理参数的最后。
     * 例如image/resize,w_100/format,jpg
     * 图片处理包含缩放和水印操作时，建议将格式转换参数添加在缩放参数之后。
     * 例如image/reisze,w_100/format,jpg/watermark,...
     */
    lqUrl = lqUrl + fmtParam;
    // print(lqUrl);
    return lqUrl;
  }

  static String getInterlaceImgUrl(String url) {
    if (!isAliyunOss(url)) {
      return url;
    }
    Uri uri = Uri.parse(url);
    String opParam = 'x-oss-process=image';
    String lqUrl = url;

    lqUrl = url + (url.contains('?') ? '&' : '?') + opParam;
    if (uri.path.toLowerCase().endsWith('jpg') ||
        uri.path.toLowerCase().endsWith('jpeg')) {
      String optParam = '';
      optParam = '/interlace,1';
      lqUrl = lqUrl + optParam;
    }

    return lqUrl;
  }

  static double getUrlParams(String url, String param) {
    Uri u = Uri.parse(url);
  
    String? paramsStr = u.queryParameters[param];
    if (StringUtil.isEmpty(paramsStr)) {
      return 0;
    }

    try {
      return double.parse(paramsStr!);
    } catch (error) {
      return 0;
    }
  }

  static buildCachedImg(String imgUrl,
      {BoxFit fit = BoxFit.cover,
      double? width,
      double? height,
      bool isEllipsis = true,
      PlaceholderWidgetBuilder? placeholder,
      bool showLog = false}) {
    late Size wh;
    int? wi;
    int? hi;
    if (width == null || height == null) {
      wh = getWidthHeightFromUrl(imgUrl);
    }
    if (width == null) {
      width = wh.width;
      if (!isEllipsis) {
        wi = width.toInt();
      }
    } else {
      wi = width.toInt() * 2;
    }
    if (height == null) {
      height = wh.height;
      if (!isEllipsis) {
        hi = height.toInt();
      }
    } else {
      hi = height.toInt() * 2;
    }
    String imageUrl = getLowQImgUrl(
      imgUrl,
      isEllipsis: isEllipsis,
      width: wi,
      height: hi,
    );
    // if (showLog) print(imageUrl);
    return CachedNetworkImage(
      imageUrl: imageUrl,
      alignment: Alignment.topCenter,
      fit: fit,
      width: width,
      height: height,
      placeholder: placeholder,
    );
  }

  static bool isAliyunOss(sourceUrl) {
    return sourceUrl.contains('wonder-test01') ||
        sourceUrl.contains('iea-formal-01');
  }

  static Size getWidthHeightFromUrl(String url) {
    Uri u = Uri.parse(url);
    double width = 200.0;
    double height = 200.0;

    String? wstr = u.queryParameters['w'];
    try {
      if (StringUtil.isEmpty(wstr)) {
        wstr = u.queryParameters['width'];
        if (!StringUtil.isEmpty(wstr)) {
          width = double.parse(wstr!);
        }
      } else {
        width = double.parse(wstr!);
      }
    } catch (e) {
      // print(e);
    }

    String? hstr = u.queryParameters['h'];
    try {
      if (StringUtil.isEmpty(hstr)) {
        hstr = u.queryParameters['height'];
        if (!StringUtil.isEmpty(hstr)) {
          height = double.parse(hstr!);
        }
      } else {
        height = double.parse(hstr!);
      }
    } catch (e) {
      // print(e);
    }
    return Size(width, height);
    // double aspectRatio = width / height;
    // return {'width': width, 'height': height, 'aspectRatio': aspectRatio};
  }
}
