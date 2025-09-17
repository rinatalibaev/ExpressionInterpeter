import 'dart:core';

import 'TreeNode.dart';

class RootTreeNode extends TreeNode {
  TreeNode? positive;
  TreeNode? negative;
  final String token;

  String getToken() => token;

  RootTreeNode(this.token);

  void setPositive(TreeNode positive) {
    this.positive = positive;
  }

  void setNegative(TreeNode negative) {
    this.negative = negative;
  }

  @override
  double calcResult(Map<String, double> map) {
    return positive!.calcResult(map) - negative!.calcResult(map);
  }
}