import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

class TimerService extends ChangeNotifier {
  final int _readyTime = 3; // 준비 시간 (3초)
  int _runningTime = 30; // 러닝 시간 (초)
  int _restingTime = 10; // 휴식 시간 (초)
  int _intervals = 5; // 인터벌 횟수
  int _currentTime = 0; // 현재 소요한 시간
  int _currentInterval = 1; // 현재 인터벌 횟수
  bool _isRunning = false; // 운동 중 여부
  bool _isResting = false; // 휴식 중 여부
  bool _isReady = true; // 준비 중 여부
  Timer? _timer;
  CountDownController? _controller; // 타이머 컨트롤러

  int get runningTime => _runningTime;
  int get restingTime => _restingTime;
  int get intervals => _intervals;
  int get currentTime => _currentTime;
  int get currentInterval => _currentInterval;
  bool get isRunning => _isRunning;
  bool get isResting => _isResting;
  bool get isReady => _isReady;

  void setController(CountDownController controller) {
    _controller = controller;
  }

  // 타이머 시작
  void startTimer() {
    if (_isRunning) return; // 이미 실행 중이면 무시
    _isRunning = true;
    _isReady = true;
    _currentTime = _readyTime; // 준비 시간 설정
    _controller?.start();
    _timer = Timer.periodic(const Duration(seconds: 1), _tick);
    notifyListeners();
  }

  // 시간 핸들러
  void _tick(Timer timer) {
    if (_currentTime > 0) {
      _currentTime--;
    } else {
      if (_isReady) {
        // 준비 시간이 끝났을 때
        _isReady = false;
        _currentTime = _runningTime;
        _controller?.restart(duration: _runningTime);
      } else if (_isResting) {
        _currentInterval++;
        if (_currentInterval > _intervals) {
          stopTimer();
          return;
        }
        _isResting = false;
        _currentTime = _runningTime;
        _controller?.restart(duration: _runningTime);
      } else {
        _isResting = true;
        _currentTime = _restingTime;
        _controller?.restart(duration: _restingTime);
      }
    }
    notifyListeners();
  }

  // 일시정지
  void pauseTimer() {
    _timer?.cancel();
    _controller?.pause();
    _isRunning = false;
    notifyListeners();
  }

  // 정지
  void stopTimer() {
    _timer?.cancel();
    _controller?.reset();
    _isRunning = false;
    _isResting = false;
    _isReady = true;
    _currentInterval = 1;
    _currentTime = 0;
    notifyListeners();
  }

  // 초기화 및 다시 시작
  void restartTimer() {
    stopTimer();
    startTimer();
  }

  void setRunningTime(int time) {
    _runningTime = time;
    notifyListeners();
  }

  void setRestingTime(int time) {
    _restingTime = time;
    notifyListeners();
  }

  void setIntervals(int intervals) {
    _intervals = intervals;
    notifyListeners();
  }
}
