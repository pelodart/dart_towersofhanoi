import 'dart:html';
import 'dart:math';

import 'TowerHanoiModel.dart';
import 'TowerHanoiView.dart';
import 'gamehost.dart';

class TowerHanoiController {
  TowerHanoiModel _model;
  GameHost _host;

  ButtonElement _startButton;
  ButtonElement _stopButton;
  ButtonElement _resetButton;

  ButtonElement _pushButton;
  ButtonElement _popButton;
  ButtonElement _pushAnimatedButton;
  ButtonElement _popAnimatedButton;
  ButtonElement _clearButton;

  TowerHanoiView _leftView;
  TowerHanoiView _middleView;
  TowerHanoiView _rightView;

  Random _random;

  int _lastSize;

  TowerHanoiController(
      this._model, this._leftView, this._middleView, this._rightView) {
    _startButton = querySelector("#start");
    _stopButton = querySelector("#stop");
    _resetButton = querySelector("#reset");
    _pushButton = querySelector("#push");
    _popButton = querySelector("#pop");
    _pushAnimatedButton = querySelector("#push_animated");
    _popAnimatedButton = querySelector("#pop_animated");
    _clearButton = querySelector("#clear");

    _startButton.onClick.listen(startSimulation);
    _stopButton.onClick.listen(stopSimulation);
    _resetButton.onClick.listen(resetSimulation);

    _pushButton.onClick.listen(pushSimulation);
    _popButton.onClick.listen(popSimulation);
    _pushAnimatedButton.onClick.listen(pushAnimatedSimulation);
    _popAnimatedButton.onClick.listen(popAnimatedSimulation);
    _clearButton.onClick.listen(clearSimulation);

    _random = new Random();

    _model.register(onStateChanged);
    _lastSize = -1;

    _host = new GameHost(_leftView, _middleView, _rightView);
  }

  // simulation area
  void startSimulation(Event e) {
    print('start');

    // initialize left tower
    for (int i = 0; i < TowerHanoiModel.NumDiscs; i++) {
      _leftView.push(TowerHanoiModel.NumDiscs - i);
    }
    _model.doSimulation();
  }

  void stopSimulation(Event e) {
    print('stop');
    _host.IsAborted = true;
  }

  void resetSimulation(Event e) {
    print('reset');
    _leftView.clear();
    _middleView.clear();
    _rightView.clear();
  }

  // testing area
  void pushSimulation(Event e) {
    print('push');
    int size = _random.nextInt(TowerHanoiModel.NumDiscs) + 1;
    _leftView.push(size);
  }

  void popSimulation(Event e) {
    print('pop');
    _leftView.pop();
  }

  void pushAnimatedSimulation(Event e) {
    print('pushAnimated');
    int size = _random.nextInt(TowerHanoiModel.NumDiscs) + 1;
    _leftView.pushAnimated(size);
    _host.run();
  }

  void popAnimatedSimulation(Event e) {
    print('popAnimated');
    _leftView.popAnimated();
    _host.run();
  }

  void clearSimulation(Event e) {
    print('clear');
    _leftView.clear();
    _middleView.clear();
    _rightView.clear();
  }

  void onStateChanged(Towers tower, Direction direction) {
    print('onStateChanged ' + tower.toString());

    if (direction == Direction.Down) {
      switch (tower) {
        case Towers.Left:
          _leftView.pushAnimated(_lastSize);
          _host.run();
          break;

        case Towers.Middle:
          _middleView.pushAnimated(_lastSize);
          _host.run();
          break;

        case Towers.Right:
          _rightView.pushAnimated(_lastSize);
          _host.run();
          break;
      }
    } else if (direction == Direction.Up) {
      switch (tower) {
        case Towers.Left:
          _lastSize = _leftView.popAnimated();
          _host.run();
          break;

        case Towers.Middle:
          _lastSize = _middleView.popAnimated();
          _host.run();
          break;

        case Towers.Right:
          _lastSize = _rightView.popAnimated();
          _host.run();
          break;
      }
    }
  }
}
