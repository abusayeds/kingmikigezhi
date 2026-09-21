import 'package:event_sharing/controllers/event_controller.dart';
import 'package:event_sharing/helpers/route.dart';
import 'package:event_sharing/models/event_model.dart';
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

  final List<String> _months = const [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  late int _selectedMonthIndex;
  late int _selectedYear;
  final List<int> _years =
      List<int>.generate(2030 - 2020 + 1, (i) => 2020 + i);

  Map<DateTime, List<HomeEventModel>> _eventsMap = {};
  Map<DateTime, List<EventModel>> _feedEventsMap = {};

  /// Current (today) highlight — soft blue circle
  static final Color _todayFill = AppColors.colorA4B9DE;

  /// Selected / tapped date highlight — brand primary circle (different from today)
  static final Color _selectedFill = AppColors.primaryColor;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _selectedMonthIndex = _focusedDay.month;
    _selectedYear = _focusedDay.year;
    _eventController.fetchHomeEvents();
    _eventController.fetchCalendarEvents();
  }

  DateTime _dayKey(DateTime day) =>
      DateTime.utc(day.year, day.month, day.day);

  int _getEventCountForDay(DateTime day) {
    final key = _dayKey(day);
    return (_eventsMap[key]?.length ?? 0) + (_feedEventsMap[key]?.length ?? 0);
  }

  List<Object> _getEventsForDay(DateTime day) {
    final key = _dayKey(day);
    return [
      ...(_eventsMap[key] ?? const <HomeEventModel>[]),
      ...(_feedEventsMap[key] ?? const <EventModel>[]),
    ];
  }

  void _jumpToMonthYear(int month, int year) {
    final day =
        (_selectedDay?.day ?? 1).clamp(1, DateTime(year, month + 1, 0).day);
    setState(() {
      _selectedMonthIndex = month;
      _selectedYear = year;
      _focusedDay = DateTime(year, month, day);
      _selectedDay = DateTime(year, month, day);
    });
  }

  /// Circle day cell — not rounded square.
  Widget _dayCell({
    required DateTime day,
    required bool isToday,
    required bool isSelected,
  }) {
    final eventCount = _getEventCountForDay(day);
    final hasEvents = eventCount > 0;
    final dotCount = eventCount > 3 ? 3 : eventCount;

    Color? fill;
    Color textColor = Colors.black;
    Border? border;

    if (isSelected) {
      fill = _selectedFill;
      textColor = Colors.white;
    } else if (isToday) {
      fill = _todayFill;
      textColor = Colors.black;
    }

    // Today that is also selected: primary fill + today ring so both states show
    if (isSelected && isToday) {
      border = Border.all(color: _todayFill, width: 2.5);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: border,
          ),
          child: Text(
            '${day.day}',
            style: TextStyle(
              fontSize: 14.sp,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          height: 6.h,
          child: hasEvents
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    dotCount,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 1.w),
                      height: 5.h,
                      width: 5.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected
                            ? _selectedFill.withOpacity(0.85)
                            : AppColors.buttonColor,
                      ),
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  Widget _buildSelectedEventsList(List<Object> selectedEvents) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 12.h),
        Text(
          'Events on ${DateFormat('d MMM yyyy').format(_selectedDay!)}',
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.color20353F,
          ),
        ),
        SizedBox(height: 8.h),
        ...selectedEvents.map((event) {
          if (event is EventModel) {
            return _eventTile(
              title: event.eventName ?? 'Event',
              subtitle: event.location,
              onTap: () {
                if (event.id != null && event.id!.isNotEmpty) {
                  Get.toNamed(
                    AppRoutes.eventDetailsScreen,
                    arguments: event.id,
                  );
                }
              },
            );
          }
          if (event is HomeEventModel) {
            final timeLabel = [
              if (event.startsAt != null)
                DateFormat('hh:mm a').format(event.startsAt!),
              if (event.endsAt != null)
                DateFormat('hh:mm a').format(event.endsAt!),
            ].join(' - ');
            return _eventTile(
              title: event.title ?? 'Home event',
              subtitle: [
                if (event.location != null && event.location!.isNotEmpty)
                  event.location!,
                if (timeLabel.isNotEmpty) timeLabel,
              ].join(' · '),
            );
          }
          return _eventTile(title: 'Event');
        }),
      ],
    );
  }

  Widget _eventTile({
    required String title,
    String? subtitle,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.colorEDF2F4,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.primaryColor, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null && subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: GoogleFonts.poppins(
                        fontSize: 11.sp,
                        color: AppColors.color414141,
                      ),
                    ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: AppColors.primaryColor,
                size: 20.sp,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      _eventsMap = {};
      for (final event in _eventController.homeEvents) {
        if (event.startsAt != null) {
          _eventsMap.putIfAbsent(_dayKey(event.startsAt!), () => []).add(event);
        }
        if (event.endsAt != null && event.startsAt != null) {
          final startKey = _dayKey(event.startsAt!);
          final endKey = _dayKey(event.endsAt!);
          if (endKey != startKey) {
            _eventsMap.putIfAbsent(endKey, () => []).add(event);
          }
        }
      }

      _feedEventsMap = {};
      for (final event in _eventController.calendarEvents) {
        final date = event.schedule?.registrationDate;
        if (date != null) {
          _feedEventsMap.putIfAbsent(_dayKey(date), () => []).add(event);
        }
      }

      final selectedEvents =
          _selectedDay == null ? <Object>[] : _getEventsForDay(_selectedDay!);
      final hasEventsOnSelected = selectedEvents.isNotEmpty;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: _selectedMonthIndex,
                    items: List.generate(
                      12,
                      (i) => DropdownMenuItem<int>(
                        value: i + 1,
                        child: Text(
                          _months[i],
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF202020),
                          ),
                        ),
                      ),
                    ),
                    onChanged: (month) {
                      if (month != null) {
                        _jumpToMonthYear(month, _selectedYear);
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    isExpanded: true,
                    value: _years.contains(_selectedYear)
                        ? _selectedYear
                        : _years.first,
                    items: _years
                        .map(
                          (y) => DropdownMenuItem<int>(
                            value: y,
                            child: Text(
                              '$y',
                              style: GoogleFonts.poppins(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF202020),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (year) {
                      if (year != null) {
                        _jumpToMonthYear(_selectedMonthIndex, year);
                      }
                    },
                  ),
                ),
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
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            startingDayOfWeek: StartingDayOfWeek.monday,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onPageChanged: (focusedDay) {
              setState(() {
                _focusedDay = focusedDay;
                _selectedMonthIndex = focusedDay.month;
                _selectedYear = focusedDay.year;
              });
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
                _selectedMonthIndex = focusedDay.month;
                _selectedYear = focusedDay.year;
              });
            },
            headerVisible: false,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: AppColors.colorA4B9DE),
              weekendStyle: TextStyle(color: AppColors.colorA4B9DE),
            ),
            calendarStyle: CalendarStyle(
              // Disabled — we draw circles in builders
              todayDecoration: const BoxDecoration(shape: BoxShape.circle),
              selectedDecoration: const BoxDecoration(shape: BoxShape.circle),
              outsideDaysVisible: false,
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return _dayCell(
                  day: day,
                  isToday: false,
                  isSelected: false,
                );
              },
              todayBuilder: (context, day, focusedDay) {
                return _dayCell(
                  day: day,
                  isToday: true,
                  isSelected: isSameDay(day, _selectedDay),
                );
              },
              selectedBuilder: (context, day, focusedDay) {
                return _dayCell(
                  day: day,
                  isToday: isSameDay(day, DateTime.now()),
                  isSelected: true,
                );
              },
            ),
          ),
          // Show events under calendar only when the tapped date has events
          if (_selectedDay != null && hasEventsOnSelected)
            _buildSelectedEventsList(selectedEvents),
        ],
      );
    });
  }
}
