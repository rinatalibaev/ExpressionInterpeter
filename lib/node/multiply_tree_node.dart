import 'dart:core';

import 'leaf_node.dart';
import '../../node/tree_node.dart';

class MultiplyTreeNode extends TreeNode {
  List<TreeNode> expressionChildren = [];
  List<LeafNode> leafChildren = [];

  void setExpressionChildren(List<TreeNode> expressionChildren) {
    this.expressionChildren = expressionChildren;
  }

  void setLeafChildren(List<LeafNode> leafChildren) {
    this.leafChildren = leafChildren;
  }

  @override
  double calcResult(Map<String, num> map) {
    double result = 1;
    for (LeafNode child in leafChildren) {
      result *= child.calcResult(map);
    }
    for (TreeNode child in expressionChildren) {
      result *= child.calcResult(map);
    }
    return result;
  }
}
