import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:ingredients_expire_alarm/util/string_util.dart';

class IpUtil {
  /// 内网ip
  static String? getIntranetIp() {
    NetworkInterface.list().then((value) {
      for (var interface in value) {
        for (var addr in interface.addresses) {
          if (!StringUtil.isEmpty(addr.address)) {
            return addr.address;
          }
        }
      }
    });
    return null;
  }

  /// 外网ip
  static Future<Map<String, String>?> getInternetIpInfo() async {
    var url = 'http://www.cip.cc';
    /* data format
      IP	: 124.126.144.142
      地址	: 中国  北京
      运营商	: 电信
      数据二	: 北京市 | 中国电信北京研究院
      数据三	: 中国北京北京 | 电信
      URL	: http://www.cip.cc/124.126.144.142
    */
    // String? ip;
    Map<String, String> info = {};
    var response = await http.get(Uri.parse(url), headers: {"User-Agent": "curl/7.64.1"});
    var resArr = response.body.split('\n');
    for (String line in resArr) {
      if (!line.contains(':')) {
        continue;
      }
      var item = line.split(':');
      var key = item[0].trim();
      var value = item[1].trim();
      if (key == 'IP') {
        info['ip'] = value;
      } else if (key == '地址') {
        info['addr'] = value;
      } else if (key == '运营商') {
        info['op'] = value;
      } else if (key == '数据三') {
        List<String> ops = ['移动', '联通', '电信'];
        var vals = value.split('|');
        if (StringUtil.isEmpty(info['op']) && ops.contains(vals[1].trim())) {
          info['op'] = vals[1].trim();
        }
      }
    }
    return info;
  }

  static Future<Map<String, dynamic>> pingHost({String host = '', int port = 80}) async {
    Map<String, dynamic> res = {};
    int start = DateTime.now().millisecond;
    try {
      var socket = await Socket.connect(host, port, timeout: const Duration(seconds: 5));
      res['res'] = 'Success';
      res['ip'] = socket.remoteAddress.address;
      res['dura'] = DateTime.now().millisecond - start;
      socket.destroy();
      return res;
    } on Exception catch (error) {
      res['res'] = 'Failed';
      res['dura'] = DateTime.now().millisecond - start;
      res['msg'] = error.toString();
      return res;
    }
  }
}
