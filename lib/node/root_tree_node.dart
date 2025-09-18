import 'dart:core';

import '../../node/tree_node.dart';

class RootTreeNode extends TreeNode {
  TreeNode? positive;
  TreeNode? negative;
  final String token;

  String getToken() => token;

  RootTreeNode(this.token);

  void setPositive(TreeNode positive) => this.positive = positive;
  void setNegative(TreeNode negative) => this.negative = negative;

  @override
  double calcResult(Map<String, num> map) =>
      positive!.calcResult(map) - negative!.calcResult(map);
}
