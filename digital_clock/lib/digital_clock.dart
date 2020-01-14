// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  text,
  shadow,
}

final _lightTheme = {
  _Element.background: Color(0xFF81B3FE),
  _Element.text: Colors.white,
  _Element.shadow: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.text: Colors.white,
  _Element.shadow: Color(0xFF174EA6),
};

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      /* _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      ); */
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(milliseconds: 100) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.dark
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);
    final second = DateFormat('ss').format(_dateTime);
    final millisecond = _dateTime.millisecond;
    final fontSize = MediaQuery.of(context).size.width / 14;
    final offset = -fontSize / 7;
    final defaultStyle = TextStyle(
      color: colors[_Element.text],
      fontFamily: 'Helvetica',
      fontSize: fontSize,
      /* shadows: [
        Shadow(
          blurRadius: 0,
          color: colors[_Element.shadow],
          offset: Offset(10, 0),
        ),
      ], */
    );

    List<Widget> hourWidgets = [];
    hourWidgets.add(SizedBox(
      width: 0,
    ));

    int dumHour = 23;
    for (var i = 0; i < dumHour /* _dateTime.hour */; i++) {
      hourWidgets.add(Container(
        width: 3,
        height: ((3 * 23) + (2 * 22)).toDouble(),
        color: Colors.blue,
      ));
      hourWidgets.add(SizedBox(
        width: 2,
      ));
    }
    hourWidgets.add(
      Text(
        //_dateTime.hour.toString(),
        dumHour.toString(),
        style: TextStyle(fontSize: 24),
      ),
    );

    List<Widget> minWidgets = [];
    int dumMin = 10;
    for (var i = 0; i < dumMin /* _dateTime.minute */; i++) {
      minWidgets.add(Container(
        width: 293,
        height: 3,
        color: Colors.yellow.withAlpha(100),
      ));
      minWidgets.add(SizedBox(width: 5, height: 2));
    }
    minWidgets.add(
      Text(
        //_dateTime.minute.toString(),
        dumMin.toString(),
        style: TextStyle(fontSize: 24),
      ),
    );

    List<Widget> secWidgets = [];
    for (var i = 0; i < _dateTime.second; i++) {
      secWidgets.add(Container(
        width: 3,
        height: 120,
        color: Colors.red,
      ));
      secWidgets.add(SizedBox(width: 2, height: 2));
    }
    secWidgets.add(Column(
      children: <Widget>[
        //SizedBox(height: _dateTime.second.toDouble() * 5),
        Text(
          _dateTime.second.toString(),
          style: TextStyle(fontSize: 24),
        ),
      ],
    ));
    Widget secRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: secWidgets,
    );

    Widget minCol = Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: minWidgets,
    );

    List<Widget> allWidgets = [];
    allWidgets.addAll(hourWidgets);
    //allWidgets.add(minCol);

    Widget skewTop = Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.01)
          ..rotateX(0.6),
        //..rotateZ(45),
        alignment: FractionalOffset.center,

        //..scale(1.0, 0.8, 0.8),
        //..scale(0),
        //origin: Offset(150.0, 50.0),
        child: Container(
          height: 120.0,
          width: 340.0,
          //color: Colors.black,
          child: secRow,
        ));

    Widget skewLeft = Transform(
      transform: Matrix4.skewY(0.3), //..rotateZ(3.14 / 12.0),
      origin: Offset(50.0, 50.0),
      child: Container(
          height: 120.0,
          width: 170.0,
          color: Colors.black,
          child: Row(children: hourWidgets)),
    );
    Widget skewRight = Transform(
        transform: Matrix4.skewY(-0.3), //..rotateZ(3.14 / 12.0),
        origin: Offset(50.0, 50.0),
        child: Container(
          height: 110.0,
          width: 120.0,
          color: Colors.black,
          child: minCol,
        )
        //child: Row(children: hourWidgets)),
        );

    List<Widget> stackWidgets = [
      //Row(children: hourWidgets),
      //minCol,
      //secRow,
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          skewLeft,
          skewRight,
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          skewTop,
          SizedBox(
            height: 100,
          )
        ],
      ),
    ];

    return Container(
      color: colors[_Element.background],
      child: DefaultTextStyle(
          style: defaultStyle,
          child: Container(
            child: Center(
              child: Stack(
                children: stackWidgets,
              ),
            ),
          )

          /* Stack(
          children: <Widget>[
            Positioned(left: offset, top: 0, child: Text(hour)),
            Positioned(right: offset, top: 0, child: Text(minute)),
            Positioned(left: offset, bottom: offset, child: Text(second)),
            Positioned(
                right: offset,
                bottom: offset,
                child: Text((millisecond / 10).round().toString())),
          ],
        ), */
          ),
    );
  }
}
