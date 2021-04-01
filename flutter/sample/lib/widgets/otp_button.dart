import 'dart:async';

import 'package:flutter/material.dart';
import 'package:novinpay/colors.dart' as colors;
import 'package:novinpay/utils.dart';
import 'package:persian/persian.dart';

typedef OtpRequestCallback = Future<bool> Function();

enum _OtpButtonStatus {
  none,
  working,
  waiting,
}

class OtpButton extends StatefulWidget {
  OtpButton({
    @required this.onRequested,
    this.wait = const Duration(seconds: 120),
    this.focusNode,
  });

  final OtpRequestCallback onRequested;
  final Duration wait;
  final FocusNode focusNode;

  @override
  State<StatefulWidget> createState() => _OtpButtonState();
}

class _OtpButtonState extends State<OtpButton> {
  _OtpButtonStatus _state = _OtpButtonStatus.none;
  String _timerText;

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(vertical: 8),
      color: colors.accentColor,
      disabledColor: Colors.grey,
      onPressed: _getCallback(),
      child: _getChild(),
      elevation: 0,
    );
  }

  VoidCallback _getCallback() {
    if (_state == _OtpButtonStatus.none) {
      return _onClick;
    } else if (_state == _OtpButtonStatus.working) {
      return null;
    } else if (_state == _OtpButtonStatus.waiting) {
      return () {};
    }

    return null;
  }

  Widget _getChild() {
    final textColor = Colors.white;

    if (_state == _OtpButtonStatus.working) {
      return Text(
        'صبر کنید...$rlm',
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: textColor),
      );
    } else if (_state == _OtpButtonStatus.waiting) {
      return Text(_timerText ?? '', style: TextStyle(color: textColor));
    }
    final srt = 'رمز پویا';

    return Text(
      srt,
      style: TextStyle(color: textColor),
    );
  }

  void _onClick() async {
    if (_state != _OtpButtonStatus.none) {
      return;
    }

    setState(() {
      _state = _OtpButtonStatus.working;
    });

    final result = await widget.onRequested?.call();

    if (mounted) {
      setState(() {
        _state = _OtpButtonStatus.none;
      });
    }

    if (result != true) {
      return;
    }

    _startTimer();
  }

  void _startTimer() {
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
        _state = _OtpButtonStatus.waiting;
        _timerText = '$twoDigitMinutes:$twoDigitSeconds'.withPersianNumbers();
      });
    }

    Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (now.isAfter(end)) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _state = _OtpButtonStatus.none;
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

class OtpIconButton extends StatefulWidget {
  OtpIconButton({
    @required this.onRequested,
    this.wait = const Duration(seconds: 120),
  });

  final OtpRequestCallback onRequested;
  final Duration wait;

  @override
  State<StatefulWidget> createState() => _OtpIconButtonState();
}

class _OtpIconButtonState extends State<OtpIconButton> {
  _OtpButtonStatus _state = _OtpButtonStatus.none;
  int _milisecondsRemaining = 0;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'درخواست رمز پویا',
      disabledColor: Colors.grey,
      onPressed: _getCallback(),
      icon: _getChild(),
    );
  }

  VoidCallback _getCallback() {
    if (_state == _OtpButtonStatus.none) {
      return _onClick;
    } else if (_state == _OtpButtonStatus.working) {
      return null;
    } else if (_state == _OtpButtonStatus.waiting) {
      return () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'لطفا ${_milisecondsRemaining ~/ 1000} ثانیه صبر کنید.'
                  .withPersianNumbers(),
              style: TextStyle(color: Colors.white, fontFamily: 'Shabnam'),
            ),
          ),
        );

        hideKeyboard(context);
      };
    }

    return null;
  }

  Widget _getChild() {
    if (_state == _OtpButtonStatus.working) {
      return SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.purple.shade100),
          backgroundColor: Colors.purple.shade900,
          strokeWidth: 3,
        ),
      );
    } else if (_state == _OtpButtonStatus.waiting) {
      return SizedBox(
        height: 16,
        width: 16,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Colors.purple.shade100),
          backgroundColor: Colors.purple.shade900,
          strokeWidth: 3,
          value: _milisecondsRemaining / widget.wait.inMilliseconds,
        ),
      );
    }

    return Icon(Icons.vpn_key_outlined);
  }

  void _onClick() async {
    if (_state != _OtpButtonStatus.none) {
      return;
    }

    setState(() {
      _state = _OtpButtonStatus.working;
    });

    final result = await widget.onRequested?.call();

    if (mounted) {
      setState(() {
        _state = _OtpButtonStatus.none;
      });
    }

    if (result != true) {
      return;
    }

    _startTimer();
  }

  void _startTimer() {
    final end = DateTime.now().add(widget.wait);

    if (mounted) {
      setState(() {
        _state = _OtpButtonStatus.waiting;
        _milisecondsRemaining = widget.wait.inMilliseconds;
      });
    }

    Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      if (now.isAfter(end)) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _state = _OtpButtonStatus.none;
          });
        }
      } else {
        final diff = end.difference(now);
        if (mounted) {
          setState(() {
            _milisecondsRemaining = diff.inMilliseconds;
          });
        }
      }
    });
  }
}
