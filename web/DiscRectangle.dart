import 'dart:core';
import 'package:sprintf/sprintf.dart';

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
