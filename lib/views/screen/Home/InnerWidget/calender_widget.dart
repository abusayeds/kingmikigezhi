import 'package:event_sharing/utils/app_colors.dart';
import 'package:event_sharing/utils/app_icons.dart';
import 'package:event_sharing/utils/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


class CalendarWithDropdown extends StatefulWidget {
  @override
  _CalendarWithDropdownState createState() => _CalendarWithDropdownState();
}

class _CalendarWithDropdownState extends State<CalendarWithDropdown> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'
  ];

  String _selectedMonth = DateFormat('MMMM yyyy').format(DateTime.now());

  final Map<DateTime, List<String>> appointmentDate = {
    DateTime.utc(2025, 4, 16): ['Meeting with team', 'Doctor appointment'],
    DateTime.utc(2025, 4, 18): ['Project deadline'],
    DateTime.utc(2025, 4, 20): ['Lunch with client', 'Gym session'],
    DateTime.utc(2025, 4, 22): ['Webinar'],
  };

  @override
  Widget build(BuildContext context) {
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
                    color: Color(0xFF202020)
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
              bool hasAppointments = _checkForAppointments(day);
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
                    if (hasAppointments)
                      Container(
                        height: 8.h,
                        width: 8.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber,
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
  }

  bool _checkForAppointments(DateTime day) {
    return appointmentDate.containsKey(day);
  }
}