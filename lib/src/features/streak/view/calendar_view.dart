import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:off_the_shelf/src/core/utils/type_defs.dart';
import 'package:off_the_shelf/src/core/widgets/error_text.dart';
import 'package:off_the_shelf/src/core/widgets/loader.dart';
import 'package:off_the_shelf/src/features/streak/controller/streak_controller.dart';
import 'package:off_the_shelf/src/features/user/controller/auth_controller.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarView extends ConsumerStatefulWidget {
  const CalendarView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CalendarViewState();
}

class _CalendarViewState extends ConsumerState<CalendarView> {
  late DateTime _focusedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
  }

  void updateCalenderView(DateTime date) {
    final monthStartDate = DateTime(date.year, date.month, 1);
    ref.read(streakStateProvider.notifier).getSessionsByMonth(monthStartDate);
    setState(() {
      _focusedDay = date;
    });
  }

  Widget calendarBuilder(BuildContext context, DateTime date,
      Map<String, DayReadStatus> sessionsMap) {
    final user = ref.read(userProvider)!;
    final goalType = user.goalType;
    final text = DateFormat('d').format(date);
    double goalCompleted = 0.0;
    final today = DateTime.now();

    final key = DateFormat('dd MM yy').format(date);
    if (sessionsMap[key] != null) {
      final dayReadStatus = sessionsMap[key]!;
      if (goalType == GoalType.pages) {
        goalCompleted = dayReadStatus.pages / user.pages!;
      } else {
        goalCompleted = dayReadStatus.minutes / user.minutes!;
      }
    }
    return SizedBox(
        height: 30,
        width: 30,
        child: Stack(fit: StackFit.expand, children: [
          CircularProgressIndicator(
            value: goalCompleted,
            valueColor: const AlwaysStoppedAnimation(Pallete.primaryBlue),
            strokeWidth: 4,
            backgroundColor:
                date.isAfter(today) ? Pallete.white : Pallete.textGreyLight,
          ),
          Center(
              child: Text(text,
                  style: AppStyles.bodyText
                      .copyWith(color: Pallete.primaryBlue, fontSize: 14))),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    final streakState = ref.watch(streakStateProvider);
    final loading = streakState.loading;
    final error = streakState.error;
    final sessionsMap = streakState.sessionsMap;

    if (loading) {
      return const Loader();
    }

    if (error != null) {
      return Center(child: ErrorText(error: error));
    }

    return TableCalendar(
        locale: "en_US",
        startingDayOfWeek: StartingDayOfWeek.monday,
        availableCalendarFormats: const {CalendarFormat.month: 'Month'},
        onPageChanged: updateCalenderView,
        headerStyle: const HeaderStyle(
            formatButtonVisible: false,
            titleCentered: true,
            titleTextStyle: AppStyles.highlightedSubtext),
        focusedDay: _focusedDay,
        firstDay: DateTime.utc(2010, 10, 16),
        lastDay: DateTime.utc(2030, 3, 14),
        rowHeight: 60,
        calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, date, _) =>
                calendarBuilder(context, date, sessionsMap),
            todayBuilder: (context, date, _) =>
                calendarBuilder(context, date, sessionsMap),
            outsideBuilder: (context, date, _) {
              final text = DateFormat('d').format(date);
              return SizedBox(
                  height: 30,
                  width: 30,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Text(text,
                        style: AppStyles.bodyText
                            .copyWith(color: Pallete.textGrey, fontSize: 14)),
                  ));
            }));
  }
}
