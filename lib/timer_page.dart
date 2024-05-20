import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

import 'timer_service.dart';

class TimerPage extends StatelessWidget {
  const TimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final readTimer = context.read<TimerService>();
    final watchTimer = context.watch<TimerService>();

    // 아이콘 버튼 속성 정의
    final List<Map<String, dynamic>> iconButtonProps = [
      {
        'title': "재시작",
        'icon': const Icon(Icons.replay_rounded, color: Colors.white),
        'onPressed': readTimer.restartTimer,
      },
      {
        'title': readTimer.isRunning || readTimer.isResting ? "일시정지" : "시작",
        'icon': readTimer.isRunning || readTimer.isResting
            ? const Icon(Icons.pause, color: Colors.white)
            : const Icon(Icons.play_arrow_rounded, color: Colors.white),
        'onPressed': readTimer.isRunning || readTimer.isResting
            ? readTimer.pauseTimer
            : readTimer.startTimer,
      },
      {
        'title': "정지",
        'icon': const Icon(Icons.stop_rounded, color: Colors.white),
        'onPressed': readTimer.stopTimer,
      },
    ];

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 53, 52, 52),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Interval ${watchTimer.currentInterval}/${watchTimer.intervals}',
                style: const TextStyle(fontSize: 24, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Text(
                watchTimer.isReady
                    ? 'READY'
                    : watchTimer.isResting
                        ? 'REST'
                        : 'RUN',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.w900,
                  color: watchTimer.isResting ? Colors.green : Colors.amber,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                '${watchTimer.currentTime}',
                style: const TextStyle(fontSize: 48, color: Colors.white),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: iconButtonProps.map((prop) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        IconButton(
                          icon: prop['icon'],
                          iconSize: prop['iconSize'] ?? 40,
                          onPressed: () {
                            Vibration.vibrate(duration: 100);
                            prop['onPressed']();
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          prop['title'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Run Time:',
                      style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    value: watchTimer.runningTime,
                    dropdownColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) => readTimer.setRunningTime(value!),
                    items: [10, 20, 30, 40, 50, 60]
                        .map((time) => DropdownMenuItem<int>(
                              value: time,
                              child: Text('$time sec'),
                            ))
                        .toList(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Rest Time:',
                      style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    value: watchTimer.restingTime,
                    dropdownColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) => readTimer.setRestingTime(value!),
                    items: [5, 10, 15, 20, 25, 30]
                        .map((time) => DropdownMenuItem<int>(
                              value: time,
                              child: Text('$time sec'),
                            ))
                        .toList(),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Intervals:',
                      style: TextStyle(color: Colors.white)),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    value: watchTimer.intervals,
                    dropdownColor: Colors.black,
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) => readTimer.setIntervals(value!),
                    items: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                        .map((intervals) => DropdownMenuItem<int>(
                              value: intervals,
                              child: Text('$intervals'),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
