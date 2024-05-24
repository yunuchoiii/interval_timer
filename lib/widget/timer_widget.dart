import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:interval_timer/service/timer_service.dart';

class TimerDisplay extends StatelessWidget {
  final TimerService readTimer;

  const TimerDisplay({
    Key? key,
    required this.readTimer,
  }) : super(key: key);

  String formatMinutes(int milliseconds) =>
      (milliseconds / 60000).floor().toString().padLeft(1, '0');
  String formatSeconds(int milliseconds) =>
      ((milliseconds % 60000) / 1000).floor().toString().padLeft(2, '0');
  String formatMilliseconds(int milliseconds) =>
      ((milliseconds % 1000) / 100).floor().toString().padLeft(1, '0');

  @override
  Widget build(BuildContext context) {
    double progress = readTimer.currentTime /
        ((readTimer.state == TimerState.running
                ? readTimer.runningTime
                : readTimer.state == TimerState.resting
                    ? readTimer.restingTime
                    : 3) *
            1000);

    return Center(
      child: SizedBox(
        width: 0.75.sw,
        height: 0.75.sw,
        child: Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 0.75.sw,
              height: 0.75.sw,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 8.w,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.white.withOpacity(0.8),
                ),
              ),
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    width: .12.sw,
                    child: Text(
                      "${formatMinutes(readTimer.currentTime)}:",
                      softWrap: false,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 36.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withOpacity(
                          int.parse(formatMinutes(readTimer.currentTime)) >= 1
                              ? 1
                              : 0.75,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0.r),
                    child: SizedBox(
                      width: .37.sw,
                      child: Text(
                        formatSeconds(readTimer.currentTime),
                        softWrap: false,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 96.sp,
                          height: 0.9,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: .12.sw,
                    child: Text(
                      ".${formatMilliseconds(readTimer.currentTime)}",
                      softWrap: false,
                      style: TextStyle(
                        fontSize: 36.sp,
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
