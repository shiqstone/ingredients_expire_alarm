import 'package:intl/intl.dart';

class DateUtil {

  static bool isToday(int? millisecond) {
    int nowMillisecond = DateTime
        .now()
        .millisecondsSinceEpoch;
    return isSameDay(millisecond ?? 0, nowMillisecond);
  }

  static String formatYyyyMmDd(int? millisecond) {
    if (millisecond == null || millisecond == 0) {
      return '';
    }
    String timeStr = millisecond.toString();
    try {
      return timeStr.substring(4, 6) + '/' + timeStr.substring(6, 8) ;
    } catch (error) {
      return '';
    }
  }

  static String formatYMD(int? millisecond, {String format = 'yyyy/MM/dd'}) {
    if (millisecond == null || millisecond == 0) {
      return '';
    }
    try {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(millisecond);
      return DateFormat(format).format(time);
    } catch (error) {
      return '';
    }
  }

  static String formatYMDHM(int? millisecond, {String format = 'yyyy/MM/dd HH:mm'}) {
    if (millisecond == null || millisecond == 0) {
      return '';
    }
    try {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(millisecond);
      return DateFormat(format).format(time);
    } catch (error) {
      return '';
    }
  }


  static String getReadableTimeFormat(int millisecond) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(millisecond);
    int nowMillisecond = DateTime.now().millisecondsSinceEpoch;

    if (nowMillisecond - millisecond > 24 * 60 * 60 * 1000 ||
        time.day != DateTime.now().day) {
      // 大于一天
      return DateFormat("MM-dd").format(time);
    } else if (nowMillisecond - millisecond > 5 * 60 * 60 * 1000) {
      // 大于5小时
      return DateFormat("HH:mm").format(time);
    } else if (nowMillisecond - millisecond > 1 * 60 * 60 * 1000) {
      // 大于1小时
      int hour = (nowMillisecond - millisecond) ~/ (1000 * 60 * 60);
      return "${hour.toInt()}小时前";
    } else if (nowMillisecond - millisecond > 60 * 1000) {
      // 默认
      int minutes = (nowMillisecond - millisecond) ~/ (1000 * 60);
      return "${minutes.toInt()}分钟前";
    } else {
      return "刚刚";
    }
  }

  static String getFormatTime5(DateTime time) {
    return DateFormat("yyyy-MM-dd HH:mm").format(time);
  }

  static String getFormatDate(DateTime time) {
    return DateFormat("yyyy-MM-dd").format(time);
  }

  static String getFormatTimeAccurate(int millisecond) {
    DateTime time = DateTime.fromMillisecondsSinceEpoch(millisecond);
    return getFormatTime5(time);
  }

  static String getFormatTime2(DateTime mDate) {
    return DateFormat("MM-dd HH:mm").format(mDate);
  }

  //秒转换为分钟:秒
  static String getFormatTime4(int mSecond) {
    var d = Duration(seconds: mSecond);
    return d.abs().inMinutes.toString() +
        ":" +
        (mSecond - d.abs().inMinutes * 60).toString().padLeft(2, '0');
  }

  static String getMonthAndDay(int millisecond) {
    //返回月日
    DateTime time = DateTime.fromMillisecondsSinceEpoch(millisecond);
    return DateFormat("MM月dd日").format(time);
  }

  static String getWeek(int millisecond) {
    //返回星期几
    DateTime time = DateTime.fromMillisecondsSinceEpoch(millisecond);
    return "星期" + getWeekDay(time.weekday);
  }

  static String getWeekDay(int weekDay) {
    switch (weekDay) {
      case 1:
        return '一';
      case 2:
        return '二';
      case 3:
        return '三';
      case 4:
        return '四';
      case 5:
        return '五';
      case 6:
        return '六';
      default:
        return '天';
    }
  }

  // 两个时间差不超过一天
  static bool isNearDay(int day1, int day2) {
    DateTime timeDay1 = DateTime.fromMillisecondsSinceEpoch(day1);
    DateTime timeDay2 = DateTime.fromMillisecondsSinceEpoch(day2);
    return timeDay1.difference(timeDay2).inDays == 0;
  }

  // 两个时间为同一天
  static bool isSameDay(int day1, int day2) {
    return format(day1, format: 'yyyyMMdd') == format(day2, format: 'yyyyMMdd');
  }

  static String format(int millisecond, {String format = 'yyyy-MM-dd HH:mm'}) {
    try {
      DateTime time = DateTime.fromMillisecondsSinceEpoch(millisecond);
      return DateFormat(format).format(time);
    } catch (error) {
      return '';
    }
  }

  /// 活动时间展示规则
  /// 开始时间结束时间同年，年份只展示一次
  /// 开始时间结束时间同年同月同日，年月日只展示一次
  /// 开始时间结束时间间隔在一天内（跨天），年月日只展示一次
  /// 例：
  /// 2021.06.22 17:00-19:00
  /// 2021.09.30 21:00-02:00
  /// 2021.10.22 17:00 - 10.25 17:00 
  /// 2021.12.30 17:00 - 2022.01.01 03:00
  static String timeActiveShow(int startTime, int endTime) {
    DateTime timeDay1 = DateTime.fromMillisecondsSinceEpoch(startTime);
    DateTime timeDay2 = DateTime.fromMillisecondsSinceEpoch(endTime);
    if (timeDay1.difference(timeDay2).inDays == 0) {
      return format(startTime, format: 'yyyy.MM.dd HH:mm') +
          '-' +
          format(endTime, format: 'HH:mm');
    } else if (timeDay1.year == timeDay2.year) {
      return format(startTime, format: 'yyyy.MM.dd HH:mm') +
          ' - ' +
          format(endTime, format: 'MM.dd HH:mm');
    } else {
      return format(startTime, format: 'yyyy.MM.dd HH:mm') +
          ' - ' +
          format(endTime, format: 'yyyy.MM.dd HH:mm');
    }
    // if (isNearDay(startTime, endTime)) {
    //   return format(startTime, format: 'yyyy.MM.dd HH:mm') + '-' + format(endTime, format: 'HH:mm');
    // } else {
    //   return format(startTime, format: 'yyyy.MM.dd HH:mm') + '-' + format(endTime, format: 'yyyy.MM.dd HH:mm');
    // }
  }

  /// 快捷发布的时间展示
  static String showQuicklyTime(int startTime, int showTimeSpan) {
    List<String> timeSpanZh = ["", "全天", "上午", "下午", "晚上"];
    if (showTimeSpan > timeSpanZh.length) {
      showTimeSpan = 0;
    }
    return format(startTime, format: 'MM月dd日 ') + timeSpanZh[showTimeSpan];
  }

  static String timeMessageActiveShow(int startTime, int endTime) {
    DateTime timeDay1 = DateTime.fromMillisecondsSinceEpoch(startTime);
    DateTime timeDay2 = DateTime.fromMillisecondsSinceEpoch(endTime);
    if (timeDay1.difference(timeDay2).inDays == 0) {
      return format(startTime, format: 'MM.dd HH:mm') +
          '-' +
          format(endTime, format: 'HH:mm');
    } else if (timeDay1.year == timeDay2.year) {
      return format(startTime, format: 'MM.dd HH:mm') +
          ' - ' +
          format(endTime, format: 'MM.dd HH:mm');
    } else {
      return format(startTime, format: 'MM.dd HH:mm') +
          ' - ' +
          format(endTime, format: 'MM.dd HH:mm');
    }
  }

  // 至今多少天
  static int since(int? day) {
    if (day == null) {
      return 0;
    }
    DateTime timeDay = DateTime.fromMillisecondsSinceEpoch(day);
    return DateTime.now().difference(timeDay).inDays;
  }

}
