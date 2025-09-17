import 'dart:core';

import '../../node/tree_node.dart';

class MultiplyTreeNode extends TreeNode {
  List<TreeNode> children = [];

  void addChildren(List<TreeNode> children) {
    this.children += children;
  }

  @override
  double calcResult(Map<String, num> map) {
    double result = 1;
    for (TreeNode child in children) {
      result *= child.calcResult(map);
    }
    return result;
  }
}
