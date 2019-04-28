import 'dart:core';
import 'dart:html';

import 'package:sprintf/sprintf.dart';
import 'TowerHanoiModel.dart';

class TowerHanoiView {
  static const int Margin = 15;
  static const int BarHeight = 20;
  static const int BarWidth = 25;

  final CanvasElement _canvas;
  final int _width;
  final int _height;
  final int _numDiscs;

  int _delta;
  int _currentDiscs;
  List<DiscRectangle> _listRectangles;

  // needed for simulation
  int _floatingDiscTop;
  DiscRectangle _floatingRect;
  bool _invalid;
  bool _upSimulationIsActive;
  bool _downSimulationIsActive;

  TowerHanoiView(this._canvas, this._numDiscs)
      : _width = _canvas.width,
        _height = _canvas.height {
    print("_width=" + _width.toString() + ", _height=" + _height.toString());

    _delta = (_width ~/ 2 - Margin - BarWidth ~/ 2) ~/ (_numDiscs + 1);
    _currentDiscs = 0;
    _listRectangles = new List<DiscRectangle>();

    _invalid = false;
    _upSimulationIsActive = false;
    _downSimulationIsActive = false;

    render(); // initial rendering
  }

  // getter / setter
  CanvasRenderingContext2D get _Context => _canvas.context2D;
  bool get Invalid => _invalid;

  // public interface
  void render() {
    print('> render');

    _Context
      ..globalAlpha = 1
      ..fillStyle = "lightgrey"
      ..rect(0, 0, _width, _height)
      ..fill();

    // horizontal line
    _Context
      ..fillStyle = "darkgrey"
      ..fillRect(
          Margin, _height - BarHeight - Margin, _width - 2 * Margin, BarHeight);

    // vertical line
    _Context
      ..fillStyle = "darkgrey"
      ..fillRect((_width) / 2 - BarWidth / 2, Margin, BarWidth,
          _height - 2 * Margin - BarHeight);

    // draw discs
    for (int i = 0; i < _listRectangles.length; i++) {
      DiscRectangle rect = _listRectangles[i];
      _drawDisc(rect);
    }

    // draw floating disc, if any
    if (_floatingRect != null) {
      _drawDisc(_floatingRect, fill: "yellowgreen");
    }
  }

  void push(int size) {
    assert(size >= 1 && size <= TowerHanoiModel.NumDiscs);
    if (_currentDiscs == _numDiscs) return;
    if (_downSimulationIsActive || _upSimulationIsActive) return;

    _currentDiscs++;
    int left = Margin + _delta * (TowerHanoiModel.NumDiscs - size + 1);
    int top = _height - (_currentDiscs + 1) * BarHeight - Margin;
    int width = _width -
        2 * Margin -
        2 * _delta * (TowerHanoiModel.NumDiscs - size + 1);
    int height = BarHeight;

    DiscRectangle rect = new DiscRectangle(size, left, top, width, height);
    print(sprintf("adding %s", [rect.toString()]));
    _listRectangles.add(rect);

    render();
  }

  void pushAnimated(int size) {
    assert(size >= 1 && size <= TowerHanoiModel.NumDiscs);
    if (_currentDiscs == _numDiscs) return;
    if (_downSimulationIsActive || _upSimulationIsActive) return;

    print("pushAnimated");

    // set guard
    _downSimulationIsActive = true;
    _currentDiscs++;

    print(sprintf("pushAnimated ==> # discs = %d", [_listRectangles.length]));

    // create a floating rectangle
    int left = Margin + _delta * (TowerHanoiModel.NumDiscs - size + 1);
    int top = 3 * Margin;
    int width = _width -
        2 * Margin -
        2 * _delta * (TowerHanoiModel.NumDiscs - size + 1);
    int height = BarHeight;

    _floatingRect = new DiscRectangle(size, left, top, width, height);
    _floatingDiscTop = _height - (_currentDiscs + 1) * BarHeight - Margin;

    _invalid = true;
  }

  int pop() {
    if (_currentDiscs == 0) return -1;
    if (_downSimulationIsActive || _upSimulationIsActive) return -1;

    _currentDiscs--;
    DiscRectangle last = _listRectangles.removeLast();
    render();
    return last.Size;
  }

  int popAnimated() {
    if (_currentDiscs == 0) return -1;
    if (_downSimulationIsActive || _upSimulationIsActive) return -1;

    print("popAnimated");

    // set guard
    _upSimulationIsActive = true;
    _currentDiscs--;

    // retrieve floating rectangle from disc stack
    _floatingRect = _listRectangles.removeLast();
    _floatingDiscTop = 3 * Margin;

    _invalid = true;
    return _floatingRect.Size;
  }

  void update() {
    print("update");

    if (_downSimulationIsActive) {
      if (_floatingDiscTop == _floatingRect.Top) {
        _invalid = false;
        _listRectangles.add(DiscRectangle.clone(_floatingRect));
        _floatingRect = null;
        _downSimulationIsActive = false; // release guard
      } else {
        _floatingRect.moveDown();
        _invalid = true;
      }
    } else if (_upSimulationIsActive) {
      if (_floatingDiscTop == _floatingRect.Top) {
        _invalid = false;
        _floatingRect = null;
        _upSimulationIsActive = false; // release guard
      } else {
        _floatingRect.moveUp();
        _invalid = true;
      }
    }
  }

  void clear() {
    _currentDiscs = 0;
    _listRectangles.clear();
    _floatingRect = null;
    render();
  }

  // helper methods
  void _drawDisc(DiscRectangle rect, {String fill = "yellow"}) {
    // draw filling
    _Context
      ..globalAlpha = 1
      ..fillStyle = fill
      ..beginPath()
      ..moveTo(rect.Left, rect.Top)
      ..lineTo(rect.Left + rect.Width, rect.Top)
      ..lineTo(rect.Left + rect.Width, rect.Top + rect.Height)
      ..lineTo(rect.Left, rect.Top + rect.Height)
      ..closePath()
      ..fill();

    // draw border
    _Context
      ..globalAlpha = 1
      ..beginPath()
      ..moveTo(rect.Left, rect.Top)
      ..lineTo(rect.Left + rect.Width, rect.Top)
      ..lineTo(rect.Left + rect.Width, rect.Top + rect.Height)
      ..lineTo(rect.Left, rect.Top + rect.Height)
      ..closePath()
      ..strokeStyle = "black"
      ..stroke();
  }
}

// helper classes
class DiscRectangle {
  // member data
  int _size;
  int _top;
  final int _left;
  final int _width;
  final int _height;

  // default c'tor
  DiscRectangle.origin()
      : _size = 0,
        _left = 0,
        _top = 0,
        _width = 0,
        _height = 0 {}

  // user-defined c'tor
  DiscRectangle(int size, int left, int top, int width, int height)
      : _size = size,
        _left = left,
        _top = top,
        _width = width,
        _height = height {}

  DiscRectangle.clone(DiscRectangle rect)
      : _size = rect.Size,
        _left = rect.Left,
        _top = rect.Top,
        _width = rect.Width,
        _height = rect.Height {}

  // getters and setters
  int get Size => _size;
  int get Left => _left;
  int get Top => _top;
  int get Width => _width;
  int get Height => _height;

  // public interface
  void moveUp() {
    _top--;
  }

  void moveDown() {
    _top++;
  }

  @override
  String toString() {
    return sprintf(
        "DiscRectangle: Left=%d, Top=%d, Width=%d, Height=%d (Size=%d)",
        [_left, _top, _width, _height, _size]);
  }
}
