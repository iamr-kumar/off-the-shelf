import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:off_the_shelf/src/theme/app_style.dart';
import 'package:off_the_shelf/src/theme/pallete.dart';
import 'package:table_calendar/table_calendar.dart';

class StreakTab extends ConsumerWidget {
  const StreakTab({super.key});

  Widget calendarBuilder(BuildContext context, DateTime date, DateTime _) {
    const goalCompleted = 0.8;
    final text = DateFormat('d').format(date);
    return SizedBox(
        height: 30,
        width: 30,
        child: Stack(fit: StackFit.expand, children: [
          const CircularProgressIndicator(
            value: goalCompleted,
            valueColor: AlwaysStoppedAnimation(Pallete.primaryBlue),
            strokeWidth: 4,
            backgroundColor: Pallete.textGreyLight,
          ),
          Center(
              child: Text(text,
                  style: AppStyles.bodyText
                      .copyWith(color: Pallete.primaryBlue, fontSize: 14))),
        ]));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
        body: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TableCalendar(
                        focusedDay: DateTime.now(),
                        firstDay: DateTime.utc(2010, 10, 16),
                        lastDay: DateTime.utc(2030, 3, 14),
                        rowHeight: 60,
                        calendarBuilders: CalendarBuilders(
                            defaultBuilder: calendarBuilder,
                            todayBuilder: calendarBuilder,
                            outsideBuilder: (context, date, _) {
                              final text = DateFormat('d').format(date);
                              return SizedBox(
                                  height: 30,
                                  width: 30,
                                  child: Text(text,
                                      style: AppStyles.bodyText.copyWith(
                                          color: Pallete.textGreyLight,
                                          fontSize: 14)));
                            }))
                  ],
                ))));
  }
}
