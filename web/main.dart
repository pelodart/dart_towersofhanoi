import 'dart:core';
import 'dart:html';

import 'TowerHanoiController.dart';
import 'TowerHanoiModel.dart';
import 'TowerHanoiView.dart';

void main() {
  // create model
  TowerHanoiModel model = new TowerHanoiModel(7);

  // create views
  TowerHanoiView leftView =
      new TowerHanoiView(querySelector("#left"), model.NumDiscs);
  TowerHanoiView middleView =
      new TowerHanoiView(querySelector("#middle"), model.NumDiscs);
  TowerHanoiView rightView =
      new TowerHanoiView(querySelector("#right"), model.NumDiscs);

  // create controller - being connected to the model and the views
  new TowerHanoiController(model, leftView, middleView, rightView);
}
