import 'dart:html';
import 'TowerHanoiView.dart';

class GameHost {
  TowerHanoiView _leftTower;
  TowerHanoiView _middleTower;
  TowerHanoiView _rightTower;
  int _lastTick;
  bool _abort;

  // smaller numbers make the game run faster
  static const num _GameSpeed = 10;

  GameHost(this._leftTower, this._middleTower, this._rightTower) {
    _lastTick = 0;
    _abort = false;
  }

  // getter / setter
  bool get IsAborted => _abort;
  set IsAborted(bool value) => _abort = value;

  // public interface
  void run() {
    window.requestAnimationFrame(_gameLoop);
  }

  // private helper methods
  void _gameLoop(final num _) {
    // this parameter must be of type 'num'

    if (_abort) return;

    if (_leftTower.Invalid) {
      int delta = _getDelta();
      if (delta > _GameSpeed) {
        _leftTower.update();
        _leftTower.render();
      }
      run();
    }

    if (_middleTower.Invalid) {
      int delta = _getDelta();
      if (delta > _GameSpeed) {
        _middleTower.update();
        _middleTower.render();
      }
      run();
    }

    if (_rightTower.Invalid) {
      int delta = _getDelta();
      if (delta > _GameSpeed) {
        _rightTower.update();
        _rightTower.render();
      }
      run();
    }
  }

  int _getDelta() {
    int currentTick = DateTime.now().millisecondsSinceEpoch;
    int diff = currentTick - _lastTick;

    if (diff > _GameSpeed) {
      _lastTick = currentTick;
    }
    return diff;
  }
}
