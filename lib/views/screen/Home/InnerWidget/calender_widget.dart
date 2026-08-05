import 'package:event_sharing/controllers/event_controller.dart';
import 'package:event_sharing/models/home_event_model.dart';
import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


class CalendarWithDropdown extends StatefulWidget {
  const CalendarWithDropdown({super.key});

  @override
  _CalendarWithDropdownState createState() => _CalendarWithDropdownState();
}

class _CalendarWithDropdownState extends State<CalendarWithDropdown> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  final EventController _eventController = Get.find<EventController>();

  final List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
  ];

  String _selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());

  Map<DateTime, List<HomeEventModel>> _eventsMap = {};
  Map<DateTime, int> _feedEventsCountMap = {};

  @override
  void initState() {
    super.initState();
    _eventController.fetchHomeEvents();
    _eventController.fetchCalendarEvents();
  }

  int _getEventCountForDay(DateTime day) {
    final utcDay = DateTime.utc(day.year, day.month, day.day);
    return (_eventsMap[utcDay]?.length ?? 0) + (_feedEventsCountMap[utcDay] ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      _eventsMap = {};
      for (final event in _eventController.homeEvents) {
        if (event.startsAt != null) {
          final startUtc = DateTime.utc(event.startsAt!.year, event.startsAt!.month, event.startsAt!.day);
          _eventsMap.putIfAbsent(startUtc, () => []).add(event);
        }
        if (event.endsAt != null && event.endsAt != event.startsAt) {
          final endUtc = DateTime.utc(event.endsAt!.year, event.endsAt!.month, event.endsAt!.day);
          if (endUtc != DateTime.utc(event.startsAt!.year, event.startsAt!.month, event.startsAt!.day)) {
            _eventsMap.putIfAbsent(endUtc, () => []).add(event);
          }
        }
      }

      _feedEventsCountMap = {};
      for (final event in _eventController.calendarEvents) {
        final date = event.schedule?.registrationDate;
        if (date != null) {
          final utcDate = DateTime.utc(date.year, date.month, date.day);
          _feedEventsCountMap[utcDate] = (_feedEventsCountMap[utcDate] ?? 0) + 1;
        }
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              DropdownButton<String>(
                value: _selectedMonth,
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      int monthIndex = _months.indexOf(newValue.split(' ')[0]) + 1;
                      int year = int.parse(newValue.split(' ')[1]);
                      _selectedMonth = newValue;
                      _focusedDay = DateTime(year, monthIndex);
                      _selectedDay = DateTime(year, monthIndex, _selectedDay?.day ?? 1);
                    });
                  }
                },
                items: _months.map<DropdownMenuItem<String>>((String month) {
                  return DropdownMenuItem<String>(
                    value: "$month ${_focusedDay.year}",
                    child: Text("$month ${_focusedDay.year}", style: GoogleFonts.poppins(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF202020)
                    )),
                  );
                }).toList(),
              ),
              IconButton(
                icon: SvgPicture.asset(AppIcons.calendarIcon),
                onPressed: () {
                  setState(() {
                    _calendarFormat = _calendarFormat == CalendarFormat.week
                        ? CalendarFormat.month
                        : CalendarFormat.week;
                  });
                },
              ),
            ],
          ),
          TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                _selectedMonth = "${_months[focusedDay.month - 1]} ${focusedDay.year}";
                _selectedDay = DateTime(focusedDay.year, focusedDay.month, _selectedDay?.day ?? 1);
              });
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            headerVisible: false,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: AppColors.colorA4B9DE),
              weekendStyle: TextStyle(color: AppColors.colorA4B9DE),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.colorCDBDB6,
                shape: BoxShape.rectangle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppColors.colorCDBDB6,
                shape: BoxShape.rectangle,
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                final eventCount = _getEventCountForDay(day);
                bool hasEvents = eventCount > 0;
                final dotCount = eventCount > 3 ? 3 : eventCount;
                return Container(
                  margin: const EdgeInsets.only(bottom: 5),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.0.h),
                            child: Text(
                              '${day.day}',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: isSameDay(day, _selectedDay) ? Colors.white : Colors.black,
                                fontWeight: isSameDay(day, _selectedDay) ? FontWeight.w600 : FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (hasEvents)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            dotCount,
                            (index) => Container(
                              margin: EdgeInsets.symmetric(horizontal: 1.w),
                              height: 5.h,
                              width: 5.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: AppColors.buttonColor,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
