import 'dart:async';
import 'dart:core';
import 'dart:html';
import 'dart:math';

import 'TowerHanoiModel.dart';
import 'TowerHanoiView.dart';
import 'gamehost.dart';

ButtonElement startButton;
ButtonElement stopButton;
ButtonElement resetButton;

ButtonElement pushButton;
ButtonElement popButton;
ButtonElement pushAnimatedButton;
ButtonElement popAnimatedButton;
ButtonElement clearButton;

TowerHanoiView leftView;
TowerHanoiView middleView;
TowerHanoiView rightView;
TowerHanoiModel model;

GameHost host;
Random random;

void main() {
  startButton = querySelector("#start");
  stopButton = querySelector("#stop");
  resetButton = querySelector("#reset");
  pushButton = querySelector("#push");
  popButton = querySelector("#pop");
  pushAnimatedButton = querySelector("#push_animated");
  popAnimatedButton = querySelector("#pop_animated");
  clearButton = querySelector("#clear");

  startButton.onClick.listen(startSimulation);
  stopButton.onClick.listen(stopSimulation);
  resetButton.onClick.listen(resetSimulation);

  pushButton.onClick.listen(pushSimulation);
  popButton.onClick.listen(popSimulation);
  pushAnimatedButton.onClick.listen(pushAnimatedSimulation);
  popAnimatedButton.onClick.listen(popAnimatedSimulation);
  clearButton.onClick.listen(clearSimulation);

  CanvasElement canvasLeft = querySelector("#left");
  CanvasElement canvasMiddle = querySelector("#middle");
  CanvasElement canvasRight = querySelector("#right");
  leftView = new TowerHanoiView(canvasLeft, TowerHanoiModel.NumDiscs);
  middleView = new TowerHanoiView(canvasMiddle, TowerHanoiModel.NumDiscs);
  rightView = new TowerHanoiView(canvasRight, TowerHanoiModel.NumDiscs);

  random = new Random();

  // initialize left tower
  for (int i = 0; i < TowerHanoiModel.NumDiscs; i++) {
    leftView.push(TowerHanoiModel.NumDiscs - i);
  }

  host = new GameHost(leftView, middleView, rightView);
  scheduleMicrotask(host.run);
}

// simulation area
void startSimulation(Event e) {
  print('in start');

  model = new TowerHanoiModel();
  model.register(onStateChanged);
  model.doSimulation();
  print('End');
}

void stopSimulation(Event e) {
  print('in stop');
  host.IsAborted = true;
}

void resetSimulation(Event e) {
  print('in reset');
  leftView.clear();
  middleView.clear();
  rightView.clear();

  for (int i = 0; i < TowerHanoiModel.NumDiscs; i++) {
    leftView.push(TowerHanoiModel.NumDiscs - i);
  }
}

// testing area
void pushSimulation(Event e) {
  print('in push');
  int size = random.nextInt(TowerHanoiModel.NumDiscs) + 1;
  leftView.push(size);
}

void popSimulation(Event e) {
  print('in pop');
  leftView.pop();
}

void pushAnimatedSimulation(Event e) {
  print('in pushAnimated');
  int size = random.nextInt(TowerHanoiModel.NumDiscs) + 1;
  leftView.pushAnimated(size);
  host.run();
}

void popAnimatedSimulation(Event e) {
  print('in popAnimated');
  leftView.popAnimated();
  host.run();
}

void clearSimulation(Event e) {
  print('in clear');
  leftView.clear();
}

int lastSize = -1;

void onStateChanged(int tower, Direction direction) {
  print('onStateChanged ' + tower.toString());

  if (direction == Direction.Down) {
    switch (tower) {
      case 1: // Left
        leftView.pushAnimated(lastSize);
        host.run();
        break;

      case 2: // Middle
        middleView.pushAnimated(lastSize);
        host.run();
        break;

      case 3: // Right
        rightView.pushAnimated(lastSize);
        host.run();
        break;
    }
  } else if (direction == Direction.Up) {
    switch (tower) {
      case 1: // Left
        lastSize = leftView.popAnimated();
        host.run();
        break;

      case 2: // Middle
        lastSize = middleView.popAnimated();
        host.run();
        break;

      case 3: // Right
        lastSize = rightView.popAnimated();
        host.run();
        break;
    }
  }
}
