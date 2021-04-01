import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/utils.dart';
import 'package:persian/persian.dart';

typedef OtpRequestCallback = Future<bool> Function();

enum _TimerStatus {
  none,
  working,
  waiting,
}

class TimerButtonController extends ChangeNotifier {
  void startTimer() {
    notifyListeners();
  }
}

class TimerButton extends StatefulWidget {
  TimerButton({
    @required this.onRequested,
    @required this.onChanged,
    this.controller,
    this.wait = const Duration(seconds: 120),
    this.text,
    this.enabledTimer,
  });

  final OtpRequestCallback onRequested;
  final TimerButtonController controller;
  final Duration wait;
  final String text;
  final bool enabledTimer;
  final ValueChanged<bool> onChanged;

  @override
  State<StatefulWidget> createState() => _TimerButtonState();
}

class _TimerButtonState extends State<TimerButton> {
  _TimerStatus _state = _TimerStatus.waiting;
  String _timerText;

  @override
  void initState() {
    widget.controller?.addListener(() {
      _startTimer();
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.enabledTimer != null && widget.enabledTimer) {
        _startTimer();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: colors.primaryColor.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: colors.primaryColor.shade50.darken(),
        ),
      ),
      disabledColor: Colors.grey,
      onPressed: _getCallback(),
      child: _getChild(),
    );
  }

  VoidCallback _getCallback() {
    if (_state == _TimerStatus.none) {
      return _onClick;
    } else if (_state == _TimerStatus.working) {
      return null;
    } else if (_state == _TimerStatus.waiting) {
      return () {};
    }
    return null;
  }

  Widget _getChild() {
    if (_state == _TimerStatus.working) {
      return Text(
        'صبر کنید...$rlm',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: Colors.black),
      );
    } else if (_state == _TimerStatus.waiting) {
      return Text(_timerText ?? '', style: TextStyle(color: Colors.black));
    }

    return Text(
      widget.text ?? '',
      style: TextStyle(color: Colors.black),
    );
  }

  void _onClick() async {
    if (_state != _TimerStatus.none) {
      return;
    }
    if (mounted) {
      setState(() {
        _state = _TimerStatus.working;
      });
    }

    final result = await widget.onRequested?.call();

    if (mounted) {
      setState(() {
        _state = _TimerStatus.none;
      });
    }

    if (result != true) {
      return;
    }

    _startTimer();
  }

  void _startTimer() {
    widget.onChanged(false);
    String twoDigits(int n) {
      if (n >= 10) return '$n';
      return '0$n';
    }

    final end = DateTime.now().add(widget.wait);
    String twoDigitMinutes = twoDigits(
        widget.wait.inMinutes.remainder(Duration.minutesPerHour).toInt());
    String twoDigitSeconds = twoDigits(
        widget.wait.inSeconds.remainder(Duration.secondsPerMinute).toInt());

    if (mounted) {
      setState(() {
        _state = _TimerStatus.waiting;
        _timerText = '$twoDigitMinutes:$twoDigitSeconds'.withPersianNumbers();
      });
    }

    Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (now.isAfter(end)) {
        timer.cancel();
        widget.onChanged?.call(true);
        if (mounted) {
          setState(() {
            _state = _TimerStatus.none;
          });
        }
      } else {
        final diff = end.difference(now);
        String twoDigitMinutes = twoDigits(
            diff.inMinutes.remainder(Duration.minutesPerHour).toInt());
        String twoDigitSeconds = twoDigits(
            diff.inSeconds.remainder(Duration.secondsPerMinute).toInt());

        if (mounted) {
          setState(() {
            _timerText =
                '$twoDigitMinutes:$twoDigitSeconds'.withPersianNumbers();
          });
        }
      }
    });
  }
}
