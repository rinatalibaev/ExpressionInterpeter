import 'dart:core';

import 'LeafNode.dart';
import 'TreeNode.dart';

class MulDivTreeNode extends TreeNode {
  List<LeafNode> mulLeafChildren = [];
  List<TreeNode> mulExpressionChildren = [];
  List<LeafNode> divLeafChildren = [];
  List<TreeNode> divExpressionChildren = [];

  @override
  double calcResult(Map<String, double> map) {
    double result = 1;
    for (LeafNode child in mulLeafChildren) {
      result *= child.calcResult(map);
    }
    for (TreeNode child in mulExpressionChildren) {
      result *= child.calcResult(map);
    }

    for (LeafNode child in divLeafChildren) {
      result /= child.calcResult(map);
    }
    for (TreeNode child in divExpressionChildren) {
      result /= child.calcResult(map);
    }

    return result;
  }

  void setMulLeafChildren(List<LeafNode> mulLeafChildren) {
    this.mulLeafChildren = mulLeafChildren;
  }

  void setMulExpressionChildren(List<TreeNode> mulExpressionChildren) {
    this.mulExpressionChildren = mulExpressionChildren;
  }

  void setDivLeafChildren(List<LeafNode> divLeafChildren) {
    this.divLeafChildren = divLeafChildren;
  }

  void setDivExpressionChildren(List<TreeNode> divExpressionChildren) {
    this.divExpressionChildren = divExpressionChildren;
  }



}