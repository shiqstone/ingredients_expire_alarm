import 'package:flutter/cupertino.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:ingredients_expire_alarm/public.dart';
import 'package:ingredients_expire_alarm/vm/alarm_list_vm.dart';

class CountDownWidget extends StatefulWidget {
  final int index;
  final DateTime validTime;
  final double? textSize;
  final Color? textColor;
  final ValueChanged<bool>? isFinish;
  final void Function(bool) switchAlarm;
  final bool isAlarming;

  const CountDownWidget(
      {Key? key,
      required this.index,
      required this.validTime,
      required this.switchAlarm,
      required this.isAlarming,
      this.textSize,
      this.textColor,
      this.isFinish})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CountDownWidgetState();
  }
}

class _CountDownWidgetState extends State<CountDownWidget> {
  var _timer;

  @override
  void dispose() {
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime endTimeDate = widget.validTime; //DateTime.fromMillisecondsSinceEpoch(endTime);
    Duration difference = endTimeDate.difference(now);
    int computingTime = difference.inSeconds;
    late String textContext = constructTime(computingTime);

    if (computingTime < 0) {
      textContext = "已过期";
      if (widget.isFinish != null) {
        widget.isFinish!(true);
      }

      return Text(
        '已过期',
        style: TextStyle(
            fontSize: widget.textSize ?? 12.0,
            color: widget.textColor ?? CupertinoDynamicColor.resolve(CupertinoColors.systemRed, context)),
      );
    } else {
      int alarmSec = 300;
      if (computingTime > 0) {
        // if (computingTime <= alarmSec && !widget.isAlarming) {
        //   // if (widget.switchAlarm(true)) {
        //   //   AlarmListVM.instance.loadData();
        //   // }
        //   widget.switchAlarm(true);
        //   AlarmListVM.instance.loadData();

        //   if (computingTime == alarmSec) {
        //     FlutterRingtonePlayer.playAlarm();
        //     AlarmListVM.instance.loadData();
        //   }
        // }
        if (computingTime == alarmSec) {
          widget.switchAlarm(true);
          FlutterRingtonePlayer.playAlarm();
          AlarmListVM.instance.loadData();
        }

        Duration dura;
        if (computingTime > 7200) {
          dura = const Duration(seconds: 60);
        } else {
          dura = const Duration(seconds: 1);
        }
        _timer = Timer.periodic(dura, (timer) {
          if (computingTime > 0) {
            String computingTimeDate = constructTime(computingTime);
            textContext = computingTimeDate;
            if (mounted) {
              setState(() {});
            }
            timer.cancel();
          } else {
            timer.cancel();
            textContext = '已过期';
            if (widget.isFinish != null) {
              widget.isFinish!(true);
            }

            if (mounted) {
              setState(() {});
            }
          }
        });
      } else {
        if (widget.isFinish != null) {
          widget.isFinish!(true);
        }

        return Text(
          '已过期',
          style: TextStyle(
              fontSize: widget.textSize ?? 12.0,
              color: widget.textColor ?? CupertinoDynamicColor.resolve(CupertinoColors.systemRed, context)),
        );
      }

      var textColor;
      if (computingTime > 600) {
        textColor = widget.textColor ?? CupertinoDynamicColor.resolve(CupertinoColors.activeBlue, context);
      } else {
        widget.textColor ?? CupertinoDynamicColor.resolve(CupertinoColors.systemRed, context);
      }

      return Text(
        textContext,
        style: TextStyle(fontSize: widget.textSize ?? 12.0, color: textColor),
      );
    }
  }

  String formatTime(int timeNum) {
    return timeNum < 10 ? "0" + timeNum.toString() : timeNum.toString();
  }

  String constructTime(int seconds) {
    int days = 0;
    int hours = 0;
    int mins = 0;
    int secs = 0;
    if (seconds > 86400 * 2) {
      days = seconds ~/ 86400;
      return days.toString() + '天';
    } else if (seconds > 86400) {
      hours = (seconds - 86400) ~/ 3600;
      return '1天' + hours.toString() + '小时';
    } else if (seconds > 3600 * 2) {
      hours = seconds ~/ 3600;
      mins = seconds % 3600 ~/ 60;
      return formatTime(hours) + '小时' + formatTime(mins) + '分';
    } else {
      hours = seconds ~/ 3600;
      mins = seconds % 3600 ~/ 60;
      secs = seconds % 60;
      return formatTime(hours) + ':' + formatTime(mins) + ':' + formatTime(secs);
    }
  }
}
