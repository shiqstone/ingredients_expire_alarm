import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ingredients_expire_alarm/util/view_utils.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarWidget extends StatefulWidget {
  DateTime? showTime;
  final String? title;
  CalendarWidget({Key? key, required this.showTime, required this.title}) : super(key: key);

  @override
  _CalendarWidgetState createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // color: Colors.deepPurpleAccent,
      appBar: AppBar(
        leading: IconButton(
            icon: ImageIcon(ViewUtils.getAssetImage('icon_activity_back')),
            color: Colors.black,
            onPressed: () {
              Get.back();
            }),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          widget.title!,
          style: TextStyle(fontSize: 18.sp, color: const Color(0xFF222222), fontWeight: FontWeight.bold),
        ),
      ),
      body: TableCalendar(
        // headerVisible: false,
        headerStyle: HeaderStyle(
          titleCentered: true,
          headerPadding: EdgeInsets.only(top: 10.w, bottom: 10.w),
          leftChevronPadding: EdgeInsets.all(4.w),
          leftChevronMargin: EdgeInsets.only(left: 110.w),
          rightChevronMargin: EdgeInsets.only(right: 110.w),
          rightChevronPadding: EdgeInsets.all(4.w),
          leftChevronVisible: true,
          rightChevronVisible: true,
          leftChevronIcon: const Icon(Icons.arrow_left),
          rightChevronIcon: const Icon(Icons.arrow_right),
          formatButtonVisible: false,
        ),
        calendarStyle: _calendarStyle(),
        calendarBuilders: CalendarBuilders(
          headerTitleBuilder: (context, day) {
            final text = DateFormat.yM('zh_CN').format(day);
            return Center(
              child: Text(
                text,
                style: TextStyle(color: const Color(0xff000000), fontSize: 14.sp, fontWeight: FontWeight.w500),
              ),
            );
          },
          dowBuilder: (context, day) {
            final text = DateFormat.E('zh_CN').format(day).substring(1);
            return Center(
              child: Text(
                text,
                style: TextStyle(color: const Color(0x66000000), fontSize: 12.sp),
              ),
            );
          },
          todayBuilder: (context, day, focusedDay) {
            return Center(
              child: Text(
                '今天',
                style: TextStyle(color: const Color(0xff000000), fontSize: 12.sp, fontWeight: FontWeight.w500),
              ),
            );
          },
          defaultBuilder: (context, day, focusedDay) {
            final text = DateFormat.d().format(day);
            return Center(
              child: Text(
                text,
                style: TextStyle(color: const Color(0xff000000), fontSize: 12.sp, fontWeight: FontWeight.w500),
              ),
            );
          },
        ),
        locale: 'zh_CN',
        firstDay: kFirstDay,
        lastDay: kLastDay,
        focusedDay: _focusedDay,
        calendarFormat: _calendarFormat,
        selectedDayPredicate: (day) {
          // Use `selectedDayPredicate` to determine which day is currently selected.
          // If this returns true, then `day` will be marked as selected.

          // Using `isSameDay` is recommended to disregard
          // the time-part of compared DateTime objects.
          // return true;
          return isSameDay(_selectedDay, day);
        },
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
            widget.showTime = selectedDay;
          });
          Get.back(result: _selectedDay);
          // if (!isSameDay(_selectedDay, selectedDay)) {
          //   // Call `setState()` when updating the selected day
          //   setState(() {
          //     _selectedDay = selectedDay;
          //     _focusedDay = focusedDay;
          //     widget.expireTime = selectedDay;
          //   });
          // } else {
          //   setState(() {
          //     _selectedDay = null;
          //     _focusedDay = DateTime.now();
          //     widget.expireTime = null;
          //   });
          //   Get.back(result: _selectedDay);
          // }
        },
        // onFormatChanged: (format) {
        //   if (_calendarFormat != format) {
        //     // Call `setState()` when updating calendar format
        //     setState(() {
        //       _calendarFormat = format;
        //     });
        //   }
        // },
        // onPageChanged: (focusedDay) {
        //   // No need to call `setState()` here
        //   _focusedDay = focusedDay;
        // },
      ),
    );
  }

  CalendarStyle _calendarStyle() {
    return const CalendarStyle(
      selectedDecoration: BoxDecoration(
        color: Color(0xff6C84FC),
        shape: BoxShape.circle,
      ),
    );
  }
}

class Event {
  final String title;

  const Event(this.title);

  @override
  String toString() => title;
}

final kEvents = LinkedHashMap<DateTime, List<Event>>(
  equals: isSameDay,
  hashCode: getHashCode,
)..addAll(_kEventSource);

final _kEventSource = {
  for (var item in List.generate(50, (index) => index))
    DateTime.utc(kFirstDay.year, kFirstDay.month, item * 5):
        List.generate(item % 4 + 1, (index) => Event('Event $item | ${index + 1}'))
}..addAll({
    kToday: [
      const Event('Today\'s Event 1'),
      const Event('Today\'s Event 2'),
    ],
  });

int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

final kToday = DateTime.now();
final kFirstDay = DateTime(kToday.year - 1, kToday.month, kToday.day);
final kLastDay = DateTime(kToday.year + 3, kToday.month, kToday.day);