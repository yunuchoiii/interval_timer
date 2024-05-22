import 'dart:async';

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

enum TimerState { ready, running, resting, completed, paused, nothing }

class TimerService extends ChangeNotifier {
  final int _readyTime = 3; // 준비 시간 (3초)
  int _runningTime = 30; // 러닝 시간 (초)
  int _restingTime = 10; // 휴식 시간 (초)
  int _intervals = 5; // 인터벌 횟수
  int _currentTime = 0; // 현재 소요한 시간
  int _currentInterval = 1; // 현재 인터벌 횟수
  TimerState _state = TimerState.nothing; // 상태 관리
  TimerState _prevState = TimerState.nothing; // 일시정지 이전 상태 관리
  Timer? _timer;

  int get runningTime => _runningTime;
  int get restingTime => _restingTime;
  int get intervals => _intervals;
  int get currentTime => _currentTime;
  int get currentInterval => _currentInterval;
  TimerState get state => _state;
  TimerState get prevState => _prevState;

  void startTimer() {
    if (_state == TimerState.running) return;
    _state = TimerState.ready;
    _currentTime = _readyTime * 1000;
    _timer = Timer.periodic(const Duration(milliseconds: 100), _tick);
    notifyListeners();
  }

  void _tick(Timer timer) {
    if (_currentTime > 0) {
      _currentTime -= 100;
    } else {
      switch (_state) {
        case TimerState.ready:
          vibrate();
          _state = TimerState.running;
          _currentTime = _runningTime * 1000;
          break;
        case TimerState.running:
          if (_currentInterval < _intervals) {
            vibrate();
            _state = TimerState.resting;
            _currentTime = _restingTime * 1000;
          } else {
            _state = TimerState.completed;
            stopTimer();
          }
          break;
        case TimerState.resting:
          _currentInterval++;
          vibrate();
          _state = TimerState.running;
          _currentTime = _runningTime * 1000;
          break;
        case TimerState.completed:
          stopTimer();
          return;
        case TimerState.nothing:
          _currentTime = _runningTime * 1000;
          stopTimer();
          return;
        default:
          return;
      }
    }
    notifyListeners();
  }

  void pauseTimer() {
    _timer?.cancel();
    _prevState = _state;
    _state = TimerState.paused;
    notifyListeners();
  }

  void restartTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 100), _tick);
    _state = _prevState;
    notifyListeners();
  }

  void stopTimer() {
    _timer?.cancel();
    _currentInterval = 1;
    _currentTime = 0;
    notifyListeners();
  }

  void resetTimer() {
    _state = TimerState.ready;
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

  void setState(TimerState state) {
    _state = state;
    notifyListeners();
  }

  void vibrate() {
    Vibration.vibrate(duration: 1000);
  }
}
