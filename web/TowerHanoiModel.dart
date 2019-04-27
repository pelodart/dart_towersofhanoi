import 'dart:async';

enum Direction { Up, Down }

enum Towers { Left, Middle, Right }

typedef StateChangeListener = void Function(int tower, Direction direction);

class TowerHanoiModel {
  static const int NumDiscs = 3;
  static const int Pause = 4;

  int _discs;
  int _distance;

  StateChangeListener _listener;

  TowerHanoiModel() {
    _discs = NumDiscs;
    _distance = 0;
    _listener = null;
  }

  void register(StateChangeListener listener) {
    _listener = listener;
  }

  void unregister(StateChangeListener listener) {
    _listener = null;
  }

  void doSimulation() {
    this._moveTower(_discs, 1, 2, 3);
  }

  void _moveTower(int discs, int from, int tmp, int to) {
    if (discs > 0) {
      _moveTower(discs - 1, from, to, tmp); // move tower of height n-1
      _moveDisc(from, to); // move lowest disc
      _moveTower(discs - 1, tmp, from, to); // move remaining tower
    }
  }

  void _moveDisc(int towerFrom, int towerTo) {
    print('Moving disc ' + towerFrom.toString() + ' to ' + towerTo.toString());

    Future.delayed(
        new Duration(seconds: _distance), () => _removeDisc(towerFrom));
    _distance += Pause;

    Future.delayed(new Duration(seconds: _distance), () => _addDisc(towerTo));
    _distance += Pause;
  }

  // helper methods
  void _removeDisc(int tower) {
    if (_listener != null) _listener(tower, Direction.Up);
  }

  void _addDisc(int tower) {
    if (_listener != null) _listener(tower, Direction.Down);
  }
}
