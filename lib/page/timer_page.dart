import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interval_timer/service/timer_service.dart';
import 'package:interval_timer/styles/app_colors.dart';
import 'package:interval_timer/widget/dropdown_row_widget.dart';
import 'package:interval_timer/widget/icon_buttons_row_widget.dart';
import 'package:interval_timer/widget/timer_widget.dart';
import 'package:provider/provider.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final readTimer = context.read<TimerService>();
    final watchTimer = context.watch<TimerService>();

    bool isWorkingOut = watchTimer.state == TimerState.running ||
        watchTimer.state == TimerState.resting ||
        watchTimer.state == TimerState.ready ||
        watchTimer.state == TimerState.paused;

    final ScrollController scrollController = ScrollController();

    final List<Map<String, dynamic>> iconButtonProps =
        getIconButtonProps(readTimer, watchTimer, scrollController);
    final List<Map<String, dynamic>> dropdownProps =
        getDropdownProps(readTimer, watchTimer);

    final timerVisuals = getTimerVisuals(watchTimer.state);

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: timerVisuals['backgroundColor'],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 1.sh - MediaQuery.of(context).viewPadding.top,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        'ROUND ${watchTimer.currentInterval}/${watchTimer.intervals}',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        timerVisuals['title'],
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TimerDisplay(readTimer: readTimer),
                      IconButtonRow(iconButtonProps: iconButtonProps),
                      IconButton(
                        onPressed: () {
                          scrollController.animateTo(
                            scrollController.position.maxScrollExtent,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                          );
                        },
                        icon: const Icon(Icons.settings),
                        iconSize: 32.r,
                        color: AppColors.gray01,
                        padding: const EdgeInsets.all(20),
                      ),
                      SizedBox(height: 10.h),
                    ],
                  ),
                ),
                // if (!isWorkingOut)
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: DropdownRow(dropdownProps: dropdownProps),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> getIconButtonProps(
    TimerService readTimer,
    TimerService watchTimer,
    ScrollController scrollController,
  ) {
    bool isWorkingOut = watchTimer.state == TimerState.running ||
        watchTimer.state == TimerState.resting ||
        watchTimer.state == TimerState.ready;
    return [
      {
        'title': "정지",
        'icon': const Icon(Icons.stop_rounded, color: Colors.white),
        'onPressed': () {
          watchTimer.setState(TimerState.nothing);
          readTimer.stopTimer();
        },
      },
      {
        'title': isWorkingOut ? "일시정지" : "시작",
        'icon': isWorkingOut
            ? const Icon(Icons.pause, color: Colors.white)
            : const Icon(Icons.play_arrow_rounded, color: Colors.white),
        'onPressed': isWorkingOut
            ? readTimer.pauseTimer
            : watchTimer.state == TimerState.paused
                ? watchTimer.restartTimer
                : () {
                    readTimer.startTimer();
                    scrollController.animateTo(
                      scrollController.position.minScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
      },
    ];
  }

  List<Map<String, dynamic>> getDropdownProps(
      TimerService readTimer, TimerService watchTimer) {
    return [
      {
        'title': 'Exercise Time',
        'value': watchTimer.runningTime,
        'onChanged': (value) => readTimer.setRunningTime(value!),
        'items': [10, 20, 30, 40, 50, 60, 70, 80, 90]
            .map((time) => DropdownMenuItem<int>(
                  value: time,
                  child: Text('$time sec'),
                ))
            .toList(),
      },
      {
        'title': 'Break Time',
        'value': watchTimer.restingTime,
        'onChanged': (value) => readTimer.setRestingTime(value!),
        'items': [10, 20, 30, 40, 50, 60, 70, 80, 90]
            .map((time) => DropdownMenuItem<int>(
                  value: time,
                  child: Text('$time sec'),
                ))
            .toList(),
      },
      {
        'title': 'Intervals',
        'value': watchTimer.intervals,
        'onChanged': (value) => readTimer.setIntervals(value!),
        'items': [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            .map((intervals) => DropdownMenuItem<int>(
                  value: intervals,
                  child: Text('$intervals'),
                ))
            .toList(),
      },
    ];
  }

  Map<String, dynamic> getTimerVisuals(TimerState state) {
    switch (state) {
      case TimerState.ready:
        return {'backgroundColor': AppColors.cyanGradient01, 'title': "READY"};
      case TimerState.running:
        return {'backgroundColor': AppColors.redGradient01, 'title': "RUN"};
      case TimerState.resting:
        return {'backgroundColor': AppColors.blueGradient01, 'title': "REST"};
      case TimerState.paused:
        return {'backgroundColor': AppColors.cyanGradient01, 'title': "PAUSED"};
      case TimerState.completed:
        return {
          'backgroundColor': AppColors.purpleGradient01,
          'title': "GREAT!"
        };
      default:
        return {
          'backgroundColor': AppColors.yellowGradient01,
          'title': "START"
        };
    }
  }
}
